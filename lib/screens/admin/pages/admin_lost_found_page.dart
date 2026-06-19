import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_lost_found_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_lost_found_form_sheet.dart';
import 'package:fuvekonmobile/screens/admin/widgets/staff_tab_scaffold.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
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

  void _openForm({AdminLostFoundItem? item}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AdminLostFoundFormSheet(
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

  Future<void> _openDetail(AdminLostFoundItem item) async {
    final changed = await context.push<bool>(
      Routes.adminLostFoundDetail(item.id),
    );
    if (changed == true && mounted) {
      await _load(refresh: true);
    }
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
                  onTap: () => _openDetail(item),
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
