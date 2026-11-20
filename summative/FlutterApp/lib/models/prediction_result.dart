class PredictionResult {
  final int? passengers;
  final double? millions;
  final List<String> errors;

  const PredictionResult({this.passengers, this.millions, this.errors = const []});

  bool get hasError => errors.isNotEmpty;
}
