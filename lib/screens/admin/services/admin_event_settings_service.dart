import 'package:fuvekonmobile/core/api/event_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';

enum AdminEventToggle {
  ticketSales,
  panelRegistration,
  talentRegistration,
  dealerRegistration,
}

class AdminEventSettings {
  const AdminEventSettings({
    required this.ticketSalesEnabled,
    required this.panelRegistrationEnabled,
    required this.talentRegistrationEnabled,
    required this.dealerRegistrationEnabled,
    this.modifiedAt,
  });

  final bool ticketSalesEnabled;
  final bool panelRegistrationEnabled;
  final bool talentRegistrationEnabled;
  final bool dealerRegistrationEnabled;
  final DateTime? modifiedAt;

  factory AdminEventSettings.fromJson(Map<String, dynamic> json) {
    return AdminEventSettings(
      ticketSalesEnabled: json['ticket_sales_enabled'] == true,
      panelRegistrationEnabled: json['panel_registration_enabled'] == true,
      talentRegistrationEnabled: json['talent_registration_enabled'] == true,
      dealerRegistrationEnabled: json['dealer_registration_enabled'] == true,
      modifiedAt: DateTime.tryParse(json['modified_at']?.toString() ?? ''),
    );
  }

  AdminEventSettings copyWith({
    bool? ticketSalesEnabled,
    bool? panelRegistrationEnabled,
    bool? talentRegistrationEnabled,
    bool? dealerRegistrationEnabled,
    DateTime? modifiedAt,
  }) {
    return AdminEventSettings(
      ticketSalesEnabled: ticketSalesEnabled ?? this.ticketSalesEnabled,
      panelRegistrationEnabled:
          panelRegistrationEnabled ?? this.panelRegistrationEnabled,
      talentRegistrationEnabled:
          talentRegistrationEnabled ?? this.talentRegistrationEnabled,
      dealerRegistrationEnabled:
          dealerRegistrationEnabled ?? this.dealerRegistrationEnabled,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }
}

class AdminEventSettingsService {
  AdminEventSettingsService({required EventApi eventApi})
    : _eventApi = eventApi;

  final EventApi _eventApi;

  Future<AdminEventSettings> getSettings() async {
    final response = await _eventApi.getAdminSettings();
    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        response.message.isNotEmpty
            ? response.message
            : 'Không tải được cài đặt sự kiện',
      );
    }
    return AdminEventSettings.fromJson(response.data!);
  }

  Future<AdminEventSettings> setToggle(
    AdminEventToggle toggle,
    bool enabled,
  ) async {
    final response = switch (toggle) {
      AdminEventToggle.ticketSales => await _eventApi.setTicketSalesOpen(
        enabled,
      ),
      AdminEventToggle.panelRegistration =>
        await _eventApi.setPanelRegistrationOpen(enabled),
      AdminEventToggle.talentRegistration =>
        await _eventApi.setTalentRegistrationOpen(enabled),
      AdminEventToggle.dealerRegistration =>
        await _eventApi.setDealerRegistrationOpen(enabled),
    };

    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        response.message.isNotEmpty
            ? response.message
            : 'Không cập nhật được cài đặt sự kiện',
      );
    }
    return AdminEventSettings.fromJson(response.data!);
  }
}
