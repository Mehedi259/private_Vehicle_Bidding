import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:private_vehicle_bidding/modules/profile/controllers/profile_verification_controller.dart';

void main() {
  late ProfileVerificationController verificationController;

  setUp(() {
    verificationController = Get.put(ProfileVerificationController());
  });

  tearDown(() {
    Get.delete<ProfileVerificationController>();
  });

  group('ProfileVerificationController Test Suite', () {
    test('Initializes with default document type and no selfie image', () {
      expect(verificationController.selectedDocType.value, equals(DocumentType.drivingLicense));
      expect(verificationController.selfieImagePath.value, isEmpty);
      expect(verificationController.isLoading.value, isFalse);
    });

    test('selectDocumentType modifies selection state', () {
      verificationController.selectDocumentType(DocumentType.passport);
      expect(verificationController.selectedDocType.value, equals(DocumentType.passport));

      verificationController.selectDocumentType(DocumentType.stateId);
      expect(verificationController.selectedDocType.value, equals(DocumentType.stateId));
    });

    test('Setting selfie path updates observable state', () {
      verificationController.selfieImagePath.value = 'dummy_path/selfie.jpg';
      expect(verificationController.selfieImagePath.value, equals('dummy_path/selfie.jpg'));
    });
  });
}
