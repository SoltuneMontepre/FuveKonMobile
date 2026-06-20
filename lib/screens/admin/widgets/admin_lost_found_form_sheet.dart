import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_error_l10n.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_lost_found_service.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image_upload_field.dart';

class AdminLostFoundFormSheet extends StatefulWidget {
  const AdminLostFoundFormSheet({
    super.key,
    this.item,
    required this.onSubmit,
  });

  final AdminLostFoundItem? item;
  final Future<void> Function(CreateLostFoundInput input) onSubmit;

  @override
  State<AdminLostFoundFormSheet> createState() =>
      _AdminLostFoundFormSheetState();
}

class _AdminLostFoundFormSheetState extends State<AdminLostFoundFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _contactController;
  late final TextEditingController _staffNotesController;
  late String _itemType;
  String? _imageUrl;
  bool _submitting = false;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _itemType = item?.itemType ?? 'found';
    _titleController = TextEditingController(text: item?.title ?? '');
    _descriptionController =
        TextEditingController(text: item?.description ?? '');
    _locationController = TextEditingController(text: item?.location ?? '');
    _contactController = TextEditingController(text: item?.contactInfo ?? '');
    _staffNotesController =
        TextEditingController(text: item?.staffNotes ?? '');
    _imageUrl = item?.imageUrl.isNotEmpty == true ? item!.imageUrl : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _staffNotesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(
        CreateLostFoundInput(
          itemType: _itemType,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          location: _locationController.text.trim(),
          imageUrl: _imageUrl ?? '',
          contactInfo: _contactController.text.trim(),
          staffNotes: _staffNotesController.text.trim(),
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(formatAdminError(context.l10n, e))),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
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
                _isEditing
                    ? l10n.adminLostFoundFormEditTitle
                    : l10n.adminLostFoundFormTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: FuvekonColors.darkText,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _itemType,
                decoration: InputDecoration(labelText: l10n.adminLostFoundFormType),
                dropdownColor: FuvekonColors.darkSurfaceElevated,
                items: [
                  DropdownMenuItem(
                    value: 'found',
                    child: Text(l10n.adminLostFoundTypeFound),
                  ),
                  DropdownMenuItem(
                    value: 'lost',
                    child: Text(l10n.adminLostFoundTypeLost),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) _itemType = value;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: '${l10n.adminLostFoundFormTitleLabel} *',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.adminLostFoundFormRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.adminLostFoundFormDescription,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: l10n.adminLostFoundFormLocation,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(
                  labelText: l10n.adminLostFoundFormContact,
                ),
              ),
              const SizedBox(height: 12),
              S3ImageUploadField(
                imageUrl: _imageUrl,
                folder: 'lost-found',
                label: l10n.adminLostFoundFormImage,
                enabled: !_submitting,
                onChanged: (url) => setState(() => _imageUrl = url),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _staffNotesController,
                decoration: InputDecoration(
                  labelText: l10n.adminLostFoundFormNotes,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _isEditing
                            ? l10n.adminSaveChanges
                            : l10n.adminLostFoundFormAddItem,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
