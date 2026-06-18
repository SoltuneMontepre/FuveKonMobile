import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/account/widgets/user_bottom_nav_bar.dart';
import 'package:fuvekonmobile/screens/info/lost_found_models.dart';
import 'package:fuvekonmobile/screens/info/lost_found_service.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:go_router/go_router.dart';

enum _LostFoundView { home, foundList, detail, report, requests }

enum _LostFoundTab { found, lost }

class LostFoundPage extends StatefulWidget {
  const LostFoundPage({super.key});

  @override
  State<LostFoundPage> createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage> {
  late final LostFoundService _service;
  late final TextEditingController _searchController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _timeController;

  final _items = <LostFoundPublicItem>[];
  final _localReports = <_LocalLostReport>[];
  LostFoundPageMeta? _meta;
  LostFoundPublicItem? _selectedItem;
  _LostFoundView _view = _LostFoundView.home;
  _LostFoundTab _tab = _LostFoundTab.found;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  String _search = '';
  String _category = 'all';
  String _requestFilter = 'all';
  String? _claimInProgress;

  @override
  void initState() {
    super.initState();
    _service = sl<LostFoundService>();
    _searchController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _timeController = TextEditingController();
    _load(refresh: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _load({required bool refresh}) async {
    if (_loadingMore) return;
    if (_loading && !refresh) return;

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

  List<LostFoundPublicItem> get _filteredItems {
    return _items.where((item) {
      if (_category == 'all') return true;
      final text = '${item.title} ${item.description}'.toLowerCase();
      return switch (_category) {
        'electronics' =>
          text.contains('điện') ||
              text.contains('phone') ||
              text.contains('tai nghe') ||
              text.contains('headphone') ||
              text.contains('airpod'),
        'bag' =>
          text.contains('ví') ||
              text.contains('bóp') ||
              text.contains('túi') ||
              text.contains('bag') ||
              text.contains('wallet'),
        _ => true,
      };
    }).toList();
  }

  List<LostFoundPublicItem> get _claimedItems {
    return _items.where((item) => item.userHasClaimed).toList();
  }

  void _openDetail(LostFoundPublicItem item) {
    setState(() {
      _selectedItem = item;
      _view = _LostFoundView.detail;
    });
  }

  void _goHome() => setState(() => _view = _LostFoundView.home);

  Future<void> _claimItem(LostFoundPublicItem item) async {
    setState(() => _claimInProgress = item.id);
    try {
      await _service.claim(
        item.id,
        message: 'Người dùng gửi yêu cầu nhận vật phẩm từ ứng dụng.',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi yêu cầu nhận vật phẩm.')),
      );
      await _load(refresh: true);
      if (!mounted) return;
      setState(() => _view = _LostFoundView.requests);
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('ServerException: ', '');
      if (message.toLowerCase().contains('ticket')) {
        _showTicketRequiredDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) setState(() => _claimInProgress = null);
    }
  }

  void _showTicketRequiredDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cần vé hợp lệ'),
        content: const Text(
          'Bạn cần đăng nhập và có vé đã được duyệt để xem và nhận đồ thất lạc.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(Routes.login);
            },
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }

  void _submitReport() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên vật phẩm.')),
      );
      return;
    }

    setState(() {
      _localReports.insert(
        0,
        _LocalLostReport(
          title: title,
          description: _descriptionController.text.trim(),
          location: _locationController.text.trim(),
          time: _timeController.text.trim(),
        ),
      );
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _timeController.clear();
      _view = _LostFoundView.requests;
      _requestFilter = 'lost';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã lưu báo mất đồ tạm thời. Backend chưa có endpoint gửi báo mất.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      body: SafeArea(
        child: switch (_view) {
          _LostFoundView.home => _HomeView(
              tab: _tab,
              onTabChanged: (tab) => setState(() => _tab = tab),
              onOpenFound: () => setState(() => _view = _LostFoundView.foundList),
              onOpenReport: () => setState(() => _view = _LostFoundView.report),
              onOpenRequests: () =>
                  setState(() => _view = _LostFoundView.requests),
            ),
          _LostFoundView.foundList => _FoundListView(
              controller: _searchController,
              category: _category,
              loading: _loading,
              loadingMore: _loadingMore,
              error: _error,
              items: _filteredItems,
              onBack: _goHome,
              onSearch: (value) {
                _search = value;
                _load(refresh: true);
              },
              onCategoryChanged: (value) => setState(() => _category = value),
              onRefresh: () => _load(refresh: true),
              onLoadMore: () => _load(refresh: false),
              onOpenDetail: _openDetail,
            ),
          _LostFoundView.detail => _LostFoundDetailView(
              item: _selectedItem,
              claimInProgress: _claimInProgress,
              onBack: () => setState(() => _view = _LostFoundView.foundList),
              onClaim: _selectedItem == null
                  ? null
                  : () => _claimItem(_selectedItem!),
            ),
          _LostFoundView.report => _ReportLostView(
              titleController: _titleController,
              descriptionController: _descriptionController,
              locationController: _locationController,
              timeController: _timeController,
              onBack: _goHome,
              onSubmit: _submitReport,
            ),
          _LostFoundView.requests => _MyRequestsView(
              filter: _requestFilter,
              claims: _claimedItems,
              reports: _localReports,
              onBack: _goHome,
              onFilterChanged: (value) => setState(() => _requestFilter = value),
              onOpenItem: _openDetail,
            ),
        },
      ),
      bottomNavigationBar: UserBottomNavBar(
        currentBranchIndex: -1,
        onTap: (_) {},
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    this.onBack,
    this.showMenu = false,
  });

  final String title;
  final VoidCallback? onBack;
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 10, 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              onBack != null ? Icons.arrow_back : Icons.home_outlined,
              color: FuvekonColors.darkText,
            ),
            onPressed: onBack ?? () => context.go(Routes.account),
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: FuvekonColors.darkPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              showMenu ? Icons.more_vert_rounded : Icons.translate,
              color: FuvekonColors.darkText,
            ),
            onPressed: () {},
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({
    required this.tab,
    required this.onTabChanged,
    required this.onOpenFound,
    required this.onOpenReport,
    required this.onOpenRequests,
  });

