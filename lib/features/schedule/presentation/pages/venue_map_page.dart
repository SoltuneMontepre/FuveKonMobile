import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/venue.dart';
import 'package:fuvekonmobile/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:go_router/go_router.dart';

class VenueMapPage extends StatefulWidget {
  const VenueMapPage({super.key});

  @override
  State<VenueMapPage> createState() => _VenueMapPageState();
}

class _VenueMapPageState extends State<VenueMapPage> {
  late final ScheduleRepository _repository;
  List<Venue> _venues = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repository = sl<ScheduleRepository>();
    _load();
  }

  Future<void> _load() async {
    final result = await _repository.listVenues();
    if (!mounted) return;
    switch (result) {
      case Success(:final data):
        setState(() {
          _venues = data;
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
      appBar: AppBar(title: Text(l10n.scheduleViewMap)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Padding(
                  padding: const EdgeInsets.all(FuvekonSpacing.page),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: FuvekonColors.premiumSurfaceContainer,
                            borderRadius:
                                BorderRadius.circular(FuvekonRadii.card),
                            border: Border.all(
                              color: FuvekonColors.premiumOutline
                                  .withValues(alpha: 0.35),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.map_outlined,
                                  size: 72,
                                  color: FuvekonColors.premiumOnSurfaceVariant
                                      .withValues(alpha: 0.35),
                                ),
                              ),
                              ..._venues.where((v) => v.mapX != null).map(
                                    (venue) => _VenuePin(
                                      venue: venue,
                                      onTap: () => context.push(
                                        Routes.accountScheduleVenue(venue.id),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._venues.map(
                        (venue) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FuveMintCard(
                            onTap: () => context.push(
                              Routes.accountScheduleVenue(venue.id),
                            ),
                            child: Text(
                              venue.name,
                              style: TextStyle(
                                color: context.fuvekonTheme.contentOnCard,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _VenuePin extends StatelessWidget {
  const _VenuePin({required this.venue, required this.onTap});

  final Venue venue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: (venue.mapX ?? 0.5) * MediaQuery.sizeOf(context).width * 0.78,
      top: (venue.mapY ?? 0.5) * 280,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: FuvekonColors.premiumPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on,
                color: FuvekonColors.premiumOnPrimary,
                size: 18,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: FuvekonColors.premiumMintCard,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                venue.name,
                style: const TextStyle(
                  color: FuvekonColors.premiumOnMintCard,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
