import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/pages/admin_tier_edit_page.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_ticket_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_user_service.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/s3_avatar.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_tier_management_widgets.dart';
import 'package:intl/intl.dart';

class AdminTicketsPage extends StatefulWidget {
  const AdminTicketsPage({super.key});

  @override
  State<AdminTicketsPage> createState() => _AdminTicketsPageState();
}

class _AdminTicketsPageState extends State<AdminTicketsPage>
    with TickerProviderStateMixin {
  late final TabController _mainTabController;
  late final TabController _ticketTabController;
  late final AdminTicketService _service;
  late final TextEditingController _searchController;

  Timer? _searchDebounce;
  String? _actionInProgress;

  final _itemsByTab = <int, List<AdminTicketItem>>{};
  final _metaByTab = <int, PaginationMeta>{};
  final _loadingByTab = <int, bool>{};
  final _loadingMoreByTab = <int, bool>{};
  final _errorByTab = <int, String?>{};
  final _searchByTab = <int, String>{};
  bool _pendingOver24Only = false;

  List<AdminTicketTierItem> _tiers = const [];
  AdminTicketOverviewStats _tierStats = AdminTicketOverviewStats.empty;
  AdminTierFilter _tierFilter = AdminTierFilter.all;
  bool _tiersLoading = true;
  String? _tiersError;

  static const _ticketTabs = AdminTicketTab.values;

  @override
  void initState() {
    super.initState();
    _service = sl<AdminTicketService>();
    _searchController = TextEditingController();
    _mainTabController = TabController(length: 2, vsync: this);
    _ticketTabController = TabController(length: _ticketTabs.length, vsync: this);
    _ticketTabController.addListener(_onTicketTabChanged);
    _mainTabController.addListener(_onMainTabChanged);
    _loadTiers();
    _loadTicketTab(0, refresh: true);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _mainTabController
      ..removeListener(_onMainTabChanged)
      ..dispose();
    _ticketTabController
      ..removeListener(_onTicketTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onMainTabChanged() {
    if (_mainTabController.indexIsChanging) return;
    setState(() {});
    if (_mainTabController.index == 1 && _itemsByTab[0] == null) {
      _loadTicketTab(0, refresh: true);
    }
  }

  void _onTicketTabChanged() {
    if (_ticketTabController.indexIsChanging) return;
    final index = _ticketTabController.index;
    _searchController.text = _searchByTab[index] ?? '';
    setState(() {});
    if (_itemsByTab[index] == null) {
      _loadTicketTab(index, refresh: true);
    }
  }

  Future<void> _loadTicketTab(int index, {required bool refresh}) async {
    if (_loadingByTab[index] == true || _loadingMoreByTab[index] == true) {
      return;
    }

    final currentPage =
        refresh ? 1 : (_metaByTab[index]?.currentPage ?? 0) + 1;
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
      final result = await _service.getTickets(
        tab: _ticketTabs[index],
        page: currentPage,
        search: search?.isNotEmpty == true ? search : null,
        pendingOver24:
            index == AdminTicketTab.pendingReview.index && _pendingOver24Only,
      );

      if (!mounted) return;
      setState(() {
        final existing =
            refresh ? <AdminTicketItem>[] : _itemsByTab[index] ?? [];
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

  Future<void> _loadTiers() async {
    setState(() {
      _tiersLoading = true;
      _tiersError = null;
    });

    try {
      final results = await Future.wait([
        _service.getTiers(),
        _service.getStatistics(),
      ]);
      if (!mounted) return;
      setState(() {
        _tiers = results[0] as List<AdminTicketTierItem>;
        _tierStats = results[1] as AdminTicketOverviewStats;
        _tiersLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _tiersError = e.toString().replaceFirst('ServerException: ', '');
        _tiersLoading = false;
      });
    }
  }

  List<AdminTicketTierItem> get _filteredTiers =>
      _tiers.where((tier) => _tierFilter.matches(tier)).toList();

  void _onSearchChanged(String value) {
    final index = _ticketTabController.index;
    _searchByTab[index] = value;
    setState(() {});
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _loadTicketTab(index, refresh: true);
    });
  }

  Future<void> _refreshTickets() =>
      _loadTicketTab(_ticketTabController.index, refresh: true);

  Future<String?> _promptDenyReason() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lý do từ chối'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Nhập lý do từ chối vé...',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Từ chối'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _runTicketAction(
    AdminTicketItem item, {
    required Future<void> Function() action,
    required String successMessage,
  }) async {
    setState(() => _actionInProgress = item.id);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
      Navigator.of(context).maybePop();
      await _refreshTickets();
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

  Future<void> _runTierAction(
    Future<void> Function() action, {
    bool closeSheet = true,
  }) async {
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật hạng vé thành công.')),
      );
      if (closeSheet) Navigator.of(context).maybePop();
      await _loadTiers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('ServerException: ', 'Lỗi: '),
          ),
        ),
      );
    }
  }

  Future<void> _openTierEditor({AdminTicketTierItem? tier}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AdminTierEditPage(tier: tier),
      ),
    );
    if (saved == true) {
      await _loadTiers();
    }
  }

  Future<void> _confirmDeleteTier(AdminTicketTierItem tier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa hạng vé?'),
          content: Text(
            'Xóa "${tier.ticketName}" sẽ xóa vĩnh viễn hạng vé này '
            'và tất cả vé đã bán thuộc hạng. Hành động không thể hoàn tác.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF0A0A8),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;
    await _runTierAction(() => _service.deleteTier(tier.id));
  }

  void _showTicketDetail(AdminTicketItem item) {
    final loading = _actionInProgress == item.id;

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
          initialChildSize: 0.6,
          minChildSize: 0.35,
          maxChildSize: 0.92,
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
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
                  if (item.canApprove) ...[
                    _ActionButton(
                      label: 'Duyệt vé',
                      color: FuvekonColors.available,
                      loading: loading,
                      onPressed: () => _runTicketAction(
                        item,
                        action: () => _service.approveTicket(item.id),
                        successMessage: 'Đã duyệt vé.',
                      ),
                    ),
                  ],
                  if (item.canDeny) ...[
                    _ActionButton(
                      label: 'Từ chối vé',
                      color: const Color(0xFFF0A0A8),
                      loading: loading,
                      onPressed: () async {
                        final reason = await _promptDenyReason();
                        if (!context.mounted || reason == null) return;
                        await _runTicketAction(
                          item,
                          action: () =>
                              _service.denyTicket(item.id, reason: reason),
                          successMessage: 'Đã từ chối vé.',
                        );
                      },
                    ),
                  ],
                  if (item.canResendQr) ...[
                    _ActionButton(
                      label: 'Gửi lại email QR',
                      color: const Color(0xFF60A5FA),
                      loading: loading,
                      onPressed: () => _runTicketAction(
                        item,
                        action: () => _service.resendQrEmail(item.id),
                        successMessage: 'Đã gửi lại email QR.',
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

  void _showTierDetail(AdminTicketTierItem tier) {
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

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
                    tier.ticketName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: FuvekonColors.darkText,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${tier.tierCode} • ${currency.format(tier.price)}'
                    '${tier.priceUsd != null ? ' • \$${tier.priceUsd!.toStringAsFixed(2)}' : ''}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: FuvekonColors.darkTextSecondary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        if (tier.description.isNotEmpty)
                          _TierDetailRow(
                            label: 'Mô tả',
                            value: tier.description,
                          ),
                        if (tier.stock != null)
                          _TierDetailRow(
                            label: 'Tồn kho',
                            value:
                                '${tier.stock}${tier.isSoldOut ? ' (hết vé)' : ''}',
                          ),
                        _TierDetailRow(
                          label: 'Trạng thái',
                          value: [
                            if (tier.isActive) 'Đang bán' else 'Tắt bán',
                            if (tier.isVisible) 'Hiện cửa hàng' else 'Ẩn',
                          ].join(' • '),
                        ),
                        if (tier.benefits.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Quyền lợi',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: FuvekonColors.darkTextSecondary,
                                ),
                          ),
                          const SizedBox(height: 6),
                          for (final benefit in tier.benefits)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(
                                        color: FuvekonColors.darkText,
                                      )),
                                  Expanded(
                                    child: Text(
                                      benefit,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: FuvekonColors.darkText,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                  _ActionButton(
                    label: 'Chỉnh sửa',
                    color: FuvekonColors.primary,
                    onPressed: () {
                      Navigator.pop(context);
                      _openTierEditor(tier: tier);
                    },
                  ),
                  _ActionButton(
                    label: tier.isActive ? 'Tắt bán' : 'Bật bán',
                    color: tier.isActive
                        ? const Color(0xFFF0A0A8)
                        : FuvekonColors.available,
                    onPressed: () => _runTierAction(
                      () => tier.isActive
                          ? _service.deactivateTier(tier.id)
                          : _service.activateTier(tier.id),
                    ),
                  ),
                  _ActionButton(
                    label: tier.isVisible
                        ? 'Ẩn khỏi cửa hàng'
                        : 'Hiện trên cửa hàng',
                    color: const Color(0xFF60A5FA),
                    onPressed: () => _runTierAction(
                      () => _service.setTierVisibility(
                        tier.id,
                        visible: !tier.isVisible,
                      ),
                    ),
                  ),
                  _ActionButton(
                    label: 'Xóa hạng vé',
                    color: const Color(0xFFDC2626),
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDeleteTier(tier);
                    },
                  ),
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
        title: const Text('Quản lý vé'),
        bottom: TabBar(
          controller: _mainTabController,
          tabs: const [
            Tab(text: 'Hạng vé'),
            Tab(text: 'Danh sách vé'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _mainTabController,
        children: [
          _buildTiersSection(),
          _buildTicketsSection(),
        ],
      ),
      floatingActionButton: _mainTabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _openTierEditor(),
              backgroundColor: FuvekonColors.darkCard,
              foregroundColor: FuvekonColors.darkCardText,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Hạng vé mới'),
            )
          : null,
    );
  }

  Widget _buildTicketsSection() {
    return Column(
      children: [
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
              hintText: 'Tìm mã vé, email, tên...',
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
        TabBar(
          controller: _ticketTabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Chờ duyệt'),
            Tab(text: 'Đã duyệt'),
            Tab(text: 'Từ chối'),
          ],
        ),
        if (_ticketTabController.index == AdminTicketTab.pendingReview.index)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FuvekonSpacing.page,
              vertical: 8,
            ),
            child: FilterChip(
              label: const Text('Chờ > 24 giờ'),
              selected: _pendingOver24Only,
              onSelected: (selected) {
                setState(() => _pendingOver24Only = selected);
                _loadTicketTab(
                  AdminTicketTab.pendingReview.index,
                  refresh: true,
                );
              },
            ),
          ),
        Expanded(
          child: TabBarView(
            controller: _ticketTabController,
            children: [
              for (var i = 0; i < _ticketTabs.length; i++) _buildTicketTab(i),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketTab(int index) {
    final loading = _loadingByTab[index] ?? (index == 0);
    final loadingMore = _loadingMoreByTab[index] ?? false;
    final error = _errorByTab[index];
    final items = _itemsByTab[index] ?? const <AdminTicketItem>[];
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
                onPressed: () => _loadTicketTab(index, refresh: true),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return EmptyState(
        title: 'Không có vé',
        subtitle: 'Không tìm thấy vé phù hợp với bộ lọc.',
        icon: Icons.confirmation_number_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshTickets,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 200 &&
              !loadingMore &&
              (meta?.hasMore ?? false)) {
            _loadTicketTab(index, refresh: false);
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

            final ticket = items[i];
            return _TicketTile(
              ticket: ticket,
              onTap: () => _showTicketDetail(ticket),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTiersSection() {
    if (_tiersLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_tiersError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(FuvekonSpacing.page),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _tiersError!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loadTiers,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_tiers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(FuvekonSpacing.page),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const EmptyState(
                title: 'Chưa có hạng vé',
                subtitle: 'Tạo hạng vé đầu tiên để bắt đầu bán.',
                icon: Icons.layers_outlined,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _openTierEditor(),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Tạo hạng vé'),
              ),
            ],
          ),
        ),
      );
    }

    final filtered = _filteredTiers;

    return RefreshIndicator(
      onRefresh: _loadTiers,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          FuvekonSpacing.page,
          8,
          FuvekonSpacing.page,
          96,
        ),
        children: [
          AdminTierStatGrid(stats: _tierStats),
          const SizedBox(height: 20),
          AdminTierFilterChips(
            selected: _tierFilter,
            onSelected: (filter) => setState(() => _tierFilter = filter),
          ),
          const SizedBox(height: 20),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: EmptyState(
                title: 'Không có hạng vé',
                subtitle: 'Không có hạng vé nào trong bộ lọc "${_tierFilter.label}".',
                icon: Icons.filter_list_off_rounded,
              ),
            )
          else
            for (var i = 0; i < filtered.length; i++) ...[
              if (i > 0) const SizedBox(height: 14),
              AdminTierCard(
                tier: filtered[i],
                stockStat: _tierStats.statFor(filtered[i].id),
                variantIndex: i,
                onTap: () => _showTierDetail(filtered[i]),
              ),
            ],
        ],
      ),
    );
  }
}

class _TicketTile extends StatelessWidget {
  const _TicketTile({required this.ticket, required this.onTap});

  final AdminTicketItem ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = ticket.holderName.isNotEmpty
        ? ticket.holderName[0].toUpperCase()
        : '?';

    return Material(
      color: FuvekonColors.darkSurfaceElevated,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: S3Avatar(
          imageUrl: ticket.userAvatar,
          initials: initials,
          radius: 24,
        ),
        title: Text(
          ticket.title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: FuvekonColors.darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          ticket.subtitle ?? ticket.referenceCode,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: FuvekonColors.darkTextSecondary,
          ),
        ),
        trailing: _StatusChip(status: ticket.status, compact: true),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, this.compact = false});

  final TicketStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = ticketStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        ticketStatusLabelVi(status),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _TierDetailRow extends StatelessWidget {
  const _TierDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: FuvekonColors.darkText,
                ),
          ),
        ],
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
