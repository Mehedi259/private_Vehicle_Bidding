import 'package:flutter_test/flutter_test.dart';
import 'package:private_vehicle_bidding/modules/profile/controllers/profile_controller.dart';

void main() {
  late ProfileController controller;

  setUp(() {
    controller = ProfileController();
  });

  group('ProfileController Test Suite', () {
    test('Initializes with default user details', () {
      expect(controller.user.value.name, equals('Mohammad Shobuj'));
      expect(controller.user.value.email, equals('mdshobuj204111@gmail.com'));
      expect(
        controller.user.value.avatarUrl,
        equals('https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150'),
      );
      expect(controller.isLoading.value, isFalse);
    });

    test('Verify user data copyWith functionality', () {
      final updatedUser = controller.user.value.copyWith(
        name: 'New Name',
        email: 'new@gmail.com',
      );
      expect(updatedUser.name, equals('New Name'));
      expect(updatedUser.email, equals('new@gmail.com'));
      expect(
        updatedUser.avatarUrl,
        equals('https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150'),
      );
    });
  });
}
