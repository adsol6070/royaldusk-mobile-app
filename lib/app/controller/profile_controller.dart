import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../controller/auth_controller.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  final RxBool isUpdating = false.obs;
  final RxString updateError = ''.obs;
  final RxString updateSuccess = ''.obs;

  /// Function to update the user name
  Future<void> updateUserName(String userId, String newName) async {
    if (newName.trim().isEmpty) {
      updateError.value = 'Name cannot be empty';
      return;
    }

    isUpdating.value = true;
    updateError.value = '';
    updateSuccess.value = '';

    try {
      final dioClient = AuthController.to.dioClient;

      final response = await dioClient.patch(
        '/user-service/api/users/$userId',
        data: {'name': newName.trim()},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        updateSuccess.value = 'Profile updated successfully';

        // Refresh user data
        await AuthController.to.refreshUserData();
      } else {
        updateError.value = 'Failed to update profile';
      }
    } on dio.DioException catch (e) {
      updateError.value = e.response?.data['message'] ?? 'Something went wrong';
    } catch (e) {
      updateError.value = 'Unexpected error: ${e.toString()}';
    } finally {
      isUpdating.value = false;
    }
  }
}
