import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';

class AuthHero extends StatelessWidget {
  const AuthHero({
    super.key,
    required this.title,
    required this.subtitle,
  });

  static const _logoAsset = 'assets/images/logo/logo_2026.webp';

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = context.fuvekonTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          _logoAsset,
          width: 220,
          fit: BoxFit.contain,
          semanticLabel: AppConfig.appName,
          errorBuilder: (context, error, stackTrace) => _LogoFallback(
            color: ext.appBarTitle,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: ext.appBarTitle,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppConfig.appName.toUpperCase(),
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
      textAlign: TextAlign.center,
    );
  }
}
