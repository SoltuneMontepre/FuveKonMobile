import 'package:fuvekonmobile/l10n/app_localizations.dart';

abstract final class ConbookContent {
  static List<String> formatRequirements(AppLocalizations l10n) => [
    l10n.artbookRulesFormat1,
    l10n.artbookRulesFormat2,
    l10n.artbookRulesFormat3,
    l10n.artbookRulesFormat4,
  ];

  static List<String> tips(AppLocalizations l10n) => [
    l10n.artbookRulesTip1,
    l10n.artbookRulesTip2,
    l10n.artbookRulesTip3,
    l10n.artbookRulesTip4,
    l10n.artbookRulesTip5,
    l10n.artbookRulesTip6,
    l10n.artbookRulesTip7,
    l10n.artbookRulesTip8,
    l10n.artbookRulesTip9,
  ];
}
