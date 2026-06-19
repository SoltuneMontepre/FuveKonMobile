import 'package:flutter/material.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_illustrated_background.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';

class ForgotPasswordPageLayout extends StatelessWidget {
  const ForgotPasswordPageLayout({
    super.key,
    required this.form,
    required this.footer,
  });

  final Widget form;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return FuvekonNavScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: FuvekonIllustratedContentPanel(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                form,
                const SizedBox(height: 20),
                footer,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
