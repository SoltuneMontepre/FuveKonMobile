import 'package:flutter/material.dart';
import 'package:fuvekonmobile/shared/widgets/placeholder_page.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Change Password',
      subtitle: 'Update your account password.',
      icon: Icons.lock_outline,
    );
  }
}

class AccountConbookPage extends StatelessWidget {
  const AccountConbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Conbook Submissions',
      subtitle: 'Your artbook / conbook submissions.',
      icon: Icons.collections_bookmark_outlined,
    );
  }
}

class AccountTalentPage extends StatelessWidget {
  const AccountTalentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Talent Status',
      subtitle: 'Talent registration status and details.',
      icon: Icons.mic_external_on_outlined,
    );
  }
}

class AccountPanelPage extends StatelessWidget {
  const AccountPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Panel Status',
      subtitle: 'Panel registration status and details.',
      icon: Icons.groups_outlined,
    );
  }
}

class AccountDealerPage extends StatelessWidget {
  const AccountDealerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Dealer Booth',
      subtitle: 'Dealer booth information and management.',
      icon: Icons.storefront_outlined,
    );
  }
}

class AccountDealerRegisterPage extends StatelessWidget {
  const AccountDealerRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Dealer Registration',
      subtitle: 'Apply for a dealer booth.',
      icon: Icons.app_registration_outlined,
    );
  }
}
