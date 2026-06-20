import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/core/services/s3_upload_service.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:image_picker/image_picker.dart';

String imageContentTypeFromName(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();
  return switch (ext) {
    'png' => 'image/png',
    'gif' => 'image/gif',
    'webp' => 'image/webp',
    'svg' => 'image/svg+xml',
    'avif' => 'image/avif',
    'jpg' || 'jpeg' => 'image/jpeg',
    _ => 'image/jpeg',
  };
}

/// Pick an image and upload it to S3 via `/s3/presign`.
class S3ImageUploadField extends StatefulWidget {
  const S3ImageUploadField({
    super.key,
    required this.imageUrl,
    required this.onChanged,
    this.folder = 'lost-found',
    this.label = 'Ảnh',
    this.enabled = true,
  });

  final String? imageUrl;
  final ValueChanged<String?> onChanged;
  final String folder;
  final String label;
  final bool enabled;

  @override
  State<S3ImageUploadField> createState() => _S3ImageUploadFieldState();
}

class _S3ImageUploadFieldState extends State<S3ImageUploadField> {
  final _picker = ImagePicker();
  bool _uploading = false;
  double? _uploadProgress;

  Future<void> _pickAndUpload() async {
    if (!widget.enabled || _uploading) return;

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() {
      _uploading = true;
      _uploadProgress = null;
    });

