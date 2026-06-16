import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_lost_found_service.dart';
import 'package:fuvekonmobile/screens/info/lost_found_models.dart';
import 'package:fuvekonmobile/screens/admin/widgets/staff_tab_scaffold.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image_upload_field.dart';
import 'package:go_router/go_router.dart';

class AdminLostFoundPage extends StatefulWidget {
  const AdminLostFoundPage({super.key});

  @override
  State<AdminLostFoundPage> createState() => _AdminLostFoundPageState();
}

class _AdminLostFoundPageState extends State<AdminLostFoundPage> {
  late final AdminLostFoundService _service;
  late final TextEditingController _searchController;
  Timer? _searchDebounce;

  final _items = <AdminLostFoundItem>[];
  LostFoundPageMeta? _meta;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  String _statusFilter = '';
  String _typeFilter = '';
  String _search = '';
  String? _actionInProgress;

  @override
  void initState() {
    super.initState();
    _service = sl<AdminLostFoundService>();
    _searchController = TextEditingController();
    _load(refresh: true);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({required bool refresh}) async {
    if (_loading && !refresh) return;
    if (_loadingMore) return;

    final nextPage = refresh ? 1 : (_meta?.page ?? 0) + 1;
    if (!refresh && !(_meta?.hasMore ?? false)) return;

    setState(() {
      if (refresh) {
        _loading = true;
      } else {
        _loadingMore = true;
      }
    });

    try {
      final result = await _service.list(
        itemType: _typeFilter.isEmpty ? null : _typeFilter,
        status: _statusFilter.isEmpty ? null : _statusFilter,
        search: _search.isEmpty ? null : _search,
        page: nextPage,
      );

      if (!mounted) return;
      setState(() {
        if (refresh) {
          _items
            ..clear()
            ..addAll(result.items);
        } else {
          _items.addAll(result.items);
        }
        _meta = result.meta;
        _error = null;
        _loading = false;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('ServerException: ', '');
        _loading = false;
        _loadingMore = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    _search = value;
    setState(() {});
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _load(refresh: true);
    });
  }

  void _setStatusFilter(String status) {
    if (_statusFilter == status) return;
    setState(() => _statusFilter = status);
    _load(refresh: true);
  }

  void _setTypeFilter(String type) {
    if (_typeFilter == type) return;
    setState(() => _typeFilter = type);
    _load(refresh: true);
  }

  Future<void> _runAction(Future<void> Function() action) async {
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công.')),
      );
      Navigator.of(context).maybePop();
      await _load(refresh: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('ServerException: ', 'Lỗi: '),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _actionInProgress = null);
    }
  }

