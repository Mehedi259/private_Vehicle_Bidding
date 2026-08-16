import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../controllers/sell_controller.dart';

class AddVehicleController extends GetxController {
  // Wizard flow step progress: 1 to 5
  final RxInt currentStep = 1.obs;

  // Horizontal category selection
  final RxString selectedCategory = 'Car'.obs;
  final List<String> categories = ['Car', 'Motorcycle', 'Truck', 'Boat', 'Aircraft', 'Other'];

  // Form input controllers (Step 1)
  final makeController = TextEditingController(text: "Audi");
  final modelController = TextEditingController(text: "Q8");
  final yearController = RxnString("2026");
  final trimController = TextEditingController(text: "3.0 TFSI Premium Plus quattro");
  final mileageController = TextEditingController(text: "5000");
  final vinController = TextEditingController(text: "1234567890");
  final transmissionController = TextEditingController(text: "Automatic");
  final fuelTypeController = TextEditingController(text: "Petrol");
  final driveTypeController = TextEditingController(text: "FWD");
  final engineController = TextEditingController(text: "3.0L");
  final exteriorColorController = TextEditingController(text: "White");
  final interiorColorController = TextEditingController(text: "Black");
  final titleStatusController = RxnString();

  // Form input controllers (Step 2)
  final RxList<String> selectedImagePaths = <String>[].obs;
  final descriptionController = TextEditingController(text: "Audi Q8 is a luxury SUV known for its premium features and performance.");
  final featuresController = TextEditingController(text: "Premium leather seats, Advanced infotainment system, Sunroof, Parking assist");

  // Form input controllers (Step 3)
  final startingBidController = TextEditingController(text: "18,000");
  final reservePriceController = TextEditingController(text: "22,000");
  final buyNowPriceController = TextEditingController(text: "26,000");
  final RxString selectedDuration = '3 Days'.obs;
  final List<String> durations = ['3 Days', '5 Days', '7 Days', '10 Days', '14 Days'];

  // Form input controllers (Step 4)
  final RxString selectedDocType = 'Driving License'.obs;
  final RxnString selfieImagePath = RxnString();
  final countryController = TextEditingController(text: "United Arab Emirates");
  final stateController = TextEditingController(text: "Dubai");
  final cityController = TextEditingController(text: "Al Aweer");
  final zipCodeController = TextEditingController(text: "7025");

  // Expanded summary indices (Step 5)
  final RxList<bool> expandedSummaries = <bool>[false, false, false, false].obs;

  void toggleSummary(int index) {
    if (index >= 0 && index < expandedSummaries.length) {
      expandedSummaries[index] = !expandedSummaries[index];
    }
  }

  final ImagePicker _picker = ImagePicker();

