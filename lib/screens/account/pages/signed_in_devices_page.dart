import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/api/auth_api.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:intl/intl.dart';

/// Lists devices signed into the current account and allows remote logout.
class SignedInDevicesPage extends StatefulWidget {
  const SignedInDevicesPage({super.key});

  @override
  State<SignedInDevicesPage> createState() => _SignedInDevicesPageState();
}

class _SignedInDevicesPageState extends State<SignedInDevicesPage> {
  bool _loading = true;
  String? _error;
  List<AuthSessionJson> _sessions = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await sl<AuthApi>().listSessions();
      if (!mounted) return;
      setState(() {
        _sessions = response.data ?? const [];
        _loading = false;
      });
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _revoke(AuthSessionJson session) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.signedInDevicesSignOutTitle),
        content: Text(
          l10n.signedInDevicesSignOutConfirm(session.deviceName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.signedInDevicesCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.signedInDevicesSignOutAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await sl<AuthApi>().revokeSession(session.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.signedInDevicesSignedOut)),
      );
      await _load();
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  IconData _iconFor(String platform) {
    switch (platform.toLowerCase()) {
      case 'ios':
        return Icons.phone_iphone;
      case 'android':
        return Icons.phone_android;
      case 'web':
        return Icons.language;
      case 'windows':
      case 'macos':
      case 'linux':
        return Icons.computer;
      default:
        return Icons.devices;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat.yMMMd().add_jm();
    final errorColor = Theme.of(context).colorScheme.error;

    return AppPageScaffold(
      title: l10n.signedInDevicesTitle,
      padding: EdgeInsets.zero,
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : _error != null
            ? ListView(
                padding: const EdgeInsets.all(FuvekonSpacing.page),
                children: [
                  Text(_error!, style: TextStyle(color: errorColor)),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: _load, child: Text(l10n.startupRetry)),
                ],
              )
            : _sessions.isEmpty
            ? ListView(
                padding: const EdgeInsets.all(FuvekonSpacing.page),
                children: [
                  Text(l10n.signedInDevicesEmpty),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(FuvekonSpacing.page),
                children: [
                  Text(
                    l10n.signedInDevicesSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: FuvekonColors.premiumOnSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: FuvekonSpacing.stackGapMd),
                  FuveMintCard(
                    child: Column(
                      children: [
                        for (var i = 0; i < _sessions.length; i++) ...[
                          if (i > 0)
                            const Divider(height: 1),
                          _SessionTile(
                            session: _sessions[i],
                            icon: _iconFor(_sessions[i].platform),
                            lastSeenLabel: dateFormat.format(
                              _sessions[i].lastSeenAt.toLocal(),
                            ),
                            currentLabel: l10n.signedInDevicesThisDevice,
                            signOutLabel: l10n.signedInDevicesSignOutAction,
                            onSignOut: _sessions[i].isCurrent
                                ? null
                                : () => _revoke(_sessions[i]),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.session,
    required this.icon,
    required this.lastSeenLabel,
    required this.currentLabel,
    required this.signOutLabel,
    required this.onSignOut,
  });

  final AuthSessionJson session;
  final IconData icon;
  final String lastSeenLabel;
  final String currentLabel;
  final String signOutLabel;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Icon(icon, color: FuvekonColors.premiumPrimary),
      title: Text(session.deviceName),
      subtitle: Text(
        session.isCurrent ? currentLabel : lastSeenLabel,
      ),
      trailing: onSignOut == null
          ? null
          : TextButton(
              onPressed: onSignOut,
              child: Text(signOutLabel),
            ),
    );
  }
}
