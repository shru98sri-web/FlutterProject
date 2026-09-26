import 'package:flutter/material.dart';

import '../app/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void navigate(
    BuildContext context,
    String route,
  ) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text(
                'AI Developer',
              ),
              accountEmail: Text(
                'Customer Intelligence',
              ),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.dashboard,
              ),
              title: const Text('Dashboard'),
              onTap: () => navigate(
                context,
                AppRoutes.dashboard,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.people,
              ),
              title: const Text('Customers'),
              onTap: () => navigate(
                context,
                AppRoutes.customers,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.auto_awesome,
              ),
              title: const Text('AI Prediction'),
              onTap: () => navigate(
                context,
                AppRoutes.prediction,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.analytics,
              ),
              title: const Text('Analytics'),
              onTap: () => navigate(
                context,
                AppRoutes.analytics,
              ),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(
                Icons.settings,
              ),
              title: const Text('Settings'),
              onTap: () => navigate(
                context,
                AppRoutes.settings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
