package services

import (
	"context"
	"errors"
	"fmt"
	"io"
	"math/rand"
	"net/url"
	"os"
	"path"
	"path/filepath"
	"regexp"
	"strings"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/aws/smithy-go"
)

const (
	defaultS3Region       = "ap-southeast-1"
	defaultPresignExpiry    = 3600
	maxUploadSizeBytes      = 50 * 1024 * 1024
	maxObjectKeyLength      = 1024
	// MaxStreamBytes is the largest object size streamed through Lambda/API Gateway.
	// Lambda synchronous responses are capped at ~6 MB; larger objects redirect to S3.
	MaxStreamBytes = 5 * 1024 * 1024
)

var (
	ErrS3NotConfigured   = errors.New("s3 is not configured")
	ErrInvalidUploadSize = errors.New("file size exceeds maximum allowed")
	ErrInvalidFileType   = errors.New("file type not allowed")
	ErrInvalidFolder     = errors.New("invalid folder parameter")
	ErrInvalidObjectKey  = errors.New("invalid object key")
	ErrObjectNotFound    = errors.New("object not found")
)

var allowedImageMIME = map[string]struct{}{
	"image/jpeg":      {},
	"image/jpg":       {},
	"image/png":       {},
	"image/gif":       {},
	"image/webp":      {},
	"image/svg+xml":   {},
	"image/avif":      {},
}

var allowedDocumentMIME = map[string]struct{}{
	"application/pdf": {},
	"application/msword": {},
	"application/vnd.openxmlformats-officedocument.wordprocessingml.document": {},
}

var folderPattern = regexp.MustCompile(`^[a-zA-Z0-9._-]+$`)

type PresignUploadInput struct {
	FileName      string
	FileType      string
	ContentLength int64
	Folder        string
	ExpiresIn     int64
}

type PresignUploadResult struct {
	PresignedURL string
	FileKey      string
	FileURL      string
}

type S3Object struct {
	Body          io.ReadCloser
	ContentType   string
	ContentLength int64
}

type S3ObjectMeta struct {
	ContentType   string
	ContentLength int64
}

type S3Service struct {
	client        *s3.Client
	presignClient *s3.PresignClient
	bucketName    string
	region        string
	bucketBaseURL string
}

func NewS3Service(ctx context.Context) (*S3Service, error) {
	bucketName := resolveBucketName()
	if bucketName == "" {
		return nil, ErrS3NotConfigured
	}

	region := strings.TrimSpace(os.Getenv("AWS_REGION"))
	if region == "" {
		region = defaultS3Region
	}

	bucketBaseURL := strings.TrimRight(strings.TrimSpace(os.Getenv("S3_BUCKET_URL")), "/")

	useLocalStack := os.Getenv("USE_LOCALSTACK") == "true" ||
		strings.Contains(bucketBaseURL, "localhost") ||
		strings.Contains(bucketBaseURL, "localstack")

	var cfg aws.Config
	var err error

	if useLocalStack {
		accessKey := os.Getenv("AWS_ACCESS_KEY_ID")
		secretKey := os.Getenv("AWS_SECRET_ACCESS_KEY")
		if accessKey == "" {
			accessKey = "test"
		}
		if secretKey == "" {
			secretKey = "test"
		}
		localEndpoint := os.Getenv("LOCALSTACK_ENDPOINT")
		if localEndpoint == "" {
			localEndpoint = "http://localhost:4566"
		}
		cfg, err = config.LoadDefaultConfig(ctx,
			config.WithRegion(region),
			config.WithCredentialsProvider(credentials.NewStaticCredentialsProvider(accessKey, secretKey, "")),
			config.WithEndpointResolverWithOptions(aws.EndpointResolverWithOptionsFunc(func(service, region string, options ...interface{}) (aws.Endpoint, error) {
				return aws.Endpoint{
					URL:           localEndpoint,
					SigningRegion: region,
				}, nil
			})),
		)
	} else {
		cfg, err = config.LoadDefaultConfig(ctx, config.WithRegion(region))
	}
	if err != nil {
		return nil, err
	}

	var s3Client *s3.Client
	if useLocalStack {
		localEndpoint := os.Getenv("LOCALSTACK_ENDPOINT")
		if localEndpoint == "" {
			localEndpoint = "http://localhost:4566"
		}
		s3Client = s3.NewFromConfig(cfg, func(o *s3.Options) {
			o.UsePathStyle = true
			o.BaseEndpoint = aws.String(localEndpoint)
		})
	} else {
		s3Client = s3.NewFromConfig(cfg)
	}

	return &S3Service{
		client:        s3Client,
		presignClient: s3.NewPresignClient(s3Client),
		bucketName:    bucketName,
		region:        region,
		bucketBaseURL: bucketBaseURL,
	}, nil
}

