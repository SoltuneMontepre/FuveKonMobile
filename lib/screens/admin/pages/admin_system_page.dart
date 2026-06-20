import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/auth/user_permissions.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_error_l10n.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_event_settings_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_system_status_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/event_controls_section.dart';
import 'package:fuvekonmobile/screens/admin/widgets/staff_tab_scaffold.dart';
import 'package:fuvekonmobile/screens/admin/widgets/system_status_section.dart';

class AdminSystemPage extends StatefulWidget {
  const AdminSystemPage({super.key});

  @override
  State<AdminSystemPage> createState() => _AdminSystemPageState();
}

class _AdminSystemPageState extends State<AdminSystemPage> {
  final _statusService = sl<AdminSystemStatusService>();
  final _eventSettingsService = sl<AdminEventSettingsService>();
  final _auth = sl<AuthSessionNotifier>();

  AdminSystemStatusSnapshot? _snapshot;
  AdminEventSettings? _eventSettings;
  bool _statusLoading = true;
  bool _eventLoading = false;
  AdminEventToggle? _updatingToggle;

  bool get _canManageEvent =>
      _auth.isAdmin || _auth.hasPermission(UserPermissions.manageTickets);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _statusLoading = true;
      if (_canManageEvent) _eventLoading = true;
    });

    final futures = <Future<void>>[
      _loadStatus(),
      if (_canManageEvent) _loadEventSettings(),
    ];
    await Future.wait(futures);
  }

  Future<void> _loadStatus() async {
    try {
      final snapshot = await _statusService.checkAll();
      if (!mounted) return;
      setState(() {
        _snapshot = snapshot;
        _statusLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _statusLoading = false);
    }
  }

  Future<void> _loadEventSettings() async {
    try {
      final settings = await _eventSettingsService.getSettings();
      if (!mounted) return;
      setState(() {
        _eventSettings = settings;
        _eventLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _eventLoading = false);
    }
  }

  Future<void> _onEventToggle(AdminEventToggle toggle, bool enabled) async {
    setState(() => _updatingToggle = toggle);
    try {
      final settings = await _eventSettingsService.setToggle(toggle, enabled);
      if (!mounted) return;
      setState(() {
        _eventSettings = settings;
        _updatingToggle = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _updatingToggle = null);
      final message = error is AppException
          ? formatAdminMessage(context.l10n, error.message)
          : formatAdminError(context.l10n, error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _auth,
      builder: (context, _) {
        final canManageEvent = _canManageEvent;

        return StaffTabScaffold(
          child: RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(FuvekonSpacing.page),
              children: [
                if (canManageEvent) ...[
                  EventControlsSection(
                    settings: _eventSettings,
                    loading: _eventLoading,
                    updatingToggle: _updatingToggle,
                    onToggle: _onEventToggle,
                    onRefresh: _loadEventSettings,
                  ),
                  const SizedBox(height: 28),
                ],
                SystemStatusSection(
                  snapshot: _snapshot,
                  loading: _statusLoading,
                  onRefresh: _loadStatus,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
