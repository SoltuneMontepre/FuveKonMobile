import 'package:flutter/material.dart';

class AdminDetailField {
  const AdminDetailField({
    required this.label,
    this.value = '',
    this.imageUrl,
  });

  final String label;
  final String value;
  final String? imageUrl;
}

abstract class AdminListItem {
  String get id;
  String get title;
  String? get subtitle;
  String? get previewImageUrl => null;
  List<AdminDetailField> get details;
}

DateTime? parseAdminDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

String formatAdminDate(DateTime? date) {
  if (date == null) return '—';
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

class AdminDealerItem implements AdminListItem {
  const AdminDealerItem({
    required this.id,
    required this.boothName,
    required this.description,
    this.boothNumber,
    required this.isVerified,
    this.priceSheets = const [],
    this.createdAt,
  });

  factory AdminDealerItem.fromJson(Map<String, dynamic> json) {
    final sheets = json['price_sheets'];
    return AdminDealerItem(
      id: json['id']?.toString() ?? '',
      boothName: json['booth_name'] as String? ?? 'Gian hàng',
      description: json['description'] as String? ?? '',
      boothNumber: json['booth_number'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      priceSheets: sheets is List
          ? sheets.whereType<String>().where((s) => s.isNotEmpty).toList()
          : const [],
      createdAt: parseAdminDate(json['created_at']),
    );
  }

  @override
  final String id;
  final String boothName;
  final String description;
  final String? boothNumber;
  final bool isVerified;
  final List<String> priceSheets;
  final DateTime? createdAt;

  @override
  String get title => boothName;

  @override
  String? get previewImageUrl =>
      priceSheets.isNotEmpty ? priceSheets.first : null;

  @override
  String? get subtitle => boothNumber?.isNotEmpty == true
      ? 'Mã gian: $boothNumber'
      : (description.isNotEmpty ? description : null);

  @override
  List<AdminDetailField> get details => [
        AdminDetailField(label: 'Tên gian hàng', value: boothName),
        if (boothNumber?.isNotEmpty == true)
          AdminDetailField(label: 'Mã gian', value: boothNumber!),
        AdminDetailField(
          label: 'Trạng thái',
          value: isVerified ? 'Đã duyệt' : 'Chờ duyệt',
        ),
        if (description.isNotEmpty)
          AdminDetailField(label: 'Mô tả', value: description),
        for (var i = 0; i < priceSheets.length; i++)
          AdminDetailField(
            label: priceSheets.length == 1 ? 'Bảng giá' : 'Bảng giá ${i + 1}',
            imageUrl: priceSheets[i],
          ),
        AdminDetailField(
          label: 'Ngày đăng ký',
          value: formatAdminDate(createdAt),
        ),
      ];
}

class AdminPanelItem implements AdminListItem {
  const AdminPanelItem({
    required this.id,
    required this.title,
    required this.nickname,
    required this.performanceGenre,
    required this.durationMinutes,
    required this.participantCount,
    required this.status,
    this.representativeUrl,
    this.introduction,
    this.slotLabel,
    this.createdAt,
  });

  factory AdminPanelItem.fromJson(Map<String, dynamic> json) {
    return AdminPanelItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? 'Panel',
      nickname: json['nickname'] as String? ?? '',
      performanceGenre: json['performance_genre'] as String? ?? '',
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      participantCount: json['participant_count'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      representativeUrl: json['representative_url'] as String?,
      introduction: json['introduction'] as String?,
      slotLabel: json['slot_label'] as String?,
      createdAt: parseAdminDate(json['created_at']),
    );
  }

  @override
  final String title;
  @override
  final String id;
  final String nickname;
  final String performanceGenre;
  final int durationMinutes;
  final int participantCount;
  final String status;
  final String? representativeUrl;
  final String? introduction;
  final String? slotLabel;
  final DateTime? createdAt;

  @override
  String? get previewImageUrl => representativeUrl;

  @override
  String? get subtitle => [
        if (nickname.isNotEmpty) nickname,
        if (performanceGenre.isNotEmpty) performanceGenre,
        '$durationMinutes phút',
      ].join(' • ');

  @override
  List<AdminDetailField> get details => [
        AdminDetailField(label: 'Tiêu đề', value: title),
        if (nickname.isNotEmpty)
          AdminDetailField(label: 'Nickname', value: nickname),
        if (representativeUrl?.isNotEmpty == true)
          AdminDetailField(
            label: 'Ảnh đại diện',
            imageUrl: representativeUrl,
          ),
        if (performanceGenre.isNotEmpty)
          AdminDetailField(label: 'Thể loại', value: performanceGenre),
        AdminDetailField(
          label: 'Số người tham gia',
          value: participantCount.toString(),
        ),
        AdminDetailField(
          label: 'Thời lượng',
          value: '$durationMinutes phút',
        ),
        if (slotLabel?.isNotEmpty == true)
          AdminDetailField(label: 'Khung giờ', value: slotLabel!),
        AdminDetailField(label: 'Trạng thái', value: _statusLabel(status)),
        if (introduction?.isNotEmpty == true)
          AdminDetailField(label: 'Giới thiệu', value: introduction!),
        AdminDetailField(
          label: 'Ngày gửi',
          value: formatAdminDate(createdAt),
        ),
      ];

  static String _statusLabel(String status) => switch (status) {
        'approved' => 'Đã duyệt',
        'denied' => 'Từ chối',
        _ => 'Chờ duyệt',
      };
}

String parseAdminRole(dynamic value) {
  if (value == null) return 'User';
  if (value is String) return value;
  return switch (value) {
    1 => 'Admin',
    2 => 'Dealer',
    3 => 'Staff',
    _ => 'User',
  };
}

String adminRoleLabel(String role) => switch (role.toLowerCase()) {
      'admin' => 'Quản trị viên',
      'dealer' => 'Dealer',
      'staff' => 'Nhân viên',
      _ => 'Người dùng',
    };

class AdminUserItem implements AdminListItem {
  const AdminUserItem({
    required this.id,
    required this.email,
    this.fursonaName,
    this.firstName,
    this.lastName,
    this.country,
    this.avatar,
    this.role = 'User',
    this.idCard,
    this.dateOfBirth,
    this.isVerified = false,
    this.isDealer = false,
    this.isHasTicket = false,
    this.isBlacklisted = false,
    this.denialCount = 0,
    this.blacklistReason,
    this.blacklistedAt,
    this.isDeleted = false,
    this.createdAt,
  });

  factory AdminUserItem.fromJson(Map<String, dynamic> json) {
    return AdminUserItem(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      fursonaName: json['fursona_name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      country: json['country'] as String?,
      avatar: json['avatar'] as String?,
      role: parseAdminRole(json['role']),
      idCard: json['id_card'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      isDealer: json['is_dealer'] as bool? ?? false,
      isHasTicket: json['is_has_ticket'] as bool? ?? false,
      isBlacklisted:
          json['is_blacklisted'] as bool? ?? json['is_banned'] as bool? ?? false,
      denialCount: json['denial_count'] as int? ?? 0,
      blacklistReason: json['blacklist_reason'] as String?,
      blacklistedAt: parseAdminDate(json['blacklisted_at']),
      isDeleted: json['is_deleted'] as bool? ?? false,
      createdAt: parseAdminDate(json['created_at']),
    );
  }

  factory AdminUserItem.fromBlacklistedJson(Map<String, dynamic> json) {
    return AdminUserItem(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      fursonaName: json['fursona_name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      isBlacklisted: true,
      denialCount: json['denial_count'] as int? ?? 0,
      blacklistReason: json['blacklist_reason'] as String?,
      blacklistedAt: parseAdminDate(json['blacklisted_at']),
    );
  }

  @override
  final String id;
  final String email;
  final String? fursonaName;
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? avatar;
  final String role;
  final String? idCard;
  final String? dateOfBirth;
  final bool isVerified;
  final bool isDealer;
  final bool isHasTicket;
  final bool isBlacklisted;
  final int denialCount;
  final String? blacklistReason;
  final DateTime? blacklistedAt;
  final bool isDeleted;
  final DateTime? createdAt;

  String get displayName {
    if (fursonaName != null && fursonaName!.isNotEmpty) return fursonaName!;
    final parts = [firstName, lastName].whereType<String>().where(
          (s) => s.isNotEmpty,
        );
    final joined = parts.join(' ').trim();
    if (joined.isNotEmpty) return joined;
    return email;
  }

  String get initials {
    final name = displayName;
    if (name.isNotEmpty && name != email) {
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
  String get title => displayName;

  @override
  String? get previewImageUrl =>
      avatar != null && avatar!.isNotEmpty ? avatar : null;

  @override
  String? get subtitle {
    final parts = <String>[
      email,
      adminRoleLabel(role),
      if (isVerified) 'Đã xác minh' else 'Chưa xác minh',
      if (isBlacklisted) 'Bị cấm',
    ];
    return parts.join(' • ');
  }

  @override
  List<AdminDetailField> get details => [
        AdminDetailField(label: 'Email', value: email),
        AdminDetailField(label: 'Tên hiển thị', value: displayName),
        if (fursonaName?.isNotEmpty == true)
          AdminDetailField(label: 'Fursona', value: fursonaName!),
        if (firstName?.isNotEmpty == true)
          AdminDetailField(label: 'Họ', value: firstName!),
        if (lastName?.isNotEmpty == true)
          AdminDetailField(label: 'Tên', value: lastName!),
        AdminDetailField(label: 'Vai trò', value: adminRoleLabel(role)),
        AdminDetailField(
          label: 'Xác minh',
          value: isVerified ? 'Đã xác minh' : 'Chưa xác minh',
        ),
        if (country?.isNotEmpty == true)
          AdminDetailField(label: 'Quốc gia', value: country!),
        if (idCard?.isNotEmpty == true)
          AdminDetailField(label: 'CCCD/CMND', value: idCard!),
        if (dateOfBirth?.isNotEmpty == true)
          AdminDetailField(label: 'Ngày sinh', value: dateOfBirth!),
        AdminDetailField(
          label: 'Có vé',
          value: isHasTicket ? 'Có' : 'Không',
        ),
        AdminDetailField(
          label: 'Dealer',
          value: isDealer ? 'Có' : 'Không',
        ),
        if (isBlacklisted) ...[
          AdminDetailField(label: 'Trạng thái', value: 'Bị cấm mua vé'),
          if (blacklistReason?.isNotEmpty == true)
            AdminDetailField(label: 'Lý do cấm', value: blacklistReason!),
          AdminDetailField(
            label: 'Ngày cấm',
            value: formatAdminDate(blacklistedAt),
          ),
          AdminDetailField(
            label: 'Số lần từ chối vé',
            value: denialCount.toString(),
          ),
        ],
        if (isDeleted)
          AdminDetailField(label: 'Tài khoản', value: 'Đã xóa'),
        if (avatar?.isNotEmpty == true)
          AdminDetailField(label: 'Ảnh đại diện', imageUrl: avatar),
        AdminDetailField(
          label: 'Ngày tạo',
          value: formatAdminDate(createdAt),
        ),
      ];
}

class AdminConbookItem implements AdminListItem {
  const AdminConbookItem({
    required this.id,
    required this.title,
    required this.description,
    required this.handle,
    required this.imageUrl,
    required this.status,
    this.createdAt,
  });

  factory AdminConbookItem.fromJson(Map<String, dynamic> json) {
    return AdminConbookItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? 'Conbook',
      description: json['description'] as String? ?? '',
      handle: json['handle'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      createdAt: parseAdminDate(json['created_at']),
    );
  }

  @override
  final String title;
  @override
  final String id;
  final String description;
  final String handle;
  final String imageUrl;
  final String status;
  final DateTime? createdAt;

  @override
  String? get previewImageUrl => imageUrl.isNotEmpty ? imageUrl : null;

  @override
  String? get subtitle => [
        if (handle.isNotEmpty) '@$handle',
        if (description.isNotEmpty) description,
      ].join(' • ');

  @override
  List<AdminDetailField> get details => [
        AdminDetailField(label: 'Tiêu đề', value: title),
        if (handle.isNotEmpty) AdminDetailField(label: 'Handle', value: '@$handle'),
        AdminDetailField(label: 'Trạng thái', value: AdminPanelItem._statusLabel(status)),
        if (description.isNotEmpty)
          AdminDetailField(label: 'Mô tả', value: description),
        if (imageUrl.isNotEmpty)
          AdminDetailField(label: 'Ảnh conbook', imageUrl: imageUrl),
        AdminDetailField(
          label: 'Ngày gửi',
          value: formatAdminDate(createdAt),
        ),
      ];
}

class AdminLostFoundItem implements AdminListItem {
  const AdminLostFoundItem({
    required this.id,
    required this.itemType,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.contactInfo,
    required this.staffNotes,
    required this.status,
    this.createdAt,
    this.modifiedAt,
  });

  factory AdminLostFoundItem.fromJson(Map<String, dynamic> json) {
    return AdminLostFoundItem(
      id: json['id']?.toString() ?? '',
      itemType: json['item_type'] as String? ?? 'found',
      title: json['title'] as String? ?? 'Vật thất lạc',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      contactInfo: json['contact_info'] as String? ?? '',
      staffNotes: json['staff_notes'] as String? ?? '',
      status: json['status'] as String? ?? 'open',
      createdAt: parseAdminDate(json['created_at']),
      modifiedAt: parseAdminDate(json['modified_at']),
    );
  }

  @override
  final String id;
  final String itemType;
  @override
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final String contactInfo;
  final String staffNotes;
  final String status;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  static String itemTypeLabel(String type) => switch (type) {
        'lost' => 'Thất lạc',
        'found' => 'Nhặt được',
        _ => type,
      };

  static String statusLabel(String status) => switch (status) {
        'claimed' => 'Đã nhận',
        'resolved' => 'Đã xử lý',
        _ => 'Đang mở',
      };

  static Color statusColor(String status) => switch (status) {
        'claimed' => const Color(0xFFFBBF24),
        'resolved' => const Color(0xFF10B981),
        _ => const Color(0xFF60A5FA),
      };

  @override
  String? get previewImageUrl => imageUrl.isNotEmpty ? imageUrl : null;

  @override
  String? get subtitle {
    final parts = <String>[
      itemTypeLabel(itemType),
      statusLabel(status),
      if (location.isNotEmpty) location,
    ];
    return parts.join(' • ');
  }

  @override
  List<AdminDetailField> get details => [
        AdminDetailField(label: 'Tiêu đề', value: title),
        AdminDetailField(label: 'Loại', value: itemTypeLabel(itemType)),
        AdminDetailField(label: 'Trạng thái', value: statusLabel(status)),
        if (description.isNotEmpty)
          AdminDetailField(label: 'Mô tả', value: description),
        if (location.isNotEmpty)
          AdminDetailField(label: 'Vị trí', value: location),
        if (contactInfo.isNotEmpty)
          AdminDetailField(label: 'Liên hệ', value: contactInfo),
        if (imageUrl.isNotEmpty)
          AdminDetailField(label: 'Ảnh', imageUrl: imageUrl),
        if (staffNotes.isNotEmpty)
          AdminDetailField(label: 'Ghi chú nhân viên', value: staffNotes),
        AdminDetailField(
          label: 'Ngày tạo',
          value: formatAdminDate(createdAt),
        ),
        AdminDetailField(
          label: 'Cập nhật',
          value: formatAdminDate(modifiedAt),
        ),
      ];
}
