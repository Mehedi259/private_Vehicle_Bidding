import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:private_vehicle_bidding/modules/profile/controllers/profile_controller.dart';
import 'package:private_vehicle_bidding/modules/profile/controllers/edit_profile_controller.dart';

void main() {
  late ProfileController profileController;
  late EditProfileController editProfileController;

  setUp(() {
    profileController = Get.put(ProfileController());
    editProfileController = Get.put(EditProfileController());
  });

  tearDown(() {
    Get.delete<ProfileController>();
    Get.delete<EditProfileController>();
  });

  group('EditProfileController Test Suite', () {
    test('Loads initial profile data from ProfileController', () {
      expect(editProfileController.nameController.text, equals(profileController.user.value.name));
      expect(editProfileController.emailController.text, equals(profileController.user.value.email));
      expect(editProfileController.gender.value, equals(profileController.user.value.gender));
      expect(editProfileController.dob.value, isNotNull);
    });

    test('Modifying gender changes state', () {
      editProfileController.gender.value = 'Female';
      expect(editProfileController.gender.value, equals('Female'));
    });

    test('Modifying dob changes state', () {
      final newDate = DateTime(1995, 5, 20);
      editProfileController.dob.value = newDate;
      expect(editProfileController.dob.value, equals(newDate));
    });
  });
}
