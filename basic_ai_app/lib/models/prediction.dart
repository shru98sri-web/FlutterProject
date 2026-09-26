class Prediction {
  final int prediction;
  final double probability;

  const Prediction({
    required this.prediction,
    required this.probability,
  });

  factory Prediction.fromJson(
    Map<String, dynamic> json,
  ) {
    return Prediction(
      prediction: json['prediction'] as int,
      probability: (json['probability'] as num).toDouble(),
    );
  }

  bool get isChurn => prediction == 1;

  double get percentage => probability * 100;

  String get percentageText => '${percentage.toStringAsFixed(1)}%';

  String get label => isChurn ? 'HIGH RISK' : 'LOW RISK';
}
