import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/utils/s3_url.dart';

/// Avatar that loads private S3 images through the Fuvekon web image proxy.
class S3Avatar extends StatefulWidget {
  const S3Avatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.radius = 48,
  });

  final String? imageUrl;
  final String initials;
  final double radius;

  @override
  State<S3Avatar> createState() => _S3AvatarState();
}

class _S3AvatarState extends State<S3Avatar> {
  bool _loadFailed = false;

  @override
  void didUpdateWidget(covariant S3Avatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadFailed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final rawUrl = widget.imageUrl;
    final hasUrl = rawUrl != null && rawUrl.isNotEmpty;
    final resolvedUrl = hasUrl && !_loadFailed
        ? S3Url.resolveImageUrl(rawUrl)
        : null;

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      backgroundImage: resolvedUrl != null ? NetworkImage(resolvedUrl) : null,
      onBackgroundImageError: resolvedUrl != null
          ? (_, _) {
              if (!_loadFailed) {
                setState(() => _loadFailed = true);
              }
            }
          : null,
      child: resolvedUrl == null
          ? Text(widget.initials, style: theme.textTheme.headlineMedium)
          : null,
    );
  }
}
