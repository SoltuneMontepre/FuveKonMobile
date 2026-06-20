import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_error_l10n.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_submission_l10n.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_lost_found_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_lost_found_form_sheet.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_list_scaffold.dart';
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
        _error = formatAdminError(context.l10n, e);
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
    final l10n = context.l10n;
    return AdminListScaffold(
      title: l10n.adminLostFoundTitle,
      embedded: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: FuvekonColors.darkPrimary,
        foregroundColor: FuvekonColors.darkButtonText,
        child: const Icon(Icons.add_rounded),
      ),
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminListSearchField(
            controller: _searchController,
            hintText: l10n.adminLostFoundSearchHint,
            onChanged: _onSearchChanged,
          ),
          AdminListFilterRow(
            children: [
              AdminListFilterChip(
                label: l10n.adminAll,
                selected: _statusFilter.isEmpty,
                onTap: () => _setStatusFilter(''),
              ),
              AdminListFilterChip(
                label: l10n.adminLostFoundStatusOpen,
                selected: _statusFilter == 'open',
                onTap: () => _setStatusFilter('open'),
              ),
              AdminListFilterChip(
                label: l10n.adminLostFoundStatusClaimed,
                selected: _statusFilter == 'claimed',
                onTap: () => _setStatusFilter('claimed'),
              ),
              AdminListFilterChip(
                label: l10n.adminLostFoundStatusResolved,
                selected: _statusFilter == 'resolved',
                onTap: () => _setStatusFilter('resolved'),
              ),
              const SizedBox(width: 8),
              AdminListFilterChip(
                label: l10n.adminLostFoundTypeLost,
                selected: _typeFilter == 'lost',
                onTap: () => _setTypeFilter(_typeFilter == 'lost' ? '' : 'lost'),
              ),
              AdminListFilterChip(
                label: l10n.adminLostFoundTypeFound,
                selected: _typeFilter == 'found',
                onTap: () =>
                    _setTypeFilter(_typeFilter == 'found' ? '' : 'found'),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    return AdminListBody(
      loading: _loading,
      error: _error,
      isEmpty: _items.isEmpty,
      onRetry: () => _load(refresh: true),
      onRefresh: () => _load(refresh: true),
      loadingMore: _loadingMore,
      hasMore: _meta?.hasMore ?? false,
      onLoadMore: () => _load(refresh: false),
      emptyState: EmptyState(
        title: l10n.adminLostFoundEmpty,
        subtitle: l10n.adminLostFoundEmptySubtitle,
        icon: Icons.inventory_2_outlined,
      ),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
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
            return const AdminListLoadMoreIndicator();
          }
          final item = _items[index];
          return _LostFoundTile(
            item: item,
            onTap: () => _openDetail(item),
          );
        },
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
    final l10n = context.l10n;
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
                    lostFoundStatusColor(item.status).withValues(alpha: 0.15),
                child: Icon(
                  item.itemType == 'lost'
                      ? Icons.search_off_rounded
                      : Icons.inventory_2_outlined,
                  color: lostFoundStatusColor(item.status),
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
          item.localizedSubtitle(l10n),
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
