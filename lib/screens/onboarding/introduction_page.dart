import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/shared/services/app_preferences.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  static const heroBannerAsset = 'assets/images/Section - Hero Banner.png';

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _version = info.version);
  }

  Future<void> _continue() async {
    await sl<AppPreferences>().setIntroductionCompleted(true);
    if (!mounted) return;
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FuvekonNavScaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeroBanner(
                    assetPath: IntroductionPage.heroBannerAsset,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 20),
                  _InfoCard(
                    icon: Icons.account_balance_outlined,
                    title: l10n.introWhatIsTitle,
                    body: l10n.introWhatIsBody,
                  ),
                  const SizedBox(height: 16),
                  _AudienceCard(l10n: l10n),
                  const SizedBox(height: 20),
                  _OutlineActionButton(
                    icon: Icons.description_outlined,
                    label: l10n.introViewRules,
                    onTap: () => context.go(Routes.tos),
                  ),
                  const SizedBox(height: 12),
                  _OutlineActionButton(
                    icon: Icons.help_outline,
                    label: l10n.introViewFaq,
                    onTap: () => context.go(Routes.faq),
                  ),
                  const SizedBox(height: 28),
                  _Footer(version: _version, l10n: l10n),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: FilledButton(
              onPressed: _continue,
              style: FilledButton.styleFrom(
                backgroundColor: _IntroColors.accentGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: Text(
                l10n.continueButton,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

abstract final class _IntroColors {
  static const cardBg = Color(0xFFF0F2F0);
  static const textDark = Color(0xFF0A2E1F);
  static const textMuted = Color(0xFF48715B);
  static const accentGreen = Color(0xFF4A7C59);
  static const heroTitle = Color(0xFFD1EAD8);
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.assetPath, required this.l10n});

  final String assetPath;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                color: FuvekonColors.darkSurface,
                child: Icon(
                  Icons.image_outlined,
                  size: 48,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.82),
                  ],
                  stops: const [0.35, 0.72, 1],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Text(
                      l10n.introBadge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                      children: [
                        TextSpan(
                          text: l10n.introHeroLine1,
                          style: const TextStyle(color: _IntroColors.heroTitle),
                        ),
                        TextSpan(
                          text: l10n.introHeroBrand,
                          style: const TextStyle(color: _IntroColors.heroTitle),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.introHeroSubtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 14,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _IntroColors.cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF121212),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _IntroColors.textDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            body,
            style: const TextStyle(
              color: _IntroColors.textMuted,
              fontSize: 14.5,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _AudienceCard extends StatelessWidget {
  const _AudienceCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: Icons.brush_outlined,
        color: const Color(0xFF4A7C59),
        title: l10n.introAudienceArtistTitle,
        body: l10n.introAudienceArtistBody,
      ),
      (
        icon: Icons.confirmation_num_outlined,
        color: const Color(0xFFE879A8),
        title: l10n.introAudienceFanTitle,
        body: l10n.introAudienceFanBody,
      ),
      (
        icon: Icons.diamond_outlined,
        color: const Color(0xFFE8B84A),
        title: l10n.introAudienceOrganizerTitle,
        body: l10n.introAudienceOrganizerBody,
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      decoration: BoxDecoration(
        color: _IntroColors.cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF121212),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.groups_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.introAudienceTitle,
                style: const TextStyle(
                  color: _IntroColors.textDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icon, color: item.color, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: _IntroColors.textDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.body,
                          style: const TextStyle(
                            color: _IntroColors.textMuted,
                            fontSize: 13.5,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.version, required this.l10n});

  final String version;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'FUVEKON',
          style: TextStyle(
            color: Color(0xFF888888),
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            fontSize: 13,
          ),
        ),
        if (version.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            l10n.versionLabel(version),
            style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
          ),
        ],
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
            children: [
              const TextSpan(text: 'contact@fuvekon.vn'),
              TextSpan(
                text: ' | ${l10n.supportLabel}',
                style: TextStyle(
                  color: _IntroColors.accentGreen.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
