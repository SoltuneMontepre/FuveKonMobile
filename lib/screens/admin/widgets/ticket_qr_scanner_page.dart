import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/utils/s3_url.dart';
import 'package:fuvekonmobile/core/utils/ticket/render_namecard.dart';
import 'package:fuvekonmobile/screens/admin/services/scan_ticket_service.dart';
import 'package:fuvekonmobile/shared/services/scan_session_store.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Full-screen QR scanner used on the Quét mã tab (and push routes if needed).
class TicketQrScannerPage extends StatefulWidget {
  const TicketQrScannerPage({
    super.key,
    required this.onLookup,
    required this.onCheckIn,
    this.embeddedInTab = false,
  });

  final Future<ScanTicketResult> Function(String code) onLookup;
  final Future<ScanTicketResult> Function(ScanTicketResult preview) onCheckIn;
  final bool embeddedInTab;

  @override
  State<TicketQrScannerPage> createState() => _TicketQrScannerPageState();
}

class _TicketQrScannerPageState extends State<TicketQrScannerPage>
    with WidgetsBindingObserver {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _isProcessing = false;
  bool _appInForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appInForeground = state == AppLifecycleState.resumed;
    _syncScannerVisibility();
  }

  /// Inactive admin tabs stay mounted inside [Offstage] (indexed shell stack).
  bool _isPageVisible(BuildContext context) {
    if (!widget.embeddedInTab) return true;
    final offstage = context.findAncestorWidgetOfExactType<Offstage>();
    return offstage == null || !offstage.offstage;
  }

  bool _shouldScannerRun(BuildContext context) {
    return _appInForeground && _isPageVisible(context) && !_isProcessing;
  }

  Future<void> _syncScannerVisibility() async {
    if (!mounted) return;

    final shouldRun = _shouldScannerRun(context);
    final running = _controller.value.isRunning;

    if (shouldRun && !running) {
      await _safeStart();
    } else if (!shouldRun && running) {
      await _safeStop();
    }
  }

  Future<void> _safeStop() async {
    try {
      await _controller.stop();
    } on MissingPluginException {
      // Plugin not registered — full app restart required.
    } on PlatformException {
      // Camera already stopped.
    }
  }

  Future<void> _safeStart() async {
    try {
      await _controller.start();
    } on MissingPluginException {
      // Plugin not registered — full app restart required.
    } on PlatformException {
      // Camera unavailable.
    }
  }

  Future<void> _handleCode(String raw) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    await _safeStop();

    final lookup = await widget.onLookup(raw);
    if (!mounted) return;

    if (lookup.canCheckIn) {
      setState(() => _isProcessing = false);
      final confirmed = await _showTicketPreviewSheet(lookup);
      if (!mounted) return;

      if (confirmed) {
        setState(() => _isProcessing = true);
        final result = await widget.onCheckIn(lookup);
        if (!mounted) return;
        setState(() => _isProcessing = false);
        await _showResultSheet(result);
      }
    } else {
      setState(() => _isProcessing = false);
      await _showResultSheet(lookup);
    }

    if (!mounted) return;
    if (_shouldScannerRun(context)) {
      await _safeStart();
    }
  }

  Future<void> _showManualEntry() async {
    final code = await showDialog<String>(
      context: context,
      builder: (context) => const _ManualEntryDialog(),
    );
    if (code == null || code.trim().isEmpty || !mounted) return;
    await _handleCode(code.trim());
  }

  Future<bool> _showTicketPreviewSheet(ScanTicketResult preview) {
    return showModalBottomSheet<bool>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: _TicketPreviewSheet(
            preview: preview,
            onCheckIn: () => Navigator.of(sheetContext).pop(true),
            onCancel: () => Navigator.of(sheetContext).pop(false),
          ),
        );
      },
    ).then((value) => value ?? false);
  }

  Future<void> _showResultSheet(ScanTicketResult result) {
    final color = switch (result.outcome) {
      ScanOutcome.valid => FuvekonColors.available,
      ScanOutcome.reused => const Color(0xFFFBBF24),
      ScanOutcome.rejected => const Color(0xFFF0A0A8),
    };

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewPaddingOf(context).bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: FuvekonColors.darkBorder,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 20),
              Icon(
                switch (result.outcome) {
                  ScanOutcome.valid => Icons.check_circle_rounded,
                  ScanOutcome.reused => Icons.history_rounded,
                  ScanOutcome.rejected => Icons.cancel_rounded,
                },
                color: color,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                result.message,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: FuvekonColors.darkText,
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
              if (result.referenceCode != null) ...[
                const SizedBox(height: 8),
                Text(
                  result.referenceCode!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: FuvekonColors.darkPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
              if (result.holderName != null) ...[
                const SizedBox(height: 4),
                Text(
                  result.holderName!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: FuvekonColors.darkTextSecondary,
                      ),
                ),
              ],
              if (result.tierName != null) ...[
                const SizedBox(height: 2),
                Text(
                  result.tierName!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: FuvekonColors.darkTextSecondary,
                      ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tiếp tục quét'),
                ),
              ),
            ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncScannerVisibility();
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            errorBuilder: (context, error) => _ScannerError(
              message: _errorMessage(error),
              onManualEntry: _showManualEntry,
              onRetry: () => _controller.start(),
            ),
            onDetect: (capture) {
              final value = capture.barcodes.firstOrNull?.rawValue;
              if (value == null || value.isEmpty) return;
              _handleCode(value);
            },
          ),
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      if (!widget.embeddedInTab)
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                        )
                      else
                        const SizedBox(width: 48),
                      const Spacer(),
                      IconButton(
                        onPressed: () => _controller.toggleTorch(),
                        icon: const Icon(
                          Icons.flash_on_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: FuvekonColors.darkPrimary,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isProcessing
                            ? 'Đang xử lý vé...'
                            : 'Đưa mã QR vé vào khung hình',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: _isProcessing ? null : _showManualEntry,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                        ),
                        icon: const Icon(Icons.keyboard_outlined),
                        label: const Text('Nhập mã thủ công'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
          if (_isProcessing)
            const ColoredBox(
              color: Color(0x88000000),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  String _errorMessage(MobileScannerException error) {
    return switch (error.errorCode) {
      MobileScannerErrorCode.permissionDenied =>
        'Cần quyền camera để quét vé. Hãy bật trong Cài đặt.',
      MobileScannerErrorCode.unsupported =>
        'Thiết bị không hỗ trợ quét mã QR.',
      _ => error.errorDetails?.message ?? 'Không thể mở camera.',
    };
  }
}

class _TicketPreviewSheet extends StatefulWidget {
  const _TicketPreviewSheet({
    required this.preview,
    required this.onCheckIn,
    required this.onCancel,
  });

  final ScanTicketResult preview;
  final VoidCallback onCheckIn;
  final VoidCallback onCancel;

  @override
  State<_TicketPreviewSheet> createState() => _TicketPreviewSheetState();
}

class _TicketPreviewSheetState extends State<_TicketPreviewSheet> {
  Uint8List? _namecardBytes;
  bool _isLoadingNamecard = true;

  @override
  void initState() {
    super.initState();
    _loadNamecard();
  }

  Future<void> _loadNamecard() async {
    final preview = widget.preview;
    final storedUrl = preview.namecardUrl;
    if (storedUrl != null && storedUrl.isNotEmpty) {
      if (mounted) setState(() => _isLoadingNamecard = false);
      return;
    }

    final tierCode = tierCodeFromTierCodeString(preview.tierCode);
    if (tierCode < 1) {
      if (mounted) setState(() => _isLoadingNamecard = false);
      return;
    }

    try {
      final bytes = await sl<NamecardRenderer>().renderPng(
        RenderNamecardOptions(
          tierCodeNumber: tierCode,
          avatarUrl: preview.avatarUrl ?? preview.badgeImage,
          previewName:
              preview.badgeName ?? preview.holderName ?? 'Guest',
          referenceCode: preview.referenceCode ?? preview.code,
          isFursuiter: preview.isFursuiter,
          isFursuitStaff: preview.isFursuitStaff,
          isDealer: preview.isDealer,
        ),
      );
      if (mounted) {
        setState(() {
          _namecardBytes = bytes;
          _isLoadingNamecard = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingNamecard = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = widget.preview;
    final idCard = preview.idCard?.trim();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: FuvekonColors.darkBorder,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Thông tin vé',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: FuvekonColors.darkText,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _TicketInfoRow(
            label: 'Mã vé',
            value: preview.referenceCode ?? preview.code,
          ),
          if (preview.holderName != null) ...[
            const SizedBox(height: 12),
            _TicketInfoRow(label: 'Khách', value: preview.holderName!),
          ],
          if (preview.tierName != null) ...[
            const SizedBox(height: 12),
            _TicketInfoRow(label: 'Hạng vé', value: preview.tierName!),
          ],
          const SizedBox(height: 12),
          _TicketInfoRow(
            label: 'CCCD/PP',
            value: idCard != null && idCard.isNotEmpty ? idCard : '—',
          ),
          const SizedBox(height: 20),
          Text(
            'Vé',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Center(
            child: _ScannedTicketImage(
              namecardBytes: _namecardBytes,
              namecardUrl: preview.namecardUrl,
              isLoading: _isLoadingNamecard,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: widget.onCheckIn,
            icon: const Icon(Icons.how_to_reg_rounded),
            label: const Text('Check-in'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: widget.onCancel,
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }
}

class _ScannedTicketImage extends StatelessWidget {
  const _ScannedTicketImage({
    required this.namecardBytes,
    required this.namecardUrl,
    required this.isLoading,
  });

  final Uint8List? namecardBytes;
  final String? namecardUrl;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    const width = 240.0;

    if (isLoading && namecardBytes == null) {
      return const SizedBox(
        width: width,
        height: 368,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (namecardBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          namecardBytes!,
          width: width,
          fit: BoxFit.contain,
        ),
      );
    }

    final storedUrl = namecardUrl;
    if (storedUrl != null && storedUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          S3Url.resolveImageUrl(storedUrl),
          width: width,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const _TicketImagePlaceholder(),
        ),
      );
    }

    return const _TicketImagePlaceholder();
  }
}

class _TicketImagePlaceholder extends StatelessWidget {
  const _TicketImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 160,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: FuvekonColors.darkBorder.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Không có ảnh vé',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: FuvekonColors.darkTextSecondary,
            ),
      ),
    );
  }
}

class _TicketInfoRow extends StatelessWidget {
  const _TicketInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: FuvekonColors.darkText,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

class _ScannerError extends StatelessWidget {
  const _ScannerError({
    required this.message,
    required this.onManualEntry,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onManualEntry;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.qr_code_scanner_outlined,
                color: Colors.white54,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onManualEntry,
                icon: const Icon(Icons.keyboard_outlined),
                label: const Text('Nhập mã thủ công'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                ),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManualEntryDialog extends StatefulWidget {
  const _ManualEntryDialog();

  @override
  State<_ManualEntryDialog> createState() => _ManualEntryDialogState();
}

class _ManualEntryDialogState extends State<_ManualEntryDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nhập mã vé'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(
          hintText: 'VD: T1-0042',
        ),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}
