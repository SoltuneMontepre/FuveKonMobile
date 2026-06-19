import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/router/schedule_route_context.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_event.dart';
import 'package:fuvekonmobile/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Màn 13 — Chi tiết sự kiện (Figma node 3093:3028).
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

    if (_loading) {
      return Scaffold(
        backgroundColor: FuvekonColors.darkBg,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: FuvekonColors.darkBg,
        appBar: AppBar(title: Text(l10n.scheduleEventDetail)),
        body: Center(child: Text(_error!)),
      );
    }

    final event = _event!;

    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _EventHeroSection(
              event: event,
              viewTicketsLabel: l10n.authHomeViewTickets,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            sliver: SliverToBoxAdapter(
              child: Text(
                event.description,
                style: const TextStyle(
                  color: Color(0xFFC1C8C2),
                  fontSize: 16,
                  height: 1.625,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventHeroSection extends StatelessWidget {
  const _EventHeroSection({
    required this.event,
    required this.viewTicketsLabel,
  });

  final ScheduleEvent event;
  final String viewTicketsLabel;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 420,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                event.heroImageAsset,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) => ColoredBox(
                  color: FuvekonColors.surfaceContainer,
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.white.withValues(alpha: 0.3),
                    size: 48,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      FuvekonColors.darkBg.withValues(alpha: 0.8),
                      FuvekonColors.darkBg,
                    ],
                    stops: const [0.35, 0.72, 1],
                  ),
                ),
              ),
              Positioned(
                top: topPadding,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Expanded(
                        child: Text(
                          'FUVEKON',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: FuvekonColors.sageGreen,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.4,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: event.tags.map(_EventTagChip.new).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      event.name,
                      style: const TextStyle(
                        color: Color(0xFFE5E2E1),
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        height: 1.22,
                        letterSpacing: -0.72,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _HeroMetaRow(
                      icon: Icons.calendar_today_outlined,
                      label: _formatDateRange(context, event),
                    ),
                    const SizedBox(height: 8),
                    if (event.locationLabel.isNotEmpty)
                      _HeroMetaRow(
                        icon: Icons.location_on_outlined,
                        label: event.locationLabel,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: _QuickActionsBar(
            event: event,
            viewTicketsLabel: viewTicketsLabel,
          ),
        ),
      ],
    );
  }

  String _formatDateRange(BuildContext context, ScheduleEvent event) {
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
}

class _EventTagChip extends StatelessWidget {
  const _EventTagChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final isSage = label == 'TRIỂN LÃM';
    final bg = isSage
        ? FuvekonColors.sageGreen.withValues(alpha: 0.2)
        : const Color(0xFFDFBEC9).withValues(alpha: 0.2);
    final border = isSage
        ? FuvekonColors.sageGreen.withValues(alpha: 0.3)
        : const Color(0xFFDFBEC9).withValues(alpha: 0.3);
    final fg = isSage ? FuvekonColors.sageGreen : const Color(0xFFDFBEC9);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _HeroMetaRow extends StatelessWidget {
  const _HeroMetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFFC1C8C2)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFC1C8C2),
              fontSize: 14,
              height: 1.43,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActionsBar extends StatelessWidget {
  const _QuickActionsBar({
    required this.event,
    required this.viewTicketsLabel,
  });

  final ScheduleEvent event;
  final String viewTicketsLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: FuvekonColors.sageGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FuvekonColors.sageGreen.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
          children: [
            Expanded(
              child: Material(
                color: FuvekonColors.sageGreen,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {
                    if (event.isPast) {
                      context.push(Routes.accountTicket);
                    } else {
                      context.push(Routes.ticket);
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.confirmation_number_outlined,
                          size: 20,
                          color: FuvekonColors.onSageGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          viewTicketsLabel,
                          style: const TextStyle(
                            color: FuvekonColors.onSageGreen,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _IconActionButton(
              icon: Icons.calendar_month_outlined,
              onTap: () => context.push(ScheduleRouteContext.list(context)),
            ),
            const SizedBox(width: 8),
            _IconActionButton(
              icon: Icons.map_outlined,
              onTap: () => context.push(ScheduleRouteContext.map(context)),
            ),
          ],
      ),
    );
  }
}

class _IconActionButton extends StatelessWidget {
  const _IconActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF353535),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF414843)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, size: 20, color: const Color(0xFFC1C8C2)),
        ),
      ),
    );
  }
}
