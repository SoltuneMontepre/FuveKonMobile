import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_schedule_models.dart';
import 'package:fuvekonmobile/screens/admin/pages/admin_schedules_page.dart';
import 'package:fuvekonmobile/screens/admin/widgets/datetime_field.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_schedule_service.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AdminScheduleDetailPage extends StatefulWidget {
  const AdminScheduleDetailPage({super.key, required this.scheduleId});

  final String scheduleId;

  @override
  State<AdminScheduleDetailPage> createState() =>
      _AdminScheduleDetailPageState();
}

class _AdminScheduleDetailPageState extends State<AdminScheduleDetailPage> {
  late final AdminScheduleService _service;
  AdminScheduleItem? _schedule;
  bool _loading = true;
  String? _error;
  bool _actionInProgress = false;
  String? _selectedDate;
  String _selectedCategory = 'Tất cả';

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
      final schedule = await _service.getSchedule(widget.scheduleId);
      if (!mounted) return;
      setState(() {
        _schedule = schedule;
        _loading = false;
        _selectedDate ??= _defaultSelectedDate(schedule);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('ServerException: ', '');
        _loading = false;
      });
    }
  }

  String? _defaultSelectedDate(AdminScheduleItem schedule) {
    if (schedule.days.isEmpty) return null;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    for (final day in schedule.days) {
      if (day.date == today) return day.date;
    }
    return schedule.days.first.date;
  }

  AdminScheduleDay? _selectedDay(AdminScheduleItem schedule) {
    final selected = _selectedDate;
    if (selected == null) return null;
    for (final day in schedule.days) {
      if (day.date == selected) return day;
    }
    return null;
  }

  List<String> _categoriesForDay(AdminScheduleDay? day) {
    if (day == null) return const [];
    return day.timeline.map((item) => item.category).where((c) => c.isNotEmpty).toSet().toList()..sort();
  }

  List<_TimelineEntry> _timelineEntries(AdminScheduleDay? day) {
    if (day == null) return const [];

    final entries = day.timeline
        .where((item) => _selectedCategory == 'Tất cả' || item.category == _selectedCategory)
        .map((item) => _TimelineEntry(item: item))
        .toList();

    entries.sort((a, b) => a.item.startAt.compareTo(b.item.startAt));
    _markLocationConflicts(entries);
    return entries;
  }

  void _markLocationConflicts(List<_TimelineEntry> entries) {
    for (var i = 0; i < entries.length; i++) {
      for (var j = i + 1; j < entries.length; j++) {
        final a = entries[i];
        final b = entries[j];
        if (!_itemsOverlap(a.item, b.item)) continue;
        if (a.item.location.isEmpty || a.item.location != b.item.location) continue;
        a.hasLocationConflict = true;
        b.hasLocationConflict = true;
      }
    }
  }

  bool _itemsOverlap(AdminTimelineItem a, AdminTimelineItem b) {
    return a.startAt.isBefore(b.endAt) && b.startAt.isBefore(a.endAt);
  }

  String _dayAbbrev(String date) {
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return '';
    const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return labels[parsed.weekday - 1];
  }

  String _dayNumber(String date) {
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return '';
    return '${parsed.day}';
  }

  Future<void> _runAction(Future<void> Function() action) async {
    setState(() => _actionInProgress = true);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công.')),
      );
      await _load();
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
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _openEditSchedule() async {
    final schedule = _schedule;
    if (schedule == null) return;

    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AdminScheduleFormSheet(
        initial: schedule,
        onSubmit: (input) => _service.updateSchedule(
          schedule.id,
          UpdateScheduleInput(
            name: input.name,
            startAt: input.startAt,
            endAt: input.endAt,
          ),
        ),
      ),
    );
    if (updated == true) await _load();
  }

  Future<void> _confirmDeleteSchedule() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa lịch trình?'),
        content: const Text('Tất cả mục trong lịch sẽ bị xóa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF0A0A8),
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await _runAction(() async {
      await _service.deleteSchedule(widget.scheduleId);
      if (mounted) context.pop();
    });
  }

  DateTime _defaultStartForSelectedDay() {
    final selected = _selectedDate;
    final parsed = selected != null ? DateTime.tryParse(selected) : null;
    final base = parsed ?? DateTime.now();
    return DateTime(base.year, base.month, base.day, 10);
  }

  Future<void> _openTimelineForm({AdminTimelineItem? item}) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _TimelineItemFormSheet(
        initial: item,
        defaultStart: item?.startAt ?? _defaultStartForSelectedDay(),
        defaultEnd: item?.endAt ??
            _defaultStartForSelectedDay().add(const Duration(hours: 1)),
        onSubmit: (input) async {
          if (item == null) {
            await _service.createTimelineItem(
              scheduleId: widget.scheduleId,
              input: input,
            );
          } else {
            await _service.updateTimelineItem(
              scheduleId: widget.scheduleId,
              itemId: item.id,
              input: input,
            );
          }
        },
      ),
    );
    if (saved == true) await _load();
  }

  Future<void> _confirmDeleteItem(AdminTimelineItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa mục lịch trình?'),
        content: Text('Xóa "${item.title}"?'),
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
    if (confirmed != true) return;

    await _runAction(
      () => _service.deleteTimelineItem(
        scheduleId: widget.scheduleId,
        itemId: item.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      floatingActionButton: _schedule == null
          ? null
          : FloatingActionButton(
              onPressed: _actionInProgress ? null : () => _openTimelineForm(),
              backgroundColor: FuvekonColors.darkPrimary,
              foregroundColor: FuvekonColors.darkButtonText,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.add_rounded, size: 30),
            ),
      body: SafeArea(child: _buildBody()),
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
                _error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: _load, child: const Text('Thử lại')),
            ],
          ),
        ),
      );
    }

    final schedule = _schedule!;
    final selectedDay = _selectedDay(schedule);
    final categories = _categoriesForDay(selectedDay);
    final entries = _timelineEntries(selectedDay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ScheduleHeaderBar(
          title: schedule.name.isNotEmpty ? schedule.name : 'Lịch trình',
          onBack: () => context.pop(),
          onEdit: _openEditSchedule,
          onDelete: _confirmDeleteSchedule,
          actionInProgress: _actionInProgress,
        ),
        if (schedule.days.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: FuvekonSpacing.page),
              itemCount: schedule.days.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final day = schedule.days[index];
                final selected = _selectedDate == day.date;
                return _DateChip(
                  dayLabel: _dayAbbrev(day.date),
                  dateLabel: _dayNumber(day.date),
                  selected: selected,
                  onTap: () => setState(() => _selectedDate = day.date),
                );
              },
            ),
          ),
        ],
        if (categories.isNotEmpty) ...[
          const SizedBox(height: 14),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: FuvekonSpacing.page),
              itemCount: categories.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _CategoryChip(
                    label: 'Tất cả',
                    selected: _selectedCategory == 'Tất cả',
                    onTap: () => setState(() => _selectedCategory = 'Tất cả'),
                  );
                }
                final category = categories[index - 1];
                return _CategoryChip(
                  label: category,
                  selected: _selectedCategory == category,
                  onTap: () => setState(() => _selectedCategory = category),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 16),
        Expanded(
          child: entries.isEmpty
              ? _buildEmptyDay()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      FuvekonSpacing.page,
                      0,
                      FuvekonSpacing.page,
                      96,
                    ),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      final isLast = index == entries.length - 1;
                      return _TimelineItemTile(
                        entry: entry,
                        isLast: isLast,
                        onTap: () => _openTimelineForm(item: entry.item),
                        onDelete: () => _confirmDeleteItem(entry.item),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyDay() {
    final selected = _selectedDate;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FuvekonSpacing.page),
        child: EmptyState(
          icon: Icons.event_busy_outlined,
          title: 'Chưa có mục lịch trình',
          subtitle: selected == null
              ? 'Chọn ngày để xem lịch trình.'
              : 'Chưa có mục nào vào ngày ${DateFormat('dd/MM').format(DateTime.parse(selected))}.',
        ),
      ),
    );
  }
}

