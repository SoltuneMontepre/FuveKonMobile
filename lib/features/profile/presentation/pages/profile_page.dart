import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_event.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_state.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/s3_avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.title = 'Profile'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(const ProfileEvent.started()),
      child: _ProfileView(title: title),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: title,
      showBackButton: false,
      padding: EdgeInsets.zero,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileInitial() || ProfileLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ProfileLoaded(:final account) => RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<ProfileBloc>()
                      .add(const ProfileEvent.refreshRequested());
                  await context.read<ProfileBloc>().stream.firstWhere(
                        (s) => s is ProfileLoaded || s is ProfileFailure,
                      );
                },
                child: _ProfileBody(account: account),
              ),
            ProfileFailure(:final message) => _ProfileError(
                message: message,
                onRetry: () {
                  context
                      .read<ProfileBloc>()
                      .add(const ProfileEvent.refreshRequested());
                },
              ),
          };
        },
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Column(
            children: [
              S3Avatar(
                imageUrl: account.avatar,
                initials: account.initials,
              ),
              const SizedBox(height: 16),
              Text(
                account.displayName ?? account.email,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              if (account.displayName != null) ...[
                const SizedBox(height: 4),
                Text(
                  account.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (account.isVerified == true) ...[
                const SizedBox(height: 12),
                Chip(
                  avatar: Icon(
                    Icons.verified,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  label: const Text('Verified'),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 32),
        _InfoSection(
          title: 'Account',
          children: [
            if (account.fursonaName != null && account.fursonaName!.isNotEmpty)
              _InfoTile(
                icon: Icons.pets_outlined,
                label: 'Nickname',
                value: account.fursonaName!,
              ),
            if (account.firstName != null && account.firstName!.isNotEmpty)
              _InfoTile(
                icon: Icons.badge_outlined,
                label: 'First name',
                value: account.firstName!,
              ),
            if (account.lastName != null && account.lastName!.isNotEmpty)
              _InfoTile(
                icon: Icons.badge_outlined,
                label: 'Last name',
                value: account.lastName!,
              ),
            _InfoTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: account.email,
            ),
            if (account.country != null && account.country!.isNotEmpty)
              _InfoTile(
                icon: Icons.public_outlined,
                label: 'Country',
                value: account.country!,
              ),
            _InfoTile(
              icon: Icons.credit_card_outlined,
              label: 'Passport/ID card',
              value: _displayOrPlaceholder(account.idCard),
            ),
            if (account.dateOfBirth != null && account.dateOfBirth!.isNotEmpty)
              _InfoTile(
                icon: Icons.cake_outlined,
                label: 'Date of birth',
                value: account.dateOfBirth!,
              ),
          ],
        ),
        if (account.isDealer == true || account.isHasTicket == true) ...[
          const SizedBox(height: 16),
          _InfoSection(
            title: 'Status',
            children: [
              if (account.isDealer == true)
                const _InfoTile(
                  icon: Icons.storefront_outlined,
                  label: 'Dealer',
                  value: 'Yes',
                ),
              if (account.isHasTicket == true)
                ListTile(
                  leading: const Icon(Icons.confirmation_number_outlined),
                  title: const Text('Ticket'),
                  subtitle: const Text('View your ticket'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(Routes.accountTicket),
                ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () async {
            final updated = await context.push<bool>(
              Routes.accountEdit,
              extra: account,
            );
            if (updated == true && context.mounted) {
              context.read<ProfileBloc>().add(
                    const ProfileEvent.refreshRequested(),
                  );
            }
          },
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit profile'),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: Icon(Icons.logout, color: colorScheme.error),
          title: Text(
            'Sign out',
            style: TextStyle(color: colorScheme.error),
          ),
          onTap: () {
            context.read<AuthBloc>().add(const AuthEvent.logoutRequested());
          },
        ),
      ],
    );
  }
}

String _displayOrPlaceholder(String? value) {
  if (value == null || value.trim().isEmpty) return '—';
  return value.trim();
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        AppContentCard(
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
