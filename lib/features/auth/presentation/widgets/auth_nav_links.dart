import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
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
    return const AuthNavLinks(
      leading: AuthNavLink(label: 'Create account', route: Routes.register),
      trailing: AuthNavLink(label: 'Forgot password?', route: Routes.forgotPassword),
    );
  }
}
