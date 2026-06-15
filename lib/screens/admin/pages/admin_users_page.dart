import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_user_service.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/s3_avatar.dart';
import 'package:go_router/go_router.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final AdminUserService _service;
  late final TextEditingController _searchController;
  Timer? _searchDebounce;

  final _itemsByTab = <int, List<AdminUserItem>>{};
  final _metaByTab = <int, PaginationMeta>{};
  final _loadingByTab = <int, bool>{};
  final _loadingMoreByTab = <int, bool>{};
  final _errorByTab = <int, String?>{};
  final _searchByTab = <int, String>{};

  @override
  void initState() {
    super.initState();
    _service = sl<AdminUserService>();
    _searchController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadTab(0, refresh: true);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final index = _tabController.index;
    _searchController.text = _searchByTab[index] ?? '';
    setState(() {});
    if (_itemsByTab[index] == null) {
      _loadTab(index, refresh: true);
    }
  }

  Future<void> _loadTab(int index, {required bool refresh}) async {
    if (_loadingByTab[index] == true || _loadingMoreByTab[index] == true) {
      return;
    }

    final currentPage = refresh ? 1 : (_metaByTab[index]?.currentPage ?? 0) + 1;
    if (!refresh && !(_metaByTab[index]?.hasMore ?? false)) return;

    setState(() {
      if (refresh) {
        _loadingByTab[index] = true;
      } else {
        _loadingMoreByTab[index] = true;
      }
    });

    try {
      final search = _searchByTab[index];
      final result = index == 0
          ? await _service.getUsers(
              page: currentPage,
              search: search?.isNotEmpty == true ? search : null,
            )
          : await _service.getBlacklistedUsers(page: currentPage);

      if (!mounted) return;
      setState(() {
        final existing = refresh ? <AdminUserItem>[] : _itemsByTab[index] ?? [];
        _itemsByTab[index] = [...existing, ...result.items];
        _metaByTab[index] = result.meta;
        _errorByTab[index] = null;
        _loadingByTab[index] = false;
        _loadingMoreByTab[index] = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorByTab[index] =
            e.toString().replaceFirst('ServerException: ', '');
        _loadingByTab[index] = false;
        _loadingMoreByTab[index] = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    final index = _tabController.index;
    _searchByTab[index] = value;
    setState(() {});
    _searchDebounce?.cancel();
    if (index != 0) return;

    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _loadTab(0, refresh: true);
    });
  }

  Future<void> _refresh() => _loadTab(_tabController.index, refresh: true);

  void _openUser(AdminUserItem user) {
    context.push(Routes.adminUserDetail(user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Bị cấm'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_tabController.index == 0)
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
                  hintText: 'Tìm email, tên, fursona...',
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabBody(0),
                _buildTabBody(1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBody(int index) {
    final loading = _loadingByTab[index] ?? (index == 0);
    final loadingMore = _loadingMoreByTab[index] ?? false;
    final error = _errorByTab[index];
    final items = _itemsByTab[index] ?? const <AdminUserItem>[];
    final meta = _metaByTab[index];

    if (loading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(FuvekonSpacing.page),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _loadTab(index, refresh: true),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return EmptyState(
        title: 'Không có người dùng',
        subtitle: index == 0
            ? 'Không tìm thấy người dùng phù hợp.'
            : 'Chưa có ai trong danh sách cấm.',
        icon: Icons.people_outline,
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 200 &&
              !loadingMore &&
              (meta?.hasMore ?? false)) {
            _loadTab(index, refresh: false);
          }
          return false;
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(FuvekonSpacing.page),
          itemCount: items.length + (loadingMore ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            if (i >= items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final user = items[i];
            return _UserTile(user: user, onTap: () => _openUser(user));
          },
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user, required this.onTap});

  final AdminUserItem user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: S3Avatar(
          imageUrl: user.avatar,
          initials: user.initials,
          radius: 24,
        ),
        title: Text(
          user.title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: FuvekonColors.darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          user.subtitle ?? user.email,
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
