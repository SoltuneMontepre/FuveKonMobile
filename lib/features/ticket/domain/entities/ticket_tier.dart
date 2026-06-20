import 'package:equatable/equatable.dart';

class TicketTier extends Equatable {
  const TicketTier({
    required this.id,
    required this.tierCode,
    required this.ticketName,
    required this.description,
    required this.benefits,
    required this.price,
    this.priceUsd,
    required this.isSoldOut,
    required this.isActive,
    required this.isVisible,
  });

  final String id;
  final String tierCode;
  final String ticketName;
  final String description;
  final List<String> benefits;
  final double price;
  final double? priceUsd;
  final bool isSoldOut;
  final bool isActive;
  final bool isVisible;

  @override
  List<Object?> get props => [
    id,
    tierCode,
    ticketName,
    description,
    benefits,
    price,
    priceUsd,
    isSoldOut,
    isActive,
    isVisible,
  ];
}
