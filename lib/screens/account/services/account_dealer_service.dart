import 'package:fuvekonmobile/core/api/dealer_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';

class DealerStaffMember {
  const DealerStaffMember({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.isOwner,
  });

  factory DealerStaffMember.fromJson(Map<String, dynamic> json) {
    return DealerStaffMember(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userEmail: json['user_email'] as String? ?? '',
      userName: json['user_name'] as String? ?? '',
      isOwner: json['is_owner'] as bool? ?? false,
    );
  }

  final String id;
  final String userId;
  final String userEmail;
  final String userName;
  final bool isOwner;
}

class DealerBoothInfo {
  const DealerBoothInfo({
    required this.id,
    required this.boothName,
    required this.description,
    required this.boothNumber,
    required this.isVerified,
    this.priceSheets = const [],
    this.staff = const [],
  });

  factory DealerBoothInfo.fromJson(Map<String, dynamic> json) {
    final sheets = json['price_sheets'];
    final staffs = json['staffs'];
    return DealerBoothInfo(
      id: json['id']?.toString() ?? '',
      boothName: json['booth_name'] as String? ?? 'Gian hàng',
      description: json['description'] as String? ?? '',
      boothNumber: json['booth_number'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
      priceSheets: sheets is List
          ? sheets.whereType<String>().where((s) => s.isNotEmpty).toList()
          : const [],
      staff: staffs is List
          ? staffs
                .whereType<Map<String, dynamic>>()
                .map(DealerStaffMember.fromJson)
                .toList()
          : const [],
    );
  }

  final String id;
  final String boothName;
  final String description;
  final String boothNumber;
  final bool isVerified;
  final List<String> priceSheets;
  final List<DealerStaffMember> staff;

  bool isOwner(String userId) =>
      staff.any((member) => member.userId == userId && member.isOwner);
}

class AccountDealerService {
  AccountDealerService({required DealerApi dealerApi}) : _api = dealerApi;

  final DealerApi _api;

  Future<DealerBoothInfo?> getMyDealer({bool useMockFallback = true}) async {
    try {
      final response = await _api.getMyDealer();
      if (response.statusCode == 404) return null;
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }
      return DealerBoothInfo.fromJson(response.data!);
    } on ServerException {
      if (!useMockFallback) rethrow;
      return _mockBooth;
    } on NetworkException {
      if (!useMockFallback) rethrow;
      return _mockBooth;
    }
  }

  Future<DealerBoothInfo> registerDealer({
    required String boothName,
    required String description,
    required List<String> priceSheets,
  }) async {
    final response = await _api.registerDealer({
      'booth_name': boothName,
      'description': description,
      'price_sheets': priceSheets,
    });
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return DealerBoothInfo.fromJson(response.data!);
  }

  Future<DealerBoothInfo> joinDealer({required String boothCode}) async {
    final response = await _api.joinDealer(boothCode: boothCode);
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return DealerBoothInfo.fromJson(response.data!);
  }

  Future<void> removeStaff({required String userId}) async {
    final response = await _api.removeStaff({'user_id': userId});
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<void> leaveDealer() async {
    final response = await _api.leaveDealer();
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<DealerBoothInfo> editDealer({
    required String boothId,
    String? boothName,
    String? description,
    List<String>? priceSheets,
  }) async {
    final payload = <String, dynamic>{};
    if (boothName != null) payload['booth_name'] = boothName;
    if (description != null) payload['description'] = description;
    if (priceSheets != null) payload['price_sheets'] = priceSheets;

    final response = await _api.editDealer(boothId, payload);
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return DealerBoothInfo.fromJson(response.data!);
  }

  static const _mockBooth = DealerBoothInfo(
    id: 'mock-dealer-1',
    boothName: 'Furry Art Corner',
    description: 'Original prints, badges, and commissions.',
    boothNumber: 'A-12',
    isVerified: true,
    priceSheets: [],
    staff: [
      DealerStaffMember(
        id: 'staff-1',
        userId: 'user-1',
        userEmail: 'owner@example.com',
        userName: 'Booth Owner',
        isOwner: true,
      ),
      DealerStaffMember(
        id: 'staff-2',
        userId: 'user-2',
        userEmail: 'helper@example.com',
        userName: 'Staff Helper',
        isOwner: false,
      ),
    ],
  );
}
