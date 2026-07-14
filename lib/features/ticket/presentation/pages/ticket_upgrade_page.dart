import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/utils/ticket_price.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_upgrade_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/explore_ticket_tier_card.dart';
import 'package:go_router/go_router.dart';

class TicketUpgradePage extends StatelessWidget {
  const TicketUpgradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TicketUpgradeBloc>()..add(const TicketUpgradeStarted()),
      child: const _TicketUpgradeView(),
    );
  }
}

class _TicketUpgradeView extends StatelessWidget {
  const _TicketUpgradeView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      body: BlocConsumer<TicketUpgradeBloc, TicketUpgradeState>(
        listener: (context, state) {
          final bloc = context.read<TicketUpgradeBloc>();
          if (bloc.lastActionError != null) {
            final message = bloc.lastActionError!;
            bloc.lastActionError = null;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }

          if (state is TicketUpgradeSuccess) {
            context.push(
              Routes.ticketPurchaseStep(state.tierId),
              extra: {
                'queued': state.queued,
                'payableAmount': state.priceDifference,
                'isUpgrade': true,
              },
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            TicketUpgradeInitial() || TicketUpgradeLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            TicketUpgradeLoaded() => _LoadedBody(state: state),
            TicketUpgradeNoTicket() => _MessageBody(
              message: l10n.ticketUpgradeNoTicket,
              onBack: () => context.pop(),
            ),
            TicketUpgradeNoOptions(:final ticket) => _MessageBody(
              message: l10n.ticketUpgradeMaxTier(ticket.tier?.ticketName ?? ''),
              onBack: () => context.pop(),
            ),
            TicketUpgradeFailure(:final message) => _MessageBody(
              message: message,
              onBack: () => context.pop(),
              onRetry: () => context.read<TicketUpgradeBloc>().add(
                const TicketUpgradeStarted(),
              ),
            ),
            TicketUpgradeSuccess() => const Center(
              child: CircularProgressIndicator(),
            ),
          };
        },
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.state});

  final TicketUpgradeLoaded state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = state.currentTier;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _UpgradeHeader(onBack: () => context.pop()),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              Text(
                l10n.ticketUpgradeCurrentLabel,
                style: TextStyle(
                  color: FuvekonColors.darkTextSecondary.withValues(
                    alpha: 0.85,
                  ),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              _CurrentTicketCard(
                tierName: current.ticketName,
                paidLabel: currentTicketPaidLabel(state.ticket.status),
                priceLabel: formatTicketPriceVndCompact(current.price),
              ),
              const SizedBox(height: 28),
              Text(
                l10n.ticketUpgradeOptionsLabel,
                style: const TextStyle(
                  color: FuvekonColors.darkText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              for (final option in state.options) ...[
                _UpgradeOptionCard(
                  tier: option,
                  currentTier: current,
                  selected: option.id == state.selectedTierId,
                  additionalBenefits: additionalUpgradeBenefits(
                    current,
                    option,
                  ),
                  onTap: () => context.read<TicketUpgradeBloc>().add(
                    TicketUpgradeTierSelected(option.id),
                  ),
                ),
                if (option != state.options.last) const SizedBox(height: 14),
              ],
              const SizedBox(height: 20),
              _UpgradeInfoNote(text: l10n.ticketUpgradeInfoNote),
            ],
          ),
        ),
        _UpgradeBottomBar(
          totalLabel: formatTicketPriceVnd(state.priceDiff),
          ctaLabel: l10n.ticketUpgradeContinue,
          isLoading: state.isSubmitting,
          onContinue: () => context.read<TicketUpgradeBloc>().add(
            const TicketUpgradeSubmitted(),
          ),
        ),
      ],
    );
  }
}

class _UpgradeHeader extends StatelessWidget {
  const _UpgradeHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 12, 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack,
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: Text(
                context.l10n.ticketUpgradeTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}

class _CurrentTicketCard extends StatelessWidget {
  const _CurrentTicketCard({
    required this.tierName,
    required this.paidLabel,
    required this.priceLabel,
  });