    try {
      final bytes = await picked.readAsBytes();
      final fileName = picked.name.isNotEmpty ? picked.name : 'image.jpg';
      final contentType =
          picked.mimeType ?? imageContentTypeFromName(fileName);

      final uploaded = await sl<S3UploadService>().uploadBytes(
        bytes: bytes,
        fileName: fileName,
        contentType: contentType,
        folder: widget.folder,
        onProgress: (sent, total) {
          if (!mounted || total <= 0) return;
          setState(() => _uploadProgress = sent / total);
        },
      );

      if (!mounted) return;
      widget.onChanged(uploaded.fileUrl);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_uploadErrorMessage(e))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _uploading = false;
          _uploadProgress = null;
        });
      }
    }
  }

  void _removeImage() {
    if (!widget.enabled || _uploading) return;
    widget.onChanged(null);
  }

  String _uploadErrorMessage(Object error) => s3UploadErrorMessage(error);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = widget.imageUrl?.isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: FuvekonColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        if (hasImage) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: S3Image(
              imageUrl: widget.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(12),
              onTap: widget.enabled && !_uploading ? _pickAndUpload : null,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton.icon(
                onPressed: widget.enabled && !_uploading ? _pickAndUpload : null,
                icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                label: const Text('Đổi ảnh'),
              ),
              TextButton.icon(
                onPressed: widget.enabled && !_uploading ? _removeImage : null,
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: const Text('Xóa ảnh'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFF0A0A8),
                ),
              ),
            ],
          ),
        ] else
          Material(
            color: FuvekonColors.darkSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(FuvekonRadii.upload),
              side: const BorderSide(
                color: FuvekonColors.darkBorder,
                width: 1.5,
              ),
            ),
            child: InkWell(
              onTap: widget.enabled && !_uploading ? _pickAndUpload : null,
              borderRadius: BorderRadius.circular(FuvekonRadii.upload),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                child: Column(
                  children: [
                    if (_uploading) ...[
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          value: _uploadProgress,
                          strokeWidth: 3,
                          color: FuvekonColors.darkPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _uploadProgress != null
                            ? 'Đang tải ${(_uploadProgress! * 100).round()}%'
                            : 'Đang tải ảnh...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: FuvekonColors.darkTextSecondary,
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 36,
                        color: FuvekonColors.darkTextSecondary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Chọn ảnh từ thiết bị',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: FuvekonColors.darkTextSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'JPEG, PNG, WebP (tối đa 50MB)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: FuvekonColors.darkTextSecondary
                              .withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

String s3UploadErrorMessage(Object error) {
  return switch (error) {
    NetworkException() =>
      'Không thể kết nối S3. Trên thiết bị thật, đặt LOCALSTACK_ENDPOINT trong general-service .env thành IP LAN (cổng 4566).',
    ServerException(:final message) =>
      'Lỗi tải ảnh: ${message.isNotEmpty ? message : 'Yêu cầu thất bại.'}',
    _ => 'Lỗi tải ảnh: $error',
  };
}

/// Pick and upload multiple images to S3 (e.g. dealer price sheets).
class S3MultiImageUploadField extends StatefulWidget {
  const S3MultiImageUploadField({
    super.key,
    required this.imageUrls,
    required this.onChanged,
    this.maxImages = 5,
    this.folder = 'dealers',
    this.label = 'Ảnh bảng giá',
    this.hint = 'Tải lên tối đa 5 ảnh bảng giá (JPEG, PNG, WebP)',
    this.enabled = true,
  });

  final List<String> imageUrls;
  final ValueChanged<List<String>> onChanged;
  final int maxImages;
  final String folder;
  final String label;
  final String hint;
  final bool enabled;

  @override
  State<S3MultiImageUploadField> createState() => _S3MultiImageUploadFieldState();
}

class _S3MultiImageUploadFieldState extends State<S3MultiImageUploadField> {
  final _picker = ImagePicker();
  bool _uploading = false;
  double? _uploadProgress;

  bool get _canAddMore => widget.imageUrls.length < widget.maxImages;

  Future<void> _pickAndUpload() async {
    if (!widget.enabled || _uploading || !_canAddMore) return;

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() {
      _uploading = true;
      _uploadProgress = null;
    });

    try {
      final bytes = await picked.readAsBytes();
      final fileName = picked.name.isNotEmpty ? picked.name : 'image.jpg';
      final contentType =
          picked.mimeType ?? imageContentTypeFromName(fileName);

      final uploaded = await sl<S3UploadService>().uploadBytes(
        bytes: bytes,
        fileName: fileName,
        contentType: contentType,
        folder: widget.folder,
        onProgress: (sent, total) {
          if (!mounted || total <= 0) return;
          setState(() => _uploadProgress = sent / total);
        },
      );

      if (!mounted) return;
      widget.onChanged([...widget.imageUrls, uploaded.fileUrl]);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s3UploadErrorMessage(e))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _uploading = false;
          _uploadProgress = null;
        });
      }
    }
  }

  void _removeAt(int index) {
    if (!widget.enabled || _uploading) return;
    final next = List<String>.from(widget.imageUrls)..removeAt(index);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
              ),
            ),
            Text(
              '${widget.imageUrls.length}/${widget.maxImages}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: FuvekonColors.darkTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < widget.imageUrls.length; i++)
              _UploadedImageTile(
                imageUrl: widget.imageUrls[i],
                enabled: widget.enabled && !_uploading,
                onRemove: () => _removeAt(i),
              ),
            if (_canAddMore)
              _AddImageTile(
                uploading: _uploading,
                uploadProgress: _uploadProgress,
                enabled: widget.enabled,
                onTap: _pickAndUpload,
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          widget.hint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _UploadedImageTile extends StatelessWidget {
  const _UploadedImageTile({
    required this.imageUrl,
    required this.enabled,
    required this.onRemove,
  });

  final String imageUrl;
  final bool enabled;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: S3Image(
            imageUrl: imageUrl,
            width: 96,
            height: 96,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(12),
            onTap: () => showS3ImagePreview(context, imageUrl),
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: Material(
            color: FuvekonColors.darkSurfaceElevated,
            shape: const CircleBorder(),
            child: IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 28, height: 28),
              onPressed: enabled ? onRemove : null,
              icon: const Icon(Icons.close_rounded, size: 16),
              color: const Color(0xFFF0A0A8),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddImageTile extends StatelessWidget {
  const _AddImageTile({
    required this.uploading,
    required this.uploadProgress,
    required this.enabled,
    required this.onTap,
  });

  final bool uploading;
  final double? uploadProgress;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: FuvekonColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: FuvekonColors.darkBorder, width: 1.5),
      ),
      child: InkWell(
        onTap: enabled && !uploading ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 96,
          height: 96,
          child: uploading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        value: uploadProgress,
                        strokeWidth: 2.5,
                        color: FuvekonColors.darkPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      uploadProgress != null
                          ? '${(uploadProgress! * 100).round()}%'
                          : '...',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: FuvekonColors.darkTextSecondary,
                      ),
                    ),
                  ],
                )
              : const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: FuvekonColors.darkTextSecondary,
                ),
        ),
      ),
    );
  }
}
