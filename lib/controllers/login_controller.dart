import 'package:get/get.dart';
import '../core/services/auth_service.dart';
import '../screens/main_navigation_screen.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }

    try {
      isLoading.value = true;
      await _authService.login(email, password);
      Get.offAll(() => const MainNavigationScreen());
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