  final _LostFoundTab tab;
  final ValueChanged<_LostFoundTab> onTabChanged;
  final VoidCallback onOpenFound;
  final VoidCallback onOpenReport;
  final VoidCallback onOpenRequests;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _TopBar(title: 'Lost & Found', showMenu: true),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _SegmentedTabs(
                tab: tab,
                onChanged: onTabChanged,
              ),
              const SizedBox(height: 18),
              _PolicyCard(onTap: () {}),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.search_rounded,
                      label: 'Xem đồ tìm thấy',
                      onTap: onOpenFound,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.notification_add_outlined,
                      label: 'Gửi báo mất đồ',
                      onTap: onOpenReport,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _TrackRequestCard(onTap: onOpenRequests),
            ],
          ),
        ),
      ],
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.tab, required this.onChanged});

  final _LostFoundTab tab;
  final ValueChanged<_LostFoundTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: _SegmentButton(
                label: 'Đồ tìm thấy',
                selected: tab == _LostFoundTab.found,
                onTap: () => onChanged(_LostFoundTab.found),
              ),
            ),
            Expanded(
              child: _SegmentButton(
                label: 'Báo mất đồ',
                selected: tab == _LostFoundTab.lost,
                onTap: () => onChanged(_LostFoundTab.lost),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? FuvekonColors.darkPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected
                ? FuvekonColors.darkButtonText
                : FuvekonColors.darkTextSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  const _PolicyCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.mintCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: FuvekonColors.surfaceContainer,
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: FuvekonColors.darkPrimary,
                    size: 16,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quy trình tìm lại đồ',
                        style: TextStyle(
                          color: FuvekonColors.darkCardText,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Món bạn làm rơi sẽ được lưu kho, hãy kiểm tra danh sách đồ được tìm thấy và gửi yêu cầu nhận.',
                        style: TextStyle(
                          color: FuvekonColors.textSecondary,
                          fontSize: 12,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(42),
                backgroundColor: FuvekonColors.darkPrimary,
                foregroundColor: FuvekonColors.darkButtonText,
              ),
              child: const Text('Xem chi tiết quy định'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: FuvekonColors.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Column(
            children: [
              Icon(icon, color: FuvekonColors.darkTextSecondary),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: FuvekonColors.darkTextSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackRequestCard extends StatelessWidget {
  const _TrackRequestCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: FuvekonColors.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.history_rounded, color: FuvekonColors.lightGold),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theo dõi yêu cầu',
                      style: TextStyle(
                        color: FuvekonColors.darkText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Xem trạng thái các đồ vật bạn đã báo mất',
                      style: TextStyle(
                        color: FuvekonColors.darkTextSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: FuvekonColors.darkText),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoundListView extends StatelessWidget {
  const _FoundListView({
    required this.controller,
    required this.category,
    required this.loading,
    required this.loadingMore,
    required this.error,
    required this.items,
    required this.onBack,
    required this.onSearch,
    required this.onCategoryChanged,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onOpenDetail,
  });

  final TextEditingController controller;
  final String category;
  final bool loading;
  final bool loadingMore;
  final String? error;
  final List<LostFoundPublicItem> items;
  final VoidCallback onBack;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onCategoryChanged;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final ValueChanged<LostFoundPublicItem> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopBar(title: 'Đồ tìm thấy', onBack: onBack),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >
                  notification.metrics.maxScrollExtent - 120) {
                onLoadMore();
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  _SearchBox(controller: controller, onSubmitted: onSearch),
                  const SizedBox(height: 14),
                  _CategoryChips(
                    selected: category,
                    onChanged: onCategoryChanged,
                  ),
                  const SizedBox(height: 16),
                  if (loading && items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (error != null && items.isEmpty)
                    _ErrorBox(message: error!, onRetry: onRefresh)
                  else if (items.isEmpty)
                    const EmptyState(
                      title: 'Chưa có vật phẩm nào',
                      subtitle: 'Danh sách sẽ được cập nhật khi staff ghi nhận.',
                      icon: Icons.inventory_2_outlined,
                    )
                  else
                    for (final item in items) ...[
                      _FoundItemCard(
                        item: item,
                        onDetail: () => onOpenDetail(item),
                      ),
                      const SizedBox(height: 14),
                    ],
                  if (loadingMore)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      style: const TextStyle(color: FuvekonColors.darkText),
      decoration: InputDecoration(
        hintText: 'Tìm kiếm vật phẩm...',
        prefixIcon: const Icon(Icons.search_rounded),
        fillColor: FuvekonColors.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: FuvekonColors.darkPrimary),
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  static const _items = [
    ('all', 'Tất cả'),
    ('electronics', 'Thiết bị điện tử'),
    ('bag', 'Ví/Bóp'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in _items) ...[
            ChoiceChip(
              label: Text(item.$2),
              selected: selected == item.$1,
              onSelected: (_) => onChanged(item.$1),
              selectedColor: FuvekonColors.darkPrimary,
              backgroundColor: FuvekonColors.surfaceContainer,
              labelStyle: TextStyle(
                color: selected == item.$1
                    ? FuvekonColors.darkButtonText
                    : FuvekonColors.darkTextSecondary,
                fontWeight: FontWeight.w700,
              ),
              side: BorderSide.none,
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FoundItemCard extends StatelessWidget {
  const _FoundItemCard({required this.item, required this.onDetail});

  final LostFoundPublicItem item;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.mintCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ItemImage(item: item, height: 160),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            color: FuvekonColors.darkCardText,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      _SmallStatusPill(label: _statusLabel(item)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _MetaLine(icon: Icons.place_outlined, text: item.location),
                  const SizedBox(height: 6),
                  _MetaLine(icon: Icons.schedule_rounded, text: '2 giờ trước'),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: onDetail,
                      style: FilledButton.styleFrom(
                        backgroundColor: FuvekonColors.surface,
                        foregroundColor: FuvekonColors.darkText,
                        minimumSize: const Size(116, 38),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Xem chi tiết ›'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LostFoundDetailView extends StatelessWidget {
  const _LostFoundDetailView({
    required this.item,
    required this.claimInProgress,
    required this.onBack,
    required this.onClaim,
  });

  final LostFoundPublicItem? item;
  final String? claimInProgress;
  final VoidCallback onBack;
  final VoidCallback? onClaim;

  @override
  Widget build(BuildContext context) {
    final item = this.item;
    if (item == null) {
      return _ErrorBox(message: 'Không tìm thấy vật phẩm.', onRetry: onBack);
    }

    return Column(
      children: [
        _TopBar(title: 'Chi tiết vật phẩm', onBack: onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    _ItemImage(item: item, height: 190),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: _DarkStatusPill(label: 'ĐANG LƯU GIỮ'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                item.title,
                style: const TextStyle(
                  color: FuvekonColors.darkText,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '# Mã số ${item.itemCode}',
                style: const TextStyle(
                  color: FuvekonColors.darkTextSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.place_outlined,
                      label: 'Địa điểm tìm thấy',
                      value: item.location.isEmpty ? 'Đang cập nhật' : item.location,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: _InfoChip(
                      icon: Icons.schedule_rounded,
                      label: 'Thời gian ghi nhận',
                      value: '14:30 - 20/10/2024',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _DescriptionCard(item: item),
              const SizedBox(height: 18),
              if (item.userHasPendingClaim)
                FilledButton(
                  onPressed: null,
                  child: const Text('Đã gửi yêu cầu nhận'),
                )
              else
                FilledButton.icon(
                  onPressed: claimInProgress == item.id ? null : onClaim,
                  icon: claimInProgress == item.id
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.back_hand_outlined, size: 18),
                  label: const Text('ĐÂY LÀ ĐỒ CỦA TÔI'),
                ),
              const SizedBox(height: 10),
              const Text(
                'Bạn sẽ cần cung cấp thêm thông tin mô tả khi staff liên hệ để xác minh quyền sở hữu.',
                style: TextStyle(
                  color: FuvekonColors.darkTextSecondary,
                  fontSize: 11,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: FuvekonColors.lightGold, size: 16),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: FuvekonColors.darkTextSecondary,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: FuvekonColors.darkText,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.item});

  final LostFoundPublicItem item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notes_rounded, color: FuvekonColors.darkPrimary, size: 16),
                SizedBox(width: 8),
                Text(
                  'Mô tả chi tiết',
                  style: TextStyle(
                    color: FuvekonColors.darkText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.description.isEmpty
                  ? 'Staff chưa nhập mô tả chi tiết cho vật phẩm này.'
                  : item.description,
              style: const TextStyle(
                color: FuvekonColors.darkTextSecondary,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportLostView extends StatelessWidget {
  const _ReportLostView({
    required this.titleController,
    required this.descriptionController,
    required this.locationController,
    required this.timeController,
    required this.onBack,
    required this.onSubmit,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final TextEditingController timeController;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopBar(title: 'Báo mất đồ', onBack: onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const Text(
                'Cung cấp thông tin chi tiết về vật phẩm bạn đã thất lạc để Ban tổ chức hỗ trợ tìm kiếm nhanh chóng nhất.',
                style: TextStyle(
                  color: FuvekonColors.darkTextSecondary,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              _FormSection(
                title: 'Định danh vật phẩm',
                children: [
                  _InputLabel('Tên vật phẩm'),
                  _FormTextField(
                    controller: titleController,
                    hintText: 'VD: Điện thoại iPhone 13 Pro',
                  ),
                  const SizedBox(height: 12),
                  _InputLabel('Loại vật phẩm'),
                  const _FakeSelect(label: 'Chọn phân loại'),
                ],
              ),
              const SizedBox(height: 14),
              _FormSection(
                title: 'Chi tiết & Hoàn cảnh',
                children: [
                  _InputLabel('Mô tả chi tiết'),
                  _FormTextField(
                    controller: descriptionController,
                    hintText:
                        'Màu sắc, thương hiệu, đặc điểm nhận dạng đặc biệt...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  _InputLabel('Khu vực có thể bị mất'),
                  _FormTextField(
                    controller: locationController,
                    hintText: 'Xác định khu vực gần nhất',
                  ),
                  const SizedBox(height: 12),
                  _InputLabel('Thời gian ước tính đánh rơi'),
                  _FormTextField(
                    controller: timeController,
                    hintText: '--:-- --/--/----',
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _AttachmentBox(),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.send_outlined, size: 18),
                label: const Text('Gửi báo mất đồ'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.mintCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: FuvekonColors.darkCardText,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InputLabel extends StatelessWidget {
  const _InputLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: FuvekonColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FormTextField extends StatelessWidget {
  const _FormTextField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: FuvekonColors.darkCardText),
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.white.withValues(alpha: 0.58),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
      ),
    );
  }
}

class _FakeSelect extends StatelessWidget {
  const _FakeSelect({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: FuvekonColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }
}

class _AttachmentBox extends StatelessWidget {
  const _AttachmentBox();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.mintCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hình ảnh đính kèm',
              style: TextStyle(
                color: FuvekonColors.darkCardText,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.38),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.08),
                  style: BorderStyle.solid,
                ),
              ),
              child: const SizedBox(
                height: 100,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        color: FuvekonColors.sageGreen,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tải lên ảnh minh họa (nếu có)',
                        style: TextStyle(
                          color: FuvekonColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyRequestsView extends StatelessWidget {
  const _MyRequestsView({
    required this.filter,
    required this.claims,
    required this.reports,
    required this.onBack,
    required this.onFilterChanged,
    required this.onOpenItem,
  });

  final String filter;
  final List<LostFoundPublicItem> claims;
  final List<_LocalLostReport> reports;
  final VoidCallback onBack;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<LostFoundPublicItem> onOpenItem;

  @override
  Widget build(BuildContext context) {
    final showClaims = filter == 'all' || filter == 'claim';
    final showReports = filter == 'all' || filter == 'lost';
    final isEmpty =
        (!showClaims || claims.isEmpty) && (!showReports || reports.isEmpty);

    return Column(
      children: [
        _TopBar(title: 'Yêu cầu của tôi', onBack: onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _RequestFilterChips(selected: filter, onChanged: onFilterChanged),
              const SizedBox(height: 16),
              if (isEmpty)
                const EmptyState(
                  title: 'Chưa có yêu cầu',
                  subtitle: 'Các claim hoặc báo mất đồ sẽ hiển thị tại đây.',
                  icon: Icons.assignment_outlined,
                )
              else ...[
                if (showReports)
                  for (final report in reports) ...[
                    _LocalReportCard(report: report),
                    const SizedBox(height: 12),
                  ],
                if (showClaims)
                  for (final item in claims) ...[
                    _ClaimRequestCard(
                      item: item,
                      onTap: () => onOpenItem(item),
                    ),
                    const SizedBox(height: 12),
                  ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RequestFilterChips extends StatelessWidget {
  const _RequestFilterChips({
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  static const _filters = [
    ('all', 'Tất cả'),
    ('lost', 'Đang tìm'),
    ('claim', 'Có kết quả'),
    ('done', 'Đã nhận'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in _filters) ...[
            ChoiceChip(
              label: Text(filter.$2),
              selected: selected == filter.$1,
              onSelected: (_) => onChanged(filter.$1),
              selectedColor: FuvekonColors.darkPrimary,
              backgroundColor: FuvekonColors.surfaceContainer,
              labelStyle: TextStyle(
                color: selected == filter.$1
                    ? FuvekonColors.darkButtonText
                    : FuvekonColors.darkTextSecondary,
                fontWeight: FontWeight.w700,
              ),
              side: BorderSide.none,
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _LocalReportCard extends StatelessWidget {
  const _LocalReportCard({required this.report});

  final _LocalLostReport report;

  @override
  Widget build(BuildContext context) {
    return _RequestCardShell(
      title: report.title,
      badge: 'Đang tìm',
      badgeColor: FuvekonColors.sageGreenContainer,
      subtitle: report.description.isEmpty
          ? 'Yêu cầu báo mất đang được lưu tạm trong ứng dụng.'
          : report.description,
      footer: 'Xem chi tiết ›',
      onTap: () {},
    );
  }
}

class _ClaimRequestCard extends StatelessWidget {
  const _ClaimRequestCard({required this.item, required this.onTap});

  final LostFoundPublicItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _RequestCardShell(
      title: item.title,
      badge: item.userClaimStatus == 'approved' ? 'Có kết quả' : 'Đang tìm',
      badgeColor: item.userClaimStatus == 'approved'
          ? FuvekonColors.lightGold
          : FuvekonColors.sageGreenContainer,
      subtitle: item.description.isEmpty
          ? 'Yêu cầu nhận vật phẩm đã được gửi tới staff.'
          : item.description,
      footer: 'Xem chi tiết ›',
      imageUrl: item.imageUrl,
      onTap: onTap,
    );
  }
}

class _RequestCardShell extends StatelessWidget {
  const _RequestCardShell({
    required this.title,
    required this.badge,
    required this.badgeColor,
    required this.subtitle,
    required this.footer,
    required this.onTap,
    this.imageUrl = '',
  });

  final String title;
  final String badge;
  final Color badgeColor;
  final String subtitle;
  final String footer;
  final VoidCallback onTap;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: FuvekonColors.mintCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl.isNotEmpty) ...[
                    S3Image(
                      imageUrl: imageUrl,
                      width: 52,
                      height: 52,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: FuvekonColors.darkCardText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            _SmallStatusPill(
                              label: badge,
                              color: badgeColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: FuvekonColors.textSecondary,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  footer,
                  style: const TextStyle(
                    color: FuvekonColors.darkCardText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  const _ItemImage({required this.item, required this.height});

  final LostFoundPublicItem item;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (item.imageUrl.isNotEmpty) {
      return S3Image(
        imageUrl: item.imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FuvekonColors.surfaceContainerHigh,
            FuvekonColors.surfaceContainerLow,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.inventory_2_outlined,
          color: FuvekonColors.darkTextSecondary,
          size: 44,
        ),
      ),
    );
  }
}

class _SmallStatusPill extends StatelessWidget {
  const _SmallStatusPill({
    required this.label,
    this.color = FuvekonColors.darkPrimary,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: color == FuvekonColors.lightGold
                ? FuvekonColors.onLightGold
                : FuvekonColors.sageGreenContainer,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _DarkStatusPill extends StatelessWidget {
  const _DarkStatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: FuvekonColors.darkTextSecondary),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: const TextStyle(
            color: FuvekonColors.darkText,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: FuvekonColors.sageGreenContainer),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text.isEmpty ? 'Đang cập nhật' : text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: FuvekonColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final needsTicket = message.toLowerCase().contains('ticket');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Text(
            needsTicket
                ? 'Bạn cần đăng nhập và có vé đã duyệt để xem danh sách đồ thất lạc.'
                : message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: FuvekonColors.darkTextSecondary),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: needsTicket
                ? () => context.go(Routes.login)
                : onRetry,
            child: Text(needsTicket ? 'Đăng nhập' : 'Thử lại'),
          ),
        ],
      ),
    );
  }
}

String _statusLabel(LostFoundPublicItem item) {
  if (item.userHasPendingClaim) return 'Đã gửi yêu cầu';
  if (item.status == 'claimed') return 'Đã có claim';
  if (item.status == 'resolved') return 'Đã xử lý';
  return 'Còn nhận';
}

class _LocalLostReport {
  const _LocalLostReport({
    required this.title,
    required this.description,
    required this.location,
    required this.time,
  });

  final String title;
  final String description;
  final String location;
  final String time;
}
