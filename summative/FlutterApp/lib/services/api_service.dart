import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/input_fields.dart';
import '../models/prediction_result.dart';

// the public API on Render
const apiUrl = 'https://air-demand-gap-api.onrender.com/predict';

Future<PredictionResult> fetchPrediction(Map<String, dynamic> body) async {
  try {
    final response = await http
        .post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 90));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PredictionResult(
        passengers: (data['predicted_passengers'] as num).round(),
        millions: (data['predicted_passengers_millions'] as num).toDouble(),
      );
    }
    if (response.statusCode == 422) {
      return PredictionResult(errors: _readErrors(jsonDecode(response.body)));
    }
    return PredictionResult(errors: ['The server gave an unexpected answer (code ${response.statusCode}).']);
  } on TimeoutException {
    return const PredictionResult(errors: ['The server is taking too long to wake up. Wait a moment and try again.']);
  } catch (_) {
    return const PredictionResult(errors: ['Could not reach the server. Check your internet connection.']);
  }
}

// turns the API's validation errors into plain sentences
List<String> _readErrors(dynamic json) {
  final detail = json is Map ? json['detail'] : null;
  if (detail is! List) return ['The server rejected the input.'];

  return detail.map<String>((e) {
    final key = (e['loc'] as List).last.toString();
    final name = fieldLabels[key] ?? key;
    final ctx = e['ctx'] as Map?;
    switch (e['type']) {
      case 'missing':
        return '$name is required.';
      case 'greater_than_equal':
        return '$name must be at least ${ctx?['ge']}.';
      case 'less_than_equal':
        return '$name must be at most ${ctx?['le']}.';
      case 'literal_error':
        return '$name must be one of the suggested options.';
      case 'int_type':
      case 'int_parsing':
        return '$name must be a whole number.';
      case 'float_type':
      case 'float_parsing':
        return '$name must be a number.';
      default:
        return '$name: ${e['msg']}';
    }
  }).toList();
}
