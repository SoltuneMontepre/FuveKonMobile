import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/utils/ticket_price.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_tier_detail_bloc.dart';
import 'package:go_router/go_router.dart';

class TicketTierDetailPage extends StatelessWidget {
  const TicketTierDetailPage({super.key, required this.tierId});

  final String tierId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TicketTierDetailBloc>()
        ..add(TicketTierDetailStarted(tierId)),
      child: const _TicketTierDetailView(),
    );
  }
}

class _TicketTierDetailView extends StatelessWidget {
  const _TicketTierDetailView();

  bool _isAuthenticated(AuthState state) =>
      state is AuthAuthenticated || state is AuthSessionRestored;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _DetailHeader(),
            Expanded(
              child: BlocBuilder<TicketTierDetailBloc, TicketTierDetailState>(
                builder: (context, state) {
                  return switch (state) {
                    TicketTierDetailInitial() || TicketTierDetailLoading() =>
                      const Center(child: CircularProgressIndicator()),
                    TicketTierDetailLoaded(
                      :final tier,
                      :final allTiers,
                    ) =>
                      _DetailBody(tier: tier, allTiers: allTiers),
                    TicketTierDetailFailure(:final message) => _ErrorBody(
                        message: message,
                        onRetry: () => context.read<TicketTierDetailBloc>().add(
                              TicketTierDetailStarted(
                                GoRouterState.of(context)
                                    .pathParameters['id']!,
                              ),
                            ),
                      ),
                  };
                },
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isAuth = _isAuthenticated(state);
                return _BottomCta(isAuthenticated: isAuth);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader();

  static const _brandColor = FuvekonColors.darkPrimary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 52, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(Routes.ticket);
              }
            },
            visualDensity: VisualDensity.compact,
          ),
          const Expanded(
            child: Text(
              'FUVEKON',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _brandColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailBody extends StatefulWidget {
  const _DetailBody({required this.tier, required this.allTiers});

  final TicketTier tier;
  final List<TicketTier> allTiers;

  @override
  State<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<_DetailBody> {
  String? _selectedCompareTierId;

  @override
  Widget build(BuildContext context) {
    final compareOptions = _compareOptions(widget.allTiers, widget.tier);
    final selectedCompareTier = _selectedCompareTier(compareOptions, widget.tier);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      children: [
        _TicketHeroCard(tier: widget.tier),
        const SizedBox(height: 28),
        _ComparisonCard(
          compareOptions: compareOptions,
          selectedCompareTier: selectedCompareTier,
          tier: widget.tier,
          onCompareTierChanged: (tierId) {
            if (tierId == null) return;
            setState(() => _selectedCompareTierId = tierId);
          },
        ),
      ],
    );
  }

  List<TicketTier> _compareOptions(List<TicketTier> allTiers, TicketTier tier) {
    final options = allTiers.where((item) => item.id != tier.id).toList()
      ..sort((a, b) => a.price.compareTo(b.price));
    return options.isEmpty ? [tier] : options;
  }

  TicketTier _selectedCompareTier(List<TicketTier> options, TicketTier tier) {
    for (final option in options) {
      if (option.id == _selectedCompareTierId) return option;
    }

    final standardTier = _standardTier(options);
    if (standardTier != null) return standardTier;

    return options.first;
  }

  TicketTier? _standardTier(List<TicketTier> tiers) {
    for (final tier in tiers) {
      final code = tier.tierCode.toUpperCase();
      final name = tier.ticketName.toLowerCase();
      if (code == 'T1' || name.contains('standard')) return tier;
    }
    return null;
  }
}

class _TicketHeroCard extends StatelessWidget {
  const _TicketHeroCard({required this.tier});

  final TicketTier tier;

  static const _cardBg = FuvekonColors.mintCard;
  static const _textDark = FuvekonColors.darkCardText;
  static const _muted = FuvekonColors.textSecondary;
  static const _badge = FuvekonColors.sageGreenContainer;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final config = _TierDetailConfig.from(tier);
    final description = tier.description.trim().isNotEmpty
        ? tier.description.trim()
        : config.description;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(26),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TierBanner(config: config),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _TierBadge(label: config.badge),
                      const Spacer(),
                      Text(
                        formatTierPrice(tier, locale: locale),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    config.title,
                    style: const TextStyle(
                      color: _textDark,
                      fontSize: 23,
                      height: 1.16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 14,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Colors.black.withValues(alpha: 0.18),
                    height: 1,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.l10n.ticketDetailBenefitsTitle,
                    style: const TextStyle(
                      color: _textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (final benefit in tier.benefits)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _BenefitRow(benefit: benefit),
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

class _TierBanner extends StatelessWidget {
  const _TierBanner({required this.config});

  final _TierDetailConfig config;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 136,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: config.bannerColors,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: CustomPaint(painter: _CurtainPainter()),
              ),
            ),
            Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: config.accent.withValues(alpha: 0.75),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    config.shortCode,
                    style: TextStyle(
                      color: config.accent,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurtainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    for (var x = 0.0; x < size.width; x += 14) {
      canvas.drawLine(Offset(x, 0), Offset(x + 10, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _TicketHeroCard._badge,
        borderRadius: BorderRadius.circular(FuvekonRadii.button),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.benefit});

  final String benefit;

  @override
  Widget build(BuildContext context) {
    final icon = _iconForBenefit(benefit);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: FuvekonColors.sageGreenContainer, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            benefit,
            style: const TextStyle(
              color: _TicketHeroCard._textDark,
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.compareOptions,
    required this.selectedCompareTier,
    required this.tier,
    required this.onCompareTierChanged,
  });

  final List<TicketTier> compareOptions;
  final TicketTier selectedCompareTier;
  final TicketTier tier;
  final ValueChanged<String?> onCompareTierChanged;

  @override
  Widget build(BuildContext context) {
    final rows = _comparisonRows(context, selectedCompareTier, tier);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    context.l10n
                        .ticketDetailCompareTitle(selectedCompareTier.ticketName),
                    style: const TextStyle(
                      color: FuvekonColors.darkPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _CompareTierDropdown(
                  options: compareOptions,
                  selectedTier: selectedCompareTier,
                  onChanged: onCompareTierChanged,
                ),
              ],
            ),
            const SizedBox(height: 18),
            _ComparisonHeader(
              standardLabel: selectedCompareTier.ticketName,
              tierLabel: tier.ticketName,
            ),
            const Divider(color: FuvekonColors.darkBorder, height: 18),
            for (final row in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: _ComparisonRow(row: row),
              ),
          ],
        ),
      ),
    );
  }
}

class _CompareTierDropdown extends StatelessWidget {
  const _CompareTierDropdown({
    required this.options,
    required this.selectedTier,
    required this.onChanged,
  });

  final List<TicketTier> options;
  final TicketTier selectedTier;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: FuvekonColors.darkBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedTier.id,
            dropdownColor: FuvekonColors.darkSurfaceElevated,
            borderRadius: BorderRadius.circular(16),
            iconEnabledColor: FuvekonColors.darkPrimary,
            style: const TextStyle(
              color: FuvekonColors.darkText,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
            items: [
              for (final tier in options)
                DropdownMenuItem(
                  value: tier.id,
                  child: Text(tier.ticketName),
                ),
            ],
            onChanged: options.length > 1 ? onChanged : null,
          ),
        ),
      ),
    );
  }
}

