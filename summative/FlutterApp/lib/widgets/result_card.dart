import 'package:flutter/material.dart';

import '../models/prediction_result.dart';
import '../theme/app_theme.dart';

// the display area: waiting, loading, the prediction, or the errors
class ResultCard extends StatelessWidget {
  final bool loading;
  final PredictionResult? result;

  const ResultCard({super.key, required this.loading, required this.result});

  @override
  Widget build(BuildContext context) {
    var background = paper;
    var border = goldLine;
    Widget content;

    if (loading) {
      content = const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: forest)),
          SizedBox(width: 14),
          Flexible(
            child: Text(
              'Contacting the server...\nThe first request can take up to a minute.',
              style: TextStyle(color: muted),
            ),
          ),
        ],
      );
    } else if (result == null) {
      content = const Text(
        'Your prediction will appear here.',
        textAlign: TextAlign.center,
        style: TextStyle(color: muted),
      );
    } else if (result!.hasError) {
      background = roseTint;
      border = burgundy;
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Please check your input', style: TextStyle(color: burgundy, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final error in result!.errors)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('•  $error', style: const TextStyle(color: burgundy)),
            ),
        ],
      );
    } else {
      content = Column(
        children: [
          const Text(
            'EXPECTED AIR PASSENGERS PER YEAR',
            textAlign: TextAlign.center,
            style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            _withCommas(result!.passengers!),
            style: const TextStyle(color: forest, fontSize: 34, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'about ${result!.millions!.toStringAsFixed(2)} million passengers',
            style: const TextStyle(color: muted),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: cardBox(background, border),
      child: Center(child: content),
    );
  }
}

String _withCommas(int n) {
  return n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
}
