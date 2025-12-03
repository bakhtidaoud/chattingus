import 'package:get/get.dart';

class SignUpController extends GetxController {
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isAgreed = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void toggleAgreement() {
    isAgreed.value = !isAgreed.value;
  }

  void signup() {
    if (!isAgreed.value) {
      Get.snackbar('Error', 'Please agree to the Terms of Service and Privacy Policy');
      return;
    }
    // Mock signup function
    Get.snackbar('Sign Up', 'Sign Up functionality not implemented yet');
  }
}
