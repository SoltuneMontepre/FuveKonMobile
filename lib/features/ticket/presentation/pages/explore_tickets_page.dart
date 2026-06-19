import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_tiers_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/explore_ticket_tier_card.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_illustrated_background.dart';
import 'package:go_router/go_router.dart';

class ExploreTicketsPage extends StatelessWidget {
  const ExploreTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TicketTiersBloc>()..add(const TicketTiersStarted()),
      child: const _ExploreTicketsView(),
    );
  }
}

class _ExploreTicketsView extends StatelessWidget {
  const _ExploreTicketsView();

  bool _isAuthenticated(AuthState state) =>
      state is AuthAuthenticated || state is AuthSessionRestored;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      body: FuvekonIllustratedPageStack(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ExploreTicketsHeader(),
              Expanded(
                child: BlocBuilder<TicketTiersBloc, TicketTiersState>(
                  builder: (context, state) {
                    return switch (state) {
                      TicketTiersInitial() || TicketTiersLoading() =>
                        const Center(child: CircularProgressIndicator()),
                      TicketTiersLoaded(:final tiers) when tiers.isEmpty =>
                        EmptyState(
                          icon: Icons.confirmation_number_outlined,
                          title: l10n.exploreTicketsEmpty,
                        ),
                      TicketTiersLoaded(:final tiers) => _LoadedBody(tiers: tiers),
                      TicketTiersFailure(:final message) => _ErrorBody(
                          message: message,
                          onRetry: () => context.read<TicketTiersBloc>().add(
                                const TicketTiersRefreshRequested(),
                              ),
                        ),
                    };
                  },
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (_isAuthenticated(authState)) {
                    return const SizedBox.shrink();
                  }
                  return const _ExploreTicketsGuestFooter();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreTicketsHeader extends StatelessWidget {
  const _ExploreTicketsHeader();

  static const _brandColor = FuvekonColors.darkPrimary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(Routes.home);
              }
            },
            visualDensity: VisualDensity.compact,
          ),
          const Expanded(
            child: Text(
              'FUVEKON',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _brandColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontSize: 15,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.translate, color: Colors.white),
            tooltip: context.l10n.languageTitle,
            onPressed: () => context.go(Routes.language),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.tiers});

  final List<TicketTier> tiers;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          l10n.exploreTicketsTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.exploreTicketsSubtitle,
          style: const TextStyle(
            color: FuvekonColors.darkTextSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        for (var i = 0; i < tiers.length; i++) ...[
          ExploreTicketTierCard(
            tier: tiers[i],
            style: exploreTierStyleFor(i, tiers.length),
            onTap: () => context.push(Routes.ticketDetail(tiers[i].id)),
          ),
          if (i < tiers.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _ExploreTicketsGuestFooter extends StatelessWidget {
  const _ExploreTicketsGuestFooter();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: FuvekonIllustratedContentPanel(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.exploreTicketsFooterInfo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: FuvekonColors.darkTextSecondary,
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(Routes.register),
              style: FilledButton.styleFrom(
                backgroundColor: FuvekonColors.darkButton,
                foregroundColor: FuvekonColors.darkButtonText,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(FuvekonRadii.button),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.exploreTicketsRegisterCta,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  l10n.exploreTicketsLoginPrompt,
                  style: const TextStyle(
                    color: FuvekonColors.darkTextSecondary,
                    fontSize: 13,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(Routes.login),
                  style: TextButton.styleFrom(
                    foregroundColor: FuvekonColors.darkPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    l10n.exploreTicketsLoginLink,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: FuvekonColors.darkTextSecondary),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: Text(l10n.exploreTicketsRetry),
            ),
          ],
        ),
      ),
    );
  }
}
