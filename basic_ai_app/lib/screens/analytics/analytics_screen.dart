import 'package:flutter/material.dart';

import '../../widgets/metric_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Customer Analytics',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Overview of customer churn predictions.',
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: const [
              MetricCard(
                title: 'Predictions',
                value: '1,248',
                icon: Icons.auto_awesome,
              ),
              MetricCard(
                title: 'High Risk',
                value: '187',
                icon: Icons.warning,
              ),
              MetricCard(
                title: 'Low Risk',
                value: '1,061',
                icon: Icons.check_circle,
              ),
              MetricCard(
                title: 'Accuracy',
                value: '91.4%',
                icon: Icons.track_changes,
              ),
            ],
          ),
          const SizedBox(height: 28),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk Distribution',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),
                  _bar(
                    context,
                    'Low Risk',
                    0.85,
                    '85%',
                  ),
                  const SizedBox(height: 18),
                  _bar(
                    context,
                    'High Risk',
                    0.15,
                    '15%',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Model Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _info(
                    'Model',
                    'Random Forest',
                  ),
                  _info(
                    'Task',
                    'Binary Classification',
                  ),
                  _info(
                    'Target',
                    'Customer Churn',
                  ),
                  _info(
                    'API',
                    'FastAPI',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(
    BuildContext context,
    String title,
    double value,
    String percentage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(
              percentage,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  Widget _info(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
