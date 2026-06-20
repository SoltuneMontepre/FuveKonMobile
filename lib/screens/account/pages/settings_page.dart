import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/locale/locale_notifier.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/services/app_preferences.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_settings_row.dart';

/// Màn 42 — app settings (locale).
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _localeNotifier = sl<LocaleNotifier>();
  String _language = 'vi';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final saved = await sl<AppPreferences>().languageCode;
    if (!mounted) return;
    setState(() => _language = saved ?? _localeNotifier.locale.languageCode);
  }

  Future<void> _setLanguage(String code) async {
    setState(() => _language = code);
    _localeNotifier.update(Locale(code));
    await sl<AppPreferences>().setLanguageCode(code);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _localeNotifier,
      builder: (context, _) {
        return AppPageScaffold(
          title: 'Cài đặt',
          padding: EdgeInsets.zero,
          body: ListView(
            padding: const EdgeInsets.all(FuvekonSpacing.page),
            children: [
              const FuveSectionHeader(title: 'Ngôn ngữ'),
              const SizedBox(height: FuvekonSpacing.stackGapMd),
              FuveMintCard(
                child: Column(
                  children: [
                    _LanguageRow(
                      label: 'Tiếng Việt',
                      selected: _language == 'vi',
                      onTap: () => _setLanguage('vi'),
                      showDivider: true,
                    ),
                    _LanguageRow(
                      label: 'English',
                      selected: _language == 'en',
                      onTap: () => _setLanguage('en'),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.showDivider,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return FuveSettingsRow(
      icon: Icons.language,
      label: label,
      onTap: onTap,
      showDivider: showDivider,
      trailing: selected
          ? Icon(Icons.check_circle, color: FuvekonColors.premiumPrimary, size: 22)
          : Icon(Icons.circle_outlined, color: FuvekonColors.premiumOutline, size: 22),
    );
  }
}
