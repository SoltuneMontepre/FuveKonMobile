import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_error_l10n.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_ticket_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_tier_management_widgets.dart';

class AdminTierEditPage extends StatefulWidget {
  const AdminTierEditPage({super.key, this.tier});

  /// When null, creates a new tier.
  final AdminTicketTierItem? tier;

  bool get isCreate => tier == null;

  @override
  State<AdminTierEditPage> createState() => _AdminTierEditPageState();
}

class _AdminTierEditPageState extends State<AdminTierEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final AdminTicketService _service;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  final List<TextEditingController> _benefitControllers = [];

  double? _priceUsd;
  bool _isActive = true;
  bool _isVisible = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _service = sl<AdminTicketService>();
    final tier = widget.tier;
    _nameController = TextEditingController(text: tier?.ticketName ?? '');
    _descriptionController = TextEditingController(
      text: tier?.description ?? '',
    );
    _priceController = TextEditingController(
      text: tier != null && tier.price > 0 ? tier.price.toStringAsFixed(0) : '',
    );
    _stockController = TextEditingController(
      text: tier?.stock?.toString() ?? '',
    );
    _priceUsd = tier?.priceUsd;
    _isActive = tier?.isActive ?? true;
    _isVisible = tier?.isVisible ?? true;

    final benefits = tier?.benefits ?? const [];
    if (benefits.isEmpty) {
      _addBenefitRow();
    } else {
      for (final benefit in benefits) {
        _addBenefitRow(benefit);
      }
    }

    for (final controller in _allControllers) {
      controller.addListener(_onFormChanged);
    }
  }

  Iterable<TextEditingController> get _allControllers => [
    _nameController,
    _descriptionController,
    _priceController,
    _stockController,
    ..._benefitControllers,
  ];

  void _onFormChanged() => setState(() {});

  void _addBenefitRow([String text = '']) {
    final controller = TextEditingController(text: text);
    controller.addListener(_onFormChanged);
    setState(() => _benefitControllers.add(controller));
  }

  void _removeBenefitRow(int index) {
    if (_benefitControllers.length <= 1) {
      _benefitControllers.first.clear();
      setState(() {});
      return;
    }
    _benefitControllers[index].dispose();
    setState(() => _benefitControllers.removeAt(index));
  }

  @override
  void dispose() {
    for (final controller in _allControllers) {
      controller
        ..removeListener(_onFormChanged)
        ..dispose();
    }
    super.dispose();
  }

  double? _parsePrice(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  int? _parseStock(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned);
  }

  List<String> _collectBenefits() {
    return _benefitControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
  }

  AdminTicketTierInput? _buildInput() {
    if (!_formKey.currentState!.validate()) return null;

    final price = _parsePrice(_priceController.text);
    final stock = _parseStock(_stockController.text);
    if (price == null || stock == null) return null;

    return AdminTicketTierInput(
      ticketName: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      benefits: _collectBenefits(),
      price: price,
      priceUsd: _priceUsd,
      stock: stock,
      isActive: _isActive,
      isVisible: _isVisible,
    );
  }

  Future<void> _save() async {
    final input = _buildInput();
    if (input == null) return;

    setState(() => _saving = true);
    try {
      if (widget.isCreate) {
        await _service.createTier(input);
      } else {
        await _service.updateTier(widget.tier!.id, input);
      }
      if (!mounted) return;
      final l10n = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isCreate ? l10n.adminTierCreated : l10n.adminTierUpdated,
          ),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(formatAdminError(context.l10n, e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _fieldDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: FuvekonColors.darkSurfaceElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: FuvekonColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: FuvekonColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: FuvekonColors.darkPrimary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final previewPrice = _parsePrice(_priceController.text) ?? 0;
    final previewStock = _parseStock(_stockController.text) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isCreate ? l10n.adminTierEditCreate : l10n.adminTierEditEdit,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            FuvekonSpacing.page,
            8,
            FuvekonSpacing.page,
            32,
          ),
          children: [
            if (!widget.isCreate) ...[
              const AdminTierSystemWarning(),
              const SizedBox(height: 20),
            ],
            AdminTierFormField(
              label: l10n.adminTierNameLabel,
              child: TextFormField(
                controller: _nameController,
                decoration: _fieldDecoration(hint: l10n.adminTierNameHint),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) return l10n.adminTierNameRequired;
                  if (trimmed.length > 255) return l10n.adminTierMaxChars255;
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AdminTierFormField(
                    label: l10n.adminTierPriceLabel,
                    child: TextFormField(
                      controller: _priceController,
                      decoration: _fieldDecoration(hint: '1500000'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        final price = _parsePrice(value ?? '');
                        if (price == null) return l10n.adminTierEnterPrice;
                        if (price < 0) return l10n.adminTierInvalidPrice;
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AdminTierFormField(
                    label: l10n.adminTierStockLabel,
                    child: TextFormField(
                      controller: _stockController,
                      decoration: _fieldDecoration(hint: '100'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        final stock = _parseStock(value ?? '');
                        if (stock == null) return l10n.adminTierEnterStockQty;
                        if (stock < 0) return l10n.adminTierInvalidStock;
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AdminTierFormField(
              label: l10n.adminTierDescriptionLabel,
              child: TextFormField(
                controller: _descriptionController,
                decoration: _fieldDecoration(
                  hint: l10n.adminTierDescriptionHint,
                ),
                maxLines: 4,
                maxLength: 500,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.adminTierBenefitsList,
              style: theme.textTheme.labelLarge?.copyWith(
                color: FuvekonColors.darkTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < _benefitControllers.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        size: 20,
                        color: FuvekonColors.darkPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _benefitControllers[i],
                        decoration: _fieldDecoration(
                          hint: l10n.adminTierBenefitHint,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _saving ? null : () => _removeBenefitRow(i),
                      icon: Icon(
                        Icons.close_rounded,
                        color: FuvekonColors.darkTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _saving ? null : () => _addBenefitRow(),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.adminTierAddBenefit),
              ),
            ),
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                color: FuvekonColors.darkSurfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: FuvekonColors.darkBorder),
              ),
              child: SwitchListTile(
                title: Text(
                  l10n.adminTierSalesStatus,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: FuvekonColors.darkText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  l10n.adminTierAllowPurchaseSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: FuvekonColors.darkTextSecondary,
                  ),
                ),
                value: _isActive,
                activeThumbColor: FuvekonColors.darkCardText,
                activeTrackColor: FuvekonColors.available,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _isActive = value),
              ),
            ),
            const SizedBox(height: 12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: FuvekonColors.darkSurfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: FuvekonColors.darkBorder),
              ),
              child: SwitchListTile(
                title: Text(
                  l10n.adminTierVisibilityStatus,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: FuvekonColors.darkText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  l10n.adminTierVisibilitySubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: FuvekonColors.darkTextSecondary,
                  ),
                ),
                value: _isVisible,
                activeThumbColor: FuvekonColors.darkCardText,
                activeTrackColor: FuvekonColors.available,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _isVisible = value),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.adminTierPreview,
              style: theme.textTheme.titleSmall?.copyWith(
                color: FuvekonColors.darkText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            AdminTierFormPreview(
              ticketName: _nameController.text,
              price: previewPrice,
              description: _descriptionController.text,
              benefits: _collectBenefits(),
              stock: previewStock,
              isActive: _isActive,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: FuvekonColors.darkCard,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  widget.isCreate
                      ? l10n.adminTierSaveCreate
                      : l10n.adminTierSaveEdit,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: FuvekonColors.available,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _saving ? null : () => Navigator.maybePop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: FuvekonColors.darkText,
                side: BorderSide(color: FuvekonColors.darkBorder),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(l10n.adminTierDiscard),
            ),
          ],
        ),
      ),
    );
  }
}
