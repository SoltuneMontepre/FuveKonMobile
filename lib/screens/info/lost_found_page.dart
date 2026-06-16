import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/info/lost_found_models.dart';
import 'package:fuvekonmobile/screens/info/lost_found_service.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:go_router/go_router.dart';

class LostFoundPage extends StatefulWidget {
  const LostFoundPage({super.key});

  @override
  State<LostFoundPage> createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage> {
  late final LostFoundService _service;
  late final TextEditingController _searchController;

  final _items = <LostFoundPublicItem>[];
  LostFoundPageMeta? _meta;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  String _search = '';
  String? _claimInProgress;

  @override
  void initState() {
    super.initState();
    _service = sl<LostFoundService>();
    _searchController = TextEditingController();
    _load(refresh: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
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

  void _onSearchChanged(String value) {
    _search = value;
    _load(refresh: true);
  }

  Future<void> _claimItem(LostFoundPublicItem item) async {
    setState(() => _claimInProgress = item.id);
    try {
      await _service.claim(item.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Đã gửi yêu cầu nhận vật phẩm. Nhân viên sẽ xác minh và liên hệ bạn.',
          ),
        ),
      );
      await _load(refresh: true);
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('ServerException: ', '');
      if (message.contains('ticket')) {
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

  void _showItemDetail(LostFoundPublicItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 4),
              Text(
                '# ${item.itemCode}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
              ),
              const SizedBox(height: 16),
              if (item.imageUrl.isNotEmpty)
                S3Image(
                  imageUrl: item.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.circular(12),
                ),
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: FuvekonColors.darkText,
                      ),
                ),
              ],
              if (item.location.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 18,
                      color: FuvekonColors.darkTextSecondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.location,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: FuvekonColors.darkTextSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              if (item.userHasPendingClaim)
                FilledButton(
                  onPressed: null,
                  child: const Text('Đã gửi yêu cầu nhận'),
                )
              else if (item.canClaim)
                FilledButton(
                  onPressed: _claimInProgress == item.id
                      ? null
                      : () {
                          Navigator.pop(context);
                          _claimItem(item);
                        },
                  child: _claimInProgress == item.id
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Đây là của tôi'),
                )
              else
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng'),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FuvekonNavScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              FuvekonSpacing.page,
              12,
              FuvekonSpacing.page,
              8,
            ),
            child: Text(
              'Vật phẩm nhặt được',
              style: theme.textTheme.titleMedium?.copyWith(
                color: FuvekonColors.darkAppBarTitle,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: FuvekonSpacing.page),
            child: TextField(
              controller: _searchController,
              onSubmitted: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Tìm theo tên, mô tả, vị trí...',
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
          Expanded(child: _buildBody(theme)),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _items.isEmpty) {
      final needsTicket = _error!.toLowerCase().contains('ticket');
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(FuvekonSpacing.page),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                needsTicket
                    ? 'Bạn cần đăng nhập và có vé đã duyệt để xem danh sách đồ thất lạc.'
                    : _error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
              ),
              const SizedBox(height: 16),
              if (needsTicket)
                FilledButton(
                  onPressed: () => context.go(Routes.login),
                  child: const Text('Đăng nhập'),
                )
              else
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
      return const EmptyState(
        title: 'Chưa có vật phẩm nào',
        subtitle: 'Danh sách sẽ được cập nhật khi ban tổ chức ghi nhận đồ nhặt được.',
        icon: Icons.inventory_2_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => _load(refresh: true),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          FuvekonSpacing.page,
          12,
          FuvekonSpacing.page,
          24,
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
          return _LostFoundPublicTile(
            item: item,
            onTap: () => _showItemDetail(item),
          );
        },
      ),
    );
  }
}

class _LostFoundPublicTile extends StatelessWidget {
  const _LostFoundPublicTile({required this.item, required this.onTap});

  final LostFoundPublicItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: FuvekonColors.darkSurfaceElevated,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: item.imageUrl.isNotEmpty
            ? S3Image(
                imageUrl: item.imageUrl,
                width: 48,
                height: 48,
                borderRadius: BorderRadius.circular(8),
              )
            : CircleAvatar(
                backgroundColor:
                    FuvekonColors.darkPrimary.withValues(alpha: 0.15),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: FuvekonColors.darkPrimary,
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
          [
            item.itemCode,
            if (item.location.isNotEmpty) item.location,
            if (item.userHasPendingClaim) 'Đã gửi claim',
          ].join(' • '),
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
