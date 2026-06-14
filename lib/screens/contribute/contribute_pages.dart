import 'package:flutter/material.dart';
import 'package:fuvekonmobile/shared/widgets/placeholder_page.dart';

class TalentRegistrationPage extends StatelessWidget {
  const TalentRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Talent Registration',
      subtitle: 'Rules and talent application form.',
      icon: Icons.mic_external_on_outlined,
    );
  }
}

class PanelRegistrationPage extends StatelessWidget {
  const PanelRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Panel Registration',
      subtitle: 'Panel rules and submission card.',
      icon: Icons.groups_outlined,
    );
  }
}

class ArtbookSubmissionPage extends StatelessWidget {
  const ArtbookSubmissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Artbook Submission',
      subtitle: 'Conbook rules and submission card.',
      icon: Icons.menu_book_outlined,
    );
  }
}

class DealerRegistrationPage extends StatelessWidget {
  const DealerRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Dealer Registration',
      subtitle: 'Dealer rules and application form.',
      icon: Icons.storefront_outlined,
    );
  }
}

class VolunteerPage extends StatelessWidget {
  const VolunteerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Volunteer',
      subtitle: 'Volunteer sign-up and information.',
      icon: Icons.volunteer_activism_outlined,
    );
  }
}