// Ping verifies the configured bucket is reachable.
func (s *S3Service) Ping(ctx context.Context) error {
	if s == nil || s.client == nil || s.bucketName == "" {
		return ErrS3NotConfigured
	}
	_, err := s.client.HeadBucket(ctx, &s3.HeadBucketInput{
		Bucket: aws.String(s.bucketName),
	})
	return err
}

func (s *S3Service) PresignUpload(ctx context.Context, input PresignUploadInput) (*PresignUploadResult, error) {
	if s == nil || s.presignClient == nil {
		return nil, ErrS3NotConfigured
	}

	if input.ContentLength <= 0 {
		return nil, fmt.Errorf("contentLength is required and must be a positive number")
	}
	if input.ContentLength > maxUploadSizeBytes {
		return nil, ErrInvalidUploadSize
	}
	if err := validateFolder(input.Folder); err != nil {
		return nil, err
	}
	if !isAllowedFileType(input.FileType, input.FileName, input.Folder) {
		return nil, ErrInvalidFileType
	}

	expiresIn := input.ExpiresIn
	if expiresIn <= 0 {
		expiresIn = defaultPresignExpiry
	}

	fileKey := generateFileKey(input.FileName, input.Folder)
	presigned, err := s.presignClient.PresignPutObject(ctx, &s3.PutObjectInput{
		Bucket:        aws.String(s.bucketName),
		Key:           aws.String(fileKey),
		ContentType:   aws.String(strings.TrimSpace(input.FileType)),
		ContentLength: aws.Int64(input.ContentLength),
	}, func(opts *s3.PresignOptions) {
		opts.Expires = time.Duration(expiresIn) * time.Second
	})
	if err != nil {
		return nil, err
	}

	return &PresignUploadResult{
		PresignedURL: presigned.URL,
		FileKey:      fileKey,
		FileURL:      s.publicURL(fileKey),
	}, nil
}

func (s *S3Service) PresignGetObject(ctx context.Context, objectKey string, expiresIn int64) (string, error) {
	if s == nil || s.presignClient == nil {
		return "", ErrS3NotConfigured
	}
	if err := validateObjectKey(objectKey); err != nil {
		return "", err
	}
	if expiresIn <= 0 {
		expiresIn = defaultPresignExpiry
	}

	_, err := s.client.HeadObject(ctx, &s3.HeadObjectInput{
		Bucket: aws.String(s.bucketName),
		Key:    aws.String(objectKey),
	})
	if err != nil {
		if isS3NotFound(err) {
			return "", ErrObjectNotFound
		}
		return "", err
	}

	presigned, err := s.presignClient.PresignGetObject(ctx, &s3.GetObjectInput{
		Bucket: aws.String(s.bucketName),
		Key:    aws.String(objectKey),
	}, func(opts *s3.PresignOptions) {
		opts.Expires = time.Duration(expiresIn) * time.Second
	})
	if err != nil {
		return "", err
	}
	return presigned.URL, nil
}

func (s *S3Service) HeadObject(ctx context.Context, objectKey string) (*S3ObjectMeta, error) {
	if s == nil || s.client == nil {
		return nil, ErrS3NotConfigured
	}
	if err := validateObjectKey(objectKey); err != nil {
		return nil, err
	}

	out, err := s.client.HeadObject(ctx, &s3.HeadObjectInput{
		Bucket: aws.String(s.bucketName),
		Key:    aws.String(objectKey),
	})
	if err != nil {
		if isS3NotFound(err) {
			return nil, ErrObjectNotFound
		}
		return nil, err
	}

	contentType := "application/octet-stream"
	if out.ContentType != nil && strings.TrimSpace(*out.ContentType) != "" {
		contentType = strings.TrimSpace(*out.ContentType)
	}

	var contentLength int64
	if out.ContentLength != nil {
		contentLength = *out.ContentLength
	}

	return &S3ObjectMeta{
		ContentType:   contentType,
		ContentLength: contentLength,
	}, nil
}

