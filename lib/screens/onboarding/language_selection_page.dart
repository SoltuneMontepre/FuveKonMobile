import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/locale/locale_notifier.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/services/app_preferences.dart';
import 'package:go_router/go_router.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String _selected = 'vi';

  Future<void> _continue() async {
    await sl<AppPreferences>().setLanguageCode(_selected);
    sl<LocaleNotifier>().update(Locale(_selected));
    if (!mounted) return;
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(FuvekonSpacing.page),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Chọn ngôn ngữ',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vui lòng chọn ngôn ngữ để tiếp tục',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
              ),
              const SizedBox(height: 40),
              _LanguageOption(
                label: 'Tiếng Việt',
                selected: _selected == 'vi',
                onTap: () => setState(() => _selected = 'vi'),
              ),
              const SizedBox(height: 16),
              _LanguageOption(
                label: 'English',
                selected: _selected == 'en',
                onTap: () => setState(() => _selected = 'en'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: _continue,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tiếp tục'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? FuvekonColors.darkPrimary
          : FuvekonColors.darkSurfaceElevated,
      borderRadius: BorderRadius.circular(FuvekonRadii.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FuvekonRadii.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Row(
            children: [
              Icon(
                Icons.language,
                color: selected
                    ? FuvekonColors.darkButtonText
                    : FuvekonColors.darkTextSecondary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: selected
                            ? FuvekonColors.darkButtonText
                            : Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle,
                  color: FuvekonColors.darkButtonText,
                )
              else
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: FuvekonColors.darkTextSecondary,
                      width: 1.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
