import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/utils/s3_url.dart';

/// Rectangular image that loads private S3 objects through the Fuvekon proxy.
class S3Image extends StatefulWidget {
  const S3Image({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.onTap,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  @override
  State<S3Image> createState() => _S3ImageState();
}

class _S3ImageState extends State<S3Image> {
  bool _loadFailed = false;

  @override
  void didUpdateWidget(covariant S3Image oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadFailed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawUrl = widget.imageUrl;
    final hasUrl = rawUrl != null && rawUrl.isNotEmpty;
    final resolvedUrl =
        hasUrl && !_loadFailed ? S3Url.resolveImageUrl(rawUrl) : null;

    final child = resolvedUrl == null
        ? _Placeholder(
            width: widget.width,
            height: widget.height,
          )
        : Image.network(
            resolvedUrl,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _Placeholder(
                width: widget.width,
                height: widget.height,
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (_, _, _) {
              if (!_loadFailed) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _loadFailed = true);
                });
              }
              return _Placeholder(
                width: widget.width,
                height: widget.height,
                icon: Icons.broken_image_outlined,
              );
            },
          );

    final image = ClipRRect(
      borderRadius: widget.borderRadius,
      child: child,
    );

    if (widget.onTap == null) return image;

    return GestureDetector(
      onTap: widget.onTap,
      child: image,
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    this.width,
    this.height,
    this.child,
    this.icon = Icons.image_outlined,
  });

  final double? width;
  final double? height;
  final Widget? child;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: FuvekonColors.darkBorder.withValues(alpha: 0.35),
      child: child ??
          Icon(
            icon,
            color: FuvekonColors.darkTextSecondary,
          ),
    );
  }
}

void showS3ImagePreview(BuildContext context, String imageUrl) {
  showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          InteractiveViewer(
            child: S3Image(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded),
              color: FuvekonColors.darkText,
            ),
          ),
        ],
      ),
    ),
  );
}