class _TimelineEntry {
  _TimelineEntry({required this.item});

  final AdminTimelineItem item;
  bool hasLocationConflict = false;
}

class _ScheduleHeaderBar extends StatelessWidget {
  const _ScheduleHeaderBar({
    required this.title,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
    required this.actionInProgress,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool actionInProgress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: FuvekonColors.darkText,
          ),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: FuvekonColors.darkAppBarTitle,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          PopupMenuButton<String>(
            enabled: !actionInProgress,
            icon: const Icon(Icons.more_vert_rounded),
            color: FuvekonColors.darkSurfaceElevated,
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  onEdit();
                case 'delete':
                  onDelete();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa lịch')),
              PopupMenuItem(
                value: 'delete',
                child: Text('Xóa lịch trình', style: TextStyle(color: Color(0xFFF0A0A8))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.dayLabel,
    required this.dateLabel,
    required this.selected,
    required this.onTap,
  });

  final String dayLabel;
  final String dateLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? FuvekonColors.darkPrimary : FuvekonColors.darkSurface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: selected ? null : Border.all(color: FuvekonColors.darkBorder),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dayLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected
                          ? FuvekonColors.darkButtonText
                          : FuvekonColors.darkTextSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                dateLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: selected
                          ? FuvekonColors.darkButtonText
                          : FuvekonColors.darkText,
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

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FuvekonColors.darkSurface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? FuvekonColors.darkPrimary : FuvekonColors.darkBorder,
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: selected ? FuvekonColors.darkPrimary : FuvekonColors.darkTextSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}

class _TimelineItemTile extends StatelessWidget {
  const _TimelineItemTile({
    required this.entry,
    required this.isLast,
    required this.onTap,
    required this.onDelete,
  });

  final _TimelineEntry entry;
  final bool isLast;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  static const _conflictColor = Color(0xFFE57373);

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat('HH:mm');
    final item = entry.item;
    final conflict = entry.hasLocationConflict;
    final timeRange = '${timeFmt.format(item.startAt)} - ${timeFmt.format(item.endAt)}';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: conflict ? _conflictColor : FuvekonColors.darkPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(color: FuvekonColors.darkBg, width: 2),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: FuvekonColors.darkBorder,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        timeRange,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: conflict ? FuvekonColors.darkText : const Color(0xFFFBBF24),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      if (item.category.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        _TagChip(label: item.category),
                      ],
                      if (conflict) ...[
                        const SizedBox(width: 6),
                        const _TagChip(
                          label: 'Trùng địa điểm',
                          icon: Icons.warning_amber_rounded,
                          backgroundColor: Color(0xFF3D2020),
                          foregroundColor: _conflictColor,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Material(
                    color: conflict ? FuvekonColors.darkSurfaceElevated : FuvekonColors.darkCard,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: onTap,
                      onLongPress: onDelete,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: conflict
                              ? Border.all(color: _conflictColor.withValues(alpha: 0.6))
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: conflict
                                        ? FuvekonColors.darkText
                                        : FuvekonColors.darkCardText,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            if (item.location.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    size: 16,
                                    color: conflict ? _conflictColor : FuvekonColors.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      conflict ? '${item.location} (Trùng lịch)' : item.location,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: conflict
                                                ? _conflictColor
                                                : FuvekonColors.textSecondary,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (item.description.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline_rounded,
                                    size: 16,
                                    color: FuvekonColors.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      item.description,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: FuvekonColors.textSecondary,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? FuvekonColors.darkTextSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor ?? FuvekonColors.darkSurface,
        borderRadius: BorderRadius.circular(6),
        border: backgroundColor == null ? Border.all(color: FuvekonColors.darkBorder) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItemFormSheet extends StatefulWidget {
  const _TimelineItemFormSheet({
    this.initial,
    required this.defaultStart,
    required this.defaultEnd,
    required this.onSubmit,
  });

  final AdminTimelineItem? initial;
  final DateTime defaultStart;
  final DateTime defaultEnd;
  final Future<void> Function(TimelineItemInput input) onSubmit;

  @override
  State<_TimelineItemFormSheet> createState() => _TimelineItemFormSheetState();
}

class _TimelineItemFormSheetState extends State<_TimelineItemFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _locationController;
  late DateTime _startAt;
  late DateTime _endAt;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _titleController = TextEditingController(text: initial?.title ?? '');
    _descriptionController = TextEditingController(text: initial?.description ?? '');
    _categoryController = TextEditingController(text: initial?.category ?? '');
    _locationController = TextEditingController(text: initial?.location ?? '');
    _startAt = initial?.startAt ?? widget.defaultStart;
    _endAt = initial?.endAt ?? widget.defaultEnd;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
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

    onChanged(DateTime(date.year, date.month, date.day, time.hour, time.minute));
    setState(() {});
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_endAt.isAfter(_startAt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thời gian kết thúc phải sau thời gian bắt đầu.')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await widget.onSubmit(
        TimelineItemInput(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          startAt: _startAt,
          endAt: _endAt,
          category: _categoryController.text.trim(),
          location: _locationController.text.trim(),
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('ServerException: ', 'Lỗi: ')),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _formatDateTime(DateTime value) => DateFormat('dd/MM/yyyy HH:mm').format(value);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isEdit = widget.initial != null;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                isEdit ? 'Chỉnh sửa mục' : 'Thêm mục lịch trình',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: FuvekonColors.darkText,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tiêu đề'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tiêu đề.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Diễn giả / mô tả (tuỳ chọn)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Hạng mục (tuỳ chọn)',
                hintText: 'Panel, Workshop...',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Địa điểm (tuỳ chọn)',
                hintText: 'Hall A, Sân khấu chính...',
              ),
            ),
            const SizedBox(height: 12),
            DateTimeField(
              label: 'Bắt đầu',
              value: _formatDateTime(_startAt),
              icon: Icons.schedule_outlined,
              onTap: () => _pickDateTime(
                initial: _startAt,
                onChanged: (value) => _startAt = value,
              ),
            ),
            const SizedBox(height: 12),
            DateTimeField(
              label: 'Kết thúc',
              value: _formatDateTime(_endAt),
              icon: Icons.schedule_outlined,
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
                  : Text(isEdit ? 'Lưu' : 'Thêm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
