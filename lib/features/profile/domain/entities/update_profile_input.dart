import 'package:equatable/equatable.dart';

class UpdateProfileInput extends Equatable {
  const UpdateProfileInput({
    this.fursonaName,
    this.firstName,
    this.lastName,
    this.country,
    this.idCard,
    this.dateOfBirth,
  });

  final String? fursonaName;
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? idCard;
  final String? dateOfBirth;

  Map<String, dynamic> toPayload() {
    String? value(String? raw) {
      if (raw == null) return null;
      final trimmed = raw.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    return {
      if (value(fursonaName) != null) 'fursona_name': value(fursonaName),
      if (value(firstName) != null) 'first_name': value(firstName),
      if (value(lastName) != null) 'last_name': value(lastName),
      if (value(country) != null) 'country': value(country),
      if (value(idCard) != null) 'id_card': value(idCard),
      if (value(dateOfBirth) != null) 'date_of_birth': value(dateOfBirth),
    };
  }

  @override
  List<Object?> get props => [
    fursonaName,
    firstName,
    lastName,
    country,
    idCard,
    dateOfBirth,
  ];
}
