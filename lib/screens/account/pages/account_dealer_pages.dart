import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_event.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_state.dart';
import 'package:fuvekonmobile/screens/account/services/account_dealer_service.dart';
import 'package:fuvekonmobile/screens/account/widgets/dealer_registration_form_fields.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image_upload_field.dart';
import 'package:go_router/go_router.dart';

/// Màn 43–45 — dealer booth overview.
class AccountDealerPage extends StatefulWidget {
  const AccountDealerPage({super.key});

  @override
  State<AccountDealerPage> createState() => _AccountDealerPageState();
}

class _AccountDealerPageState extends State<AccountDealerPage> {
  final _service = sl<AccountDealerService>();
  late Future<DealerBoothInfo?> _future = _service.getMyDealer(useMockFallback: false);

  Future<void> _refresh() async {
    setState(() => _future = _service.getMyDealer(useMockFallback: false));
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(const ProfileEvent.started()),
      child: AppPageScaffold(
        title: 'Gian hàng dealer',
        padding: EdgeInsets.zero,
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            final userId = switch (profileState) {
              ProfileLoaded(:final account) => account.id,
              _ => '',
            };

            return FutureBuilder<DealerBoothInfo?>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(FuvekonSpacing.page),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${snapshot.error}'),
                        const SizedBox(height: 16),
                        FuvePillButton(
                          label: 'Thử lại',
                          expanded: false,
                          onPressed: _refresh,
                        ),
                      ],
                    ),
                  );
                }

                final booth = snapshot.data;
                if (booth == null) {
                  return Padding(
                    padding: const EdgeInsets.all(FuvekonSpacing.page),
                    child: Column(
                      children: [
                        const EmptyState(
                          title: 'Chưa có gian hàng',
                          subtitle:
                              'Đăng ký gian hàng hoặc tham gia bằng mã booth.',
                          icon: Icons.storefront_outlined,
                        ),
                        const SizedBox(height: FuvekonSpacing.stackGapLg),
                        FuvePillButton(
                          label: 'Đăng ký gian hàng',
                          icon: Icons.app_registration_outlined,
                          onPressed: () =>
                              context.push(Routes.accountDealerRegister),
                        ),
                        const SizedBox(height: FuvekonSpacing.stackGapMd),
                        FuvePillButton(
                          label: 'Tham gia bằng mã booth',
                          variant: FuvePillButtonVariant.outline,
                          icon: Icons.qr_code_2_outlined,
                          onPressed: () => _showJoinDialog(context),
                        ),
                      ],
                    ),
                  );
                }

                final isOwner = userId.isNotEmpty && booth.isOwner(userId);

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView(
                    padding: const EdgeInsets.all(FuvekonSpacing.page),
                    children: [
                      FuveMintCard(
                        showGoldAccent: booth.isVerified,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    booth.boothName,
                                    style: TextStyle(
                                      color: context.fuvekonTheme.contentOnCard,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                FuveStatusBadge(
                                  label: booth.isVerified
                                      ? 'Đã duyệt'
                                      : 'Chờ duyệt',
                                  variant: booth.isVerified
                                      ? FuveStatusBadgeVariant.success
                                      : FuveStatusBadgeVariant.pending,
                                ),
                              ],
                            ),
                            if (booth.boothNumber.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _BoothNumberBadge(number: booth.boothNumber),
                            ],
                            if (booth.description.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                booth.description,
                                style: TextStyle(
                                  color: context.fuvekonTheme.contentOnCardMuted,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (booth.priceSheets.isNotEmpty) ...[
                        const SizedBox(height: FuvekonSpacing.stackGapLg),
                        FuveSectionHeader(
                          title: booth.priceSheets.length == 1
                              ? 'Bảng giá'
                              : 'Bảng giá (${booth.priceSheets.length})',
                          actionLabel: isOwner ? 'Chỉnh sửa' : null,
                          onActionTap: isOwner
                              ? () => _showEditPriceSheets(context, booth)
                              : null,
                        ),
                        const SizedBox(height: FuvekonSpacing.stackGapMd),
                        ...booth.priceSheets.map(
                          (url) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: FuvekonSpacing.stackGapMd,
                            ),
                            child: S3Image(
                              imageUrl: url,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => showS3ImagePreview(context, url),
                            ),
                          ),
                        ),
                      ] else if (isOwner) ...[
                        const SizedBox(height: FuvekonSpacing.stackGapLg),
                        FuveSectionHeader(title: 'Bảng giá'),
                        const SizedBox(height: FuvekonSpacing.stackGapMd),
                        FuveMintCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Chưa có ảnh bảng giá.',
                                style: TextStyle(
                                  color: context.fuvekonTheme.contentOnCardMuted,
                                ),
                              ),
                              const SizedBox(height: 12),
                              FuvePillButton(
                                label: 'Thêm bảng giá',
                                variant: FuvePillButtonVariant.outline,
                                expanded: false,
                                onPressed: () =>
                                    _showEditPriceSheets(context, booth),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: FuvekonSpacing.stackGapLg),
                      const FuveSectionHeader(title: 'Quản lý'),
                      const SizedBox(height: FuvekonSpacing.stackGapMd),
                      FuveMintCard(
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.people_outline,
                                color: context.fuvekonTheme.contentOnCard,
                              ),
                              title: Text(
                                'Nhân viên gian hàng',
                                style: TextStyle(
                                  color: context.fuvekonTheme.contentOnCard,
                                ),
                              ),
                              subtitle: Text(
                                '${booth.staff.length} thành viên',
                                style: TextStyle(
                                  color: context.fuvekonTheme.contentOnCardMuted,
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => context.push(
                                Routes.accountDealerStaff,
                                extra: booth,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showEditPriceSheets(
    BuildContext context,
    DealerBoothInfo booth,
  ) async {
    var sheets = List<String>.from(booth.priceSheets);
    var saving = false;

    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: FuvekonSpacing.page,
                right: FuvekonSpacing.page,
                top: FuvekonSpacing.page,
                bottom: MediaQuery.viewInsetsOf(context).bottom +
                    FuvekonSpacing.page,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Cập nhật bảng giá',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    S3MultiImageUploadField(
                      imageUrls: sheets,
                      onChanged: (value) =>
                          setSheetState(() => sheets = List.of(value)),
                      enabled: !saving,
                    ),
                    const SizedBox(height: 16),
                    FuvePillButton(
                      label: saving ? 'Đang lưu...' : 'Lưu bảng giá',
                      onPressed: saving
                          ? null
                          : () async {
                              final error = validateDealerPriceSheets(sheets);
                              if (error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error)),
                                );
                                return;
                              }

                              setSheetState(() => saving = true);
                              try {
                                await _service.editDealer(
                                  boothId: booth.id,
                                  priceSheets: sheets,
                                );
                                if (context.mounted) {
                                  Navigator.pop(context, true);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('$e')),
                                  );
                                }
                              } finally {
                                if (context.mounted) {
                                  setSheetState(() => saving = false);
                                }
                              }
                            },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (updated == true) await _refresh();
  }

  Future<void> _showJoinDialog(BuildContext context) async {
    final joined = await showDialog<bool>(
      context: context,
      builder: (context) => _JoinDealerDialog(
        onJoin: (boothCode) => _service.joinDealer(boothCode: boothCode),
      ),
    );
    if (joined == true) await _refresh();
  }
}

