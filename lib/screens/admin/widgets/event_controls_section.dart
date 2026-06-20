import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_event_settings_service.dart';

class EventControlsSection extends StatelessWidget {
  const EventControlsSection({
    super.key,
    required this.settings,
    this.loading = false,
    this.updatingToggle,
    this.onToggle,
    this.onRefresh,
  });

  final AdminEventSettings? settings;
  final bool loading;
  final AdminEventToggle? updatingToggle;
  final Future<void> Function(AdminEventToggle toggle, bool enabled)? onToggle;
  final VoidCallback? onRefresh;

  static final _controls =
      <
        ({
          AdminEventToggle toggle,
          String Function(AppLocalizations l10n) title,
          String Function(AppLocalizations l10n) subtitle,
          IconData icon,
          bool Function(AdminEventSettings settings) isEnabled,
        })
      >[
        (
          toggle: AdminEventToggle.ticketSales,
          title: (l10n) => l10n.adminEventToggleTicketSales,
          subtitle: (l10n) => l10n.adminEventToggleTicketSalesSubtitle,
          icon: Icons.confirmation_number_outlined,
          isEnabled: _ticketSalesEnabled,
        ),
        (
          toggle: AdminEventToggle.panelRegistration,
          title: (l10n) => l10n.adminEventTogglePanelRegistration,
          subtitle: (l10n) => l10n.adminEventTogglePanelRegistrationSubtitle,
          icon: Icons.groups_outlined,
          isEnabled: _panelRegistrationEnabled,
        ),
        (
          toggle: AdminEventToggle.talentRegistration,
          title: (l10n) => l10n.adminEventToggleTalentRegistration,
          subtitle: (l10n) => l10n.adminEventToggleTalentRegistrationSubtitle,
          icon: Icons.mic_external_on_outlined,
          isEnabled: _talentRegistrationEnabled,
        ),
        (
          toggle: AdminEventToggle.dealerRegistration,
          title: (l10n) => l10n.adminEventToggleDealerRegistration,
          subtitle: (l10n) => l10n.adminEventToggleDealerRegistrationSubtitle,
          icon: Icons.storefront_outlined,
          isEnabled: _dealerRegistrationEnabled,
        ),
      ];

  static bool _ticketSalesEnabled(AdminEventSettings settings) =>
      settings.ticketSalesEnabled;
  static bool _panelRegistrationEnabled(AdminEventSettings settings) =>
      settings.panelRegistrationEnabled;
  static bool _talentRegistrationEnabled(AdminEventSettings settings) =>
      settings.talentRegistrationEnabled;
  static bool _dealerRegistrationEnabled(AdminEventSettings settings) =>
      settings.dealerRegistrationEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.adminEventControlsTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: FuvekonColors.darkAppBarTitle,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.adminEventControlsSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onRefresh != null)
              IconButton(
                onPressed: loading ? null : onRefresh,
                icon: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh_rounded),
                color: FuvekonColors.darkTextSecondary,
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (settings == null && loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(),
            ),
          )
        else if (settings != null)
          ..._controls.map((control) {
            final enabled = control.isEnabled(settings!);
            final isUpdating = updatingToggle == control.toggle;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _EventToggleCard(
                title: control.title(l10n),
                subtitle: control.subtitle(l10n),
                icon: control.icon,
                value: enabled,
                loading: isUpdating,
                onChanged: onToggle == null || isUpdating
                    ? null
                    : (value) => onToggle!(control.toggle, value),
              ),
            );
          }),
      ],
    );
  }
}

class _EventToggleCard extends StatelessWidget {
  const _EventToggleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    this.loading = false,
    this.onChanged,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final bool loading;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = value
        ? FuvekonColors.available
        : FuvekonColors.darkTextSecondary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: FuvekonColors.darkBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: FuvekonColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeThumbColor: FuvekonColors.available,
              ),
          ],
        ),
      ),
    );
  }
}
