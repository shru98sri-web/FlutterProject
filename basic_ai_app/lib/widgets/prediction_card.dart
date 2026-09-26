import 'package:flutter/material.dart';

import '../models/prediction.dart';
import 'risk_badge.dart';

class PredictionCard extends StatelessWidget {
  final Prediction prediction;

  const PredictionCard({
    super.key,
    required this.prediction,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = prediction.percentage;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'AI Prediction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: prediction.probability,
                      strokeWidth: 12,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('probability'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            RiskBadge(
              highRisk: prediction.isChurn,
            ),
            const SizedBox(height: 18),
            Text(
              prediction.isChurn
                  ? 'The model predicts that this customer '
                      'has a high probability of churn.'
                  : 'The model predicts that this customer '
                      'has a low probability of churn.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
