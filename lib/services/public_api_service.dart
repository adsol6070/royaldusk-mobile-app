import 'package:royaldusk_mobile_app/services/api_service.dart';

abstract class PublicApiService extends ApiService {
  @override
  Future<Map<String, String>> getAuthHeaders() async {
    // Return empty map - no auth needed for public APIs
    return {};
  }
}
