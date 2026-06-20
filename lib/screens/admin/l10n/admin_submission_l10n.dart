import 'package:flutter/material.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';

String adminRoleLabel(AppLocalizations l10n, String role) =>
    switch (role.toLowerCase()) {
      'admin' => l10n.adminRoleAdminLabel,
      'dealer' => l10n.adminRoleDealerLabel,
      'staff' => l10n.adminRoleStaffLabel,
      _ => l10n.adminRoleUserLabel,
    };

String adminRoleTitle(AppLocalizations l10n, String role) =>
    switch (role.toLowerCase()) {
      'admin' => l10n.adminRoleCodeAdmin,
      'dealer' => l10n.adminRoleCodeDealer,
      'staff' => l10n.adminRoleCodeStaff,
      _ => l10n.adminRoleCodeAttendee,
    };

String adminRoleSubtitle(AppLocalizations l10n, String role) =>
    switch (role.toLowerCase()) {
      'admin' => l10n.adminRoleAdminLabel,
      'dealer' => l10n.adminRoleExhibitor,
      'staff' => l10n.adminRoleStaffSupport,
      _ => l10n.adminRoleAttendee,
    };

String adminPermissionLabel(AppLocalizations l10n, String code) =>
    switch (code) {
      'manage_tickets' => l10n.adminPermissionManageTickets,
      'scan_tickets' => l10n.adminPermissionScanTickets,
      'approve_profiles' => l10n.adminPermissionApproveProfiles,
      'send_notifications' => l10n.adminPermissionSendNotifications,
      'view_dashboard' => l10n.adminPermissionViewDashboard,
      'manage_users' => l10n.adminPermissionManageUsers,
      _ => code,
    };

String ticketStatusLabel(AppLocalizations l10n, TicketStatus status) =>
    switch (status) {
      TicketStatus.pending => l10n.adminTicketStatusPending,
      TicketStatus.selfConfirmed => l10n.adminTicketStatusAwaitingApproval,
      TicketStatus.approved => l10n.adminTicketStatusApproved,
      TicketStatus.denied => l10n.adminTicketStatusDenied,
      TicketStatus.adminGranted => l10n.adminTicketStatusAdminGranted,
    };

String approvalStatusLabel(AppLocalizations l10n, String status) =>
    switch (status) {
      'approved' => l10n.adminStatusApproved,
      'require_changes' => l10n.adminStatusRequireChanges,
      'denied' => l10n.adminStatusDenied,
      _ => l10n.adminStatusPending,
    };

String lostFoundTypeLabel(AppLocalizations l10n, String type) => switch (type) {
  'lost' => l10n.adminLostFoundTypeLost,
  'found' => l10n.adminLostFoundTypeFound,
  _ => type,
};

String lostFoundStatusLabel(AppLocalizations l10n, String status) =>
    switch (status) {
      'claimed' => l10n.adminLostFoundStatusClaimed,
      'resolved' => l10n.adminLostFoundStatusResolved,
      _ => l10n.adminLostFoundStatusOpen,
    };

String formatAdminPermissionsSummary(
  AppLocalizations l10n,
  List<String> permissions,
) {
  if (permissions.isEmpty) return l10n.adminNone;
  return permissions.map((code) => adminPermissionLabel(l10n, code)).join(', ');
}

extension AdminDealerItemL10n on AdminDealerItem {
  String? localizedSubtitle(AppLocalizations l10n) {
    if (boothNumber?.isNotEmpty == true) {
      return l10n.adminDealerBoothCode(boothNumber!);
    }
    if (description.isNotEmpty) return description;
    return null;
  }

  List<AdminDetailField> localizedDetails(AppLocalizations l10n) => [
    AdminDetailField(label: l10n.adminFieldBoothName, value: boothName),
    if (boothNumber?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldBoothCode, value: boothNumber!),
    AdminDetailField(
      label: l10n.adminFieldStatus,
      value: isVerified ? l10n.adminStatusApproved : l10n.adminStatusPending,
    ),
    if (description.isNotEmpty)
      AdminDetailField(label: l10n.adminFieldDescription, value: description),
    for (var i = 0; i < priceSheets.length; i++)
      AdminDetailField(
        label: priceSheets.length == 1
            ? l10n.adminFieldPriceSheet
            : l10n.adminFieldPriceSheetN(i + 1),
        imageUrl: priceSheets[i],
      ),
    AdminDetailField(
      label: l10n.adminFieldRegisteredAt,
      value: formatAdminDate(createdAt),
    ),
    if (modifiedAt != null)
      AdminDetailField(
        label: l10n.adminFieldLastUpdated,
        value: formatAdminDate(modifiedAt),
      ),
  ];
}

extension AdminPanelItemL10n on AdminPanelItem {
  String localizedSubtitle(AppLocalizations l10n) => [
    if (nickname.isNotEmpty) nickname,
    if (performanceGenre.isNotEmpty) performanceGenre,
    l10n.adminDurationMinutes(durationMinutes),
  ].join(' • ');

