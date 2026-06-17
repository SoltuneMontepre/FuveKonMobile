import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';

/// Màn 40 — identity verification placeholder (API TBD).
class VerifyIdentityPage extends StatelessWidget {
  const VerifyIdentityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;

    return AppPageScaffold(
      title: 'Xác minh danh tính',
      body: ListView(
        children: [
          const FuveSectionHeader(title: 'Xác thực tài khoản'),
          const SizedBox(height: FuvekonSpacing.stackGapMd),
          FuveMintCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.verified_user_outlined, color: ext.infoAccent, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tính năng đang phát triển',
                        style: TextStyle(
                          color: ext.contentOnCard,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Xác minh danh tính sẽ cho phép bạn gửi hồ sơ panel, talent, conbook và đăng ký gian hàng dealer.',
                  style: TextStyle(color: ext.contentOnCardMuted, height: 1.5),
                ),
                const SizedBox(height: 16),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: ext.notesSurface,
                    borderRadius: BorderRadius.circular(FuvekonRadii.notes),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: ext.infoAccent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'API xác minh danh tính chưa sẵn sàng trên mobile. '
                            'Hiện tại bạn có thể xác minh email qua OTP sau khi đăng ký.',
                            style: TextStyle(
                              color: ext.contentOnCardMuted,
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FuvekonSpacing.stackGapLg),
          FuveMintCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yêu cầu dự kiến',
                  style: TextStyle(
                    color: ext.contentOnCard,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                ...[
                  'Ảnh CMND/CCCD hoặc hộ chiếu',
                  'Ảnh selfie cầm giấy tờ',
                  'Thông tin khớp với hồ sơ tài khoản',
                ].map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ', style: TextStyle(color: ext.contentOnCardMuted)),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(color: ext.contentOnCardMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
