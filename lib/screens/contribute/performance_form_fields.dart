import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';

class PerformanceFormFields extends StatelessWidget {
  const PerformanceFormFields({
    super.key,
    required this.titleController,
    required this.nicknameController,
    required this.genreController,
    required this.introController,
    required this.driveController,
    required this.repUrlController,
    required this.memberNameController,
    required this.enabled,
  });

  final TextEditingController titleController;
  final TextEditingController nicknameController;
  final TextEditingController genreController;
  final TextEditingController introController;
  final TextEditingController driveController;
  final TextEditingController repUrlController;
  final TextEditingController memberNameController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppLabeledField(
          label: 'Tiêu đề tiết mục',
          required: true,
          field: TextFormField(
            controller: titleController,
            enabled: enabled,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập tiêu đề' : null,
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'Nickname',
          required: true,
          field: TextFormField(
            controller: nicknameController,
            enabled: enabled,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập nickname' : null,
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'Thể loại',
          required: true,
          field: TextFormField(
            controller: genreController,
            enabled: enabled,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập thể loại' : null,
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'Giới thiệu',
          required: true,
          field: TextFormField(
            controller: introController,
            enabled: enabled,
            maxLines: 4,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập giới thiệu' : null,
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'URL ảnh đại diện',
          required: true,
          field: TextFormField(
            controller: repUrlController,
            enabled: enabled,
            keyboardType: TextInputType.url,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Nhập URL ảnh';
              if (!v.startsWith('http')) return 'URL không hợp lệ';
              return null;
            },
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'Link tài liệu (Google Drive)',
          required: true,
          field: TextFormField(
            controller: driveController,
            enabled: enabled,
            keyboardType: TextInputType.url,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Nhập link tài liệu';
              if (!v.startsWith('http')) return 'URL không hợp lệ';
              return null;
            },
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'Tên thành viên',
          required: true,
          field: TextFormField(
            controller: memberNameController,
            enabled: enabled,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập tên thành viên' : null,
          ),
        ),
      ],
    );
  }
}
