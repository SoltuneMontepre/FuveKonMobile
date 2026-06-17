import 'package:flutter/material.dart';
import 'package:fuvekonmobile/screens/info/event_rules_page.dart';
import 'package:fuvekonmobile/shared/widgets/placeholder_page.dart';

export 'event_rules_page.dart';
export 'faq_page.dart';
export 'lost_found_page.dart';

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

class TosPage extends StatelessWidget {
  const TosPage({super.key, this.onboarding = false});

  final bool onboarding;

  @override
  Widget build(BuildContext context) {
    return EventRulesPage(onboarding: onboarding);
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
