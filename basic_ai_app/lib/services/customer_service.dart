import '../models/customer.dart';

class CustomerService {
  Future<List<Customer>> getCustomers() async {
    // Replace this with your real customer API
    // when a /customers endpoint is added to FastAPI.

    return [
      Customer(
        gender: 'Female',
        seniorCitizen: 0,
        partner: 'Yes',
        dependents: 'No',
        tenure: 24,
        phoneService: 'Yes',
        multipleLines: 'No',
        internetService: 'Fiber optic',
        onlineSecurity: 'No',
        onlineBackup: 'Yes',
        deviceProtection: 'No',
        techSupport: 'No',
        streamingTV: 'Yes',
        streamingMovies: 'No',
        contract: 'Month-to-month',
        paperlessBilling: 'Yes',
        paymentMethod: 'Electronic check',
        monthlyCharges: 75.50,
        totalCharges: 1800,
      ),
      Customer(
        gender: 'Male',
        seniorCitizen: 0,
        partner: 'No',
        dependents: 'No',
        tenure: 60,
        phoneService: 'Yes',
        multipleLines: 'Yes',
        internetService: 'DSL',
        onlineSecurity: 'Yes',
        onlineBackup: 'Yes',
        deviceProtection: 'Yes',
        techSupport: 'Yes',
        streamingTV: 'No',
        streamingMovies: 'No',
        contract: 'Two year',
        paperlessBilling: 'No',
        paymentMethod: 'Bank transfer',
        monthlyCharges: 55.30,
        totalCharges: 3318,
      ),
    ];
  }
}