  final String tierName;
  final String paidLabel;
  final String priceLabel;

  @override
  Widget build(BuildContext context) {
    final colors = exploreTicketTextColors(ExploreTierStyle.standard);

    return TicketExploreSurface(
      style: ExploreTierStyle.standard,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: FuvekonColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.confirmation_number_outlined,
              color: colors.title,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${tierName.toUpperCase()} TICKET',
                  style: TextStyle(
                    color: colors.title,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  paidLabel,
                  style: TextStyle(color: colors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            priceLabel,
            style: TextStyle(
              color: colors.title,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpgradeOptionCard extends StatelessWidget {
  const _UpgradeOptionCard({
    required this.tier,
    required this.currentTier,
    required this.selected,
    required this.additionalBenefits,
    required this.onTap,
  });

  final TicketTier tier;
  final TicketTier currentTier;
  final bool selected;
  final List<String> additionalBenefits;
  final VoidCallback onTap;

  static const _gold = FuvekonColors.lightGold;
  static const _diffColor = Color(0xFFE8A090);

  @override
  Widget build(BuildContext context) {
    final diff = tier.price - currentTier.price;
    final isPremium = tier.price >= currentTier.price * 1.5;

    return Material(
      color: FuvekonColors.darkSurfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected
              ? _gold
              : FuvekonColors.darkBorder.withValues(alpha: 0.5),
          width: selected ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _gold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: _gold,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tier.ticketName.toUpperCase(),
                          style: const TextStyle(
                            color: _gold,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: 0.4,
                          ),
                        ),
                        if (tier.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            tier.description,
                            style: TextStyle(
                              color: FuvekonColors.darkTextSecondary.withValues(
                                alpha: 0.95,
                              ),
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatTicketPriceVndCompact(tier.price),
                        style: const TextStyle(
                          color: _gold,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatTierPriceDiff(diff),
                        style: const TextStyle(
                          color: _diffColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
              const SizedBox(height: 12),
              Text(
                context.l10n.ticketUpgradeExtraBenefits,
                style: TextStyle(
                  color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              for (final benefit in additionalBenefits)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: isPremium
                            ? FuvekonColors.dustyRose
                            : FuvekonColors.darkPrimary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(
                            color: FuvekonColors.darkTextSecondary.withValues(
                              alpha: 0.95,
                            ),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: _SelectionDot(selected: selected),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionDot extends StatelessWidget {
  const _SelectionDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? FuvekonColors.lightGold
              : FuvekonColors.darkTextSecondary.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: FuvekonColors.lightGold,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

class _UpgradeInfoNote extends StatelessWidget {
  const _UpgradeInfoNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: FuvekonColors.sageGreen.withValues(alpha: 0.85),
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: FuvekonColors.sageGreen.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: FuvekonColors.darkTextSecondary.withValues(
                    alpha: 0.95,
                  ),
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpgradeBottomBar extends StatelessWidget {
  const _UpgradeBottomBar({
    required this.totalLabel,
    required this.ctaLabel,
    required this.isLoading,
    required this.onContinue,
  });

  final String totalLabel;
  final String ctaLabel;
  final bool isLoading;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkBg,
        border: Border(
          top: BorderSide(
            color: FuvekonColors.darkBorder.withValues(alpha: 0.45),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.ticketUpgradeTotalLabel,
                style: TextStyle(
                  color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                totalLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: isLoading ? null : onContinue,
                style: FilledButton.styleFrom(
                  backgroundColor: FuvekonColors.darkPrimary,
                  foregroundColor: FuvekonColors.onSageGreen,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading) ...[
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      ctaLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    if (!isLoading) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBody extends StatelessWidget {
  const _MessageBody({
    required this.message,
    required this.onBack,
    this.onRetry,
  });

  final String message;
  final VoidCallback onBack;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _UpgradeHeader(onBack: onBack),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: FuvekonColors.darkTextSecondary,
                    ),
                  ),
                  if (onRetry != null) ...[
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: onRetry,
                      child: Text(context.l10n.exploreTicketsRetry),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