  void _openForm({AdminLostFoundItem? item}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _LostFoundFormSheet(
        item: item,
        onSubmit: (input) async {
          if (item == null) {
            await _service.create(input);
          } else {
            await _service.update(
              item.id,
              UpdateLostFoundInput(
                itemType: input.itemType,
                title: input.title,
                description: input.description,
                location: input.location,
                imageUrl: input.imageUrl,
                contactInfo: input.contactInfo,
                staffNotes: input.staffNotes,
              ),
            );
          }
        },
      ),
    ).then((_) {
      if (mounted) _load(refresh: true);
    });
  }

  void _showDetail(AdminLostFoundItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _LostFoundDetailSheet(
          itemId: item.id,
          service: _service,
          actionInProgress: _actionInProgress,
          onActionStarted: (id) => setState(() => _actionInProgress = id),
          onActionFinished: () => setState(() => _actionInProgress = null),
          onRunAction: _runAction,
          onOpenReturn: (id) async {
            Navigator.of(context).pop();
            final confirmed = await context.push<bool>(
              Routes.adminLostFoundReturn(id),
            );
            if (confirmed == true && mounted) {
              await _load(refresh: true);
            }
          },
          onEdit: (detailItem) {
            Navigator.of(context).pop();
            _openForm(item: detailItem);
          },
        );
      },
    ).then((_) {
      if (mounted) _load(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StaffTabScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              FuvekonSpacing.page,
              12,
              FuvekonSpacing.page,
              0,
            ),
            child: Text(
              'Quản lý thất lạc',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: FuvekonColors.darkAppBarTitle,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              FuvekonSpacing.page,
              12,
              FuvekonSpacing.page,
              4,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Tìm tiêu đề, mô tả, vị trí...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      )
                    : null,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: FuvekonSpacing.page,
              vertical: 4,
            ),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Tất cả',
                  selected: _statusFilter.isEmpty,
                  onTap: () => _setStatusFilter(''),
                ),
                _FilterChip(
                  label: 'Đang mở',
                  selected: _statusFilter == 'open',
                  onTap: () => _setStatusFilter('open'),
                ),
                _FilterChip(
                  label: 'Đã nhận',
                  selected: _statusFilter == 'claimed',
                  onTap: () => _setStatusFilter('claimed'),
                ),
                _FilterChip(
                  label: 'Đã xử lý',
                  selected: _statusFilter == 'resolved',
                  onTap: () => _setStatusFilter('resolved'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Thất lạc',
                  selected: _typeFilter == 'lost',
                  onTap: () => _setTypeFilter(
                    _typeFilter == 'lost' ? '' : 'lost',
                  ),
                ),
                _FilterChip(
                  label: 'Nhặt được',
                  selected: _typeFilter == 'found',
                  onTap: () => _setTypeFilter(
                    _typeFilter == 'found' ? '' : 'found',
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(FuvekonSpacing.page),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _load(refresh: true),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return Stack(
        children: [
          const EmptyState(
            title: 'Chưa có mục thất lạc',
            subtitle: 'Nhấn + để thêm vật thất lạc hoặc nhặt được.',
            icon: Icons.inventory_2_outlined,
          ),
          _buildFab(),
        ],
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => _load(refresh: true),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 200 &&
                  !_loadingMore &&
                  (_meta?.hasMore ?? false)) {
                _load(refresh: false);
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                FuvekonSpacing.page,
                8,
                FuvekonSpacing.page,
                88,
              ),
              itemCount: _items.length + (_loadingMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index >= _items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = _items[index];
                return _LostFoundTile(
                  item: item,
                  onTap: () => _showDetail(item),
                );
              },
            ),
          ),
        ),
        _buildFab(),
      ],
    );
  }

  Widget _buildFab() {
    return Positioned(
      right: FuvekonSpacing.page,
      bottom: FuvekonSpacing.page,
      child: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: FuvekonColors.darkPrimary,
        foregroundColor: FuvekonColors.darkButtonText,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _LostFoundDetailSheet extends StatefulWidget {
  const _LostFoundDetailSheet({
    required this.itemId,
    required this.service,
    required this.actionInProgress,
    required this.onActionStarted,
    required this.onActionFinished,
    required this.onRunAction,
    required this.onOpenReturn,
    required this.onEdit,
  });

  final String itemId;
  final AdminLostFoundService service;
  final String? actionInProgress;
  final ValueChanged<String> onActionStarted;
  final VoidCallback onActionFinished;
  final Future<void> Function(Future<void> Function() action) onRunAction;
  final ValueChanged<String> onOpenReturn;
  final ValueChanged<AdminLostFoundItem> onEdit;

  @override
  State<_LostFoundDetailSheet> createState() => _LostFoundDetailSheetState();
}

class _LostFoundDetailSheetState extends State<_LostFoundDetailSheet> {
  AdminLostFoundItem? _item;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final item = await widget.service.getById(widget.itemId);
      if (!mounted) return;
      setState(() {
        _item = item;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('ServerException: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        height: 240,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _item == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error ?? 'Không tải được chi tiết.'),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    }

    final item = _item!;
    final claim = item.activeClaim;
    final claimer = claim?.claimedBy;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: FuvekonColors.darkBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: FuvekonColors.darkText,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  _StatusChip(status: item.status),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    if (claim != null && claimer != null) ...[
                      Text(
                        'Người nhận (đã claim)',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: FuvekonColors.darkAppBarTitle,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: FuvekonColors.darkCard,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                claimer.displayName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: FuvekonColors.darkCardText,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'CCCD: ${AdminLostFoundClaimUser.maskSensitive(claimer.idCard)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: FuvekonColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Email: ${AdminLostFoundClaimUser.maskSensitive(claimer.email)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: FuvekonColors.textSecondary,
                                    ),
                              ),
                              if (claim.message.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  claim.message,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: FuvekonColors.darkCardText,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ] else if (item.itemType == 'found' &&
                        item.status == 'open') ...[
                      Text(
                        'Chưa có người dùng nào claim vật phẩm này.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: FuvekonColors.darkTextSecondary,
                            ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    for (final field in item.details)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              field.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: FuvekonColors.darkTextSecondary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            if (field.imageUrl != null)
                              S3Image(
                                imageUrl: field.imageUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => showS3ImagePreview(
                                  context,
                                  field.imageUrl!,
                                ),
                              )
                            else if (field.value.isNotEmpty)
                              Text(
                                field.value,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: FuvekonColors.darkText,
                                    ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (item.canConfirmReturn)
                _ActionButton(
                  label: 'Xác nhận hoàn trả',
                  color: FuvekonColors.available,
                  loading: widget.actionInProgress == item.id,
                  onPressed: () => widget.onOpenReturn(item.id),
                )
              else if (item.itemType == 'lost' && item.status != 'resolved')
                _ActionButton(
                  label: 'Đánh dấu đã xử lý',
                  color: FuvekonColors.available,
                  loading: widget.actionInProgress == item.id,
                  onPressed: () {
                    widget.onActionStarted(item.id);
                    widget.onRunAction(
                      () => widget.service.updateStatus(item.id, 'resolved'),
                    ).whenComplete(widget.onActionFinished);
                  },
                ),
              _ActionButton(
                label: 'Chỉnh sửa',
                color: FuvekonColors.darkPrimary,
                onPressed: () => widget.onEdit(item),
              ),
              _ActionButton(
                label: 'Xóa',
                color: const Color(0xFFF0A0A8),
                loading: widget.actionInProgress == item.id,
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Xóa mục thất lạc?'),
                      content: const Text(
                        'Hành động này không thể hoàn tác.',
                      ),
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
                  if (confirmed != true || !context.mounted) return;
                  widget.onActionStarted(item.id);
                  widget.onRunAction(
                    () => widget.service.delete(item.id),
                  ).whenComplete(widget.onActionFinished);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: FuvekonColors.darkPrimary.withValues(alpha: 0.25),
        checkmarkColor: FuvekonColors.darkPrimary,
        labelStyle: TextStyle(
          color: selected
              ? FuvekonColors.darkPrimary
              : FuvekonColors.darkTextSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected
              ? FuvekonColors.darkPrimary
              : FuvekonColors.darkBorder,
        ),
        backgroundColor: FuvekonColors.darkSurfaceElevated,
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = AdminLostFoundItem.statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        AdminLostFoundItem.statusLabel(status),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _LostFoundTile extends StatelessWidget {
  const _LostFoundTile({required this.item, required this.onTap});

  final AdminLostFoundItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final previewUrl = item.previewImageUrl;

    return Material(
      color: FuvekonColors.darkSurfaceElevated,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: previewUrl != null
            ? S3Image(
                imageUrl: previewUrl,
                width: 48,
                height: 48,
                borderRadius: BorderRadius.circular(8),
              )
            : CircleAvatar(
                backgroundColor:
                    AdminLostFoundItem.statusColor(item.status)
                        .withValues(alpha: 0.15),
                child: Icon(
                  item.itemType == 'lost'
                      ? Icons.search_off_rounded
                      : Icons.inventory_2_outlined,
                  color: AdminLostFoundItem.statusColor(item.status),
                  size: 22,
                ),
              ),
        title: Text(
          item.title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: FuvekonColors.darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          item.subtitle ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: FuvekonColors.darkTextSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: FuvekonColors.darkTextSecondary,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: loading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color,
            foregroundColor: FuvekonColors.darkCardText,
          ),
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(label),
        ),
      ),
    );
  }
}

class _LostFoundFormSheet extends StatefulWidget {
  const _LostFoundFormSheet({
    this.item,
    required this.onSubmit,
  });

  final AdminLostFoundItem? item;
  final Future<void> Function(CreateLostFoundInput input) onSubmit;

  @override
  State<_LostFoundFormSheet> createState() => _LostFoundFormSheetState();
}

class _LostFoundFormSheetState extends State<_LostFoundFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _contactController;
  late final TextEditingController _staffNotesController;
  late String _itemType;
  String? _imageUrl;
  bool _submitting = false;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _itemType = item?.itemType ?? 'found';
    _titleController = TextEditingController(text: item?.title ?? '');
    _descriptionController =
        TextEditingController(text: item?.description ?? '');
    _locationController = TextEditingController(text: item?.location ?? '');
    _contactController = TextEditingController(text: item?.contactInfo ?? '');
    _staffNotesController =
        TextEditingController(text: item?.staffNotes ?? '');
    _imageUrl = item?.imageUrl.isNotEmpty == true ? item!.imageUrl : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _staffNotesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(
        CreateLostFoundInput(
          itemType: _itemType,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          location: _locationController.text.trim(),
          imageUrl: _imageUrl ?? '',
          contactInfo: _contactController.text.trim(),
          staffNotes: _staffNotesController.text.trim(),
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('ServerException: ', 'Lỗi: '),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: FuvekonColors.darkBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isEditing ? 'Chỉnh sửa mục thất lạc' : 'Thêm mục thất lạc',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: FuvekonColors.darkText,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _itemType,
                decoration: const InputDecoration(labelText: 'Loại'),
                dropdownColor: FuvekonColors.darkSurfaceElevated,
                items: const [
                  DropdownMenuItem(value: 'found', child: Text('Nhặt được')),
                  DropdownMenuItem(value: 'lost', child: Text('Thất lạc')),
                ],
                onChanged: (value) {
                  if (value != null) _itemType = value;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề *'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Vị trí'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Liên hệ'),
              ),
              const SizedBox(height: 12),
              S3ImageUploadField(
                imageUrl: _imageUrl,
                folder: 'lost-found',
                enabled: !_submitting,
                onChanged: (url) => setState(() => _imageUrl = url),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _staffNotesController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú nhân viên',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEditing ? 'Lưu thay đổi' : 'Thêm mục'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
