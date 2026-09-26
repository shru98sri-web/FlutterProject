import 'package:flutter/material.dart';

import '../../models/customer.dart';
import '../../services/customer_service.dart';
import '../../widgets/customer_card.dart';
import '../../widgets/loading_widget.dart';
import 'customer_detail_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final service = CustomerService();

  final searchController = TextEditingController();

  List<Customer> customers = [];
  List<Customer> filtered = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCustomers();
    searchController.addListener(filter);
  }

  Future<void> loadCustomers() async {
    setState(() {
      loading = true;
    });

    final result = await service.getCustomers();

    setState(() {
      customers = result;
      filtered = result;
      loading = false;
    });
  }

  void filter() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filtered = customers.where((customer) {
        return customer.gender.toLowerCase().contains(query) ||
            customer.internetService.toLowerCase().contains(query) ||
            customer.contract.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
      ),
      body: loading
          ? const LoadingWidget(
              message: 'Loading customers...',
            )
          : RefreshIndicator(
              onRefresh: loadCustomers,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search customers...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'No customers found',
                        ),
                      ),
                    ),
                  ...filtered.map(
                    (customer) => CustomerCard(
                      customer: customer,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CustomerDetailScreen(
                              customer: customer,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
