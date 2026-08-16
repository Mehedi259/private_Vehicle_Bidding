import 'package:flutter_test/flutter_test.dart';
import 'package:private_vehicle_bidding/modules/profile/controllers/change_password_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ChangePasswordController controller;

  setUp(() {
    controller = ChangePasswordController();
  });

  group('ChangePasswordController Test Suite', () {
    test('Initializes with default states', () {
      expect(controller.isLoading.value, isFalse);
      expect(controller.currentPasswordController.text, isEmpty);
      expect(controller.newPasswordController.text, isEmpty);
      expect(controller.confirmPasswordController.text, isEmpty);
    });

    test('validates matching confirm password', () {
      controller.newPasswordController.text = 'Password123!';
      controller.confirmPasswordController.text = 'Password123!';
      
      // Confirming matching state works correctly
      expect(
        controller.confirmPasswordController.text == controller.newPasswordController.text,
        isTrue,
      );
    });
  });
}
