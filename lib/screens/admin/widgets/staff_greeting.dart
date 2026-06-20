import 'package:fuvekonmobile/l10n/app_localizations.dart';

String staffGreeting(AppLocalizations l10n) {
  final hour = DateTime.now().hour;
  if (hour < 12) return l10n.adminStaffGreetingMorning;
  if (hour < 18) return l10n.adminStaffGreetingAfternoon;
  return l10n.adminStaffGreetingEvening;
}
