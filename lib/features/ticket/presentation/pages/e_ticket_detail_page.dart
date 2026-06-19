import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/ticket/presentation/models/my_ticket_list_item.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/explore_ticket_tier_card.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ETicketDetailPage extends StatelessWidget {
  const ETicketDetailPage({super.key, required this.args});

  final ETicketDetailArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DetailHeader(onBack: () => context.pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TicketPassCard(args: args, l10n: l10n),
                    const SizedBox(height: 20),
                    _BenefitsSection(
                      title: l10n.eTicketBenefitsTitle(args.tierLabel),
                      benefits: args.benefits,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (args.listItem.userTicket != null) ...[
                    OutlinedButton.icon(
                      onPressed: () => context.push(Routes.accountTicketUpgrade),
                      icon: const Icon(Icons.north_east, size: 18),
                      label: Text(l10n.eTicketUpgrade),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.eTicketWalletSoon)),
                      );
                    },
                    icon: const Icon(Icons.account_balance_wallet_outlined, size: 18),
                    label: Text(l10n.eTicketSaveWallet),
                    style: FilledButton.styleFrom(
                      backgroundColor: FuvekonColors.darkSurfaceElevated,
                      foregroundColor: FuvekonColors.darkText,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
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

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBack,
            visualDensity: VisualDensity.compact,
          ),
          const Expanded(
            child: Text(
              'FUVEKON',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: FuvekonColors.darkPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _TicketPassCard extends StatelessWidget {
  const _TicketPassCard({required this.args, required this.l10n});

  final ETicketDetailArgs args;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    const style = ExploreTierStyle.premium;
    final colors = exploreTicketTextColors(style);

    return CustomPaint(
      painter: _TicketPerforationPainter(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TicketExploreSurface(
          style: style,
          highlighted: true,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.eTicketEventLabel,
                          style: TextStyle(
                            color: colors.muted,
                            fontSize: 12,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'FUVEKON 2024',
                          style: TextStyle(
                            color: colors.title,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (args.isValid) _ValidBadge(label: l10n.eTicketValid),
                ],
              ),
              const SizedBox(height: 20),
              _InfoLine(label: l10n.eTicketOwner, value: args.ownerName, colors: colors),
              const SizedBox(height: 10),
              _InfoLine(
                label: l10n.eTicketTier,
                value: args.tierLabel,
                colors: colors,
                trailing: const Icon(
                  Icons.star_rounded,
                  color: FuvekonColors.lightGold,
                  size: 18,
                ),
              ),
              const SizedBox(height: 10),
              _InfoLine(label: l10n.eTicketDay, value: args.eventDayLabel, colors: colors),
              const SizedBox(height: 18),
              Divider(
                color: colors.muted.withValues(alpha: 0.25),
                height: 1,
              ),
              const SizedBox(height: 18),
              Text(
                l10n.eTicketScanHint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.muted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: FuvekonColors.lightGold.withValues(alpha: 0.25),
                    ),
                  ),
                  child: QrImageView(
                    data: args.referenceCode,
                    version: QrVersions.auto,
                    backgroundColor: Colors.white,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Colors.black87,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.eTicketCodeLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.muted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    args.referenceCode,
                    style: TextStyle(
                      color: colors.title,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
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

class _ValidBadge extends StatelessWidget {
  const _ValidBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: FuvekonColors.available.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 14, color: FuvekonColors.available),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: FuvekonColors.available,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.label,
    required this.value,
    required this.colors,
    this.trailing,
  });

  final String label;
  final String value;
  final ({Color title, Color body, Color muted}) colors;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: Text(
            label,
            style: TextStyle(
              color: colors.muted,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: colors.title,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _BenefitsSection extends StatelessWidget {
  const _BenefitsSection({required this.title, required this.benefits});

  final String title;
  final List<String> benefits;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FuvekonColors.darkBorder.withValues(alpha: 0.45)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_offer_outlined, color: FuvekonColors.lightGold, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: FuvekonColors.darkText,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            for (final benefit in benefits)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check,
                      size: 16,
                      color: FuvekonColors.lightGold,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        benefit,
                        style: TextStyle(
                          color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.95),
                          fontSize: 13,
                          height: 1.45,
                        ),
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

class _TicketPerforationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = FuvekonColors.darkBg
      ..style = PaintingStyle.fill;

    const radius = 8.0;
    const count = 9;
    final spacing = size.height / (count + 1);

    for (var i = 1; i <= count; i++) {
      final y = spacing * i;
      canvas.drawCircle(Offset(0, y), radius, paint);
      canvas.drawCircle(Offset(size.width, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
