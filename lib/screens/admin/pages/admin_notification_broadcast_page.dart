import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_error_l10n.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_notification_service.dart';
import 'package:go_router/go_router.dart';

class AdminNotificationBroadcastPage extends StatefulWidget {
  const AdminNotificationBroadcastPage({super.key});

  @override
  State<AdminNotificationBroadcastPage> createState() =>
      _AdminNotificationBroadcastPageState();
}

class _AdminNotificationBroadcastPageState
    extends State<AdminNotificationBroadcastPage> {
  final _formKey = GlobalKey<FormState>();
  late final AdminNotificationService _notificationService;

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _kindController = TextEditingController();

  String? _role;
  bool _sendPush = true;
  bool _sendEmail = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _notificationService = sl<AdminNotificationService>();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final result = await _notificationService.broadcast(
        AdminBroadcastNotificationInput(
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          kind: _kindController.text.trim().isEmpty
              ? null
              : _kindController.text.trim(),
          role: _role,
          sendEmail: _sendEmail,
          sendPush: _sendPush,
        ),
      );

      if (!mounted) return;
      _showResultSnackBar(l10n, result);
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(formatAdminError(l10n, e))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showResultSnackBar(
    AppLocalizations l10n,
    AdminBroadcastNotificationResult result,
  ) {
    final buffer = StringBuffer(l10n.adminNotificationBroadcastSuccess);
    buffer.write(
      '\n${l10n.adminNotificationBroadcastRecipients(result.recipients)}',
    );
    if (result.error != null && result.error!.isNotEmpty) {
      buffer.write('\n${result.error}');
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(buffer.toString())));
  }

  InputDecoration _fieldDecoration({String? hint, String? label}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: FuvekonColors.darkSurfaceElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: FuvekonColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: FuvekonColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: FuvekonColors.darkPrimary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _kindController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminNotificationBroadcastTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            FuvekonSpacing.page,
            8,
            FuvekonSpacing.page,
            32,
          ),
          children: [
            Text(
              l10n.adminNotificationBroadcastSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: FuvekonColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String?>(
              initialValue: _role,
              decoration: _fieldDecoration(
                label: l10n.adminNotificationBroadcastAudienceLabel,
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.adminNotificationBroadcastAudienceAll),
                ),
                DropdownMenuItem(
                  value: 'user',
                  child: Text(l10n.adminNotificationBroadcastAudienceUser),
                ),
                DropdownMenuItem(
                  value: 'dealer',
                  child: Text(l10n.adminNotificationBroadcastAudienceDealer),
                ),
                DropdownMenuItem(
                  value: 'staff',
                  child: Text(l10n.adminNotificationBroadcastAudienceStaff),
                ),
                DropdownMenuItem(
                  value: 'admin',
                  child: Text(l10n.adminNotificationBroadcastAudienceAdmin),
                ),
              ],
              onChanged: _saving
                  ? null
                  : (value) => setState(() => _role = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: _fieldDecoration(
                label: l10n.adminNotificationTitleLabel,
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.adminNotificationTitleRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bodyController,
              decoration: _fieldDecoration(
                label: l10n.adminNotificationBodyLabel,
              ),
              minLines: 4,
              maxLines: 8,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kindController,
              decoration: _fieldDecoration(
                label: l10n.adminNotificationKindLabel,
                hint: l10n.adminNotificationKindHint,
              ),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.adminNotificationSendPush),
              subtitle: Text(
                l10n.adminNotificationSendPushHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
              ),
              value: _sendPush,
              onChanged: _saving
                  ? null
                  : (value) => setState(() => _sendPush = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.adminNotificationSendEmail),
              subtitle: Text(
                l10n.adminNotificationSendEmailHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
              ),
              value: _sendEmail,
              onChanged: _saving
                  ? null
                  : (value) => setState(() => _sendEmail = value),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.adminNotificationBroadcastAction),
            ),
          ],
        ),
      ),
    );
  }
}