  // Wizard transitions
  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void previousStep(BuildContext context) {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      if (context.mounted) {
        Navigator.of(context).pop(); // Exit wizard if clicked Back on Step 1
      }
    }
  }

  bool validateStep1() {
    if (makeController.text.trim().isEmpty) return false;
    if (modelController.text.trim().isEmpty) return false;
    if (yearController.value == null || yearController.value!.isEmpty) return false;
    if (mileageController.text.trim().isEmpty) return false;
    if (vinController.text.trim().isEmpty) return false;
    if (transmissionController.text.trim().isEmpty) return false;
    if (fuelTypeController.text.trim().isEmpty) return false;
    if (titleStatusController.value == null || titleStatusController.value!.isEmpty) return false;
    return true;
  }

  bool validateStep2() {
    if (descriptionController.text.trim().isEmpty) return false;
    return true;
  }

  bool validateStep3() {
    final startingText = startingBidController.text.trim().replaceAll(',', '');
    if (startingText.isEmpty) return false;
    final startingPrice = double.tryParse(startingText);
    if (startingPrice == null || startingPrice <= 0) return false;

    final reserveText = reservePriceController.text.trim().replaceAll(',', '');
    if (reserveText.isNotEmpty) {
      final reservePrice = double.tryParse(reserveText);
      if (reservePrice == null || reservePrice <= 0) return false;
    }

    final buyNowText = buyNowPriceController.text.trim().replaceAll(',', '');
    if (buyNowText.isNotEmpty) {
      final buyNowPrice = double.tryParse(buyNowText);
      if (buyNowPrice == null || buyNowPrice <= 0) return false;
    }

    return true;
  }

  bool validateStep4() {
    if (stateController.text.trim().isEmpty) return false;
    if (cityController.text.trim().isEmpty) return false;
    if (zipCodeController.text.trim().isEmpty) return false;
    return true;
  }

  Future<void> pickSelfie() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1080,
      );
      if (image != null) {
        selfieImagePath.value = image.path;
      }
    } catch (e) {
      Get.log("Error picking selfie: $e");
      SnackbarHelper.showError('Failed to capture selfie');
    }
  }

  void removeSelfie() {
    selfieImagePath.value = null;
  }

  void nextStep(BuildContext context) {
    if (currentStep.value == 1) {
      if (validateStep1()) {
        currentStep.value++;
      } else {
        SnackbarHelper.showError('Please fill all required fields marked with *');
      }
    } else if (currentStep.value == 2) {
      if (validateStep2()) {
        currentStep.value++;
      } else {
        SnackbarHelper.showError('Please enter a description for your vehicle');
      }
    } else if (currentStep.value == 3) {
      if (validateStep3()) {
        currentStep.value++;
      } else {
        SnackbarHelper.showError('Please enter a valid starting bid price');
      }
    } else if (currentStep.value == 4) {
      if (validateStep4()) {
        currentStep.value++;
      } else {
        SnackbarHelper.showError('Please fill all required verification fields marked with *');
      }
    } else if (currentStep.value < 5) {
      currentStep.value++;
    } else {
      submitForm(context);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    if (selectedImagePaths.length >= 10) {
      SnackbarHelper.showError('You can list a maximum of 10 photos.');
      return;
    }

    try {
      if (source == ImageSource.gallery) {
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 85,
          maxWidth: 1080,
        );
        if (images.isNotEmpty) {
          final remainingCount = 10 - selectedImagePaths.length;
          final imagesToAdd = images.take(remainingCount);
          selectedImagePaths.addAll(imagesToAdd.map((img) => img.path));
          if (images.length > remainingCount) {
            SnackbarHelper.showError('Only the first $remainingCount selected photos were added (max 10 allowed).');
          }
        }
      } else {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          maxWidth: 1080,
        );
        if (image != null) {
          selectedImagePaths.add(image.path);
        }
      }
    } catch (e) {
      Get.log("Error picking image: $e");
      SnackbarHelper.showError('Failed to pick image');
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImagePaths.length) {
      selectedImagePaths.removeAt(index);
    }
  }

  String getDefaultImagePath() {
    switch (selectedCategory.value) {
      case 'Car':
        return 'assets/images/tesla_model_y.png';
      case 'Motorcycle':
        return 'assets/images/yamaha_yzf_r1.png';
      case 'Truck':
        return 'assets/images/ford_f150.png';
      case 'Boat':
        return 'assets/images/sea_ray_sdx.png';
      default:
        return 'assets/images/tesla_model_y.png';
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (Get.isRegistered<SellController>()) {
      final sellController = Get.find<SellController>();
      final title = '${yearController.value ?? ''} ${makeController.text.trim()} ${modelController.text.trim()}';
      final cleanedStarting = startingBidController.text.trim().replaceAll(',', '');
      final startingBid = double.tryParse(cleanedStarting) ?? 18000.0;
      
      final cleanedBuyNow = buyNowPriceController.text.trim().replaceAll(',', '');
      final buyNowPrice = cleanedBuyNow.isNotEmpty ? double.tryParse(cleanedBuyNow) : null;

      final success = await sellController.addNewVehicle(
        title,
        startingBid,
        customImage: selectedImagePaths.isNotEmpty ? selectedImagePaths.first : getDefaultImagePath(),
        buyNowPrice: buyNowPrice,
      );

      if (success) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Exit wizard
        }
        SnackbarHelper.showSuccess('Vehicle listed successfully!');
      } else {
        SnackbarHelper.showError('Failed to list vehicle. Please try again.');
      }
    } else {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  final RxString displayAddress = 'Dubai, Al Aweer, 7025'.obs;

  @override
  void onInit() {
    super.onInit();
    stateController.addListener(_onLocationChanged);
    cityController.addListener(_onLocationChanged);
    zipCodeController.addListener(_onLocationChanged);
    _updateDisplayAddress();
  }

  void _onLocationChanged() {
    _updateDisplayAddress();
  }

  void _updateDisplayAddress() {
    final city = cityController.text.trim();
    final state = stateController.text.trim();
    final zip = zipCodeController.text.trim();
    if (city.isEmpty && state.isEmpty && zip.isEmpty) {
      displayAddress.value = 'Dubai, Al Aweer, 7025';
    } else {
      displayAddress.value = '$state, $city, $zip';
    }
  }

  @override
  void onClose() {
    stateController.removeListener(_onLocationChanged);
    cityController.removeListener(_onLocationChanged);
    zipCodeController.removeListener(_onLocationChanged);
    makeController.dispose();
    modelController.dispose();
    trimController.dispose();
    mileageController.dispose();
    vinController.dispose();
    transmissionController.dispose();
    fuelTypeController.dispose();
    driveTypeController.dispose();
    engineController.dispose();
    exteriorColorController.dispose();
    interiorColorController.dispose();
    descriptionController.dispose();
    featuresController.dispose();
    startingBidController.dispose();
    reservePriceController.dispose();
    buyNowPriceController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    super.onClose();
  }
}

