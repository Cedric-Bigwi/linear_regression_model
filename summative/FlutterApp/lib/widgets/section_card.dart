import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SectionCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: cardBox(paper),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          for (final child in children) Padding(padding: const EdgeInsets.only(top: 14), child: child),
        ],
      ),
    );
  }
}