class _JoinDealerDialog extends StatefulWidget {
  const _JoinDealerDialog({required this.onJoin});

  final Future<void> Function(String boothCode) onJoin;

  @override
  State<_JoinDealerDialog> createState() => _JoinDealerDialogState();
}

class _JoinDealerDialogState extends State<_JoinDealerDialog> {
  final _controller = TextEditingController();
  var _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await widget.onJoin(_controller.text.trim());
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tham gia gian hàng'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Mã booth (6 ký tự)',
          hintText: 'ABC123',
        ),
        textCapitalization: TextCapitalization.characters,
        maxLength: 6,
        enabled: !_submitting,
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: Text(_submitting ? 'Đang tham gia...' : 'Tham gia'),
        ),
      ],
    );
  }
}

class _BoothNumberBadge extends StatelessWidget {
  const _BoothNumberBadge({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: FuvekonColors.premiumPrimary.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.storefront,
            size: 16,
            color: context.fuvekonTheme.contentOnCard,
          ),
          const SizedBox(width: 6),
          Text(
            'Mã gian: $number',
            style: TextStyle(
              color: context.fuvekonTheme.contentOnCard,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Màn 53–54 — dealer staff management.
class AccountDealerStaffPage extends StatefulWidget {
  const AccountDealerStaffPage({super.key, required this.booth});

  final DealerBoothInfo booth;

  @override
  State<AccountDealerStaffPage> createState() => _AccountDealerStaffPageState();
}

class _AccountDealerStaffPageState extends State<AccountDealerStaffPage> {
  final _service = sl<AccountDealerService>();
  late final List<DealerStaffMember> _staff = List.of(widget.booth.staff);

  Future<void> _removeStaff(DealerStaffMember member) async {
    if (member.isOwner) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa nhân viên?'),
        content: Text('Gỡ ${member.userName} khỏi gian hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _service.removeStaff(userId: member.userId);
      setState(() => _staff.removeWhere((s) => s.id == member.id));
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã xóa nhân viên')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;

    return AppPageScaffold(
      title: 'Nhân viên gian hàng',
      padding: EdgeInsets.zero,
      body: ListView(
        padding: const EdgeInsets.all(FuvekonSpacing.page),
        children: [
          FuveMintCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.booth.boothName,
                  style: TextStyle(
                    color: ext.contentOnCard,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (widget.booth.boothNumber.isNotEmpty)
                  Text(
                    'Mã gian: ${widget.booth.boothNumber}',
                    style: TextStyle(color: ext.contentOnCardMuted),
                  ),
              ],
            ),
          ),
          const SizedBox(height: FuvekonSpacing.stackGapLg),
          const FuveSectionHeader(title: 'Danh sách nhân viên'),
          const SizedBox(height: FuvekonSpacing.stackGapMd),
          ..._staff.map(
            (member) => Padding(
              padding: const EdgeInsets.only(bottom: FuvekonSpacing.stackGapMd),
              child: FuveMintCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: FuvekonColors.premiumPrimary.withValues(
                        alpha: 0.25,
                      ),
                      child: Text(
                        member.userName.isNotEmpty
                            ? member.userName[0].toUpperCase()
                            : '?',
                        style: TextStyle(color: ext.contentOnCard),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.userName,
                            style: TextStyle(
                              color: ext.contentOnCard,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            member.userEmail,
                            style: TextStyle(
                              color: ext.contentOnCardMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (member.isOwner)
                      const FuveStatusBadge(
                        label: 'Owner',
                        variant: FuveStatusBadgeVariant.success,
                      )
                    else
                      IconButton(
                        icon: Icon(
                          Icons.person_remove_outlined,
                          color: ext.contentOnCardMuted,
                        ),
                        onPressed: () => _removeStaff(member),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Màn 44 — dealer registration form.
class AccountDealerRegisterPage extends StatefulWidget {
  const AccountDealerRegisterPage({super.key});

  @override
  State<AccountDealerRegisterPage> createState() =>
      _AccountDealerRegisterPageState();
}

class _AccountDealerRegisterPageState extends State<AccountDealerRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _service = sl<AccountDealerService>();
  final _priceSheetUrls = <String>[];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final priceSheetError = validateDealerPriceSheets(_priceSheetUrls);
    if (priceSheetError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(priceSheetError)),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await _service.registerDealer(
        boothName: _nameController.text.trim(),
        description: _descController.text.trim(),
        priceSheets: List.of(_priceSheetUrls),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã gửi đăng ký gian hàng')));
      context.go(Routes.accountDealer);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollPage(
      title: 'Đăng ký gian hàng',
      footer: FuvePillButton(
        label: _isSubmitting ? 'Đang gửi...' : 'Gửi đăng ký',
        icon: Icons.send_outlined,
        onPressed: _isSubmitting ? null : _submit,
      ),
      child: Form(
        key: _formKey,
        child: DealerRegistrationFormFields(
          nameController: _nameController,
          descController: _descController,
          priceSheetUrls: _priceSheetUrls,
          onPriceSheetsChanged: (urls) => setState(() {
            _priceSheetUrls
              ..clear()
              ..addAll(urls);
          }),
          enabled: !_isSubmitting,
        ),
      ),
    );
  }
}
