import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_event.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/venue.dart';
import 'package:fuvekonmobile/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key, required this.eventId});

  final String eventId;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  late final ScheduleRepository _repository;
  ScheduleEvent? _event;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repository = sl<ScheduleRepository>();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _repository.getScheduleEvent(widget.eventId);
    if (!mounted) return;

    switch (result) {
      case Success(:final data):
        setState(() {
          _event = data;
          _loading = false;
        });
      case Error(:final failure):
        setState(() {
          _error = failure.message;
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scheduleEventDetail)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView(
                  padding: const EdgeInsets.all(FuvekonSpacing.page),
                  children: [
                    FuveMintCard(
                      showGoldAccent: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _event!.name,
                            style: TextStyle(
                              color: context.fuvekonTheme.contentOnCard,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _formatDateRange(context, _event!),
                            style: TextStyle(
                              color: context.fuvekonTheme.contentOnCardMuted,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _event!.description,
                            style: TextStyle(
                              color: context.fuvekonTheme.contentOnCardMuted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: FuvekonSpacing.section),
                    FuveSectionHeader(
                      title: l10n.scheduleVenues,
                      actionLabel: l10n.scheduleViewMap,
                      onActionTap: () =>
                          context.push(Routes.accountScheduleMap),
                    ),
                    const SizedBox(height: 12),
                    ..._event!.venues.map(
                      (venue) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _VenueTile(venue: venue),
                      ),
                    ),
                  ],
                ),
    );
  }

  String _formatDateRange(BuildContext context, ScheduleEvent event) {
    final locale = Localizations.localeOf(context).toString();
    final format = DateFormat('d/M/yyyy', locale);
    return '${format.format(event.startAt)} – ${format.format(event.endAt)}';
  }
}

class _VenueTile extends StatelessWidget {
  const _VenueTile({required this.venue});

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    return FuveMintCard(
      onTap: () => context.push(Routes.accountScheduleVenue(venue.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            venue.name,
            style: TextStyle(
              color: context.fuvekonTheme.contentOnCard,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          if (venue.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              venue.description,
              style: TextStyle(
                color: context.fuvekonTheme.contentOnCardMuted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
