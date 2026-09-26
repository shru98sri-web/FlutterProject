import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../widgets/metric_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Customer Intelligence',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Analyze customers using the AI prediction service.'),
          const SizedBox(height: 24),

          const MetricCard(
            title: 'Customers',
            value: '1,248',
            icon: Icons.people,
          ),

          const SizedBox(height: 12),

          const MetricCard(
            title: 'High Risk',
            value: '186',
            icon: Icons.warning,
          ),

          const SizedBox(height: 12),

          const MetricCard(
            title: 'Predictions',
            value: '3,492',
            icon: Icons.analytics,
          ),

          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.prediction);
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Run AI Prediction'),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.customers);
            },
            icon: const Icon(Icons.people),
            label: const Text('View Customers'),
          ),
        ],
      ),
    );
  }
}
