import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/widgets/s3_avatar.dart';

/// Top bar: brand and profile — matches the logged-in home screen.
class FuvekonHomeAppBar extends StatelessWidget {
  const FuvekonHomeAppBar({
    super.key,
    this.avatarUrl,
    this.initials = '?',
    this.onProfileTap,
    this.onMenuTap,
  });

  final String? avatarUrl;
  final String initials;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          if (onMenuTap != null)
            IconButton(
              onPressed: onMenuTap,
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              icon: const Icon(Icons.menu_rounded, color: FuvekonColors.darkText),
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              'FUVEKON',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: FuvekonColors.darkText,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
            ),
          ),
          IconButton(
            onPressed: onProfileTap,
            padding: EdgeInsets.zero,
            tooltip: 'Hồ sơ',
            icon: S3Avatar(
              imageUrl: avatarUrl,
              initials: initials,
              radius: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class FuvekonHomeGreeting extends StatelessWidget {
  const FuvekonHomeGreeting({
    super.key,
    required this.name,
    required this.subtitle,
  });

  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xin chào, $name',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: FuvekonColors.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: FuvekonColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}

class FuvekonHeroBanner extends StatelessWidget {
  const FuvekonHeroBanner({
    super.key,
    this.badge = 'Sự kiện chính',
    this.title = 'Lễ hội Giao lưu Văn hóa Anime',
  });

  final String badge;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(FuvekonRadii.card),
      child: SizedBox(
        height: 168,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2D1B4E),
                    const Color(0xFF5B2D8E),
                    const Color(0xFF1A1F2E),
                  ],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.celebration_outlined,
                    size: 72,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: FuvekonColors.available,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Light sage card used for ticket / schedule / status blocks.
class FuvekonSageCard extends StatelessWidget {
  const FuvekonSageCard({
    super.key,
    required this.title,
    required this.child,
    this.badge,
    this.badgeColor,
    this.badgeIcon,
  });

  final String title;
  final Widget child;
  final String? badge;
  final Color? badgeColor;
  final IconData? badgeIcon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkCard,
        borderRadius: BorderRadius.circular(FuvekonRadii.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: FuvekonColors.darkCardText,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? FuvekonColors.available)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (badgeIcon != null) ...[
                          Icon(
                            badgeIcon,
                            size: 14,
                            color: badgeColor ?? FuvekonColors.available,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          badge!,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: badgeColor ?? FuvekonColors.available,
                                    fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class FuvekonUtilityItem {
  const FuvekonUtilityItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.accentColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? accentColor;
}

class FuvekonUtilitySection extends StatelessWidget {
  const FuvekonUtilitySection({
    super.key,
    required this.items,
  });

  final List<FuvekonUtilityItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiện ích',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: FuvekonColors.darkText,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: items.map((item) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _UtilityTile(item: item),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _UtilityTile extends StatelessWidget {
  const _UtilityTile({required this.item});

  final FuvekonUtilityItem item;

  @override
  Widget build(BuildContext context) {
    final accent = item.accentColor ?? FuvekonColors.darkPrimary;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: FuvekonColors.darkSurfaceElevated,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: accent, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class FuvekonQuickActionItem {
  const FuvekonQuickActionItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class FuvekonQuickActionsSection extends StatelessWidget {
  const FuvekonQuickActionsSection({
    super.key,
    required this.items,
  });

  final List<FuvekonQuickActionItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bolt_rounded, color: const Color(0xFFFBBF24), size: 22),
            const SizedBox(width: 6),
            Text(
              'Tác vụ nhanh',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: FuvekonColors.darkText,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: items.map((item) => _QuickActionTile(item: item)).toList(),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.item});

  final FuvekonQuickActionItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FuvekonColors.darkSurfaceElevated,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: FuvekonColors.darkText, size: 28),
              const SizedBox(height: 10),
              Text(
                item.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
