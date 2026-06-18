import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_state.dart';
import 'package:fuvekonmobile/features/ticket/presentation/models/my_ticket_list_item.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/my_ticket_list_card.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:go_router/go_router.dart';

class MyTicketPage extends StatelessWidget {
  const MyTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MyTicketBloc>()..add(const MyTicketEvent.started()),
      child: const _MyTicketView(),
    );
  }
}

class _MyTicketView extends StatefulWidget {
  const _MyTicketView();

  @override
  State<_MyTicketView> createState() => _MyTicketViewState();
}

class _MyTicketViewState extends State<_MyTicketView> {
  MyTicketFilter _filter = MyTicketFilter.active;

  List<MyTicketListItem> _buildItems(MyTicketLoaded state) {
    final l10n = context.l10n;
    final items = <MyTicketListItem>[
      MyTicketListItem.fromTicket(
        ticket: state.ticket,
        account: state.account,
        eventDateLabel: l10n.myTicketsEventDateRange,
      ),
    ];

    if (AppConfig.mockTicketMode) {
      items.add(MyTicketListItem.demoWorkshop(account: state.account));
    }

    return items;
  }

  void _onViewTicket(MyTicketListItem item) {
    final ticket = item.userTicket;
    if (ticket != null && ticket.needsPayment && ticket.tier?.id != null) {
      context.push<bool>(Routes.ticketPurchaseStep(ticket.tier!.id)).then((confirmed) {
        if (confirmed == true && mounted) {
          context.read<MyTicketBloc>().add(const MyTicketEvent.refreshRequested());
        }
      });
      return;
    }

    openETicketDetail(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: FuvekonColors.darkBg,
      child: BlocConsumer<MyTicketBloc, MyTicketState>(
        listener: (context, state) {
          final bloc = context.read<MyTicketBloc>();
          if (bloc.lastActionError != null) {
            final message = bloc.lastActionError!;
            bloc.lastActionError = null;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            MyTicketInitial() || MyTicketLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            MyTicketLoaded() => RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<MyTicketBloc>()
                      .add(const MyTicketEvent.refreshRequested());
                  await context.read<MyTicketBloc>().stream.firstWhere(
                        (s) =>
                            s is MyTicketLoaded ||
                            s is MyTicketEmpty ||
                            s is MyTicketFailure,
                      );
                },
                child: _LoadedBody(
                  items: _filter.apply(_buildItems(state)),
                  filter: _filter,
                  onFilterChanged: (value) => setState(() => _filter = value),
                  onViewTicket: _onViewTicket,
                ),
              ),
            MyTicketEmpty() => _EmptyBody(
                onBrowse: () => context.go(Routes.ticket),
              ),
            MyTicketFailure(:final message) => _MyTicketError(
                message: message,
                onRetry: () => context.read<MyTicketBloc>().add(
                      const MyTicketEvent.refreshRequested(),
                    ),
              ),
          };
        },
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({
    required this.items,
    required this.filter,
    required this.onFilterChanged,
    required this.onViewTicket,
  });

  final List<MyTicketListItem> items;
  final MyTicketFilter filter;
  final ValueChanged<MyTicketFilter> onFilterChanged;
  final ValueChanged<MyTicketListItem> onViewTicket;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          l10n.navMyTickets,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 20),
        MyTicketFilterTabs(
          selected: filter,
          onChanged: onFilterChanged,
        ),
        const SizedBox(height: 20),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: EmptyState(
              icon: Icons.confirmation_number_outlined,
              title: l10n.myTicketsEmptyFilter,
            ),
          )
        else
          for (var i = 0; i < items.length; i++) ...[
            MyTicketListCard(
              item: items[i],
              onViewTicket: () => onViewTicket(items[i]),
            ),
            if (i < items.length - 1) const SizedBox(height: 14),
          ],
      ],
    );
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptyState(
              title: l10n.myTicketsEmptyTitle,
              subtitle: l10n.myTicketsEmptySubtitle,
              icon: Icons.confirmation_number_outlined,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onBrowse,
              child: Text(l10n.myTicketsBrowse),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyTicketError extends StatelessWidget {
  const _MyTicketError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