func (s *S3Service) PutObject(
	ctx context.Context,
	objectKey string,
	body io.Reader,
	contentLength int64,
	contentType string,
) error {
	if s == nil || s.client == nil {
		return ErrS3NotConfigured
	}
	if err := validateObjectKey(objectKey); err != nil {
		return err
	}
	if contentLength <= 0 {
		return fmt.Errorf("contentLength must be positive")
	}

	_, err := s.client.PutObject(ctx, &s3.PutObjectInput{
		Bucket:        aws.String(s.bucketName),
		Key:           aws.String(objectKey),
		Body:          body,
		ContentLength: aws.Int64(contentLength),
		ContentType:   aws.String(strings.TrimSpace(contentType)),
	})
	return err
}

// ExtractObjectKeyFromURL resolves an S3 object key from a stored file URL or proxy URL.
func ExtractObjectKeyFromURL(rawURL string) (string, error) {
	rawURL = strings.TrimSpace(rawURL)
	if rawURL == "" {
		return "", ErrInvalidObjectKey
	}

	if strings.Contains(rawURL, "/s3/image?key=") {
		parsed, err := url.Parse(rawURL)
		if err != nil {
			return "", ErrInvalidObjectKey
		}
		key := strings.TrimSpace(parsed.Query().Get("key"))
		if key == "" {
			return "", ErrInvalidObjectKey
		}
		return DecodeObjectKey(key)
	}

	parsed, err := url.Parse(rawURL)
	if err != nil {
		return "", ErrInvalidObjectKey
	}

	pathname := strings.TrimPrefix(parsed.Path, "/")
	if pathname == "" {
		return "", ErrInvalidObjectKey
	}

	hostname := parsed.Hostname()

	// Virtual-hosted AWS: bucket.s3.region.amazonaws.com/key
	if strings.Contains(hostname, "amazonaws.com") &&
		strings.Contains(hostname, "s3") &&
		!strings.HasPrefix(hostname, "s3.") {
		return DecodeObjectKey(pathname)
	}

	// Path-style AWS: s3.region.amazonaws.com/bucket/key
	if strings.HasPrefix(hostname, "s3.") && strings.Contains(hostname, "amazonaws.com") {
		return extractPathStyleObjectKey(pathname)
	}

	// LocalStack / configured bucket base URL: .../bucket/key
	if bucketName := resolveBucketName(); bucketName != "" {
		prefix := bucketName + "/"
		if strings.HasPrefix(pathname, prefix) {
			return DecodeObjectKey(strings.TrimPrefix(pathname, prefix))
		}
	}

	return extractPathStyleObjectKey(pathname)
}

func extractPathStyleObjectKey(pathname string) (string, error) {
	slashIndex := strings.Index(pathname, "/")
	if slashIndex == -1 {
		return "", ErrInvalidObjectKey
	}
	return DecodeObjectKey(pathname[slashIndex+1:])
}

func (s *S3Service) GetObject(ctx context.Context, objectKey string) (*S3Object, error) {
	if s == nil || s.client == nil {
		return nil, ErrS3NotConfigured
	}
	if err := validateObjectKey(objectKey); err != nil {
		return nil, err
	}

	out, err := s.client.GetObject(ctx, &s3.GetObjectInput{
		Bucket: aws.String(s.bucketName),
		Key:    aws.String(objectKey),
	})
	if err != nil {
		if isS3NotFound(err) {
			return nil, ErrObjectNotFound
		}
		return nil, err
	}

	contentType := "application/octet-stream"
	if out.ContentType != nil && strings.TrimSpace(*out.ContentType) != "" {
		contentType = strings.TrimSpace(*out.ContentType)
	}

	var contentLength int64
	if out.ContentLength != nil {
		contentLength = *out.ContentLength
	}

	return &S3Object{
		Body:          out.Body,
		ContentType:   contentType,
		ContentLength: contentLength,
	}, nil
}

