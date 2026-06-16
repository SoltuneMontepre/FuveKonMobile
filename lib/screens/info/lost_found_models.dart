class LostFoundPublicItem {
  const LostFoundPublicItem({
    required this.id,
    this.displayCode = '',
    required this.title,
    this.description = '',
    this.location = '',
    this.imageUrl = '',
    this.status = 'open',
    this.userClaimStatus = '',
  });

  factory LostFoundPublicItem.fromJson(Map<String, dynamic> json) {
    return LostFoundPublicItem(
      id: json['id']?.toString() ?? '',
      displayCode: json['display_code'] as String? ?? '',
      title: json['title'] as String? ?? 'Vật phẩm',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      status: json['status'] as String? ?? 'open',
      userClaimStatus: json['user_claim_status'] as String? ?? '',
    );
  }

  final String id;
  final String displayCode;
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final String status;
  final String userClaimStatus;

  String get itemCode {
    if (displayCode.isNotEmpty) return displayCode;
    final compact = id.replaceAll('-', '');
    if (compact.length >= 5) {
      return 'FND-${compact.substring(compact.length - 5).toUpperCase()}';
    }
    return 'FND-${compact.toUpperCase()}';
  }

  bool get userHasPendingClaim => userClaimStatus == 'pending';
  bool get userHasClaimed =>
      userClaimStatus == 'pending' || userClaimStatus == 'approved';
  bool get canClaim => status == 'open' && !userHasClaimed;
}

class AdminLostFoundClaimUser {
  const AdminLostFoundClaimUser({
    required this.id,
    this.firstName = '',
    this.lastName = '',
    this.fursonaName = '',
    this.email = '',
    this.idCard = '',
    this.avatar = '',
  });

  factory AdminLostFoundClaimUser.fromJson(Map<String, dynamic> json) {
    return AdminLostFoundClaimUser(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      fursonaName: json['fursona_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      idCard: json['id_card'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );
  }

  final String id;
  final String firstName;
  final String lastName;
  final String fursonaName;
  final String email;
  final String idCard;
  final String avatar;

  String get displayName {
    final parts = [firstName.trim(), lastName.trim()]
        .where((part) => part.isNotEmpty)
        .join(' ');
    if (parts.isNotEmpty) return parts;
    if (fursonaName.trim().isNotEmpty) return fursonaName.trim();
    return email;
  }

  static String maskSensitive(String value) {
    final trimmed = value.trim();
    if (trimmed.length <= 3) return 'x' * trimmed.length;
    final at = trimmed.indexOf('@');
    if (at > 1) {
      return '${trimmed.substring(0, 2)}${'x' * (at - 2)}${trimmed.substring(at)}';
    }
    return '${trimmed.substring(0, 3)}${'x' * (trimmed.length - 3)}';
  }
}

class AdminLostFoundClaim {
  const AdminLostFoundClaim({
    required this.id,
    required this.itemId,
    required this.status,
    this.message = '',
    required this.claimedBy,
  });

  factory AdminLostFoundClaim.fromJson(Map<String, dynamic> json) {
    final claimedBy = json['claimed_by'];
    return AdminLostFoundClaim(
      id: json['id']?.toString() ?? '',
      itemId: json['item_id']?.toString() ?? '',
      status: json['status'] as String? ?? 'pending',
      message: json['message'] as String? ?? '',
      claimedBy: claimedBy is Map<String, dynamic>
          ? AdminLostFoundClaimUser.fromJson(claimedBy)
          : const AdminLostFoundClaimUser(id: ''),
    );
  }

  final String id;
  final String itemId;
  final String status;
  final String message;
  final AdminLostFoundClaimUser claimedBy;

  bool get isPending => status == 'pending';
}
