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
      icon: Icons.celebration_outlined,
      gradient: [Color(0xFF1A2E24), Color(0xFF2D5A40)],
    ),
    _OnboardingSlide(
      title: 'Kết nối cộng đồng yêu nghệ thuật',
      body:
          'Gặp gỡ nghệ sĩ, dealer và fan cùng đam mê trong một không gian sôi động.',
      icon: Icons.groups_outlined,
      gradient: [Color(0xFF1E2430), Color(0xFF3A4F5C)],
    ),
    _OnboardingSlide(
      title: 'Quản lý vé và trải nghiệm của bạn',
      body:
          'Mua vé, theo dõi lịch trình và tận hưởng sự kiện một cách thuận tiện nhất.',
      icon: Icons.confirmation_num_outlined,
      gradient: [Color(0xFF241E30), Color(0xFF4A3A5C)],
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
    context.go(Routes.language);
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
      backgroundColor: FuvekonColors.darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            FuvekonSpacing.page,
            16,
            FuvekonSpacing.page,
            12,
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) =>
                      _OnboardingSlideCard(slide: _slides[index]),
                ),
              ),
              const SizedBox(height: 20),
              _PageIndicator(
                count: _slides.length,
                current: _currentPage,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  TextButton(
                    onPressed: _finish,
                    child: const Text(
                      'BỎ QUA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: FuvekonColors.outline,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(140, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == _slides.length - 1
                              ? 'BẮT ĐẦU'
                              : 'TIẾP THEO',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 6),
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

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.title,
    required this.body,
    required this.icon,
    required this.gradient,
  });

  final String title;
  final String body;
  final IconData icon;
  final List<Color> gradient;
}

class _OnboardingSlideCard extends StatelessWidget {
  const _OnboardingSlideCard({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(FuvekonRadii.card),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: slide.gradient,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          FuvekonColors.darkPrimary.withValues(alpha: 0.08),
                          Colors.transparent,
                          FuvekonColors.outline.withValues(alpha: 0.15),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(
                      slide.icon,
                      size: 88,
                      color: FuvekonColors.darkPrimary.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ColoredBox(
              color: FuvekonColors.darkCard,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slide.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: FuvekonColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      slide.body,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: FuvekonColors.textSecondary,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 10 : 8,
          height: active ? 10 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? FuvekonColors.darkPrimary
                : FuvekonColors.darkSurfaceElevated,
          ),
        );
      }),
    );
  }
}
