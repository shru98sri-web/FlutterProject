import 'package:flutter/material.dart';

import '../../models/customer.dart';
import '../../models/prediction.dart';
import '../../services/api_service.dart';
import '../../services/prediction_service.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/prediction_card.dart';

class PredictionScreen extends StatefulWidget {
  final Customer? customer;

  const PredictionScreen({
    super.key,
    this.customer,
  });

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  late final PredictionService service;

  final formKey = GlobalKey<FormState>();

  late TextEditingController tenure;
  late TextEditingController monthlyCharges;
  late TextEditingController totalCharges;

  String gender = 'Female';
  String seniorCitizen = 'No';
  String partner = 'Yes';
  String dependents = 'No';
  String phoneService = 'Yes';
  String multipleLines = 'No';
  String internetService = 'Fiber optic';
  String onlineSecurity = 'No';
  String onlineBackup = 'Yes';
  String deviceProtection = 'No';
  String techSupport = 'No';
  String streamingTV = 'Yes';
  String streamingMovies = 'No';
  String contract = 'Month-to-month';
  String paperlessBilling = 'Yes';
  String paymentMethod = 'Electronic check';

  bool loading = false;
  String? error;
  Prediction? prediction;

  @override
  void initState() {
    super.initState();

    service = PredictionService(
      apiService: ApiService(
        baseUrl: AppConstants.baseUrl,
      ),
    );

    final customer = widget.customer;

    tenure = TextEditingController(
      text: customer?.tenure.toString() ?? '24',
    );

    monthlyCharges = TextEditingController(
      text: customer?.monthlyCharges.toString() ?? '75.50',
    );

    totalCharges = TextEditingController(
      text: customer?.totalCharges.toString() ?? '1800',
    );

    if (customer != null) {
      gender = customer.gender;
      seniorCitizen = customer.seniorCitizen == 1 ? 'Yes' : 'No';
      partner = customer.partner;
      dependents = customer.dependents;
      phoneService = customer.phoneService;
      multipleLines = customer.multipleLines;
      internetService = customer.internetService;
      onlineSecurity = customer.onlineSecurity;
      onlineBackup = customer.onlineBackup;
      deviceProtection = customer.deviceProtection;
      techSupport = customer.techSupport;
      streamingTV = customer.streamingTV;
      streamingMovies = customer.streamingMovies;
      contract = customer.contract;
      paperlessBilling = customer.paperlessBilling;
      paymentMethod = customer.paymentMethod;
    }
  }

  @override
  void dispose() {
    tenure.dispose();
    monthlyCharges.dispose();
    totalCharges.dispose();
    super.dispose();
  }