  List<AdminDetailField> localizedDetails(AppLocalizations l10n) => [
    AdminDetailField(label: l10n.adminFieldTitle, value: title),
    if (nickname.isNotEmpty)
      AdminDetailField(label: l10n.adminFieldNickname, value: nickname),
    if (representativeUrl?.isNotEmpty == true)
      AdminDetailField(
        label: l10n.adminFieldAvatar,
        imageUrl: representativeUrl,
      ),
    if (performanceGenre.isNotEmpty)
      AdminDetailField(label: l10n.adminFieldGenre, value: performanceGenre),
    AdminDetailField(
      label: l10n.adminFieldParticipantCount,
      value: participantCount.toString(),
    ),
    AdminDetailField(
      label: l10n.adminFieldDuration,
      value: l10n.adminDurationMinutes(durationMinutes),
    ),
    if (slotLabel?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldTimeSlot, value: slotLabel!),
    AdminDetailField(
      label: l10n.adminFieldStatus,
      value: approvalStatusLabel(l10n, status),
    ),
    if (introduction?.isNotEmpty == true)
      AdminDetailField(
        label: l10n.adminFieldIntroduction,
        value: introduction!,
      ),
    AdminDetailField(
      label: l10n.adminFieldSubmittedAt,
      value: formatAdminDate(createdAt),
    ),
  ];
}

extension AdminUserItemL10n on AdminUserItem {
  String localizedSubtitle(AppLocalizations l10n) {
    final parts = <String>[
      email,
      adminRoleLabel(l10n, role),
      isVerified ? l10n.adminFieldVerifiedYes : l10n.adminFieldVerifiedNo,
      if (isBlacklisted) l10n.adminUserBlacklisted,
    ];
    return parts.join(' • ');
  }

  List<AdminDetailField> localizedDetails(AppLocalizations l10n) => [
    AdminDetailField(label: l10n.adminFieldEmail, value: email),
    AdminDetailField(label: l10n.adminFieldDisplayName, value: displayName),
    if (fursonaName?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldFursona, value: fursonaName!),
    if (firstName?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldFirstName, value: firstName!),
    if (lastName?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldLastName, value: lastName!),
    AdminDetailField(
      label: l10n.adminFieldRole,
      value: adminRoleLabel(l10n, role),
    ),
    AdminDetailField(
      label: l10n.adminFieldVerified,
      value: isVerified
          ? l10n.adminFieldVerifiedYes
          : l10n.adminFieldVerifiedNo,
    ),
    if (country?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldCountry, value: country!),
    if (idCard?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldIdCard, value: idCard!),
    if (dateOfBirth?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldDateOfBirth, value: dateOfBirth!),
    AdminDetailField(
      label: l10n.adminFieldHasTicket,
      value: isHasTicket ? l10n.adminYes : l10n.adminNo,
    ),
    AdminDetailField(
      label: l10n.adminFieldDealer,
      value: isDealer ? l10n.adminYes : l10n.adminNo,
    ),
    if (isBlacklisted) ...[
      AdminDetailField(
        label: l10n.adminFieldStatus,
        value: l10n.adminUserBannedFromTickets,
      ),
      if (blacklistReason?.isNotEmpty == true)
        AdminDetailField(label: l10n.adminBanReason, value: blacklistReason!),
      AdminDetailField(
        label: l10n.adminBanDate,
        value: formatAdminDate(blacklistedAt),
      ),
      AdminDetailField(
        label: l10n.adminDenialCount,
        value: denialCount.toString(),
      ),
    ],
    if (isDeleted)
      AdminDetailField(
        label: l10n.adminFieldAccount,
        value: l10n.adminAccountDeleted,
      ),
    if (avatar?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldAvatar, imageUrl: avatar),
    AdminDetailField(
      label: l10n.adminFieldCreatedAt,
      value: formatAdminDate(createdAt),
    ),
  ];
}

extension AdminConbookItemL10n on AdminConbookItem {
  List<AdminDetailField> localizedDetails(AppLocalizations l10n) => [
    AdminDetailField(label: l10n.adminFieldTitle, value: title),
    if (handle.isNotEmpty)
      AdminDetailField(label: l10n.adminFieldHandle, value: '@$handle'),
    AdminDetailField(
      label: l10n.adminFieldStatus,
      value: approvalStatusLabel(l10n, status),
    ),
    if (description.isNotEmpty)
      AdminDetailField(label: l10n.adminFieldDescription, value: description),
    if (imageUrl.isNotEmpty)
      AdminDetailField(label: l10n.adminFieldConbookImage, imageUrl: imageUrl),
    AdminDetailField(
      label: l10n.adminFieldSubmittedAt,
      value: formatAdminDate(createdAt),
    ),
  ];
}

extension AdminTicketItemL10n on AdminTicketItem {
  String localizedSubtitle(AppLocalizations l10n) {
    final parts = <String>[
      referenceCode,
      if (tierName != null && tierName!.isNotEmpty) tierName!,
      ticketStatusLabel(l10n, status),
      if (isCheckedIn) l10n.adminCheckedIn,
    ];
    return parts.join(' • ');
  }