func isS3NotFound(err error) bool {
	var apiErr smithy.APIError
	if errors.As(err, &apiErr) {
		switch apiErr.ErrorCode() {
		case "NoSuchKey", "NotFound":
			return true
		}
	}
	var noSuchKey *types.NoSuchKey
	return errors.As(err, &noSuchKey)
}

func (s *S3Service) publicURL(key string) string {
	if s.bucketBaseURL != "" {
		return s.bucketBaseURL + "/" + key
	}
	return fmt.Sprintf("https://%s.s3.%s.amazonaws.com/%s", s.bucketName, s.region, key)
}

func resolveBucketName() string {
	if bucket := strings.TrimSpace(os.Getenv("S3_BUCKET")); bucket != "" {
		return bucket
	}

	bucketURL := strings.TrimSpace(os.Getenv("S3_BUCKET_URL"))
	if bucketURL == "" {
		return ""
	}

	parsed, err := url.Parse(bucketURL)
	if err != nil {
		return ""
	}

	segment := strings.Trim(parsed.Path, "/")
	if segment == "" {
		return ""
	}
	return strings.Split(segment, "/")[0]
}

func validateFolder(folder string) error {
	if folder == "" {
		return nil
	}
	if strings.Contains(folder, "..") ||
		strings.Contains(folder, "/") ||
		strings.Contains(folder, "\\") ||
		strings.HasPrefix(folder, ".") {
		return ErrInvalidFolder
	}
	if !folderPattern.MatchString(folder) {
		return ErrInvalidFolder
	}
	return nil
}

func validateObjectKey(key string) error {
	if key == "" {
		return ErrInvalidObjectKey
	}
	if strings.Contains(key, "..") || strings.HasPrefix(key, "/") {
		return ErrInvalidObjectKey
	}
	if len(key) > maxObjectKeyLength {
		return ErrInvalidObjectKey
	}
	return nil
}

func DecodeObjectKey(raw string) (string, error) {
	decoded := raw
	for i := 0; i < 3; i++ {
		prev := decoded
		unescaped, err := url.PathUnescape(decoded)
		if err != nil {
			break
		}
		decoded = unescaped
		if decoded == prev {
			break
		}
	}
	if err := validateObjectKey(decoded); err != nil {
		return "", err
	}
	return decoded, nil
}

func isAllowedFileType(fileType, fileName, folder string) bool {
	normalizedType := strings.ToLower(strings.TrimSpace(fileType))
	if _, ok := allowedImageMIME[normalizedType]; ok {
		return true
	}

	if !isArtbookFolder(folder) {
		return false
	}
	if _, ok := allowedDocumentMIME[normalizedType]; ok {
		return true
	}
	return hasAllowedDocumentExtension(fileName)
}

func isArtbookFolder(folder string) bool {
	return folder == "artbooks" || strings.HasPrefix(folder, "artbooks/")
}

func hasAllowedDocumentExtension(fileName string) bool {
	ext := strings.ToLower(filepath.Ext(fileName))
	return ext == ".pdf" || ext == ".doc" || ext == ".docx"
}

func generateFileKey(fileName, folder string) string {
	timestamp := time.Now().UnixMilli()
	randomString := randomAlphaNumeric(13)
	sanitized := sanitizeFileName(fileName)
	if folder != "" {
		return path.Join(folder, fmt.Sprintf("%d-%s-%s", timestamp, randomString, sanitized))
	}
	return fmt.Sprintf("%d-%s-%s", timestamp, randomString, sanitized)
}

func sanitizeFileName(fileName string) string {
	base := filepath.Base(fileName)
	base = strings.TrimLeft(base, ".")
	replacer := strings.NewReplacer("/", "_", "\\", "_")
	sanitized := replacer.Replace(base)
	var b strings.Builder
	for _, r := range sanitized {
		if (r >= 'a' && r <= 'z') ||
			(r >= 'A' && r <= 'Z') ||
			(r >= '0' && r <= '9') ||
			r == '.' || r == '-' || r == '_' {
			b.WriteRune(r)
		} else {
			b.WriteRune('_')
		}
	}
	return b.String()
}

func randomAlphaNumeric(length int) string {
	const alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"
	b := make([]byte, length)
	for i := range b {
		b[i] = alphabet[rand.Intn(len(alphabet))]
	}
	return string(b)
}
