import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/utils/s3_url.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_state.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/explore_ticket_tier_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';

class NameCardSection extends StatefulWidget {
  const NameCardSection({super.key, required this.state});

  final MyTicketLoaded state;

  @override
  State<NameCardSection> createState() => _NameCardSectionState();
}

class _NameCardSectionState extends State<NameCardSection> {
  late final TextEditingController _badgeNameController;

  @override
  void initState() {
    super.initState();
    _badgeNameController = TextEditingController(text: widget.state.badgeName);
  }

  @override
  void didUpdateWidget(covariant NameCardSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.badgeName != widget.state.badgeName &&
        _badgeNameController.text != widget.state.badgeName) {
      _badgeNameController.text = widget.state.badgeName;
    }
  }

  @override
  void dispose() {
    _badgeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final bloc = context.read<MyTicketBloc>();
    final previewBytes = bloc.previewPngBytes;
    final storedUrl = state.ticket.namecardUrl;
    final colors = exploreTicketTextColors(ExploreTierStyle.standard);
    final theme = Theme.of(context);

    return TicketExploreSurface(
      style: ExploreTierStyle.standard,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name card',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.title,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chỉnh sửa thông tin badge và xem trước name card.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              if (!state.canSaveNameCard)
                const FuveStatusBadge(
                  label: 'Sau khi duyệt',
                  variant: FuveStatusBadgeVariant.pending,
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.canEditNameCard) ...[
            TextField(
              controller: _badgeNameController,
              decoration: const InputDecoration(
                labelText: 'Badge name',
                border: OutlineInputBorder(),
              ),
              maxLength: 255,
              enabled: state.canSaveNameCard && !state.isSavingNameCard,
              onChanged: (value) => context.read<MyTicketBloc>().add(
                    MyTicketEvent.badgeNameChanged(value),
                  ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('I am a fursuiter'),
              value: state.isFursuiter,
              onChanged: state.canSaveNameCard && !state.isSavingNameCard
                  ? (v) => context.read<MyTicketBloc>().add(
                        MyTicketEvent.fursuiterChanged(v ?? false),
                      )
                  : null,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fursuit staff'),
              value: state.isFursuitStaff,
              onChanged: state.canSaveNameCard && !state.isSavingNameCard
                  ? (v) => context.read<MyTicketBloc>().add(
                        MyTicketEvent.fursuitStaffChanged(v ?? false),
                      )
                  : null,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: state.canSaveNameCard && !state.isSavingNameCard
                  ? () => context.read<MyTicketBloc>().add(
                        const MyTicketEvent.saveNameCardRequested(),
                      )
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: FuvekonColors.darkButton,
                foregroundColor: FuvekonColors.darkButtonText,
              ),
              child: Text(
                state.isSavingNameCard ? 'Saving…' : 'Save name card',
              ),
            ),
          ] else
            Text(
              'Name card editing is available on higher tiers after approval.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.muted,
              ),
            ),
          const SizedBox(height: 20),
          Text(
            'Preview',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colors.title,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: _NameCardPreviewImage(
              previewBytes: previewBytes,
              storedUrl: storedUrl,
              isLoading: state.isGeneratingPreview,
            ),
          ),
        ],
      ),
    );
  }
}

class _NameCardPreviewImage extends StatelessWidget {
  const _NameCardPreviewImage({
    required this.previewBytes,
    required this.storedUrl,
    required this.isLoading,
  });

  final Uint8List? previewBytes;
  final String? storedUrl;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    const width = 310.0;

    if (isLoading && previewBytes == null) {
      return const SizedBox(
        width: width,
        height: 488,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (previewBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          previewBytes!,
          width: width,
          fit: BoxFit.contain,
        ),
      );
    }

    if (storedUrl != null && storedUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          S3Url.resolveImageUrl(storedUrl!),
          width: width,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const _PreviewPlaceholder(),
        ),
      );
    }

    return const _PreviewPlaceholder();
  }
}

class _PreviewPlaceholder extends StatelessWidget {
  const _PreviewPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: FuvekonColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Preview will appear here',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: FuvekonColors.darkTextSecondary,
            ),
      ),
    );
  }
}
