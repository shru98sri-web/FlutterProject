import 'package:flutter/material.dart';

// --- MOCK DEFINITIONS (To prevent missing import errors) ---
class AppRoutes {
  static const String customerDetail = '/customer-detail';
}

class Customer {
  final String gender;
  final int seniorCitizen;
  final int partner;
  final int dependents;
  final int tenure;
  final int phoneService;
  final String multipleLines;
  final String internetService;
  final String onlineSecurity;
  final String onlineBackup;
  final String deviceProtection;
  final String techSupport;
  final String streamingTV;
  final String streamingMovies;
  final String contract;
  final int paperlessBilling;
  final String paymentMethod;
  final double monthlyCharges;
  final double totalCharges;

  const Customer({
    required this.gender,
    required this.seniorCitizen,
    required this.partner,
    required this.dependents,
    required this.tenure,
    required this.phoneService,
    required this.multipleLines,
    required this.internetService,
    required this.onlineSecurity,
    required this.onlineBackup,
    required this.deviceProtection,
    required this.techSupport,
    required this.streamingTV,
    required this.streamingMovies,
    required this.contract,
    required this.paperlessBilling,
    required this.paymentMethod,
    required this.monthlyCharges,
    required this.totalCharges,
  });
}

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text('${customer.gender} - Tenure: ${customer.tenure} months'),
        subtitle: Text(
            'Contract: ${customer.contract} | Charges: \$${customer.monthlyCharges}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
// -----------------------------------------------------------

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  // Marked as final since the list reference doesn't change
  final List<Customer> customers = const [
    Customer(
      gender: 'Female',
      seniorCitizen: 0,
      partner: 1,
      dependents: 0,
      tenure: 10,
      phoneService: 1,
      multipleLines: 'No',
      internetService: 'Fiber optic',
      onlineSecurity: 'No',
      onlineBackup: 'No',
      deviceProtection: 'No',
      techSupport: 'No',
      streamingTV: 'No',
      streamingMovies: 'No',
      contract: 'Month-to-month',
      paperlessBilling: 1,
      paymentMethod: 'Electronic check',
      monthlyCharges: 70.5,
      totalCharges: 705.0,
    ),
    Customer(
      gender: 'Male',
      seniorCitizen: 0,
      partner: 0,
      dependents: 1,
      tenure: 48,
      phoneService: 1,
      multipleLines: 'Yes',
      internetService: 'DSL',
      onlineSecurity: 'Yes',
      onlineBackup: 'Yes',
      deviceProtection: 'Yes',
      techSupport: 'Yes',
      streamingTV: 'No',
      streamingMovies: 'No',
      contract: 'Two year',
      paperlessBilling: 0,
      paymentMethod: 'Bank transfer',
      monthlyCharges: 55.0,
      totalCharges: 2640.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: customers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final customer = customers[index];

          return CustomerCard(
            customer: customer,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.customerDetail,
                arguments: customer,
              );
            },
          );
        },
      ),
    );
  }
}
