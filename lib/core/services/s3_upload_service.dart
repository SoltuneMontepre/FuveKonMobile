import 'package:dio/dio.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';

class S3UploadResult {
  const S3UploadResult({required this.fileUrl, required this.fileKey});

  final String fileUrl;
  final String fileKey;
}

/// Uploads files via Fuvekon web `/api/s3/presign` (same flow as `useUploadToS3.ts`).
class S3UploadService {
  S3UploadService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConfig.webBaseUrl,
                connectTimeout: AppConfig.connectTimeout,
                receiveTimeout: AppConfig.receiveTimeout,
              ),
            );

  final Dio _dio;

  Future<S3UploadResult> uploadBytes({
    required List<int> bytes,
    required String fileName,
    required String contentType,
    String? folder,
    void Function(int sent, int total)? onProgress,
  }) async {
    final presignResponse = await _dio.post<Map<String, dynamic>>(
      '/api/s3/presign',
      data: {
        'fileName': fileName,
        'fileType': contentType,
        'contentLength': bytes.length,
        'folder': folder,
        'expiresIn': 3600,
      },
    );

    final body = presignResponse.data;
    if (body == null) {
      throw const ServerException('Empty presign response');
    }

    final parsed = ApiResponse<Map<String, dynamic>>.fromJson(
      body,
      mapData: (value) =>
          value is Map ? Map<String, dynamic>.from(value) : null,
    );

    if (!parsed.isSuccess || parsed.data == null) {
      throw ServerException(
        parsed.errorMessage ?? parsed.message,
      );
    }

    final data = parsed.data!;
    final presignedUrl = data['presignedUrl'] as String?;
    final fileUrl = data['fileUrl'] as String?;
    final fileKey = data['fileKey'] as String?;

    if (presignedUrl == null || fileUrl == null || fileKey == null) {
      throw const ServerException('Invalid presign response data');
    }

    await _dio.put<void>(
      presignedUrl,
      data: bytes,
      options: Options(
        headers: {'Content-Type': contentType},
        contentType: contentType,
      ),
      onSendProgress: onProgress,
    );

    return S3UploadResult(fileUrl: fileUrl, fileKey: fileKey);
  }
}
