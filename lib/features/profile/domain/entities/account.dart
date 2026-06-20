import 'package:equatable/equatable.dart';

class Account extends Equatable {
  const Account({
    required this.id,
    required this.email,
    this.fursonaName,
    this.firstName,
    this.lastName,
    this.country,
    this.idCard,
    this.dateOfBirth,
    this.avatar,
    this.role,
    this.isVerified,
    this.isDealer,
    this.isBlacklisted,
    this.isHasTicket,
  });

  final String id;
  final String email;
  final String? fursonaName;
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? idCard;
  final String? dateOfBirth;
  final String? avatar;
  final String? role;
  final bool? isVerified;
  final bool? isDealer;
  final bool? isBlacklisted;
  final bool? isHasTicket;

  String? get displayName {
    if (fursonaName != null && fursonaName!.isNotEmpty) return fursonaName;
    return legalName;
  }

  /// Full legal name (first + last) for tickets and checkout.
  String? get legalName {
    final parts = [
      firstName,
      lastName,
    ].whereType<String>().map((s) => s.trim()).where((s) => s.isNotEmpty);
    final joined = parts.join(' ').trim();
    return joined.isEmpty ? null : joined;
  }

  /// Name on e-ticket / order — legal name first, then display name, then email.
  String get ticketHolderName {
    final legal = legalName;
    if (legal != null && legal.isNotEmpty) return legal;
    final display = displayName;
    if (display != null && display.isNotEmpty) return display;
    final local = email.split('@').first.trim();
    return local.isNotEmpty ? local : email;
  }

  String get initials {
    final name = displayName;
    if (name != null && name.isNotEmpty) {
      final words = name.trim().split(RegExp(r'\s+'));
      if (words.length >= 2) {
        return '${words.first[0]}${words[1][0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    if (email.isNotEmpty) return email[0].toUpperCase();
    return '?';
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fursonaName,
    firstName,
    lastName,
    country,
    idCard,
    dateOfBirth,
    avatar,
    role,
    isVerified,
    isDealer,
    isBlacklisted,
    isHasTicket,
  ];
}
