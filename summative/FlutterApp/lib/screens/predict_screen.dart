import 'package:flutter/material.dart';

import '../models/input_fields.dart';
import '../models/prediction_result.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/choice_field.dart';
import '../widgets/result_card.dart';
import '../widgets/section_card.dart';

class PredictScreen extends StatefulWidget {
  const PredictScreen({super.key});

  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  final _scroll = ScrollController();
  final _numbers = {for (final f in numFields) f.key: TextEditingController()};
  final _region = TextEditingController();
  final _income = TextEditingController();

  bool _loading = false;
  PredictionResult? _result;

  @override
  void dispose() {
    _scroll.dispose();
    _region.dispose();
    _income.dispose();
    for (final c in _numbers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _showResult(PredictionResult result) {
    setState(() {
      _loading = false;
      _result = result;
    });
    // scroll down so the display area is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final body = <String, dynamic>{};
    final errors = <String>[];

    // missing values and wrong types are caught here
    for (final f in numFields) {
      final text = _numbers[f.key]!.text.trim();
      if (text.isEmpty) {
        errors.add('${f.label} is required.');
        continue;
      }
      final value = f.whole ? int.tryParse(text) : double.tryParse(text);
      if (value == null) {
        errors.add('${f.label} must be ${f.whole ? 'a whole number' : 'a number'}.');
      } else {
        body[f.key] = value;
      }
    }
    for (final entry in {'region': _region, 'income_group': _income}.entries) {
      final text = entry.value.text.trim();
      if (text.isEmpty) {
        errors.add('${fieldLabels[entry.key]} is required.');
      } else {
        body[entry.key] = text;
      }
    }

    if (errors.isNotEmpty) {
      _showResult(PredictionResult(errors: errors));
      return;
    }

    // out-of-range values are rejected by the API and shown in the same display area
    setState(() {
      _loading = true;
      _result = null;
    });
    final result = await fetchPrediction(body);
    if (mounted) _showResult(result);
  }

  Widget _numField(NumField f) {
    return TextField(
      controller: _numbers[f.key],
      keyboardType: TextInputType.numberWithOptions(decimal: !f.whole),
      style: const TextStyle(color: ink),
      decoration: fieldDecoration(f.label, f.hint),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: forest,
        foregroundColor: ivory,
        centerTitle: true,
        title: const Text('Air Demand Gap Finder', style: TextStyle(letterSpacing: 1.2)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              controller: _scroll,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionCard(title: 'Country profile', children: [
                    ChoiceField(label: 'Region', options: regions, controller: _region),
                    ChoiceField(label: 'Income group', options: incomeGroups, controller: _income),
                    _numField(byKey['year']!),
                  ]),
                  SectionCard(title: 'Economy', children: [
                    _numField(byKey['gdp_per_capita']!),
                    _numField(byKey['population']!),
                    _numField(byKey['land_area']!),
                  ]),
                  SectionCard(title: 'Society and tourism', children: [
                    _numField(byKey['urban_pct']!),
                    _numField(byKey['internet_pct']!),
                    _numField(byKey['tourism_receipts_pct']!),
                  ]),
                  FilledButton(
                    onPressed: _loading ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: forest,
                      foregroundColor: ivory,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontSize: 16, letterSpacing: 2),
                    ),
                    child: const Text('Predict'),
                  ),
                  const SizedBox(height: 16),
                  ResultCard(loading: _loading, result: _result),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
