import 'package:fuvekonmobile/features/schedule/domain/entities/itinerary_item.dart';

sealed class ItineraryState {
  const ItineraryState();
}

final class ItineraryInitial extends ItineraryState {
  const ItineraryInitial();
}

final class ItineraryLoading extends ItineraryState {
  const ItineraryLoading();
}

final class ItineraryLoaded extends ItineraryState {
  const ItineraryLoaded(this.items);

  final List<ItineraryItem> items;
}

final class ItineraryEmpty extends ItineraryState {
  const ItineraryEmpty();
}

final class ItineraryFailure extends ItineraryState {
  const ItineraryFailure(this.message);

  final String message;
}
