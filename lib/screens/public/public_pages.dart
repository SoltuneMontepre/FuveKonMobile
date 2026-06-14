import 'package:flutter/material.dart';
import 'package:fuvekonmobile/shared/widgets/placeholder_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Home',
      subtitle: 'Landing page and event highlights will live here.',
      icon: Icons.home_outlined,
    );
  }
}
