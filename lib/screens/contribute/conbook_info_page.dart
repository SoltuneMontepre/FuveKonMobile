import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';
import 'package:go_router/go_router.dart';

/// Màn 30 — static conbook info page linked from shortcuts.
class ConbookInfoPage extends StatelessWidget {
  const ConbookInfoPage({super.key, this.showSubmitButton = true});

  final bool showSubmitButton;

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;

    return AppPageScaffold(
      title: 'Conbook FUVEKON',
      body: ListView(
        children: [
          FuveMintCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FUVEKON Conbook',
                  style: TextStyle(
                    color: ext.contentOnCard,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ấn phẩm kỷ niệm tập hợp tác phẩm từ cộng đồng furry Việt Nam.',
                  style: TextStyle(color: ext.contentOnCardMuted, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: FuvekonSpacing.stackGapLg),
          const FuveSectionHeader(title: 'Quy định gửi bài'),
          const SizedBox(height: FuvekonSpacing.stackGapMd),
          FuveMintCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...[
                  'Ảnh gốc, độ phân giải tối thiểu 300 DPI',
                  'Nội dung phù hợp PG-13, không vi phạm bản quyền',
                  'Mỗi tài khoản gửi tối đa theo hạn mức sự kiện',
                  'Ban tổ chức có quyền từ chối bài không đạt yêu cầu',
                ].map(
                  (rule) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ', style: TextStyle(color: ext.contentOnCardMuted)),
                        Expanded(
                          child: Text(rule, style: TextStyle(color: ext.contentOnCard)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FuvekonSpacing.stackGapLg),
          AppInfoSection(
            title: 'Lưu ý',
            items: const [
              'Hồ sơ conbook được duyệt trước khi in ấn.',
              'Theo dõi trạng thái tại mục Hồ sơ đã gửi trong tài khoản.',
            ],
          ),
          if (showSubmitButton) ...[
            const SizedBox(height: FuvekonSpacing.stackGapLg),
            FuvePillButton(
              label: 'Gửi ảnh conbook',
              icon: Icons.upload_outlined,
              onPressed: () => context.push(Routes.artbookSubmit),
            ),
          ],
        ],
      ),
    );
  }
}
