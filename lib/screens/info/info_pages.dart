import 'package:flutter/material.dart';
import 'package:fuvekonmobile/shared/widgets/placeholder_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'About',
      subtitle: 'Event information and team details.',
      icon: Icons.info_outline,
    );
  }
}

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'FAQ',
      subtitle: 'Frequently asked questions.',
      icon: Icons.help_outline,
    );
  }
}

class TosPage extends StatelessWidget {
  const TosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Terms of Service',
      subtitle: 'Event terms and policies.',
      icon: Icons.gavel_outlined,
    );
  }
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Schedule',
      subtitle: 'Event schedule and programming.',
      icon: Icons.calendar_month_outlined,
    );
  }
}

class RecapPage extends StatelessWidget {
  const RecapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Recap',
      subtitle: 'Highlights from past events.',
      icon: Icons.photo_library_outlined,
    );
  }
}
