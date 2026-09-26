class Customer {
  final String gender;
  final int seniorCitizen;
  final String partner;
  final String dependents;
  final int tenure;
  final String phoneService;
  final String multipleLines;
  final String internetService;
  final String onlineSecurity;
  final String onlineBackup;
  final String deviceProtection;
  final String techSupport;
  final String streamingTV;
  final String streamingMovies;
  final String contract;
  final String paperlessBilling;
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

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'SeniorCitizen': seniorCitizen,
      'Partner': partner,
      'Dependents': dependents,
      'tenure': tenure,
      'PhoneService': phoneService,
      'MultipleLines': multipleLines,
      'InternetService': internetService,
      'OnlineSecurity': onlineSecurity,
      'OnlineBackup': onlineBackup,
      'DeviceProtection': deviceProtection,
      'TechSupport': techSupport,
      'StreamingTV': streamingTV,
      'StreamingMovies': streamingMovies,
      'Contract': contract,
      'PaperlessBilling': paperlessBilling,
      'PaymentMethod': paymentMethod,
      'MonthlyCharges': monthlyCharges,
      'TotalCharges': totalCharges,
    };
  }
}
