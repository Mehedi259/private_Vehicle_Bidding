import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/snackbar_helper.dart';

class ContactSupportController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController subjectController;
  late final TextEditingController emailController;
  late final TextEditingController messageController;

  final FocusNode subjectFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode messageFocusNode = FocusNode();

  final RxString selectedScreenshotPath = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    subjectController = TextEditingController();
    emailController = TextEditingController();
    messageController = TextEditingController();
  }

  @override
  void onClose() {
    subjectController.dispose();
    emailController.dispose();
    messageController.dispose();

    subjectFocusNode.dispose();
    emailFocusNode.dispose();
    messageFocusNode.dispose();

    super.onClose();
  }

  /// Pick issue screenshot via ImagePicker
  Future<void> pickScreenshot() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        selectedScreenshotPath.value = image.path;
      }
    } catch (e) {
      SnackbarHelper.showError('Failed to pick screenshot: ${e.toString()}');
    }
  }

  /// Clear the attached screenshot path
  void clearScreenshot() {
    selectedScreenshotPath.value = '';
  }

  /// Submit the contact support request ticket
  Future<void> submitTicket(BuildContext context) async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      // Mock network submission delay
      await Future.delayed(const Duration(milliseconds: 1000));

      if (context.mounted) {
        Navigator.of(context).pop();
        SnackbarHelper.showSuccess('Support ticket submitted successfully!');
      }

      // Reset values
      subjectController.clear();
      emailController.clear();
      messageController.clear();
      selectedScreenshotPath.value = '';
    } catch (e) {
      SnackbarHelper.showError('Failed to submit ticket: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
