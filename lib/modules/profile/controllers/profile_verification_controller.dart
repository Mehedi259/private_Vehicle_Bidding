import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/snackbar_helper.dart';

enum DocumentType { drivingLicense, passport, stateId }

class ProfileVerificationController extends GetxController {
  // Selected document type
  final Rx<DocumentType> selectedDocType = DocumentType.drivingLicense.obs;

  // Selfie image path
  final RxString selfieImagePath = ''.obs;
  final RxBool isLoading = false.obs;

  /// Sets the selected document type
  void selectDocumentType(DocumentType docType) {
    selectedDocType.value = docType;
  }

  /// Takes a selfie using the camera
  Future<void> takeSelfie() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image != null) {
        selfieImagePath.value = image.path;
      }
    } catch (e) {
      SnackbarHelper.showError('Failed to capture selfie: ${e.toString()}');
    }
  }

  /// Save verification documents
  Future<void> saveVerification(BuildContext context) async {
    if (selfieImagePath.value.isEmpty) {
      SnackbarHelper.showError('Please take a selfie to complete verification.');
      return;
    }

    isLoading.value = true;

    try {
      // Mock API delay
      await Future.delayed(const Duration(milliseconds: 1500));

      if (context.mounted) {
        Navigator.of(context).pop();
        SnackbarHelper.showSuccess('Verification documents uploaded successfully!');
      }
    } catch (e) {
      SnackbarHelper.showError('Upload failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
