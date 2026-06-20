import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image_upload_field.dart';

class DealerRegistrationFormFields extends StatelessWidget {
  const DealerRegistrationFormFields({
    super.key,
    required this.nameController,
    required this.descController,
    required this.priceSheetUrls,
    required this.onPriceSheetsChanged,
    required this.enabled,
  });

  final TextEditingController nameController;
  final TextEditingController descController;
  final List<String> priceSheetUrls;
  final ValueChanged<List<String>> onPriceSheetsChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppLabeledField(
          label: 'Tên gian hàng',
          required: true,
          field: TextFormField(
            controller: nameController,
            enabled: enabled,
            decoration: const InputDecoration(
              hintText: 'VD: Furry Art Corner',
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập tên gian hàng' : null,
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'Mô tả',
          required: true,
          field: TextFormField(
            controller: descController,
            enabled: enabled,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Sản phẩm / dịch vụ',
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập mô tả' : null,
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        S3MultiImageUploadField(
          imageUrls: priceSheetUrls,
          onChanged: onPriceSheetsChanged,
          enabled: enabled,
          label: 'Bảng giá',
          hint: 'Tải lên tối đa 5 ảnh bảng giá (JPEG, PNG, WebP)',
        ),
      ],
    );
  }
}

String? validateDealerPriceSheets(List<String> urls) {
  if (urls.isEmpty) {
    return 'Tải lên ít nhất 1 ảnh bảng giá';
  }
  if (urls.length > 5) {
    return 'Tối đa 5 ảnh bảng giá';
  }
  return null;
}
