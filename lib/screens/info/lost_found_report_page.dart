import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/info/lost_found_models.dart';
import 'package:fuvekonmobile/screens/info/lost_found_service.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image_upload_field.dart';
import 'package:go_router/go_router.dart';

/// Màn 36 — lost item report at `/lost-found/report`.
class LostFoundReportPage extends StatefulWidget {
  const LostFoundReportPage({super.key});

  @override
  State<LostFoundReportPage> createState() => _LostFoundReportPageState();
}

class _LostFoundReportPageState extends State<LostFoundReportPage> {
  final _formKey = GlobalKey<FormState>();
  late final LostFoundService _service;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();

  String? _imageUrl;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _service = sl<LostFoundService>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      final item = await _service.report(
        LostFoundReportInput(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          location: _locationController.text.trim(),
          imageUrl: _imageUrl ?? '',
          contactInfo: _contactController.text.trim(),
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Đã gửi báo mất. Ban tổ chức sẽ liên hệ khi có thông tin.',
          ),
        ),
      );
      context.pushReplacement(Routes.lostFoundRequest(item.id));
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('ServerException: ', '');
      if (message.contains('ticket')) {
        _showTicketRequiredDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showTicketRequiredDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cần vé hợp lệ'),
        content: const Text(
          'Bạn cần đăng nhập và có vé đã được duyệt để gửi báo mất.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(Routes.login);
            },
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollPage(
      title: 'Báo mất đồ',
      wrapInCard: true,
      footer: FuvePillButton(
        label: _submitting ? 'Đang gửi...' : 'Gửi báo mất',
        icon: Icons.send_outlined,
        onPressed: _submitting ? null : _submit,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FuveSectionHeader(title: 'Thông tin vật phẩm'),
            const SizedBox(height: FuvekonSpacing.field),
            AppLabeledField(
              label: 'Tên / loại vật phẩm',
              required: true,
              field: TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Ví dụ: Balo đen, điện thoại iPhone...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên vật phẩm';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: FuvekonSpacing.field),
            AppLabeledField(
              label: 'Mô tả chi tiết',
              field: TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Màu sắc, nhãn hiệu, dấu hiệu nhận biết...',
                ),
              ),
            ),
            const SizedBox(height: FuvekonSpacing.section),
            const FuveSectionHeader(title: 'Thời gian & vị trí'),
            const SizedBox(height: FuvekonSpacing.field),
            AppLabeledField(
              label: 'Vị trí ước tính cuối cùng',
              field: TextFormField(
                controller: _locationController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Khu vực / phòng / quầy gần nhất...',
                ),
              ),
            ),
            const SizedBox(height: FuvekonSpacing.field),
            AppLabeledField(
              label: 'Liên hệ (tuỳ chọn)',
              field: TextFormField(
                controller: _contactController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Số điện thoại hoặc Telegram...',
                ),
              ),
            ),
            const SizedBox(height: FuvekonSpacing.section),
            const FuveSectionHeader(title: 'Hình ảnh'),
            const SizedBox(height: FuvekonSpacing.field),
            S3ImageUploadField(
              imageUrl: _imageUrl,
              onChanged: (url) => setState(() => _imageUrl = url),
              label: 'Tải ảnh vật phẩm (tuỳ chọn)',
            ),
            const SizedBox(height: FuvekonSpacing.section),
            const AppInfoSection(
              title: 'Lưu ý',
              items: [
                'Chỉ người có vé đã duyệt mới gửi được báo mất.',
                'Ban tổ chức sẽ đối chiếu với đồ nhặt được và liên hệ bạn.',
                'Mang giấy tờ tùy thân khi đến quầy nhận lại đồ.',
              ],
            ),
          ],
        ),
      ),
    );
  }
}
