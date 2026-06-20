import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_submission_l10n.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/shared/widgets/s3_avatar.dart';

class AdminUserSectionTitle extends StatelessWidget {
  const AdminUserSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: FuvekonColors.darkAppBarTitle,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class AdminUserEditSectionCard extends StatelessWidget {
  const AdminUserEditSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: FuvekonColors.darkBorder.withValues(alpha: 0.6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: FuvekonColors.darkText,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
              ),
            ],
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class AdminUserProfileHeader extends StatelessWidget {
  const AdminUserProfileHeader({
    super.key,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    this.initials = '?',
    this.role,
    this.detailStyle = false,
    this.isVerified = false,
    this.isBlacklisted = false,
    this.isDeleted = false,
    this.country,
  });

  final String displayName;
  final String email;
  final String? avatarUrl;
  final String initials;
  final String? role;
  final bool detailStyle;
  final bool isVerified;
  final bool isBlacklisted;
  final bool isDeleted;
  final String? country;

  @override
  Widget build(BuildContext context) {
    if (detailStyle) {
      return _DetailProfileHeader(
        displayName: displayName,
        email: email,
        avatarUrl: avatarUrl,
        initials: initials,
        role: role,
        isVerified: isVerified,
        isBlacklisted: isBlacklisted,
        isDeleted: isDeleted,
        country: country,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkCard,
        borderRadius: BorderRadius.circular(FuvekonRadii.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            S3Avatar(
              imageUrl: avatarUrl,
              initials: initials,
              radius: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: FuvekonColors.darkCardText,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: FuvekonColors.textSecondary,
                        ),
                  ),
                  if (role != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            FuvekonColors.darkPrimary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        context.l10n.adminRoleCurrent(
                          adminRoleTitle(context.l10n, role!),
                        ),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: FuvekonColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailProfileHeader extends StatelessWidget {
  const _DetailProfileHeader({
    required this.displayName,
    required this.email,
    this.avatarUrl,
    required this.initials,
    this.role,
    required this.isVerified,
    required this.isBlacklisted,
    required this.isDeleted,
    this.country,
  });

  final String displayName;
  final String email;
  final String? avatarUrl;
  final String initials;
  final String? role;
  final bool isVerified;
  final bool isBlacklisted;
  final bool isDeleted;
  final String? country;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: FuvekonColors.darkPrimary.withValues(alpha: 0.7),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: FuvekonColors.darkPrimary.withValues(alpha: 0.25),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: S3Avatar(
                imageUrl: avatarUrl,
                initials: initials,
                radius: 44,
              ),
            ),
            if (isVerified)
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: FuvekonColors.available,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: FuvekonColors.darkBg,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          displayName,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: FuvekonColors.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          email,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: FuvekonColors.darkTextSecondary,
          ),
        ),
        if (country != null && country!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            country!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.8),
            ),
          ),
        ],
        if (role != null) ...[
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusPill(
                icon: Icons.person_outline_rounded,
                label: adminRoleSubtitle(l10n, role!),
                background: FuvekonColors.darkSurfaceElevated,
                foreground: FuvekonColors.darkTextSecondary,
              ),
              _StatusPill(
                label: _statusLabel(l10n),
                background: _statusBackground,
                foreground: _statusForeground,
                leading: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isDeleted
                        ? FuvekonColors.darkTextSecondary
                        : isBlacklisted
                            ? const Color(0xFFFBBF24)
                            : FuvekonColors.available,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _statusLabel(AppLocalizations l10n) {
    if (isDeleted) return l10n.adminStatusPillDeleted;
    if (isBlacklisted) return l10n.adminStatusPillBlacklisted;
    return l10n.adminStatusPillActive;
  }

  Color get _statusBackground {
    if (isDeleted) return FuvekonColors.darkSurfaceElevated;
    if (isBlacklisted) return const Color(0xFFFBBF24).withValues(alpha: 0.2);
    return FuvekonColors.darkCard;
  }

  Color get _statusForeground {
    if (isDeleted) return FuvekonColors.darkTextSecondary;
    if (isBlacklisted) return const Color(0xFFFBBF24);
    return FuvekonColors.darkCardText;
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    this.leading,
  });

  final IconData? icon;
  final String label;
  final Color background;
  final Color foreground;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: FuvekonColors.darkBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null)
            leading!
          else if (icon != null)
            Icon(icon, size: 14, color: foreground),
          if (leading != null || icon != null) const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class AdminUserRoleGrid extends StatelessWidget {
  const AdminUserRoleGrid({
    super.key,
    required this.selectedRole,
    required this.enabled,
    required this.onRoleSelected,
  });

  final String selectedRole;
  final bool enabled;
  final ValueChanged<String> onRoleSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: [
        for (final role in adminRoleOptions)
          _RoleCard(
            role: role,
            selected: selectedRole.toLowerCase() == role.toLowerCase(),
            enabled: enabled,
            onTap: () => onRoleSelected(role),
          ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String role;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final borderColor = selected
        ? FuvekonColors.darkPrimary
        : FuvekonColors.darkBorder.withValues(alpha: 0.7);
    final bg = selected
        ? FuvekonColors.darkSurface
        : FuvekonColors.darkBg.withValues(alpha: 0.35);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        adminRoleTitle(l10n, role),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: FuvekonColors.darkText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _RoleRadioIndicator(selected: selected),
                  ],
                ),
                const Spacer(),
                Text(
                  adminRoleSubtitle(l10n, role),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: FuvekonColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleRadioIndicator extends StatelessWidget {
  const _RoleRadioIndicator({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? FuvekonColors.darkPrimary
              : FuvekonColors.darkTextSecondary,
          width: 2,
        ),
        color: selected ? FuvekonColors.darkPrimary : Colors.transparent,
      ),
      child: selected
          ? const Center(
              child: CircleAvatar(
                radius: 4,
                backgroundColor: FuvekonColors.darkButtonText,
              ),
            )
          : null,
    );
  }
}

class AdminUserPermissionGroup extends StatelessWidget {
  const AdminUserPermissionGroup({
    super.key,
    required this.permissions,
    required this.enabled,
    required this.onToggle,
  });

  final List<String> permissions;
  final bool enabled;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkBg.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FuvekonColors.darkBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          for (var i = 0; i < adminPermissionCodes.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                color: FuvekonColors.darkBorder.withValues(alpha: 0.5),
              ),
            _PermissionTile(
              code: adminPermissionCodes[i],
              checked: permissions.contains(adminPermissionCodes[i]),
              enabled: enabled,
              onTap: () => onToggle(adminPermissionCodes[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.code,
    required this.checked,
    required this.enabled,
    required this.onTap,
  });

  final String code;
  final bool checked;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  adminPermissionLabel(l10n, code),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: FuvekonColors.darkText,
                  ),
                ),
              ),
              _PermissionCheckbox(checked: checked, enabled: enabled),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionCheckbox extends StatelessWidget {
  const _PermissionCheckbox({required this.checked, required this.enabled});

  final bool checked;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bg = checked ? FuvekonColors.darkPrimary : Colors.transparent;
    final border = checked
        ? FuvekonColors.darkPrimary
        : FuvekonColors.darkTextSecondary.withValues(alpha: enabled ? 1 : 0.4);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border, width: 1.5),
      ),
      child: checked
          ? const Icon(
              Icons.check_rounded,
              size: 16,
              color: FuvekonColors.darkButtonText,
            )
          : null,
    );
  }
}
