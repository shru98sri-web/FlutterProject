import 'package:flutter/material.dart';

import '../../models/customer.dart';
import '../screens/prediction/prediction_screen.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Details',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 42,
            child: Icon(
              Icons.person,
              size: 42,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${customer.gender} Customer',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          _section(
            context,
            'Customer Information',
            [
              _row(
                'Gender',
                customer.gender,
              ),
              _row(
                'Senior Citizen',
                customer.seniorCitizen == 1 ? 'Yes' : 'No',
              ),
              _row(
                'Partner',
                customer.partner,
              ),
              _row(
                'Dependents',
                customer.dependents,
              ),
              _row(
                'Tenure',
                '${customer.tenure} months',
              ),
            ],
          ),
          _section(
            context,
            'Services',
            [
              _row(
                'Phone',
                customer.phoneService,
              ),
              _row(
                'Internet',
                customer.internetService,
              ),
              _row(
                'Online Security',
                customer.onlineSecurity,
              ),
              _row(
                'Online Backup',
                customer.onlineBackup,
              ),
              _row(
                'Tech Support',
                customer.techSupport,
              ),
            ],
          ),
          _section(
            context,
            'Billing',
            [
              _row(
                'Contract',
                customer.contract,
              ),
              _row(
                'Payment Method',
                customer.paymentMethod,
              ),
              _row(
                'Monthly Charges',
                '₹${customer.monthlyCharges.toStringAsFixed(2)}',
              ),
              _row(
                'Total Charges',
                '₹${customer.totalCharges.toStringAsFixed(2)}',
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PredictionScreen(
                    customer: customer,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.auto_awesome,
            ),
            label: const Text(
              'PREDICT CHURN',
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
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
