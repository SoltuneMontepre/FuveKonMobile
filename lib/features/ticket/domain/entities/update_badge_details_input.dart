import 'package:equatable/equatable.dart';

class UpdateBadgeDetailsInput extends Equatable {
  const UpdateBadgeDetailsInput({
    required this.conBadgeName,
    this.namecardUrl,
    required this.isFursuiter,
    required this.isFursuitStaff,
  });

  final String conBadgeName;
  final String? namecardUrl;
  final bool isFursuiter;
  final bool isFursuitStaff;

  Map<String, dynamic> toPayload() => {
    'con_badge_name': conBadgeName,
    if (namecardUrl != null) 'namecard_url': namecardUrl,
    'is_fursuiter': isFursuiter,
    'is_fursuit_staff': isFursuitStaff,
  };

  @override
  List<Object?> get props => [
    conBadgeName,
    namecardUrl,
    isFursuiter,
    isFursuitStaff,
  ];
}
