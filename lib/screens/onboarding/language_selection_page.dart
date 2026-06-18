import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
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

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final saved = await sl<AppPreferences>().languageCode;
    if (!mounted || saved == null) return;
    setState(() => _selected = saved);
    sl<LocaleNotifier>().update(Locale(saved));
  }

  void _selectLanguage(String code) {
    setState(() => _selected = code);
    sl<LocaleNotifier>().update(Locale(code));
  }

  Future<void> _continue() async {
    await sl<AppPreferences>().setLanguageCode(_selected);
    sl<LocaleNotifier>().update(Locale(_selected));
    if (!mounted) return;
    context.go(Routes.tosOnboarding);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                l10n.languageTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.languageSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
              ),
              const SizedBox(height: 40),
              _LanguageOption(
                label: l10n.languageVietnamese,
                selected: _selected == 'vi',
                onTap: () => _selectLanguage('vi'),
              ),
              const SizedBox(height: 16),
              _LanguageOption(
                label: l10n.languageEnglish,
                selected: _selected == 'en',
                onTap: () => _selectLanguage('en'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: _continue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.continueButton),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
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
