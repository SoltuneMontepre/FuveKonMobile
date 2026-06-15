import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';

enum AdminApprovalAction { approve, deny, markPending }

class AdminApprovalTabConfig {
  const AdminApprovalTabConfig({required this.label, required this.index});

  final String label;
  final int index;
}

class AdminApprovalPage extends StatefulWidget {
  const AdminApprovalPage({
    super.key,
    required this.title,
    required this.tabs,
    required this.loadItems,
    this.showApprove = true,
    this.showDeny = true,
    this.showMarkPending = false,
    this.onApprove,
    this.onDeny,
    this.onMarkPending,
    this.approveLabel = 'Duyệt',
    this.denyLabel = 'Từ chối',
    this.markPendingLabel = 'Chờ duyệt lại',
  });

  final String title;
  final List<AdminApprovalTabConfig> tabs;
  final Future<List<AdminListItem>> Function(int tabIndex) loadItems;
  final bool showApprove;
  final bool showDeny;
  final bool showMarkPending;
  final Future<void> Function(AdminListItem item)? onApprove;
  final Future<void> Function(AdminListItem item)? onDeny;
  final Future<void> Function(AdminListItem item)? onMarkPending;
  final String approveLabel;
  final String denyLabel;
  final String markPendingLabel;

  @override
  State<AdminApprovalPage> createState() => _AdminApprovalPageState();
}

class _AdminApprovalPageState extends State<AdminApprovalPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _itemsByTab = <int, List<AdminListItem>>{};
  final _loadingByTab = <int, bool>{};
  final _errorByTab = <int, String?>{};
  String? _actionInProgress;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadTab(0);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    _loadTab(_tabController.index);
  }

  Future<void> _loadTab(int index) async {
    if (_loadingByTab[index] == true) return;
    setState(() => _loadingByTab[index] = true);
    try {
      final items = await widget.loadItems(index);
      if (!mounted) return;
      setState(() {
        _itemsByTab[index] = items;
        _errorByTab[index] = null;
        _loadingByTab[index] = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorByTab[index] = e.toString().replaceFirst('ServerException: ', '');
        _loadingByTab[index] = false;
      });
    }
  }

  Future<void> _refresh() => _loadTab(_tabController.index);

  Future<void> _runAction(
    AdminListItem item,
    AdminApprovalAction action,
  ) async {
    setState(() => _actionInProgress = item.id);
    try {
      switch (action) {
        case AdminApprovalAction.approve:
          await widget.onApprove?.call(item);
        case AdminApprovalAction.deny:
          await widget.onDeny?.call(item);
        case AdminApprovalAction.markPending:
          await widget.onMarkPending?.call(item);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công.')),
      );
      Navigator.of(context).maybePop();
      await _refresh();
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

  void _showDetail(AdminListItem item) {
    final tabIndex = _tabController.index;
    final showApprove = widget.showApprove && widget.onApprove != null;
    final showDeny = widget.showDeny && widget.onDeny != null;
    final showMarkPending =
        widget.showMarkPending && widget.onMarkPending != null;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: FuvekonColors.darkText,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
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
                  if (showApprove || showDeny || showMarkPending) ...[
                    const SizedBox(height: 8),
                    if (showApprove && tabIndex == 0)
                      _ActionButton(
                        label: widget.approveLabel,
                        color: FuvekonColors.available,
                        loading: _actionInProgress == item.id,
                        onPressed: () =>
                            _runAction(item, AdminApprovalAction.approve),
                      ),
                    if (showDeny && tabIndex == 0)
                      _ActionButton(
                        label: widget.denyLabel,
                        color: const Color(0xFFF0A0A8),
                        loading: _actionInProgress == item.id,
                        onPressed: () =>
                            _runAction(item, AdminApprovalAction.deny),
                      ),
                    if (showMarkPending && tabIndex != 0)
                      _ActionButton(
                        label: widget.markPendingLabel,
                        color: const Color(0xFFFBBF24),
                        loading: _actionInProgress == item.id,
                        onPressed: () => _runAction(
                          item,
                          AdminApprovalAction.markPending,
                        ),
                      ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: [for (final tab in widget.tabs) Tab(text: tab.label)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          for (final tab in widget.tabs) _buildTabBody(tab.index),
        ],
      ),
    );
  }

  Widget _buildTabBody(int index) {
    final loading = _loadingByTab[index] ?? (index == 0);
    final error = _errorByTab[index];
    final items = _itemsByTab[index] ?? const <AdminListItem>[];

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
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
                onPressed: () => _loadTab(index),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return EmptyState(
        title: 'Không có mục nào',
        subtitle: 'Danh sách ${widget.tabs[index].label.toLowerCase()} trống.',
        icon: Icons.inbox_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(FuvekonSpacing.page),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final item = items[i];
          return _SubmissionTile(
            item: item,
            onTap: () => _showDetail(item),
          );
        },
      ),
    );
  }
}

class _SubmissionTile extends StatelessWidget {
  const _SubmissionTile({required this.item, required this.onTap});

  final AdminListItem item;
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
            : null,
        title: Text(
          item.title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: FuvekonColors.darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: item.subtitle != null
            ? Text(
                item.subtitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
              )
            : null,
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
