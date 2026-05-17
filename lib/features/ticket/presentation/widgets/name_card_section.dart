import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/utils/s3_url.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_state.dart';

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

    return Card(
      child: Padding(
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Edit your badge details and preview how it will look.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                if (!state.canSaveNameCard)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'After approval',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade900,
                      ),
                    ),
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
                child: Text(
                  state.isSavingNameCard ? 'Saving…' : 'Save name card',
                ),
              ),
            ] else
              Text(
                'Name card editing is available on higher tiers after approval.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            const SizedBox(height: 20),
            Text(
              'Preview',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Preview will appear here',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
