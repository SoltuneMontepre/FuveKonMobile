import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_error_l10n.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_schedule_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_schedule_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/datetime_field.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AdminSchedulesPage extends StatefulWidget {
  const AdminSchedulesPage({super.key});

  @override
  State<AdminSchedulesPage> createState() => _AdminSchedulesPageState();
}

class _AdminSchedulesPageState extends State<AdminSchedulesPage> {
  late final AdminScheduleService _service;
  final _items = <AdminScheduleItem>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = sl<AdminScheduleService>();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final items = await _service.listSchedules();
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(items);
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

  Future<void> _openCreateSheet() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AdminScheduleFormSheet(),
    );
    if (created == true) await _load();
  }

  String _formatRange(BuildContext context, AdminScheduleItem item) {
    final l10n = context.l10n;
    final fmt = DateFormat('dd/MM/yyyy HH:mm');
    if (item.startAt == null && item.endAt == null)
      return l10n.adminEventSchedulesNoTime;
    if (item.startAt != null && item.endAt != null) {
      return '${fmt.format(item.startAt!)} – ${fmt.format(item.endAt!)}';
    }
    if (item.startAt != null)
      return '${l10n.adminEventSchedulesFrom} ${fmt.format(item.startAt!)}';
    return '${l10n.adminEventSchedulesTo} ${fmt.format(item.endAt!)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateSheet,
        backgroundColor: FuvekonColors.darkPrimary,
        foregroundColor: FuvekonColors.darkButtonText,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: FuvekonColors.darkText,
                  ),
                  Expanded(
                    child: Text(
                      l10n.adminSchedulesTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: FuvekonColors.darkAppBarTitle,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(FuvekonSpacing.page),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatAdminError(context.l10n, _error!),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _load,
                child: Text(context.l10n.adminRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(FuvekonSpacing.page),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmptyState(
                icon: Icons.calendar_month_outlined,
                title: context.l10n.adminSchedulesEmpty,
                subtitle: context.l10n.adminSchedulesEmptySubtitle,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _openCreateSheet,
                icon: const Icon(Icons.add_rounded),
                label: Text(context.l10n.adminSchedulesCreate),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          FuvekonSpacing.page,
          12,
          FuvekonSpacing.page,
          88,
        ),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = _items[index];
          return _ScheduleCard(
            name: item.name,
            dateRange: _formatRange(context, item),
            dayCount: item.dayCount,
            timelineItemCount: item.timelineItemCount,
            onTap: () => context.push(Routes.adminScheduleDetail(item.id)),
          );
        },
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.name,
    required this.dateRange,
    required this.dayCount,
    required this.timelineItemCount,
    required this.onTap,
  });

  final String name;
  final String dateRange;
  final int dayCount;
  final int timelineItemCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: FuvekonColors.darkCard,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: FuvekonColors.darkCardText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: FuvekonColors.darkCardText.withValues(alpha: 0.5),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                dateRange,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: FuvekonColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (dayCount > 0)
                    _MetaChip(
                      icon: Icons.calendar_today_outlined,
                      label: l10n.adminSchedulesDaysCount(dayCount),
                    ),
                  if (dayCount > 0 && timelineItemCount > 0)
                    const SizedBox(width: 8),
                  if (timelineItemCount > 0)
                    _MetaChip(
                      icon: Icons.timeline_outlined,
                      label: l10n.adminSchedulesItemsCount(timelineItemCount),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: FuvekonColors.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: FuvekonColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: FuvekonColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class AdminScheduleFormSheet extends StatefulWidget {
  const AdminScheduleFormSheet({super.key, this.initial, this.onSubmit});

  final AdminScheduleItem? initial;
  final Future<void> Function(CreateScheduleInput input)? onSubmit;

  @override
  State<AdminScheduleFormSheet> createState() => _AdminScheduleFormSheetState();
}

class _AdminScheduleFormSheetState extends State<AdminScheduleFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late DateTime _startAt;
  late DateTime _endAt;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.name ?? '');
    final now = DateTime.now();
    _startAt = initial?.startAt ?? DateTime(now.year, now.month, now.day, 8);
    _endAt =
        initial?.endAt ??
        DateTime(now.year, now.month, now.day, 22).add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime({
    required DateTime initial,
    required ValueChanged<DateTime> onChanged,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return;

    onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
    setState(() {});
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_endAt.isAfter(_startAt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.adminScheduleEndAfterStart)),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final input = CreateScheduleInput(
        name: _nameController.text.trim(),
        startAt: _startAt,
        endAt: _endAt,
      );
      if (widget.onSubmit != null) {
        await widget.onSubmit!(input);
      } else {
        await sl<AdminScheduleService>().createSchedule(input);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(formatAdminError(context.l10n, e))),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _formatDateTime(DateTime value) =>
      DateFormat('dd/MM/yyyy HH:mm').format(value);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isEdit = widget.initial != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
      child: Form(
        key: _formKey,
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
              isEdit ? l10n.adminSchedulesEdit : l10n.adminSchedulesCreateNew,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: FuvekonColors.darkText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.adminSchedulesNameLabel,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.adminSchedulesNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DateTimeField(
              label: l10n.adminScheduleStartLabel,
              value: _formatDateTime(_startAt),
              icon: Icons.calendar_today_outlined,
              onTap: () => _pickDateTime(
                initial: _startAt,
                onChanged: (value) => _startAt = value,
              ),
            ),
            const SizedBox(height: 12),
            DateTimeField(
              label: l10n.adminScheduleEndLabel,
              value: _formatDateTime(_endAt),
              icon: Icons.calendar_today_outlined,
              onTap: () => _pickDateTime(
                initial: _endAt,
                onChanged: (value) => _endAt = value,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEdit ? l10n.adminSave : l10n.adminCreate),
            ),
          ],
        ),
      ),
    );
  }
}
