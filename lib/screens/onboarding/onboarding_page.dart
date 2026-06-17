import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/services/app_preferences.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _slides = [
    _OnboardingSlide(
      title: 'Khám phá sự kiện và hoạt động nổi bật',
      body:
          'Hòa mình vào không gian giao lưu văn hóa, mua sắm và trải nghiệm nghệ thuật độc đáo.',
      imageAsset: 'assets/images/logo/onboarding.png',
    ),
    _OnboardingSlide(
      title: 'Kết nối cộng đồng yêu nghệ thuật',
      body:
          'Gặp gỡ nghệ sĩ, dealer và fan cùng đam mê trong một không gian sôi động.',
      imageAsset: 'assets/images/logo/onboarding.png',
    ),
    _OnboardingSlide(
      title: 'Quản lý vé và trải nghiệm của bạn',
      body:
          'Mua vé, theo dõi lịch trình và tận hưởng sự kiện một cách thuận tiện nhất.',
      imageAsset: 'assets/images/logo/onboarding.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await sl<AppPreferences>().setOnboardingCompleted(true);
    if (!mounted) return;
    context.go(Routes.login);
  }

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    _finish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _OnboardingColors.screenBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: _OnboardingSlideCard(slide: _slides[index]),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _PageIndicator(
                count: _slides.length,
                current: _currentPage,
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _finish,
                    style: TextButton.styleFrom(
                      foregroundColor: _OnboardingColors.skipText,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 14,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'BỎ QUA',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: _OnboardingColors.accentGreen,
                      foregroundColor: const Color(0xFFE8EDE9),
                      minimumSize: const Size(168, 52),
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == _slides.length - 1
                              ? 'BẮT ĐẦU'
                              : 'TIẾP THEO',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

abstract final class _OnboardingColors {
  static const screenBg = FuvekonColors.darkBg;
  static const accentGreen = FuvekonColors.sageGreenContainer;
  static const cardPanel = FuvekonColors.mintCard;
  static const textDark = FuvekonColors.darkButtonText;
  static const skipText = Color(0xFF888888);
  static const inactiveDot = Color(0xFF3D3D3D);

  static const cardRadius = 36.0;

  /// Desaturate + slight green cast to match Figma hero art.
  static const grayscaleMatrix = <double>[
    0.18, 0.55, 0.09, 0, 0,
    0.18, 0.55, 0.09, 0, 0,
    0.18, 0.55, 0.09, 0, 0,
    0, 0, 0, 1, 0,
  ];
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.title,
    required this.body,
    this.imageAsset,
  });

  final String title;
  final String body;
  final String? imageAsset;
}

class _OnboardingSlideCard extends StatelessWidget {
  const _OnboardingSlideCard({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_OnboardingColors.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 32,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_OnboardingColors.cardRadius),
        child: Column(
          children: [
            Expanded(
              flex: 13,
              child: _SlideHero(imageAsset: slide.imageAsset!),
            ),
            Expanded(
              flex: 10,
              child: ColoredBox(
                color: _OnboardingColors.cardPanel,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 28, 32, 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        slide.title,
                        style: const TextStyle(
                          color: _OnboardingColors.textDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          height: 1.35,
                          letterSpacing: -0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        slide.body,
                        style: TextStyle(
                          color: _OnboardingColors.textDark.withValues(
                            alpha: 0.88,
                          ),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.5,
                          height: 1.55,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideHero extends StatelessWidget {
  const _SlideHero({required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.matrix(
            _OnboardingColors.grayscaleMatrix,
          ),
          child: Image.asset(
            imageAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) => ColoredBox(
              color: FuvekonColors.darkSurface,
              child: Icon(
                Icons.image_outlined,
                size: 64,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1A3328).withValues(alpha: 0.25),
                Colors.transparent,
                Colors.transparent,
              ],
              stops: const [0, 0.35, 1],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 110,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _OnboardingColors.cardPanel.withValues(alpha: 0),
                  _OnboardingColors.cardPanel.withValues(alpha: 0.35),
                  _OnboardingColors.cardPanel.withValues(alpha: 0.92),
                  _OnboardingColors.cardPanel,
                ],
                stops: const [0, 0.35, 0.72, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.count,
    required this.current,
  });

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: active ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: active
                ? _OnboardingColors.accentGreen
                : _OnboardingColors.inactiveDot,
          ),
        );
      }),
    );
  }
}
