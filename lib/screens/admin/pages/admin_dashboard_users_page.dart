import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_dashboard_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_user_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_list_scaffold.dart';
import 'package:fuvekonmobile/screens/admin/widgets/users_by_country_chart.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';

class AdminDashboardUsersPage extends StatefulWidget {
  const AdminDashboardUsersPage({super.key});

  @override
  State<AdminDashboardUsersPage> createState() =>
      _AdminDashboardUsersPageState();
}

class _AdminDashboardUsersPageState extends State<AdminDashboardUsersPage> {
  final _service = sl<AdminUserService>();
  List<CountryUserCount>? _items;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final items = await _service.getUsersByCountry();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AdminListScaffold(
      title: l10n.adminPlaceholderDashboardUsers,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? AdminListErrorState(
                  message: l10n.adminDashboardLoadFailed,
                  onRetry: _load,
                )
              : _items == null || _items!.isEmpty
                  ? EmptyState(
                      title: l10n.adminDashboardUsersByCountryEmpty,
                      subtitle: l10n.adminPlaceholderDashboardUsersSubtitle,
                      icon: Icons.public_outlined,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        padding: const EdgeInsets.all(FuvekonSpacing.page),
                        children: [
                          Text(
                            l10n.adminPlaceholderDashboardUsersSubtitle,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: FuvekonColors.darkTextSecondary,
                                ),
                          ),
                          const SizedBox(height: 16),
                          UsersByCountryChart(items: _items!),
                        ],
                      ),
                    ),
    );
  }
}
