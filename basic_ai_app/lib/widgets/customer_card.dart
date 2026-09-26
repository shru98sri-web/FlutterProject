import 'package:flutter/material.dart';

import '../models/customer.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onTap;

  const CustomerCard({
    super.key,
    required this.customer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(
          '${customer.gender} Customer',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${customer.tenure} months • '
          '₹${customer.monthlyCharges.toStringAsFixed(2)}/month',
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}
