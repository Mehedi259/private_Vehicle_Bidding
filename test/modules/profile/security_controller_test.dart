import 'package:flutter_test/flutter_test.dart';
import 'package:private_vehicle_bidding/modules/profile/controllers/security_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SecurityController controller;

  setUp(() {
    controller = SecurityController();
  });

  group('SecurityController Test Suite', () {
    test('Initializes with default settings values', () {
      expect(controller.isLoginActivityEnabled.value, isTrue);
      expect(controller.isVerificationEnabled.value, isTrue);
      expect(controller.isLoading.value, isFalse);
    });

    test('toggleLoginActivity updates setting state', () {
      controller.toggleLoginActivity(false);
      expect(controller.isLoginActivityEnabled.value, isFalse);

      controller.toggleLoginActivity(true);
      expect(controller.isLoginActivityEnabled.value, isTrue);
    });

    test('toggleVerification updates setting state', () {
      controller.toggleVerification(false);
      expect(controller.isVerificationEnabled.value, isFalse);

      controller.toggleVerification(true);
      expect(controller.isVerificationEnabled.value, isTrue);
    });
  });
}
