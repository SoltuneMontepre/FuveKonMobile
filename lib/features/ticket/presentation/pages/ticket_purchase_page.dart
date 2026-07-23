import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/utils/ticket_price.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_purchase_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_purchase_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_purchase_state.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/explore_ticket_tier_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_illustrated_background.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TicketPurchasePage extends StatelessWidget {
  const TicketPurchasePage({
    super.key,
    required this.tierId,
    this.queued = false,
    this.payableAmount,
    this.isUpgrade = false,
  });

  final String tierId;
  final bool queued;
  final double? payableAmount;
  final bool isUpgrade;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<TicketPurchaseBloc>()..add(
            TicketPurchaseEvent.started(
              tierId: tierId,
              queued: queued,
              payableAmount: payableAmount,
              isUpgrade: isUpgrade,
            ),
          ),
      child: _TicketPurchaseView(
        tierId: tierId,
        queued: queued,
        payableAmount: payableAmount,
        isUpgrade: isUpgrade,
      ),
    );
  }
}

class _TicketPurchaseView extends StatefulWidget {
  const _TicketPurchaseView({
    required this.tierId,
    required this.queued,
    this.payableAmount,
    this.isUpgrade = false,
  });

  final String tierId;
  final bool queued;
  final double? payableAmount;
  final bool isUpgrade;

  @override
  State<_TicketPurchaseView> createState() => _TicketPurchaseViewState();
}

class _TicketPurchaseViewState extends State<_TicketPurchaseView> {
  final _idCardController = TextEditingController();
  _PaymentMethod _selectedMethod = _PaymentMethod.bankQr;
  bool _acceptedTerms = true;
  double? _payableAmount;
  bool _isUpgrade = false;

  @override
  void initState() {
    super.initState();
    _payableAmount = widget.payableAmount;
    _isUpgrade = widget.isUpgrade;
  }

  @override
  void dispose() {
    _idCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TicketPurchaseBloc, TicketPurchaseState>(
      listener: (context, state) {
        final bloc = context.read<TicketPurchaseBloc>();
        final actionError = bloc.lastActionError;
        if (actionError != null) {
          bloc.lastActionError = null;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(actionError)));
        }

        if (state is TicketPurchaseLoaded) {
          _payableAmount = state.payableAmount ?? _payableAmount;
          _isUpgrade = state.isUpgrade || _isUpgrade;
        }

        if (state is TicketPurchaseQueueTimedOut) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Đơn hàng vẫn đang xử lý. Vui lòng kiểm tra lại sau trong Vé của tôi.',
              ),
            ),
          );
          context.go(Routes.account);
          return;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: FuvekonColors.darkBg,
          body: FuvekonIllustratedPageStack(
            child: switch (state) {
              TicketPurchaseInitial() ||
              TicketPurchaseLoading() => const _QueueProcessingBody(),
              TicketPurchasePolling(:final attempt, :final maxAttempts) =>
                _QueueProcessingBody(
                  attempt: attempt,
                  maxAttempts: maxAttempts,
                ),
              TicketPurchaseQueueTimedOut() => const _QueueProcessingBody(),
              TicketPurchaseNotFound(:final queued) => _NotFoundBody(
                queued: queued,
                onRetry: () => context.read<TicketPurchaseBloc>().add(
                  TicketPurchaseEvent.started(
                    tierId: widget.tierId,
                    queued: queued,
                    payableAmount: widget.payableAmount,
                    isUpgrade: widget.isUpgrade,
                  ),
                ),
                onBack: () => Navigator.of(context).pop(),
              ),
              TicketPurchaseDenied(:final ticket, :final denialReason) =>
                _DeniedBody(
                  denialReason: denialReason.isNotEmpty
                      ? denialReason
                      : ticket.denialReason,
                  onBack: () => Navigator.of(context).pop(),
                ),
              TicketPurchaseLoaded() => _PaymentBody(
                state: state,
                idCardController: _idCardController,
                selectedMethod: _selectedMethod,
                onMethodChanged: (method) =>
                    setState(() => _selectedMethod = method),
                onSaveIdCard: () {
                  context.read<TicketPurchaseBloc>().add(
                    TicketPurchaseEvent.idCardSaved(_idCardController.text),
                  );
                },
                acceptedTerms: _acceptedTerms,
                onAcceptedChanged: (value) =>
                    setState(() => _acceptedTerms = value ?? false),
                onConfirm: _acceptedTerms
                    ? () {
                        context.read<TicketPurchaseBloc>().add(
                          const TicketPurchaseEvent.confirmPaymentRequested(),
                        );
                      }
                    : null,
              ),
              TicketPurchaseFailure(:final message) => _ErrorBody(
                message: message,
                onRetry: () => context.read<TicketPurchaseBloc>().add(
                  TicketPurchaseEvent.started(
                    tierId: widget.tierId,
                    queued: widget.queued,
                    payableAmount: widget.payableAmount,
                    isUpgrade: widget.isUpgrade,
                  ),
                ),
              ),
              TicketPurchaseConfirmed(:final ticket) => _PaymentSuccessBody(
                ticket: ticket,
                payableAmount: _payableAmount,
                isUpgrade: _isUpgrade,
              ),
            },
          ),
        );
      },
    );
  }
}

