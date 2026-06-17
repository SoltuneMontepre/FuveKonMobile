import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/venue.dart';
import 'package:fuvekonmobile/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';

class VenueDetailPage extends StatefulWidget {
  const VenueDetailPage({super.key, required this.venueId});

  final String venueId;

  @override
  State<VenueDetailPage> createState() => _VenueDetailPageState();
}

class _VenueDetailPageState extends State<VenueDetailPage> {
  late final ScheduleRepository _repository;
  Venue? _venue;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repository = sl<ScheduleRepository>();
    _load();
  }

  Future<void> _load() async {
    final result = await _repository.getVenue(widget.venueId);
    if (!mounted) return;
    switch (result) {
      case Success(:final data):
        setState(() {
          _venue = data;
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
      appBar: AppBar(title: Text(l10n.scheduleVenueDetail)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView(
                  padding: const EdgeInsets.all(FuvekonSpacing.page),
                  children: [
                    FuveMintCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _venue!.name,
                            style: TextStyle(
                              color: context.fuvekonTheme.contentOnCard,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _venue!.description,
                            style: TextStyle(
                              color: context.fuvekonTheme.contentOnCardMuted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_venue!.locations.isNotEmpty) ...[
                      const SizedBox(height: FuvekonSpacing.section),
                      FuveSectionHeader(title: l10n.scheduleLocations),
                      const SizedBox(height: 12),
                      ..._venue!.locations.map(
                        (location) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FuveMintCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location.name,
                                  style: TextStyle(
                                    color: context.fuvekonTheme.contentOnCard,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (location.description.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    location.description,
                                    style: TextStyle(
                                      color: context
                                          .fuvekonTheme.contentOnCardMuted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
    );
  }
}
