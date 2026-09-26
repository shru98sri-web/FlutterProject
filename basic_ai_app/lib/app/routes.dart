import 'package:flutter/material.dart';

import '../screens/analytics/analytics_screen.dart';
import '../screens/customers/customer_list_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/prediction/prediction_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String customers = '/customers';
  static const String prediction = '/prediction';
  static const String analytics = '/analytics';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    dashboard: (_) => const DashboardScreen(),
    customers: (_) => const CustomerListScreen(),
    prediction: (_) => const PredictionScreen(),
    analytics: (_) => const AnalyticsScreen(),
    settings: (_) => const SettingsScreen(),
  };
}
