import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/locale/locale_notifier.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/services/app_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const _logoAsset = 'assets/images/logo/image.png';
  static const _splashDuration = Duration(milliseconds: 2200);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  String _version = '';

  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadVersion();
    _navigateNext();
  }

  void _initAnimations() {
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0, 0.45, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _titleFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.18, 0.62, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.18, 0.62, curve: Curves.easeOutCubic),
      ),
    );

    _taglineFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.32, 0.78, curve: Curves.easeOut),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.32, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    _footerFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.48, 0.92, curve: Curves.easeOut),
    );

    _entranceController.forward();
    _entranceController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _pulseController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _version = 'v${info.version}');
  }

  Future<void> _navigateNext() async {
    await Future<void>.delayed(SplashPage._splashDuration);
    if (!mounted) return;

    final prefs = sl<AppPreferences>();
    final languageCode = await prefs.languageCode;
    if (!mounted) return;

    if (languageCode == null) {
      context.go(Routes.language);
      return;
    }

    sl<LocaleNotifier>().update(Locale(languageCode));

    final rulesAccepted = await prefs.eventRulesAccepted;
    if (!mounted) return;

    if (!rulesAccepted) {
      context.go(Routes.tosOnboarding);
      return;
    }

    final introDone = await prefs.introductionCompleted;
    if (!mounted) return;

    if (!introDone) {
      context.go(Routes.introduction);
      return;
    }

    context.go(Routes.home);
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
              AnimatedBuilder(
                animation: Listenable.merge([_logoFade, _logoScale, _pulseController]),
                builder: (context, child) {
                  final breathe = 1 + (_pulseController.value * 0.035);
                  return Opacity(
                    opacity: _logoFade.value,
                    child: Transform.scale(
                      scale: _logoScale.value * breathe,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
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
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _titleFade,
                child: SlideTransition(
                  position: _titleSlide,
                  child: const _BrandTitle(),
                ),
              ),
              const SizedBox(height: 12),
              FadeTransition(
                opacity: _taglineFade,
                child: SlideTransition(
                  position: _taglineSlide,
                  child: Text(
                    context.l10n.splashTagline,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: FuvekonColors.darkText.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w300,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(flex: 4),
              FadeTransition(
                opacity: _footerFade,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _LoadingDots(),
                    if (_version.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        _version,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: FuvekonColors.darkTextSecondary.withValues(
                                alpha: 0.6,
                              ),
                            ),
                      ),
                    ],
                  ],
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

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final phase = (_controller.value + index * 0.22) % 1.0;
            final opacity = 0.25 + (Curves.easeInOut.transform(phase) * 0.75);
            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 6),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: FuvekonColors.tier3,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
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
          color: Colors.white,
        );

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white,
          Color(0xFFE8D5A8),
          FuvekonColors.tier3,
        ],
        stops: [0.0, 0.55, 1.0],
      ).createShader(bounds),
      child: Text(
        'FUVEKON',
        style: baseStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