class _PaymentBody extends StatelessWidget {
  const _PaymentBody({
    required this.state,
    required this.idCardController,
    required this.selectedMethod,
    required this.onMethodChanged,
    required this.onSaveIdCard,
    required this.acceptedTerms,
    required this.onAcceptedChanged,
    required this.onConfirm,
  });

  final TicketPurchaseLoaded state;
  final TextEditingController idCardController;
  final _PaymentMethod selectedMethod;
  final ValueChanged<_PaymentMethod> onMethodChanged;
  final VoidCallback onSaveIdCard;
  final bool acceptedTerms;
  final ValueChanged<bool?> onAcceptedChanged;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final ticket = state.ticket;
    final tier = ticket.tier;
    final rawPrice = state.payableAmount ?? tier?.price ?? 0;
    final amount = formatTicketPriceVnd(rawPrice);
    final fee = 0.0;
    final total = formatTicketPriceVnd(rawPrice + fee);
    final buyerName = state.account.ticketHolderName;
    final buyerContact = _maskedContact(state.account.email);
    final needsIdCard = (state.account.idCard?.trim().isEmpty ?? true);

    if (needsIdCard && idCardController.text.isEmpty) {
      idCardController.text = state.account.idCard ?? '';
    }

    return Stack(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _PaymentHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                  children: [
                    const Text(
                      'Thanh toán vé',
                      style: TextStyle(
                        color: FuvekonColors.darkText,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Hoàn tất thủ tục để tham gia sự kiện.',
                      style: TextStyle(
                        color: FuvekonColors.darkTextSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _TicketSummaryCard(
                      ticketName: tier?.ticketName ?? '—',
                      amount: amount,
                    ),
                    const SizedBox(height: 12),
                    _BuyerInfoCard(name: buyerName, contact: buyerContact),
                    if (needsIdCard) ...[
                      const SizedBox(height: 12),
                      _IdCardCard(
                        controller: idCardController,
                        isSaving: state.isSavingIdCard,
                        onSave: onSaveIdCard,
                      ),
                    ],
                    const SizedBox(height: 24),
                    const Text(
                      'Phương thức thanh toán',
                      style: TextStyle(
                        color: FuvekonColors.darkText,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PaymentMethodTile(
                      method: _PaymentMethod.bankQr,
                      selectedMethod: selectedMethod,
                      title: 'Chuyển khoản QR',
                      subtitle: 'Miễn phí giao dịch',
                      icon: Icons.qr_code_2_rounded,
                      recommended: true,
                      onChanged: onMethodChanged,
                    ),
                    const SizedBox(height: 22),
                    _OrderTotalCard(
                      subtotal: amount,
                      fee: formatTicketPriceVnd(fee),
                      total: total,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: acceptedTerms,
                          onChanged: onAcceptedChanged,
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Tôi xác nhận thông tin đơn hàng là chính xác và đồng ý với điều khoản vé.',
                            style: TextStyle(
                              color: FuvekonColors.darkTextSecondary,
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    FuvekonIllustratedContentPanel(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: FilledButton(
                        onPressed:
                            state.isConfirming ||
                                needsIdCard ||
                                !acceptedTerms
                            ? null
                            : onConfirm,
                        style: FilledButton.styleFrom(
                          backgroundColor: FuvekonColors.darkButton,
                          foregroundColor: FuvekonColors.darkButtonText,
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              FuvekonRadii.button,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.isConfirming
                                  ? 'Đang xử lý...'
                                  : 'Xác nhận và thanh toán',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 12,
                          color: FuvekonColors.lightGold,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Mọi giao dịch được mã hóa và bảo mật tuyệt đối.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: FuvekonColors.darkTextSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (state.isConfirming)
          ColoredBox(
            color: FuvekonColors.darkDeep.withValues(alpha: 0.55),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

enum _PaymentMethod { bankQr }

class _PaymentHeader extends StatelessWidget {
  const _PaymentHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: FuvekonColors.darkText),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () => Navigator.of(context).pop(),
            visualDensity: VisualDensity.compact,
          ),
          const Expanded(
            child: Text(
              'FUVEKON',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: FuvekonColors.darkPrimary,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.8,
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.translate, color: FuvekonColors.darkText),
            onPressed: () {},
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _TicketSummaryCard extends StatelessWidget {
  const _TicketSummaryCard({required this.ticketName, required this.amount});

  final String ticketName;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final colors = exploreTicketTextColors(ExploreTierStyle.standard);

    return TicketExploreSurface(
      style: ExploreTierStyle.standard,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: FuvekonColors.surfaceContainerLow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.confirmation_number_rounded,
                  size: 16,
                  color: colors.title,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SỰ KIỆN CHÍNH',
                      style: TextStyle(
                        color: FuvekonColors.textSecondary,
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Vé $ticketName',
                      style: const TextStyle(
                        color: FuvekonColors.darkCardText,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: Colors.black.withValues(alpha: 0.08), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                '× 1',
                style: TextStyle(
                  color: FuvekonColors.darkCardText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                amount,
                style: const TextStyle(
                  color: FuvekonColors.darkCardText,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BuyerInfoCard extends StatelessWidget {
  const _BuyerInfoCard({required this.name, required this.contact});

  final String name;
  final String contact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: 13,
                  color: FuvekonColors.darkPrimary,
                ),
                SizedBox(width: 6),
                Text(
                  'THÔNG TIN NGƯỜI MUA',
                  style: TextStyle(
                    color: FuvekonColors.darkTextSecondary,
                    fontSize: 10,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: FuvekonColors.darkText,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  contact,
                  style: const TextStyle(
                    color: FuvekonColors.darkTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IdCardCard extends StatelessWidget {
  const _IdCardCard({
    required this.controller,
    required this.isSaving,
    required this.onSave,
  });

  final TextEditingController controller;
  final bool isSaving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FuvekonColors.dustyRose.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bổ sung CCCD/Hộ chiếu để tiếp tục thanh toán',
              style: TextStyle(
                color: FuvekonColors.darkText,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              style: const TextStyle(color: FuvekonColors.darkText),
              decoration: InputDecoration(
                hintText: 'Nhập số CCCD/Hộ chiếu',
                fillColor: FuvekonColors.surfaceContainerHigh,
                suffixIcon: TextButton(
                  onPressed: isSaving ? null : onSave,
                  child: Text(isSaving ? 'Đang lưu...' : 'Lưu'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.selectedMethod,
    required this.title,
    required this.icon,
    required this.onChanged,
    this.subtitle,
    this.recommended = false,
  });

  final _PaymentMethod method;
  final _PaymentMethod selectedMethod;
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool recommended;
  final ValueChanged<_PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = method == selectedMethod;

    return InkWell(
      onTap: () => onChanged(method),
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            decoration: BoxDecoration(
              color: selected
                  ? FuvekonColors.surfaceContainerLow
                  : FuvekonColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? FuvekonColors.darkPrimary
                    : FuvekonColors.outlineVariantToken,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected
                      ? FuvekonColors.darkPrimary
                      : FuvekonColors.outlineToken,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Container(
                  width: 34,
                  height: 28,
                  decoration: BoxDecoration(
                    color: FuvekonColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 17,
                    color: selected
                        ? FuvekonColors.darkPrimary
                        : FuvekonColors.darkTextSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: FuvekonColors.darkText,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            color: FuvekonColors.darkTextSecondary,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (recommended)
            Positioned(
              right: 12,
              top: -9,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: FuvekonColors.sageGreenContainer,
                  borderRadius: BorderRadius.circular(FuvekonRadii.button),
                ),
                child: const Text(
                  'Khuyên dùng',
                  style: TextStyle(
                    color: FuvekonColors.onSurface,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderTotalCard extends StatelessWidget {
  const _OrderTotalCard({
    required this.subtotal,
    required this.fee,
    required this.total,
  });

  final String subtotal;
  final String fee;
  final String total;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          children: [
            _TotalRow(label: 'Tạm tính', value: subtotal),
            const SizedBox(height: 12),
            _TotalRow(label: 'Phí xử lý', value: fee),
            const SizedBox(height: 14),
            Divider(color: FuvekonColors.darkBorder.withValues(alpha: 0.6)),
            const SizedBox(height: 12),
            _TotalRow(label: 'Tổng cộng', value: total, prominent: true),
          ],
        ),
      ),
    );
  }
}

class _PaymentSuccessBody extends StatelessWidget {
  const _PaymentSuccessBody({
    required this.ticket,
    this.payableAmount,
    this.isUpgrade = false,
  });

  final dynamic ticket;
  final double? payableAmount;
  final bool isUpgrade;

  @override
  Widget build(BuildContext context) {
    final tier = ticket.tier;
    final rawPrice = payableAmount ?? tier?.price ?? 0;
    final total = formatTicketPriceVnd(rawPrice);

    return SafeArea(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
          children: [
            FuvekonIllustratedContentPanel(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FuvekonColors.sageGreenContainer.withValues(
                          alpha: 0.85,
                        ),
                        border: Border.all(
                          color: FuvekonColors.darkPrimary,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isUpgrade
                        ? 'Yêu cầu nâng cấp đã gửi!'
                        : 'Mua vé thành công!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: FuvekonColors.darkText,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isUpgrade
                        ? 'Cảm ơn bạn. BTC sẽ xác nhận khoản chênh lệch trong thời gian sớm nhất.'
                        : 'Cảm ơn bạn đã đặt vé. Hẹn gặp bạn tại sự kiện.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: FuvekonColors.darkTextSecondary,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _SuccessTicketCard(
                    ticketName: tier?.ticketName ?? '—',
                    referenceCode: ticket.referenceCode,
                    total: total,
                    purchasedAt: ticket.createdAt,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.go(Routes.accountTicket),
                    style: FilledButton.styleFrom(
                      backgroundColor: FuvekonColors.darkButton,
                      foregroundColor: FuvekonColors.darkButtonText,
                      minimumSize: const Size.fromHeight(52),
                    ),
                    icon: const Icon(
                      Icons.confirmation_number_outlined,
                      size: 18,
                    ),
                    label: const Text('Xem vé của tôi'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => context.go(Routes.account),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: FuvekonColors.dustyRose,
                      side: const BorderSide(color: FuvekonColors.dustyRose),
                      minimumSize: const Size.fromHeight(48),
                      shape: const StadiumBorder(),
                    ),
                    icon: const Icon(Icons.home_outlined, size: 18),
                    label: const Text('Về trang chủ'),
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

class _SuccessTicketCard extends StatelessWidget {
  const _SuccessTicketCard({
    required this.ticketName,
    required this.referenceCode,
    required this.total,
    required this.purchasedAt,
  });

  final String ticketName;
  final String referenceCode;
  final String total;
  final DateTime purchasedAt;

  @override
  Widget build(BuildContext context) {
    final colors = exploreTicketTextColors(ExploreTierStyle.premium);
    final dateLabel = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    ).format(purchasedAt.toLocal());

    return TicketExploreSurface(
      style: ExploreTierStyle.premium,
      highlighted: true,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'MÃ ĐƠN HÀNG',
                style: TextStyle(
                  color: colors.muted,
                  fontSize: 10,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                referenceCode.isNotEmpty ? '#$referenceCode' : '#FVK',
                style: TextStyle(
                  color: colors.title,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: FuvekonColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.confirmation_number_rounded,
                  color: colors.title,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppConfig.appName} — $ticketName',
                      style: TextStyle(
                        color: colors.body,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateLabel,
                      style: TextStyle(
                        color: colors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: colors.muted.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Số lượng',
                    style: TextStyle(
                      color: colors.muted,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    '1 Vé',
                    style: TextStyle(
                      color: colors.body,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Tổng tiền',
                    style: TextStyle(
                      color: colors.muted,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    total,
                    style: TextStyle(
                      color: colors.title,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.prominent = false,
  });

  final String label;
  final String value;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: prominent
                ? FuvekonColors.darkText
                : FuvekonColors.darkTextSecondary,
            fontSize: prominent ? 15 : 12,
            fontWeight: prominent ? FontWeight.w900 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: prominent
                ? FuvekonColors.darkPrimary
                : FuvekonColors.darkTextSecondary,
            fontSize: prominent ? 18 : 12,
            fontWeight: prominent ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

String _maskedContact(String value) {
  if (value.contains('@')) {
    final parts = value.split('@');
    final name = parts.first;
    final domain = parts.length > 1 ? parts[1] : '';
    final visible = name.length <= 3 ? name : name.substring(0, 3);
    return '$visible***@$domain';
  }

  if (value.length <= 4) return value;
  return '${value.substring(0, 3)}xxxx${value.substring(value.length - 2)}';
}

class _QueueProcessingBody extends StatelessWidget {
  const _QueueProcessingBody({this.attempt, this.maxAttempts});

  final int? attempt;
  final int? maxAttempts;

  @override
  Widget build(BuildContext context) {
    final progress = attempt != null && maxAttempts != null && maxAttempts! > 0
        ? attempt! / maxAttempts!
        : null;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: FuvekonColors.darkPrimary),
              const SizedBox(height: 24),
              const Text(
                'Đang xử lý đơn hàng...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FuvekonColors.darkPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                attempt != null && maxAttempts != null
                    ? 'Vui lòng đợi trong giây lát ($attempt/$maxAttempts)'
                    : 'Vui lòng đợi trong giây lát',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: FuvekonColors.darkTextSecondary,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              if (progress != null) ...[
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: FuvekonColors.darkTextSecondary.withValues(
                      alpha: 0.2,
                    ),
                    color: FuvekonColors.darkPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NotFoundBody extends StatelessWidget {
  const _NotFoundBody({
    required this.queued,
    required this.onRetry,
    required this.onBack,
  });

  final bool queued;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(
              queued
                  ? 'Ticket is still processing or no longer available.'
                  : 'Ticket not found.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            if (queued)
              FilledButton(onPressed: onRetry, child: const Text('Retry')),
            TextButton(onPressed: onBack, child: const Text('Back')),
          ],
        ),
      ),
    );
  }
}

class _DeniedBody extends StatelessWidget {
  const _DeniedBody({this.denialReason, required this.onBack});

  final String? denialReason;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel, size: 48, color: Colors.red.shade700),
            const SizedBox(height: 16),
            Text(
              'Your ticket was denied.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (denialReason?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(denialReason!, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: onBack, child: const Text('Back')),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
