import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/metric_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  void navigate(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(
          context,
          AppRoutes.customers,
        );
        break;
      case 2:
        Navigator.pushNamed(
          context,
          AppRoutes.prediction,
        );
        break;
      case 3:
        Navigator.pushNamed(
          context,
          AppRoutes.analytics,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(
            const Duration(milliseconds: 700),
          );
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Monitor your customer intelligence platform.',
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                final crossAxisCount = width > 900
                    ? 4
                    : width > 600
                        ? 2
                        : 2;

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: const [
                    MetricCard(
                      title: 'Total Customers',
                      value: '1,248',
                      icon: Icons.people,
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
                      title: 'Model Accuracy',
                      value: '91.4%',
                      icon: Icons.track_changes,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Prediction',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Use the trained churn model to '
                      'predict customer risk.',
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.prediction,
                        );
                      },
                      icon: const Icon(
                        Icons.auto_awesome,
                      ),
                      label: const Text(
                        'RUN AI PREDICTION',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Recent Predictions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _recentPrediction(
              context,
              'Customer #1024',
              '82%',
              true,
            ),
            _recentPrediction(
              context,
              'Customer #1025',
              '13%',
              false,
            ),
            _recentPrediction(
              context,
              'Customer #1026',
              '76%',
              true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentIndex,
        onTap: navigate,
      ),
    );
  }

  Widget _recentPrediction(
    BuildContext context,
    String customer,
    String probability,
    bool highRisk,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            highRisk ? Icons.warning : Icons.check,
          ),
        ),
        title: Text(customer),
        subtitle: Text(
          highRisk ? 'High churn risk' : 'Low churn risk',
        ),
        trailing: Text(
          probability,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
