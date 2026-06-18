import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/ticket/presentation/models/my_ticket_list_item.dart';
import 'package:go_router/go_router.dart';

class MyTicketListCard extends StatelessWidget {
  const MyTicketListCard({
    super.key,
    required this.item,
    required this.onViewTicket,
  });

  final MyTicketListItem item;
  final VoidCallback onViewTicket;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final statusLabel = item.isCheckedIn
        ? l10n.myTicketsStatusUsed
        : l10n.myTicketsStatusActive;

    return Material(
      color: FuvekonColors.mintCard,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onViewTicket,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item.imageAsset,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 72,
                    height: 72,
                    color: FuvekonColors.sageGreenContainer,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: FuvekonColors.onSageGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _StatusChip(label: statusLabel, active: !item.isCheckedIn),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: FuvekonColors.onSageGreen.withValues(alpha: 0.55),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.dateLabel,
                          style: TextStyle(
                            color: FuvekonColors.onSageGreen.withValues(alpha: 0.75),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        onPressed: onViewTicket,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: FuvekonColors.onSageGreen,
                          side: BorderSide(
                            color: FuvekonColors.onSageGreen.withValues(alpha: 0.35),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Text(l10n.myTicketsViewTicket),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: FuvekonColors.onSageGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: active ? FuvekonColors.available : FuvekonColors.outline,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: FuvekonColors.onSageGreen.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum MyTicketFilter { active, used, all }

extension MyTicketFilterX on MyTicketFilter {
  String label(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      MyTicketFilter.active => l10n.myTicketsFilterActive,
      MyTicketFilter.used => l10n.myTicketsFilterUsed,
      MyTicketFilter.all => l10n.myTicketsFilterAll,
    };
  }

  List<MyTicketListItem> apply(List<MyTicketListItem> items) {
    return switch (this) {
      MyTicketFilter.active =>
        items.where((item) => item.isActive && !item.isCheckedIn).toList(),
      MyTicketFilter.used => items.where((item) => item.isCheckedIn).toList(),
      MyTicketFilter.all => items,
    };
  }
}

class MyTicketFilterTabs extends StatelessWidget {
  const MyTicketFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final MyTicketFilter selected;
  final ValueChanged<MyTicketFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: MyTicketFilter.values.map((filter) {
        final isSelected = filter == selected;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: filter != MyTicketFilter.all ? 8 : 0,
            ),
            child: Material(
              color: isSelected
                  ? FuvekonColors.darkPrimary
                  : FuvekonColors.darkSurfaceElevated,
              borderRadius: BorderRadius.circular(999),
              child: InkWell(
                onTap: () => onChanged(filter),
                borderRadius: BorderRadius.circular(999),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    filter.label(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? FuvekonColors.onSageGreen
                          : FuvekonColors.darkTextSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

void openETicketDetail(BuildContext context, MyTicketListItem item) {
  final args = ETicketDetailArgs.fromListItem(item);
  context.push(Routes.accountTicketDetail(item.id), extra: args);
}
