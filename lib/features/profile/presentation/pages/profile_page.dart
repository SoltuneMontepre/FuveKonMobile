import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_event.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_state.dart';
import 'package:fuvekonmobile/shared/widgets/admin_surface_widgets.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';
import 'package:fuvekonmobile/shared/widgets/s3_avatar.dart';

/// Profile tab — admin-style dark surface layout.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(const ProfileEvent.started()),
      child: _ProfileView(title: title ?? context.l10n.navAccount),
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
                  context.read<ProfileBloc>().add(
                        const ProfileEvent.refreshRequested(),
                      );
                  await context.read<ProfileBloc>().stream.firstWhere(
                        (s) => s is ProfileLoaded || s is ProfileFailure,
                      );
                },
                child: _ProfileBody(account: account),
              ),
            ProfileFailure(:final message) => _ProfileError(
                message: message,
                onRetry: () {
                  context.read<ProfileBloc>().add(
                        const ProfileEvent.refreshRequested(),
                      );
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
    final isVerified = account.isVerified == true;

    return ListView(
      padding: const EdgeInsets.all(FuvekonSpacing.page),
      children: [
        AdminSurfaceCard(
          child: Column(
            children: [
              S3Avatar(
                imageUrl: account.avatar,
                initials: account.initials,
                radius: 44,
              ),
              const SizedBox(height: 14),
              Text(
                account.displayName ?? account.email,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: FuvekonColors.darkText,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              if (account.displayName != null) ...[
                const SizedBox(height: 4),
                Text(
                  account.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: FuvekonColors.darkTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 12),
              FuveStatusBadge(
                label: isVerified ? 'Đã xác minh email' : 'Chưa xác minh',
                variant: isVerified
                    ? FuveStatusBadgeVariant.success
                    : FuveStatusBadgeVariant.pending,
                icon: isVerified
                    ? Icons.verified
                    : Icons.mark_email_unread_outlined,
              ),
            ],
          ),
        ),
        const SizedBox(height: FuvekonSpacing.stackGapLg),
        const AdminSectionHeader(title: 'Thông tin tài khoản'),
        AdminSurfaceCard(
          child: Column(
            children: [
              AdminInfoRow(label: 'Nickname', value: account.fursonaName),
              AdminInfoRow(label: 'Họ tên', value: _fullName(account)),
              AdminInfoRow(label: 'Email', value: account.email),
              AdminInfoRow(label: 'Quốc gia', value: account.country),
              AdminInfoRow(
                label: 'CMND/Hộ chiếu',
                value: _displayOrPlaceholder(account.idCard),
              ),
              AdminInfoRow(label: 'Ngày sinh', value: account.dateOfBirth),
            ],
          ),
        ),
        if (account.isDealer == true || account.isHasTicket == true) ...[
          const SizedBox(height: FuvekonSpacing.stackGapLg),
          const AdminSectionHeader(title: 'Trạng thái'),
          AdminSurfaceCard(
            child: Column(
              children: [
                if (account.isDealer == true)
                  AdminActionTile(
                    icon: Icons.storefront_outlined,
                    title: 'Gian hàng dealer',
                    subtitle: 'Quản lý booth và nhân viên',
                    onTap: () => context.push(Routes.accountDealer),
                  ),
                if (account.isDealer == true && account.isHasTicket == true)
                  const SizedBox(height: 8),
                if (account.isHasTicket == true)
                  AdminActionTile(
                    icon: Icons.confirmation_number_outlined,
                    title: 'Vé của tôi',
                    subtitle: 'Xem vé và QR check-in',
                    onTap: () => context.go(Routes.accountTicket),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: FuvekonSpacing.stackGapLg),
        const AdminSectionHeader(title: 'Hồ sơ & đăng ký'),
        AdminSurfaceCard(
          child: Column(
            children: [
              AdminActionTile(
                icon: Icons.folder_shared_outlined,
                title: 'Hồ sơ đã gửi',
                subtitle: 'Panel, talent, conbook',
                onTap: () => context.push(Routes.accountSubmissions),
              ),
              const SizedBox(height: 8),
              AdminActionTile(
                icon: Icons.menu_book_outlined,
                title: 'Thông tin conbook',
                subtitle: 'Quy định và gửi bài',
                onTap: () => context.push(Routes.artbook),
              ),
            ],
          ),
        ),
        const SizedBox(height: FuvekonSpacing.stackGapLg),
        const AdminSectionHeader(title: 'Cài đặt tài khoản'),
        AdminSurfaceCard(
          child: Column(
            children: [
              AdminActionTile(
                icon: Icons.edit_outlined,
                title: 'Chỉnh sửa hồ sơ',
                onTap: () async {
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
              ),
              const SizedBox(height: 8),
              AdminActionTile(
                icon: Icons.verified_user_outlined,
                title: 'Xác minh danh tính',
                subtitle: 'API đang phát triển',
                onTap: () => context.push(Routes.accountVerifyIdentity),
              ),
              const SizedBox(height: 8),
              AdminActionTile(
                icon: Icons.lock_outline,
                title: 'Đổi mật khẩu',
                onTap: () => context.push(Routes.accountChangePassword),
              ),
              const SizedBox(height: 8),
              AdminActionTile(
                icon: Icons.settings_outlined,
                title: 'Cài đặt ứng dụng',
                subtitle: 'Ngôn ngữ',
                onTap: () => context.push(Routes.accountSettings),
              ),
            ],
          ),
        ),
        const SizedBox(height: FuvekonSpacing.stackGapLg),
        FuvePillButton(
          label: 'Đăng xuất',
          icon: Icons.logout,
          variant: FuvePillButtonVariant.outline,
          onPressed: () {
            context.read<AuthBloc>().add(const AuthEvent.logoutRequested());
          },
        ),
      ],
    );
  }
}

String? _fullName(Account account) {
  final parts = [
    account.firstName,
    account.lastName,
  ].whereType<String>().where((s) => s.isNotEmpty);
  final joined = parts.join(' ').trim();
  return joined.isEmpty ? null : joined;
}

String _displayOrPlaceholder(String? value) {
  if (value == null || value.trim().isEmpty) return '—';
  return value.trim();
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.message, required this.onRetry});

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
            FuvePillButton(
              label: 'Thử lại',
              icon: Icons.refresh,
              expanded: false,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
