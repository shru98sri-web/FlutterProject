import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../models/customer.dart';

class CustomerDetailScreen extends StatelessWidget {
  const CustomerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customer = ModalRoute.of(context)!.settings.arguments as Customer;

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(context, 'Customer', [
            _row('Gender', customer.gender),
            _row('Tenure', '${customer.tenure} months'),
            _row('Partner', customer.partner == 1 ? 'Yes' : 'No'),
            _row('Dependents', customer.dependents == 1 ? 'Yes' : 'No'),
          ]),
          const SizedBox(height: 16),
          _section(context, 'Services', [
            _row('Internet', customer.internetService),
            _row('Phone', customer.phoneService == 1 ? 'Yes' : 'No'),
            _row('Online Security', customer.onlineSecurity),
            _row('Tech Support', customer.techSupport),
          ]),
          const SizedBox(height: 16),
          _section(context, 'Billing', [
            _row('Contract', customer.contract),
            _row(
              'Monthly Charges',
              '\$${customer.monthlyCharges.toStringAsFixed(2)}',
            ),
            _row(
              'Total Charges',
              '\$${customer.totalCharges.toStringAsFixed(2)}',
            ),
          ]),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.prediction,
                arguments: customer,
              );
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Predict Churn Risk'),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
