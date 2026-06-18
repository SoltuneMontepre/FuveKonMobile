import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_illustrated_background.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';
import 'package:go_router/go_router.dart';

class ArtbookPage extends StatelessWidget {
  const ArtbookPage({super.key});

  static const coverAsset = 'assets/images/cover-artbook.png';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      drawer: const FuvekonGuestDrawer(),
      body: FuvekonIllustratedPageStack(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _ArtbookHeader(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _CoverImage(),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: -72,
                      child: _ArtbookInfoCard(l10n: l10n),
                    ),
                  ],
                ),
                const SizedBox(height: 88),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArtbookHeader extends StatelessWidget {
  const _ArtbookHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 12, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            onPressed: () => FuvekonGuestDrawer.open(context),
            visualDensity: VisualDensity.compact,
          ),
          const Expanded(
            child: Text(
              'FUVEKON',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: FuvekonColors.darkPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontSize: 15,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            tooltip: MaterialLocalizations.of(context).searchFieldLabel,
            onPressed: () {},
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(
        ArtbookPage.coverAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => ColoredBox(
          color: FuvekonColors.darkSurfaceElevated,
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

class _ArtbookInfoCard extends StatelessWidget {
  const _ArtbookInfoCard({required this.l10n});

  final AppLocalizations l10n;

  static const _accent = Color(0xFFCD6B52);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        FuvekonIllustratedContentPanel(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.artbookTitle,
                style: const TextStyle(
                  color: FuvekonColors.darkPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.artbookSubtitle,
                style: TextStyle(
                  color: _accent.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.artbookDescription,
                style: TextStyle(
                  color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.95),
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _SpecItem(
                      icon: Icons.auto_stories_outlined,
                      label: l10n.artbookPageCount,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SpecItem(
                      icon: Icons.description_outlined,
                      label: l10n.artbookPaperType,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.push(Routes.artbookSubmit),
                  style: FilledButton.styleFrom(
                    backgroundColor: FuvekonColors.sageGreenContainer,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    l10n.artbookSubmitCta,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Positioned(top: 12, left: 12, child: _CornerAccent(flip: false)),
        const Positioned(bottom: 12, right: 12, child: _CornerAccent(flip: true)),
      ],
    );
  }
}

class _CornerAccent extends StatelessWidget {
  const _CornerAccent({required this.flip});

  final bool flip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(
        painter: _CornerAccentPainter(flip: flip),
      ),
    );
  }
}

class _CornerAccentPainter extends CustomPainter {
  const _CornerAccentPainter({required this.flip});

  final bool flip;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = FuvekonColors.lightGold
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (flip) {
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);
      canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
    } else {
      canvas.drawLine(Offset.zero, const Offset(0, 18), paint);
      canvas.drawLine(Offset.zero, const Offset(18, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpecItem extends StatelessWidget {
  const _SpecItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: FuvekonColors.darkPrimary.withValues(alpha: 0.75)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.95),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
