import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/snackbar_helper.dart';
import 'profile_controller.dart';

class EditProfileController extends GetxController {
  late final ProfileController _profileController;

  // Form keys and Text Controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;

  // Focus nodes
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  // Observables
  final Rx<DateTime?> dob = Rx<DateTime?>(null);
  final RxString gender = 'Male'.obs;
  final RxString selectedImagePath = ''.obs;
  final RxBool isLoading = false.obs;

  String? get currentAvatarUrl => _profileController.user.value.avatarUrl;

  @override
  void onInit() {
    super.onInit();
    // Retrieve the active ProfileController
    _profileController = Get.find<ProfileController>();

    final currentUser = _profileController.user.value;

    // Initialize text controllers
    nameController = TextEditingController(text: currentUser.name);
    emailController = TextEditingController(text: currentUser.email);

    // Initialize DOB
    if (currentUser.dob != null) {
      try {
        dob.value = DateFormat('dd/MM/yyyy').parse(currentUser.dob!);
      } catch (_) {
        dob.value = null;
      }
    }

    // Initialize gender
    if (currentUser.gender != null) {
      gender.value = currentUser.gender!;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    super.onClose();
  }

  /// Select date of birth using Flutter DatePicker
  Future<void> selectDate(BuildContext context) async {
    final DateTime initialDate = dob.value ?? DateTime(2001, 11, 12);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1B4E9F), // Primary Color
              onPrimary: Colors.white,
              onSurface: Color(0xFF323232),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != dob.value) {
      dob.value = picked;
    }
  }

  /// Pick image using ImagePicker
  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      SnackbarHelper.showError('Failed to pick image: ${e.toString()}');
    }
  }

  /// Save changes back to ProfileController
  Future<void> saveProfile(BuildContext context) async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      // Mock network/db delay
      await Future.delayed(const Duration(milliseconds: 1000));

      final current = _profileController.user.value;
      final dobStr = dob.value != null ? DateFormat('dd/MM/yyyy').format(dob.value!) : null;

      final updatedUser = current.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        dob: dobStr,
        gender: gender.value,
        avatarUrl: selectedImagePath.value.isNotEmpty ? selectedImagePath.value : current.avatarUrl,
      );

      _profileController.user.value = updatedUser;
      _profileController.update();

      if (context.mounted) {
        Navigator.of(context).pop();
        SnackbarHelper.showSuccess('Profile updated successfully!');
      }
    } catch (e) {
      SnackbarHelper.showError('Failed to save profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
