import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_error_l10n.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_notification_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_user_service.dart';
import 'package:go_router/go_router.dart';

class AdminNotificationCreatePage extends StatefulWidget {
  const AdminNotificationCreatePage({super.key, this.initialUserId});

  final String? initialUserId;

  @override
  State<AdminNotificationCreatePage> createState() =>
      _AdminNotificationCreatePageState();
}

class _AdminNotificationCreatePageState
    extends State<AdminNotificationCreatePage> {
  final _formKey = GlobalKey<FormState>();
  late final AdminNotificationService _notificationService;
  late final AdminUserService _userService;

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _kindController = TextEditingController();
  final _userSearchController = TextEditingController();

  AdminUserItem? _selectedUser;
  bool _sendPush = true;
  bool _sendEmail = false;
  bool _saving = false;
  bool _loadingUser = false;
  Timer? _searchDebounce;
  List<AdminUserItem> _searchResults = [];
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _notificationService = sl<AdminNotificationService>();
    _userService = sl<AdminUserService>();
    if (widget.initialUserId != null && widget.initialUserId!.isNotEmpty) {
      _loadInitialUser(widget.initialUserId!);
    }
  }

  Future<void> _loadInitialUser(String userId) async {
    setState(() => _loadingUser = true);
    try {
      final user = await _userService.getUserById(userId);
      if (!mounted) return;
      setState(() {
        _selectedUser = user;
        _userSearchController.text = user.displayName;
      });
    } catch (_) {
      // User can still pick manually.
    } finally {
      if (mounted) setState(() => _loadingUser = false);
    }
  }

  Future<void> _searchUsers(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      setState(() {
        _searchResults = const [];
        _searching = false;
      });
      return;
    }

    setState(() => _searching = true);
    try {
      final result = await _userService.getUsers(page: 1, pageSize: 20, search: trimmed);
      if (!mounted) return;
      setState(() {
        _searchResults = result.items;
        _searching = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _searchResults = const [];
        _searching = false;
      });
    }
  }

  void _onUserSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _searchUsers(value);
    });
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) return;

    final user = _selectedUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.adminNotificationSelectUserRequired)),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final result = await _notificationService.createNotification(
        AdminCreateNotificationInput(
          userId: user.id,
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          kind: _kindController.text.trim().isEmpty
              ? null
              : _kindController.text.trim(),
          sendEmail: _sendEmail,
          sendPush: _sendPush,
        ),
      );

      if (!mounted) return;
      _showResultSnackBar(l10n, result);
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(formatAdminError(l10n, e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showResultSnackBar(
    AppLocalizations l10n,
    AdminCreateNotificationResult result,
  ) {
    final buffer = StringBuffer(l10n.adminNotificationCreateSuccess);

    if (_sendPush) {
      if (result.pushSent) {
        buffer.write(
          '\n${l10n.adminNotificationPushSent(result.devicesNotified)}',
        );
      } else if (result.pushError != null && result.pushError!.isNotEmpty) {
        buffer.write('\n${l10n.adminNotificationPushFailed(result.pushError!)}');
      }
    }

    if (_sendEmail) {
      if (result.emailSent) {
        buffer.write('\n${l10n.adminNotificationEmailSent}');
      } else if (result.emailError != null && result.emailError!.isNotEmpty) {
        buffer.write(
          '\n${l10n.adminNotificationEmailFailed(result.emailError!)}',
        );
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(buffer.toString())),
    );
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
    _searchDebounce?.cancel();
    _titleController.dispose();
    _bodyController.dispose();
    _kindController.dispose();
    _userSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final userLocked =
        widget.initialUserId != null && widget.initialUserId!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminNotificationCreateTitle)),
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
              l10n.adminNotificationCreateSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: FuvekonColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: 20),
            if (_loadingUser)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (userLocked && _selectedUser != null)
              _SelectedUserCard(user: _selectedUser!)
            else ...[
              Text(
                l10n.adminNotificationRecipientLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: FuvekonColors.darkText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _userSearchController,
                decoration: _fieldDecoration(
                  hint: l10n.adminNotificationSearchUserHint,
                ),
                onChanged: (value) {
                  if (_selectedUser != null &&
                      value.trim() != _selectedUser!.displayName) {
                    setState(() => _selectedUser = null);
                  }
                  _onUserSearchChanged(value);
                },
              ),
              if (_searching)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else if (_searchResults.isNotEmpty) ...[
                const SizedBox(height: 8),
                ..._searchResults.map(
                  (user) => _UserSearchResultTile(
                    user: user,
                    selected: _selectedUser?.id == user.id,
                    onTap: () {
                      setState(() {
                        _selectedUser = user;
                        _userSearchController.text = user.displayName;
                        _searchResults = const [];
                      });
                    },
                  ),
                ),
              ] else if (_selectedUser != null) ...[
                const SizedBox(height: 8),
                _SelectedUserCard(user: _selectedUser!),
              ],
              const SizedBox(height: 20),
            ],
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
              onChanged: _saving ? null : (value) => setState(() => _sendPush = value),
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
              onChanged:
                  _saving ? null : (value) => setState(() => _sendEmail = value),
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
                  : Text(l10n.adminNotificationSend),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedUserCard extends StatelessWidget {
  const _SelectedUserCard({required this.user});

  final AdminUserItem user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FuvekonColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.displayName,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: FuvekonColors.darkText,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _UserSearchResultTile extends StatelessWidget {
  const _UserSearchResultTile({
    required this.user,
    required this.selected,
    required this.onTap,
  });

  final AdminUserItem user;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? FuvekonColors.darkPrimary.withValues(alpha: 0.12)
          : FuvekonColors.darkSurfaceElevated,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: FuvekonColors.darkText,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: FuvekonColors.darkTextSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: FuvekonColors.darkPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
