import 'package:flutter/material.dart';

import 'screens/predict_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const AirDemandApp());

class AirDemandApp extends StatelessWidget {
  const AirDemandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Demand Gap Finder',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: appTheme,
      home: const PredictScreen(),
    );
  }
}
