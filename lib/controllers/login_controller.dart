import 'package:get/get.dart';
import '../screens/main_navigation_screen.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() {
    // Mock login function
    Get.offAll(() => const MainNavigationScreen());
  }
}