  Future<void> predict() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
      error = null;
      prediction = null;
    });

    try {
      final customer = Customer(
        gender: gender,
        seniorCitizen: seniorCitizen == 'Yes' ? 1 : 0,
        partner: partner,
        dependents: dependents,
        tenure: int.parse(tenure.text),
        phoneService: phoneService,
        multipleLines: multipleLines,
        internetService: internetService,
        onlineSecurity: onlineSecurity,
        onlineBackup: onlineBackup,
        deviceProtection: deviceProtection,
        techSupport: techSupport,
        streamingTV: streamingTV,
        streamingMovies: streamingMovies,
        contract: contract,
        paperlessBilling: paperlessBilling,
        paymentMethod: paymentMethod,
        monthlyCharges: double.parse(monthlyCharges.text),
        totalCharges: double.parse(totalCharges.text),
      );

      final result = await service.predict(customer);

      setState(() {
        prediction = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Prediction',
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _header(context),
            const SizedBox(height: 24),
            _customerSection(),
            const SizedBox(height: 20),
            _servicesSection(),
            const SizedBox(height: 20),
            _billingSection(),
            const SizedBox(height: 24),
            if (error != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    error!,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            if (prediction != null) ...[
              PredictionCard(
                prediction: prediction!,
              ),
              const SizedBox(height: 20),
            ],
            ElevatedButton.icon(
              onPressed: loading ? null : predict,
              icon: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.auto_awesome,
                    ),
              label: Text(
                loading ? 'PREDICTING...' : 'RUN AI PREDICTION',
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Churn Prediction',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Enter customer information and send '
          'it to the FastAPI machine-learning model.',
        ),
      ],
    );
  }

  Widget _customerSection() {
    return _section(
      'Customer Information',
      [
        CustomDropdown(
          label: 'Gender',
          value: gender,
          items: const [
            'Female',
            'Male',
          ],
          onChanged: (value) {
            setState(() {
              gender = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Senior Citizen',
          value: seniorCitizen,
          items: const [
            'No',
            'Yes',
          ],
          onChanged: (value) {
            setState(() {
              seniorCitizen = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Partner',
          value: partner,
          items: const [
            'No',
            'Yes',
          ],
          onChanged: (value) {
            setState(() {
              partner = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Dependents',
          value: dependents,
          items: const [
            'No',
            'Yes',
          ],
          onChanged: (value) {
            setState(() {
              dependents = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomTextField(
          label: 'Tenure (months)',
          controller: tenure,
          keyboardType: TextInputType.number,
          validator: Validators.positiveNumber,
        ),
      ],
    );
  }

  Widget _servicesSection() {
    return _section(
      'Services',
      [
        CustomDropdown(
          label: 'Phone Service',
          value: phoneService,
          items: const [
            'No',
            'Yes',
          ],
          onChanged: (value) {
            setState(() {
              phoneService = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Multiple Lines',
          value: multipleLines,
          items: const [
            'No',
            'Yes',
            'No phone service',
          ],
          onChanged: (value) {
            setState(() {
              multipleLines = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Internet Service',
          value: internetService,
          items: const [
            'DSL',
            'Fiber optic',
            'No',
          ],
          onChanged: (value) {
            setState(() {
              internetService = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Online Security',
          value: onlineSecurity,
          items: const [
            'No',
            'Yes',
            'No internet service',
          ],
          onChanged: (value) {
            setState(() {
              onlineSecurity = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Online Backup',
          value: onlineBackup,
          items: const [
            'No',
            'Yes',
            'No internet service',
          ],
          onChanged: (value) {
            setState(() {
              onlineBackup = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Device Protection',
          value: deviceProtection,
          items: const [
            'No',
            'Yes',
            'No internet service',
          ],
          onChanged: (value) {
            setState(() {
              deviceProtection = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Tech Support',
          value: techSupport,
          items: const [
            'No',
            'Yes',
            'No internet service',
          ],
          onChanged: (value) {
            setState(() {
              techSupport = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Streaming TV',
          value: streamingTV,
          items: const [
            'No',
            'Yes',
            'No internet service',
          ],
          onChanged: (value) {
            setState(() {
              streamingTV = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Streaming Movies',
          value: streamingMovies,
          items: const [
            'No',
            'Yes',
            'No internet service',
          ],
          onChanged: (value) {
            setState(() {
              streamingMovies = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _billingSection() {
    return _section(
      'Billing',
      [
        CustomDropdown(
          label: 'Contract',
          value: contract,
          items: const [
            'Month-to-month',
            'One year',
            'Two year',
          ],
          onChanged: (value) {
            setState(() {
              contract = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Paperless Billing',
          value: paperlessBilling,
          items: const [
            'No',
            'Yes',
          ],
          onChanged: (value) {
            setState(() {
              paperlessBilling = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          label: 'Payment Method',
          value: paymentMethod,
          items: const [
            'Electronic check',
            'Mailed check',
            'Bank transfer',
            'Credit card',
          ],
          onChanged: (value) {
            setState(() {
              paymentMethod = value!;
            });
          },
        ),
        const SizedBox(height: 14),
        CustomTextField(
          label: 'Monthly Charges',
          controller: monthlyCharges,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          validator: Validators.positiveNumber,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          label: 'Total Charges',
          controller: totalCharges,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          validator: Validators.positiveNumber,
        ),
      ],
    );
  }

  Widget _section(
    String title,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            ...children,
          ],
        ),
      ),
    );
  }
}
