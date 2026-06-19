import 'package:flutter/material.dart';
import 'package:fuvekonmobile/screens/info/lost_found_models.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';

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

class AdminDealerStaffMember {
  const AdminDealerStaffMember({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.isOwner,
    this.createdAt,
  });

  factory AdminDealerStaffMember.fromJson(Map<String, dynamic> json) {
    return AdminDealerStaffMember(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userEmail: json['user_email'] as String? ?? '',
      userName: json['user_name'] as String? ?? '',
      isOwner: json['is_owner'] as bool? ?? false,
      createdAt: parseAdminDate(json['created_at']),
    );
  }

  final String id;
  final String userId;
  final String userEmail;
  final String userName;
  final bool isOwner;
  final DateTime? createdAt;
}

class AdminDealerItem implements AdminListItem {
  const AdminDealerItem({
    required this.id,
    required this.boothName,
    required this.description,
    this.boothNumber,
    required this.isVerified,
    this.priceSheets = const [],
    this.staff = const [],
    this.createdAt,
    this.modifiedAt,
  });

  factory AdminDealerItem.fromJson(Map<String, dynamic> json) {
    final sheets = json['price_sheets'];
    final staffs = json['staffs'];
    return AdminDealerItem(
      id: json['id']?.toString() ?? '',
      boothName: json['booth_name'] as String? ?? 'Gian hàng',
      description: json['description'] as String? ?? '',
      boothNumber: json['booth_number'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      priceSheets: sheets is List
          ? sheets.whereType<String>().where((s) => s.isNotEmpty).toList()
          : const [],
      staff: staffs is List
          ? staffs
                .whereType<Map<String, dynamic>>()
                .map(AdminDealerStaffMember.fromJson)
                .toList()
          : const [],
      createdAt: parseAdminDate(json['created_at']),
      modifiedAt: parseAdminDate(json['modified_at']),
    );
  }

  @override
  final String id;
  final String boothName;
  final String description;
  final String? boothNumber;
  final bool isVerified;
  final List<String> priceSheets;
  final List<AdminDealerStaffMember> staff;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

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
        if (modifiedAt != null)
          AdminDetailField(
            label: 'Cập nhật lần cuối',
            value: formatAdminDate(modifiedAt),
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

List<String> _parsePermissionCodes(dynamic value) {
  if (value is! List) return const [];
  return value.whereType<String>().toList();
}

String adminRoleLabel(String role) => switch (role.toLowerCase()) {
      'admin' => 'Quản trị viên',
      'dealer' => 'Dealer',
      'staff' => 'Nhân viên',
      _ => 'Người dùng',
    };

const adminRoleOptions = ['User', 'Dealer', 'Staff', 'Admin'];

const adminPermissionCodes = [
  'manage_tickets',
  'scan_tickets',
  'approve_profiles',
  'send_notifications',
  'view_dashboard',
  'manage_users',
];

String adminRoleTitle(String role) => switch (role.toLowerCase()) {
      'admin' => 'Admin',
      'dealer' => 'Dealer',
      'staff' => 'Staff',
      _ => 'Attendee',
    };

String adminRoleSubtitle(String role) => switch (role.toLowerCase()) {
      'admin' => 'Quản trị viên',
      'dealer' => 'Nhà triển lãm',
      'staff' => 'Nhân viên hỗ trợ',
      _ => 'Khách tham quan',
    };

String adminPermissionLabel(String code) => switch (code) {
      'manage_tickets' => 'Quản lý vé',
      'scan_tickets' => 'Quét vé',
      'approve_profiles' => 'Duyệt hồ sơ',
      'send_notifications' => 'Gửi thông báo',
      'view_dashboard' => 'Xem dashboard',
      'manage_users' => 'Quản lý người dùng',
      _ => code,
    };

List<String> defaultPermissionsForRole(String role) => switch (role.toLowerCase()) {
      'admin' => List<String>.from(adminPermissionCodes),
      'staff' => const ['scan_tickets', 'view_dashboard'],
      _ => const [],
    };

bool isAdminRole(String role) => role.toLowerCase() == 'admin';

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
    this.permissions = const [],
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
      permissions: _parsePermissionCodes(json['permissions']),
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
  final List<String> permissions;

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

String ticketStatusLabelVi(TicketStatus status) => switch (status) {
      TicketStatus.pending => 'Chờ thanh toán',
      TicketStatus.selfConfirmed => 'Chờ duyệt',
      TicketStatus.approved => 'Đã duyệt',
      TicketStatus.denied => 'Từ chối',
      TicketStatus.adminGranted => 'Cấp bởi admin',
    };

Color ticketStatusColor(TicketStatus status) => switch (status) {
      TicketStatus.pending => const Color(0xFFFBBF24),
      TicketStatus.selfConfirmed => const Color(0xFF60A5FA),
      TicketStatus.approved => const Color(0xFF10B981),
      TicketStatus.denied => const Color(0xFFF0A0A8),
      TicketStatus.adminGranted => const Color(0xFFA78BFA),
    };

class AdminTicketItem implements AdminListItem {
  const AdminTicketItem({
    required this.id,
    required this.referenceCode,
    required this.status,
    required this.ticketNumber,
    this.conBadgeName,
    this.badgeImage,
    this.namecardUrl,
    required this.isFursuiter,
    required this.isFursuitStaff,
    required this.isCheckedIn,
    this.tshirtSize,
    this.denialReason,
    this.tierName,
    this.tierCode,
    this.tierId,
    this.userId,
    this.userEmail,
    this.userFursonaName,
    this.userFirstName,
    this.userLastName,
    this.userAvatar,
    this.userIdCard,
    this.userIsBlacklisted = false,
    this.createdAt,
    this.approvedAt,
    this.deniedAt,
  });

  factory AdminTicketItem.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final userMap =
        user is Map ? Map<String, dynamic>.from(user) : <String, dynamic>{};
    final tier = json['tier'];
    final tierMap =
        tier is Map ? Map<String, dynamic>.from(tier) : <String, dynamic>{};

    return AdminTicketItem(
      id: json['id']?.toString() ?? '',
      referenceCode: json['reference_code'] as String? ?? '',
      status: TicketStatus.fromApi(json['status'] as String?) ??
          TicketStatus.pending,
      ticketNumber: json['ticket_number'] as int? ?? 0,
      conBadgeName: json['con_badge_name'] as String?,
      badgeImage: json['badge_image'] as String?,
      namecardUrl: json['namecard_url'] as String?,
      isFursuiter: json['is_fursuiter'] as bool? ?? false,
      isFursuitStaff: json['is_fursuit_staff'] as bool? ?? false,
      isCheckedIn: json['is_checked_in'] as bool? ?? false,
      tshirtSize: json['tshirt_size'] as String?,
      denialReason: json['denial_reason'] as String?,
      tierName: tierMap['ticket_name'] as String?,
      tierCode: tierMap['tier_code'] as String?,
      tierId: tierMap['id']?.toString(),
      userId: userMap['id']?.toString(),
      userEmail: userMap['email'] as String?,
      userFursonaName: userMap['fursona_name'] as String?,
      userFirstName: userMap['first_name'] as String?,
      userLastName: userMap['last_name'] as String?,
      userAvatar: userMap['avatar'] as String?,
      userIdCard: userMap['id_card'] as String?,
      userIsBlacklisted: userMap['is_blacklisted'] as bool? ?? false,
      createdAt: parseAdminDate(json['created_at']),
      approvedAt: parseAdminDate(json['approved_at']),
      deniedAt: parseAdminDate(json['denied_at']),
    );
  }

  @override
  final String id;
  final String referenceCode;
  final TicketStatus status;
  final int ticketNumber;
  final String? conBadgeName;
  final String? badgeImage;
  final String? namecardUrl;
  final bool isFursuiter;
  final bool isFursuitStaff;
  final bool isCheckedIn;
  final String? tshirtSize;
  final String? denialReason;
  final String? tierName;
  final String? tierCode;
  final String? tierId;
  final String? userId;
  final String? userEmail;
  final String? userFursonaName;
  final String? userFirstName;
  final String? userLastName;
  final String? userAvatar;
  final String? userIdCard;
  final bool userIsBlacklisted;
  final DateTime? createdAt;
  final DateTime? approvedAt;
  final DateTime? deniedAt;

  String get holderName {
    if (conBadgeName != null && conBadgeName!.isNotEmpty) return conBadgeName!;
    if (userFursonaName != null && userFursonaName!.isNotEmpty) {
      return userFursonaName!;
    }
    final parts = [userFirstName, userLastName]
        .whereType<String>()
        .where((s) => s.isNotEmpty);
    final joined = parts.join(' ').trim();
    if (joined.isNotEmpty) return joined;
    return userEmail ?? referenceCode;
  }

  bool get canApprove => status == TicketStatus.selfConfirmed;

  bool get canDeny =>
      status == TicketStatus.selfConfirmed ||
      status == TicketStatus.pending;

  bool get canResendQr =>
      status == TicketStatus.approved || status == TicketStatus.adminGranted;

  @override
  String get title => holderName;

  @override
  String? get previewImageUrl =>
      userAvatar != null && userAvatar!.isNotEmpty ? userAvatar : badgeImage;

  @override
  String? get subtitle {
    final parts = <String>[
      referenceCode,
      if (tierName != null && tierName!.isNotEmpty) tierName!,
      ticketStatusLabelVi(status),
      if (isCheckedIn) 'Đã check-in',
    ];
    return parts.join(' • ');
  }

  @override
  List<AdminDetailField> get details => [
        AdminDetailField(label: 'Mã vé', value: referenceCode),
        AdminDetailField(label: 'Số vé', value: '#$ticketNumber'),
        AdminDetailField(
          label: 'Trạng thái',
          value: ticketStatusLabelVi(status),
        ),
        if (tierName?.isNotEmpty == true)
          AdminDetailField(label: 'Hạng vé', value: tierName!),
        if (tierCode?.isNotEmpty == true)
          AdminDetailField(label: 'Mã hạng', value: tierCode!),
        if (conBadgeName?.isNotEmpty == true)
          AdminDetailField(label: 'Tên badge', value: conBadgeName!),
        if (userEmail?.isNotEmpty == true)
          AdminDetailField(label: 'Email', value: userEmail!),
        if (userIdCard?.isNotEmpty == true)
          AdminDetailField(label: 'CCCD/CMND', value: userIdCard!),
        if (userIsBlacklisted)
          AdminDetailField(label: 'Người dùng', value: 'Bị cấm mua vé'),
        AdminDetailField(
          label: 'Fursuiter',
          value: isFursuiter ? 'Có' : 'Không',
        ),
        AdminDetailField(
          label: 'Fursuit staff',
          value: isFursuitStaff ? 'Có' : 'Không',
        ),
        if (tshirtSize?.isNotEmpty == true)
          AdminDetailField(label: 'Size áo', value: tshirtSize!),
        AdminDetailField(
          label: 'Check-in',
          value: isCheckedIn ? 'Đã check-in' : 'Chưa check-in',
        ),
        if (denialReason?.isNotEmpty == true)
          AdminDetailField(label: 'Lý do từ chối', value: denialReason!),
        if (badgeImage?.isNotEmpty == true)
          AdminDetailField(label: 'Ảnh badge', imageUrl: badgeImage),
        if (namecardUrl?.isNotEmpty == true)
          AdminDetailField(label: 'Namecard', imageUrl: namecardUrl),
        AdminDetailField(
          label: 'Ngày tạo',
          value: formatAdminDate(createdAt),
        ),
        if (approvedAt != null)
          AdminDetailField(
            label: 'Ngày duyệt',
            value: formatAdminDate(approvedAt),
          ),
        if (deniedAt != null)
          AdminDetailField(
            label: 'Ngày từ chối',
            value: formatAdminDate(deniedAt),
          ),
      ];
}

class AdminTicketTierItem {
  const AdminTicketTierItem({
    required this.id,
    required this.tierCode,
    required this.ticketName,
    required this.description,
    required this.price,
    this.priceUsd,
    this.stock,
    required this.isSoldOut,
    required this.isActive,
    required this.isVisible,
    this.benefits = const [],
  });

  factory AdminTicketTierItem.fromJson(Map<String, dynamic> json) {
    final benefitsRaw = json['benefits'];
    return AdminTicketTierItem(
      id: json['id']?.toString() ?? '',
      tierCode: json['tier_code'] as String? ?? '',
      ticketName: json['ticket_name'] as String? ?? 'Hạng vé',
      description: json['description'] as String? ?? '',
      price: _parseDecimal(json['price']),
      priceUsd: _parseOptionalDecimal(json['price_usd']),
      stock: (json['stock'] as num?)?.toInt(),
      isSoldOut: json['is_sold_out'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? false,
      isVisible: json['is_visible'] as bool? ?? false,
      benefits: benefitsRaw is List
          ? benefitsRaw.whereType<String>().toList()
          : const [],
    );
  }

  static double _parseDecimal(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static double? _parseOptionalDecimal(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  final String id;
  final String tierCode;
  final String ticketName;
  final String description;
  final double price;
  final double? priceUsd;
  final int? stock;
  final bool isSoldOut;
  final bool isActive;
  final bool isVisible;
  final List<String> benefits;
}

class AdminLostFoundItem implements AdminListItem {
  const AdminLostFoundItem({
    required this.id,
    this.displayCode = '',
    required this.itemType,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.contactInfo,
    required this.staffNotes,
    required this.status,
    this.recipientName = '',
    this.recipientIdCard = '',
    this.recipientPhone = '',
    this.verifiedDescription = false,
    this.verifiedOwnership = false,
    this.verifiedIdentity = false,
    this.returnedAt,
    this.activeClaim,
    this.createdAt,
    this.modifiedAt,
  });

  factory AdminLostFoundItem.fromJson(Map<String, dynamic> json) {
    return AdminLostFoundItem(
      id: json['id']?.toString() ?? '',
      displayCode: json['display_code'] as String? ?? '',
      itemType: json['item_type'] as String? ?? 'found',
      title: json['title'] as String? ?? 'Vật thất lạc',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      contactInfo: json['contact_info'] as String? ?? '',
      staffNotes: json['staff_notes'] as String? ?? '',
      status: json['status'] as String? ?? 'open',
      recipientName: json['recipient_name'] as String? ?? '',
      recipientIdCard: json['recipient_id_card'] as String? ?? '',
      recipientPhone: json['recipient_phone'] as String? ?? '',
      verifiedDescription: json['verified_description'] as bool? ?? false,
      verifiedOwnership: json['verified_ownership'] as bool? ?? false,
      verifiedIdentity: json['verified_identity'] as bool? ?? false,
      returnedAt: parseAdminDate(json['returned_at']),
      activeClaim: json['active_claim'] is Map<String, dynamic>
          ? AdminLostFoundClaim.fromJson(
              json['active_claim'] as Map<String, dynamic>,
            )
          : null,
      createdAt: parseAdminDate(json['created_at']),
      modifiedAt: parseAdminDate(json['modified_at']),
    );
  }

  @override
  final String id;
  final String displayCode;
  final String itemType;
  @override
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final String contactInfo;
  final String staffNotes;
  final String status;
  final String recipientName;
  final String recipientIdCard;
  final String recipientPhone;
  final bool verifiedDescription;
  final bool verifiedOwnership;
  final bool verifiedIdentity;
  final DateTime? returnedAt;
  final AdminLostFoundClaim? activeClaim;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  String get itemCode {
    if (displayCode.isNotEmpty) return displayCode;
    final compact = id.replaceAll('-', '');
    if (compact.length >= 5) {
      return 'FND-${compact.substring(compact.length - 5).toUpperCase()}';
    }
    return 'FND-${compact.toUpperCase()}';
  }

  bool get canConfirmReturn =>
      itemType == 'found' &&
      status == 'claimed' &&
      activeClaim?.isPending == true;

  static String maskSensitive(String value) {
    final trimmed = value.trim();
    if (trimmed.length <= 3) return 'x' * trimmed.length;
    return '${trimmed.substring(0, 3)}${'x' * (trimmed.length - 3)}';
  }

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
        AdminDetailField(label: 'Mã vật phẩm', value: itemCode),
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
        if (returnedAt != null && recipientName.isNotEmpty) ...[
          AdminDetailField(label: 'Người nhận', value: recipientName),
          AdminDetailField(
            label: 'CCCD người nhận',
            value: maskSensitive(recipientIdCard),
          ),
          AdminDetailField(
            label: 'SĐT người nhận',
            value: maskSensitive(recipientPhone),
          ),
          AdminDetailField(
            label: 'Hoàn trả lúc',
            value: formatAdminDate(returnedAt),
          ),
        ],
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
