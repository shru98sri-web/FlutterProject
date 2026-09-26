import '../models/customer.dart';
import '../models/prediction.dart';
import 'api_service.dart';

class PredictionService {
  final ApiService apiService;

  PredictionService({
    required this.apiService,
  });

  Future<Prediction> predict(
    Customer customer,
  ) async {
    final response = await apiService.post(
      '/predict',
      customer.toJson(),
    );

    return Prediction.fromJson(response);
  }

  Future<bool> checkHealth() async {
    try {
      final response = await apiService.get('/health');

      return response['status'] == 'healthy';
    } catch (_) {
      return false;
    }
  }
}
