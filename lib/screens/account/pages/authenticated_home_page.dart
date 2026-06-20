import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/featured_event_summary.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/explore_ticket_tier_card.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AuthenticatedHomePage extends StatelessWidget {
  const AuthenticatedHomePage({super.key});

  static const heroBackgroundAsset = 'assets/images/background-trang-chu.png';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ColoredBox(
      color: FuvekonColors.darkBg,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HeroSection(l10n: l10n)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              FuvekonSpacing.page,
              24,
              FuvekonSpacing.page,
              16,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FuveSectionHeader(title: l10n.authHomeBentoTitle),
                  const SizedBox(height: 16),
                  _BentoGrid(l10n: l10n),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              FuvekonSpacing.page,
              8,
              FuvekonSpacing.page,
              16,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FuveSectionHeader(title: l10n.authHomeShortcutsTitle),
                  const SizedBox(height: 12),
                  _ShortcutRow(l10n: l10n),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              FuvekonSpacing.page,
              8,
              FuvekonSpacing.page,
              32,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FuveSectionHeader(
                    title: l10n.authHomeFeaturedTitle,
                    actionLabel: l10n.authHomeSeeAll,
                    onActionTap: () => context.go(Routes.ticket),
                  ),
                  const SizedBox(height: 16),
                  _FeaturedEventCard(l10n: l10n, event: kHomeFeaturedEvent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoGrid extends StatelessWidget {
  const _BentoGrid({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TicketExploreSurface(
                  style: ExploreTierStyle.premium,
                  highlighted: true,
                  onTap: () => context.go(Routes.accountTicket),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined,
                        color: exploreTicketTextColors(
                          ExploreTierStyle.premium,
                        ).title,
                        size: 28,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.authHomeMyTicketTitle,
                        style: TextStyle(
                          color: exploreTicketTextColors(
                            ExploreTierStyle.premium,
                          ).title,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.authHomeMyTicketSubtitle,
                        style: TextStyle(
                          color: exploreTicketTextColors(
                            ExploreTierStyle.premium,
                          ).muted,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _ScheduleOverviewCard(l10n: l10n)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TicketExploreSurface(
          onTap: () => context.push(Routes.ticket),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: FuvekonColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_activity_outlined,
                  color: exploreTicketTextColors(
                    ExploreTierStyle.standard,
                  ).title,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.authHomeBuyTicketBanner,
                      style: TextStyle(
                        color: exploreTicketTextColors(
                          ExploreTierStyle.standard,
                        ).title,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      l10n.authHomeBuyTicketBannerSubtitle,
                      style: TextStyle(
                        color: exploreTicketTextColors(
                          ExploreTierStyle.standard,
                        ).muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: exploreTicketTextColors(ExploreTierStyle.standard).muted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScheduleOverviewCard extends StatelessWidget {
  const _ScheduleOverviewCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go(Routes.accountSchedule),
        borderRadius: BorderRadius.circular(FuvekonRadii.card),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: FuvekonColors.mintCard,
            borderRadius: BorderRadius.circular(FuvekonRadii.card),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: FuvekonColors.onSageGreen,
                  size: 28,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.authHomeTodayScheduleTitle,
                  style: const TextStyle(
                    color: FuvekonColors.onSageGreen,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.authHomeTodaySchedulePreview,
                  style: const TextStyle(
                    color: FuvekonColors.premiumOnMintCardMuted,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final shortcuts = [
      (
        icon: Icons.calendar_month_outlined,
        label: l10n.navSchedule,
        route: Routes.accountSchedule,
      ),
      (
        icon: Icons.confirmation_number_outlined,
        label: l10n.navMyTickets,
        route: Routes.accountTicket,
      ),
      (
        icon: Icons.menu_book_outlined,
        label: l10n.authHomeShortcutArtbook,
        route: Routes.artbook,
      ),
      (
        icon: Icons.search_outlined,
        label: l10n.authHomeShortcutLostFound,
        route: Routes.lostFound,
      ),
    ];

    return Row(
      children: shortcuts.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () {
                switch (item.route) {
                  case Routes.accountSchedule:
                  case Routes.accountTicket:
                    context.go(item.route);
                  default:
                    context.push(item.route);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: FuvekonColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: FuvekonColors.outlineToken.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(item.icon, color: FuvekonColors.sageGreen, size: 22),
                    const SizedBox(height: 6),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: FuvekonColors.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AuthenticatedHomePage.heroBackgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (context, error, stackTrace) =>
                ColoredBox(color: FuvekonColors.surfaceContainer),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  FuvekonColors.darkBg.withValues(alpha: 0.55),
                  FuvekonColors.darkBg,
                ],
                stops: const [0.35, 0.72, 1],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusBadge(label: l10n.authHomeUpcomingBadge),
                  const Spacer(),
                  Text(
                    l10n.authHomeHeroTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.authHomeHeroSubtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: FuvekonColors.deepNavy.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FeaturedEventCard extends StatelessWidget {
  const _FeaturedEventCard({required this.l10n, required this.event});

  final AppLocalizations l10n;
  final FeaturedEventSummary event;

  void _openEventDetail(BuildContext context) {
    context.push(Routes.accountScheduleEvent(event.id));
  }

  @override
  Widget build(BuildContext context) {
    final isPast = event.isPast;
    final dateLabel = _formatFeaturedDateRange(context, event);

    return FuveMintCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => _openEventDetail(context),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(FuvekonRadii.card),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      event.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => ColoredBox(
                        color: FuvekonColors.surfaceContainer,
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.white.withValues(alpha: 0.3),
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: FuvekonColors.sageGreen,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 12,
                            color: FuvekonColors.onSageGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.authHomeHotBadge,
                            style: const TextStyle(
                              color: FuvekonColors.onSageGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => _openEventDetail(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          color: FuvekonColors.onSageGreen,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _MetaRow(
                        icon: Icons.calendar_today_outlined,
                        label: dateLabel,
                      ),
                      const SizedBox(height: 6),
                      _MetaRow(
                        icon: Icons.location_on_outlined,
                        label: event.locationLabel,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FuvePillButton(
                  label: isPast
                      ? l10n.authHomeViewDetails
                      : l10n.authHomeBuyTicket,
                  onPressed: () {
                    if (isPast) {
                      _openEventDetail(context);
                    } else {
                      context.push(Routes.ticket);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatFeaturedDateRange(
  BuildContext context,
  FeaturedEventSummary event,
) {
  final locale = Localizations.localeOf(context).toString();
  final monthYear = DateFormat('MMMM y', locale).format(event.startAt);
  if (event.startAt.year == event.endAt.year &&
      event.startAt.month == event.endAt.month &&
      event.startAt.day != event.endAt.day) {
    return '${event.startAt.day} - ${event.endAt.day} $monthYear';
  }
  final format = DateFormat('d MMMM y', locale);
  if (event.startAt == event.endAt) {
    return format.format(event.startAt);
  }
  return '${format.format(event.startAt)} – ${format.format(event.endAt)}';
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: FuvekonColors.premiumOnMintCardMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: FuvekonColors.premiumOnMintCardMuted,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
