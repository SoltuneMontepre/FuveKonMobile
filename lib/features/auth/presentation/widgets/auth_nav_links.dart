import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:go_router/go_router.dart';

class AuthNavLinks extends StatelessWidget {
  const AuthNavLinks({
    super.key,
    this.leading,
    this.trailing,
  });

  final AuthNavLink? leading;
  final AuthNavLink? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = context.fuvekonTheme;
    final linkStyle = theme.textTheme.bodyMedium?.copyWith(
      color: ext.link,
      fontWeight: FontWeight.w600,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null)
          TextButton(
            onPressed: () => context.go(leading!.route),
            child: Text(leading!.label, style: linkStyle),
          ),
        if (leading != null && trailing != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text('|', style: theme.textTheme.bodySmall),
          ),
        if (trailing != null)
          TextButton(
            onPressed: () => context.go(trailing!.route),
            child: Text(trailing!.label, style: linkStyle),
          ),
      ],
    );
  }
}

class AuthNavLink {
  const AuthNavLink({required this.label, required this.route});

  final String label;
  final String route;
}

class LoginNavLinks extends StatelessWidget {
  const LoginNavLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Text(
          l10n.loginNoAccount,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextButton(
          onPressed: () => context.go(Routes.register),
          style: TextButton.styleFrom(
            foregroundColor: FuvekonColors.darkPrimary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            l10n.loginRegisterLink,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterNavLinks extends StatelessWidget {
  const RegisterNavLinks({super.key});

  static const _textDark = FuvekonColors.darkButtonText;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          l10n.registerHasAccount,
          style: TextStyle(
            color: _textDark.withValues(alpha: 0.65),
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () => context.go(Routes.login),
          style: TextButton.styleFrom(
            foregroundColor: _textDark,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            l10n.registerLoginLink,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.5,
            ),
          ),
        ),
      ],
    );
  }
}