  List<AdminDetailField> localizedDetails(AppLocalizations l10n) => [
    AdminDetailField(label: l10n.adminFieldTicketCode, value: referenceCode),
    AdminDetailField(
      label: l10n.adminFieldTicketNumber,
      value: '#$ticketNumber',
    ),
    AdminDetailField(
      label: l10n.adminFieldStatus,
      value: ticketStatusLabel(l10n, status),
    ),
    if (tierName?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldTier, value: tierName!),
    if (tierCode?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldTierCode, value: tierCode!),
    if (conBadgeName?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldBadgeName, value: conBadgeName!),
    if (userEmail?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldEmail, value: userEmail!),
    if (userIdCard?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldIdCard, value: userIdCard!),
    if (userIsBlacklisted)
      AdminDetailField(
        label: l10n.adminFieldUser,
        value: l10n.adminUserBannedFromTickets,
      ),
    AdminDetailField(
      label: l10n.adminFieldFursuiter,
      value: isFursuiter ? l10n.adminYes : l10n.adminNo,
    ),
    AdminDetailField(
      label: l10n.adminFieldFursuitStaff,
      value: isFursuitStaff ? l10n.adminYes : l10n.adminNo,
    ),
    if (tshirtSize?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldTshirtSize, value: tshirtSize!),
    AdminDetailField(
      label: l10n.adminFieldCheckIn,
      value: isCheckedIn ? l10n.adminCheckedIn : l10n.adminNotCheckedIn,
    ),
    if (denialReason?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminDenyReason, value: denialReason!),
    if (badgeImage?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldBadgeImage, imageUrl: badgeImage),
    if (namecardUrl?.isNotEmpty == true)
      AdminDetailField(label: l10n.adminFieldNamecard, imageUrl: namecardUrl),
    AdminDetailField(
      label: l10n.adminFieldCreatedAt,
      value: formatAdminDate(createdAt),
    ),
    if (approvedAt != null)
      AdminDetailField(
        label: l10n.adminFieldApprovedAt,
        value: formatAdminDate(approvedAt),
      ),
    if (deniedAt != null)
      AdminDetailField(
        label: l10n.adminFieldDeniedAt,
        value: formatAdminDate(deniedAt),
      ),
  ];
}

extension AdminLostFoundItemL10n on AdminLostFoundItem {
  String localizedSubtitle(AppLocalizations l10n) {
    final parts = <String>[
      lostFoundTypeLabel(l10n, itemType),
      lostFoundStatusLabel(l10n, status),
      if (location.isNotEmpty) location,
    ];
    return parts.join(' • ');
  }

  List<AdminDetailField> localizedDetails(AppLocalizations l10n) => [
    AdminDetailField(label: l10n.adminFieldTitle, value: title),
    AdminDetailField(label: l10n.adminFieldItemCode, value: itemCode),
    AdminDetailField(
      label: l10n.adminFieldType,
      value: lostFoundTypeLabel(l10n, itemType),
    ),
    AdminDetailField(
      label: l10n.adminFieldStatus,
      value: lostFoundStatusLabel(l10n, status),
    ),
    if (description.isNotEmpty)
      AdminDetailField(label: l10n.adminFieldDescription, value: description),
    if (location.isNotEmpty)
      AdminDetailField(label: l10n.adminFieldLocation, value: location),
    if (contactInfo.isNotEmpty)
      AdminDetailField(label: l10n.adminFieldContact, value: contactInfo),
    if (imageUrl.isNotEmpty)
      AdminDetailField(label: l10n.adminFieldImage, imageUrl: imageUrl),
    if (staffNotes.isNotEmpty)
      AdminDetailField(label: l10n.adminFieldStaffNotes, value: staffNotes),
    if (returnedAt != null && recipientName.isNotEmpty) ...[
      AdminDetailField(label: l10n.adminFieldRecipient, value: recipientName),
      AdminDetailField(
        label: l10n.adminFieldRecipientIdCard,
        value: AdminLostFoundItem.maskSensitive(recipientIdCard),
      ),
      AdminDetailField(
        label: l10n.adminFieldRecipientPhone,
        value: AdminLostFoundItem.maskSensitive(recipientPhone),
      ),
      AdminDetailField(
        label: l10n.adminFieldReturnedAt,
        value: formatAdminDate(returnedAt),
      ),
    ],
    AdminDetailField(
      label: l10n.adminFieldCreatedAt,
      value: formatAdminDate(createdAt),
    ),
    AdminDetailField(
      label: l10n.adminFieldUpdatedAt,
      value: formatAdminDate(modifiedAt),
    ),
  ];
}

Color lostFoundStatusColor(String status) => switch (status) {
  'claimed' => const Color(0xFFFBBF24),
  'resolved' => const Color(0xFF10B981),
  _ => const Color(0xFF60A5FA),
};
