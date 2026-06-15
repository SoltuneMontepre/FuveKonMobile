import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/locale/locale_notifier.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/services/app_preferences.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const _logoAsset = 'assets/images/logo/image.png';
  static const _splashDuration = Duration(milliseconds: 2200);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future<void>.delayed(SplashPage._splashDuration);
    if (!mounted) return;

    final prefs = sl<AppPreferences>();
    final onboardingDone = await prefs.onboardingCompleted;
    if (!mounted) return;

    if (!onboardingDone) {
      context.go(Routes.onboarding);
      return;
    }

    final languageCode = await prefs.languageCode;
    if (!mounted) return;

    if (languageCode == null) {
      context.go(Routes.language);
      return;
    }

    sl<LocaleNotifier>().update(Locale(languageCode));
    if (!mounted) return;
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: FuvekonSpacing.page),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Image.asset(
                SplashPage._logoAsset,
                width: 160,
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.account_circle_outlined,
                  size: 120,
                  color: FuvekonColors.darkText.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 28),
              const _BrandTitle(),
              const SizedBox(height: 12),
              Text(
                'Nơi kết nối cộng đồng sự kiện và nghệ thuậtkjlscxdgflhjkgfdkjhiudgfjhkdfg',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: FuvekonColors.darkText.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 4),
              Text(
                'v1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandTitle extends StatelessWidget {
  const _BrandTitle();

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: 3,
      fontSize: 34,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'FUVE',
            style: baseStyle?.copyWith(color: Colors.white),
          ),
          TextSpan(
            text: 'KON',
            style: baseStyle?.copyWith(color: FuvekonColors.tier3),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