class _ComparisonHeader extends StatelessWidget {
  const _ComparisonHeader({
    required this.standardLabel,
    required this.tierLabel,
  });

  final String standardLabel;
  final String tierLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 5, child: SizedBox.shrink()),
        Expanded(
          flex: 3,
          child: Text(
            standardLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: FuvekonColors.darkTextSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            tierLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: FuvekonColors.darkPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({required this.row});

  final _Comparison row;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            row.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(flex: 3, child: _ComparisonValue(value: row.standard)),
        Expanded(flex: 3, child: _ComparisonValue(value: row.current)),
      ],
    );
  }
}

class _ComparisonValue extends StatelessWidget {
  const _ComparisonValue({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    if (value == '✓' || value == 'x') {
      return Icon(
        value == '✓' ? Icons.check_rounded : Icons.close_rounded,
        color: value == '✓'
            ? FuvekonColors.lightGold
            : FuvekonColors.darkTextSecondary,
        size: 18,
      );
    }

    return Text(
      value,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: FuvekonColors.darkTextSecondary,
        fontSize: 13,
        height: 1.25,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _BottomCta extends StatelessWidget {
  const _BottomCta({required this.isAuthenticated});

  final bool isAuthenticated;

  static const _ctaColor = FuvekonColors.darkButton;
  static const _ctaTextColor = FuvekonColors.darkButtonText;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: FuvekonColors.darkSurface,
        border: Border(top: BorderSide(color: FuvekonColors.darkBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.ticketDetailTotal,
                    style: const TextStyle(
                      color: FuvekonColors.darkTextSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  BlocBuilder<TicketTierDetailBloc, TicketTierDetailState>(
                    builder: (context, state) {
                      final price = state is TicketTierDetailLoaded
                          ? formatTierPrice(
                              state.tier,
                              locale: Localizations.localeOf(context),
                            )
                          : '';
                      return Text(
                        price,
                        style: const TextStyle(
                          color: FuvekonColors.darkPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            FilledButton(
              onPressed: () => context.go(
                isAuthenticated ? Routes.ticketPurchase : Routes.register,
              ),
              style: FilledButton.styleFrom(
                backgroundColor: _ctaColor,
                foregroundColor: _ctaTextColor,
                minimumSize: const Size(172, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(FuvekonRadii.button),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isAuthenticated
                        ? l10n.exploreTicketsBuyCta
                        : l10n.exploreTicketsRegisterCta,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: FuvekonColors.darkTextSecondary),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: Text(context.l10n.exploreTicketsRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _TierDetailConfig {
  const _TierDetailConfig({
    required this.title,
    required this.badge,
    required this.shortCode,
    required this.description,
    required this.bannerColors,
    required this.accent,
  });

  final String title;
  final String badge;
  final String shortCode;
  final String description;
  final List<Color> bannerColors;
  final Color accent;

  factory _TierDetailConfig.from(TicketTier tier) {
    final code = tier.tierCode.toUpperCase();
    final name = tier.ticketName.toUpperCase();

    if (code == 'T2' || name.contains('VIP')) {
      return _TierDetailConfig(
        title: '${tier.ticketName} Ticket - FUVEKON 2024',
        badge: 'PREMIUM',
        shortCode: 'II',
        description:
            'Trải nghiệm lễ hội trọn vẹn với các đặc quyền ưu tiên. Đắm chìm trong không gian nghệ thuật cao cấp và tận hưởng dịch vụ hàng đầu.',
        bannerColors: const [
          FuvekonColors.surfaceContainerLow,
          FuvekonColors.mintCard,
          FuvekonColors.sageGreenContainer,
        ],
        accent: FuvekonColors.lightGold,
      );
    }

    if (name.contains('SUPER')) {
      return _TierDetailConfig(
        title: '${tier.ticketName} Ticket - FUVEKON 2024',
        badge: 'ELITE',
        shortCode: 'IV',
        description:
            'Gói trải nghiệm cao nhất với bộ quà tặng giới hạn, quyền lợi ưu tiên và các đặc quyền dành riêng cho người đồng hành đặc biệt.',
        bannerColors: const [
          FuvekonColors.surfaceContainerLow,
          FuvekonColors.dustyRoseContainer,
          FuvekonColors.lightGold,
        ],
        accent: const Color(0xFFFFE088),
      );
    }

    if (name.contains('SPONSOR')) {
      return _TierDetailConfig(
        title: '${tier.ticketName} Ticket - FUVEKON 2024',
        badge: 'SPECIAL',
        shortCode: 'III',
        description:
            'Nâng cấp hành trình tham dự với nhiều vật phẩm kỷ niệm, check-in ưu tiên và trải nghiệm sự kiện chỉn chu hơn.',
        bannerColors: const [
          FuvekonColors.surfaceContainerLow,
          FuvekonColors.goldContainer,
          FuvekonColors.mintCard,
        ],
        accent: const Color(0xFFFFE088),
      );
    }

    return _TierDetailConfig(
      title: '${tier.ticketName} Ticket - FUVEKON 2024',
      badge: 'BASIC',
      shortCode: 'I',
      description:
          'Tấm vé tiêu chuẩn để tham gia không gian triển lãm, nhận badge và các vật phẩm cơ bản của sự kiện.',
      bannerColors: const [
        FuvekonColors.surfaceContainerHigh,
        FuvekonColors.mintCard,
        FuvekonColors.sageGreen,
      ],
      accent: FuvekonColors.sageGreenContainer,
    );
  }
}

class _Comparison {
  const _Comparison({
    required this.label,
    required this.standard,
    required this.current,
  });

  final String label;
  final String standard;
  final String current;
}

List<_Comparison> _comparisonRows(
  BuildContext context,
  TicketTier standard,
  TicketTier tier,
) {
  final l10n = context.l10n;
  final standardBenefits = standard.benefits.map((e) => e.toLowerCase()).toList();
  final tierBenefits = tier.benefits.map((e) => e.toLowerCase()).toList();

  final standardMerch = _extraMerchCount(standardBenefits);
  final tierMerch = _extraMerchCount(tierBenefits);

  return [
    _Comparison(
      label: l10n.ticketDetailCompareAccess,
      standard: _hasAny(standardBenefits, ['event pass']) ? '1-Day' : 'x',
      current: _hasAny(tierBenefits, ['event pass']) ? '1-Day' : 'x',
    ),
    _Comparison(
      label: l10n.ticketDetailCompareCheckIn,
      standard: _hasAny(standardBenefits, ['priority check-in'])
          ? l10n.ticketDetailComparePriority
          : l10n.ticketDetailCompareShared,
      current: _hasAny(tierBenefits, ['priority check-in'])
          ? l10n.ticketDetailComparePriority
          : l10n.ticketDetailCompareShared,
    ),
    _Comparison(
      label: l10n.ticketDetailCompareBadge,
      standard: _hasAny(standardBenefits, ['custom'])
          ? l10n.ticketDetailCompareCustom
          : l10n.ticketDetailCompareNormal,
      current: _hasAny(tierBenefits, ['custom'])
          ? l10n.ticketDetailCompareCustom
          : l10n.ticketDetailCompareNormal,
    ),
    _Comparison(
      label: l10n.ticketDetailCompareGifts,
      standard: standardMerch > 0 ? '$standardMerch' : 'x',
      current: tierMerch > standardMerch ? '✓' : '$tierMerch',
    ),
  ];
}

bool _hasAny(List<String> values, List<String> needles) {
  return values.any((value) => needles.any(value.contains));
}

int _extraMerchCount(List<String> benefits) {
  const excluded = ['event pass', 'name badge', 'priority check-in'];
  return benefits.where((benefit) {
    return !excluded.any(benefit.contains);
  }).length;
}

IconData _iconForBenefit(String benefit) {
  final value = benefit.toLowerCase();
  if (value.contains('check-in')) return Icons.move_to_inbox_rounded;
  if (value.contains('badge')) return Icons.badge_rounded;
  if (value.contains('shirt')) return Icons.checkroom_rounded;
  if (value.contains('photo')) return Icons.photo_camera_rounded;
  if (value.contains('print') || value.contains('conbook')) {
    return Icons.collections_bookmark_rounded;
  }
  if (value.contains('lanyard') || value.contains('keychain')) {
    return Icons.local_offer_rounded;
  }
  return Icons.card_giftcard_rounded;
}
