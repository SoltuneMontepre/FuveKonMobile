enum TicketStatus {
  pending,
  selfConfirmed,
  approved,
  denied,
  adminGranted;

  static TicketStatus? fromApi(String? value) {
    return switch (value) {
      'pending' => TicketStatus.pending,
      'self_confirmed' => TicketStatus.selfConfirmed,
      'approved' => TicketStatus.approved,
      'denied' => TicketStatus.denied,
      'admin_granted' => TicketStatus.adminGranted,
      _ => null,
    };
  }

  String get apiValue => switch (this) {
        TicketStatus.pending => 'pending',
        TicketStatus.selfConfirmed => 'self_confirmed',
        TicketStatus.approved => 'approved',
        TicketStatus.denied => 'denied',
        TicketStatus.adminGranted => 'admin_granted',
      };

  bool get isActive => this != TicketStatus.denied;
}
