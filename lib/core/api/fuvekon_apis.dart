import 'package:fuvekonmobile/core/api/admin_ticket_api.dart';
import 'package:fuvekonmobile/core/api/admin_user_api.dart';
import 'package:fuvekonmobile/core/api/analytics_api.dart';
import 'package:fuvekonmobile/core/api/auth_api.dart';
import 'package:fuvekonmobile/core/api/conbook_api.dart';
import 'package:fuvekonmobile/core/api/dealer_api.dart';
import 'package:fuvekonmobile/core/api/lost_found_api.dart';
import 'package:fuvekonmobile/core/api/panel_api.dart';
import 'package:fuvekonmobile/core/api/talent_api.dart';
import 'package:fuvekonmobile/core/api/ticket_api.dart';
import 'package:fuvekonmobile/core/network/api_client.dart';

/// Facade for all Fuvekon general API clients (parity with web `axios.general` hooks).
class FuvekonApis {
  FuvekonApis(ApiClient client)
      : auth = AuthApi(client),
        account = AccountApi(client),
        ticket = TicketApi(client),
        adminTicket = AdminTicketApi(client),
        adminUser = AdminUserApi(client),
        dealer = DealerApi(client),
        adminDealer = AdminDealerApi(client),
        talent = TalentApi(client),
        adminTalent = AdminTalentApi(client),
        panel = PanelApi(client),
        adminPanel = AdminPanelApi(client),
        conbook = ConbookApi(client),
        adminLostFound = AdminLostFoundApi(client),
        analytics = AnalyticsApi(client);

  final AuthApi auth;
  final AccountApi account;
  final TicketApi ticket;
  final AdminTicketApi adminTicket;
  final AdminUserApi adminUser;
  final DealerApi dealer;
  final AdminDealerApi adminDealer;
  final TalentApi talent;
  final AdminTalentApi adminTalent;
  final PanelApi panel;
  final AdminPanelApi adminPanel;
  final ConbookApi conbook;
  final AdminLostFoundApi adminLostFound;
  final AnalyticsApi analytics;
}
