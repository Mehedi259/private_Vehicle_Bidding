import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/snackbar_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/api_service.dart';
import '../controllers/sell_controller.dart';

class AddVehicleController extends GetxController {
  // Wizard flow step progress: 1 to 5
  final RxInt currentStep = 1.obs;

  // Horizontal category selection
  final RxString selectedCategory = 'Car'.obs;
  final List<String> categories = ['Car', 'Motorcycle', 'Truck', 'Boat', 'Aircraft', 'Other'];

  // Form input controllers (Step 1)
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = RxnString();
  final trimController = TextEditingController();
  final mileageController = TextEditingController();
  final vinController = TextEditingController();
  final transmissionController = TextEditingController();
  final fuelTypeController = TextEditingController();
  final driveTypeController = TextEditingController();
  final engineController = TextEditingController();
  final exteriorColorController = TextEditingController();
  final interiorColorController = TextEditingController();
  final titleStatusController = RxnString();
  final cabTypeController = TextEditingController();
  final bedLengthController = TextEditingController();
  final towingCapacityController = TextEditingController();
  final lengthController = TextEditingController();
  final hullMaterialController = TextEditingController();
  final hullTypeController = TextEditingController();
  final engineHoursController = TextEditingController();
  final flightHoursController = TextEditingController();
  final aircraftTypeController = TextEditingController();
  final registrationNumberController = TextEditingController();
  final engineCcController = TextEditingController();

  // Form input controllers (Step 2)
  final RxList<String> selectedImagePaths = <String>[].obs;
  final descriptionController = TextEditingController();
  final featuresController = TextEditingController();

  // Form input controllers (Step 3)
  final startingBidController = TextEditingController();
  final reservePriceController = TextEditingController();
  final buyNowPriceController = TextEditingController();
  final RxString selectedDuration = '3 Days'.obs;
  final List<String> durations = ['3 Days', '5 Days', '7 Days', '10 Days', '14 Days'];

  // Form input controllers (Step 4)
  final RxString selectedDocType = 'Driving License'.obs;
  final RxnString selfieImagePath = RxnString();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();

  // Expanded summary indices (Step 5)
  final RxList<bool> expandedSummaries = <bool>[false, false, false, false].obs;

  // Verification Tokens
  String? vinToken;
  String? imageToken;
  String? idToken;
  final RxBool isVerifying = false.obs;

  void toggleSummary(int index) {
    if (index >= 0 && index < expandedSummaries.length) {
      expandedSummaries[index] = !expandedSummaries[index];
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> verifyVinAndPopulate() async {
    final vin = vinController.text.trim();
    if (vin.isEmpty) {
      SnackbarHelper.showError('Please enter a VIN number first');
      return;
    }
    
    isVerifying.value = true;
    try {
      final response = await ApiService.post('/api/sell/posts/verify-vin/', {
        'vin_number': vin,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['is_valid'] == true && data['decoded_info'] != null) {
          final info = data['decoded_info'];
          makeController.text = info['make'] ?? '';
          modelController.text = info['model'] ?? '';
          yearController.value = info['year']?.toString();
          trimController.text = info['trim'] ?? '';
          transmissionController.text = info['transmission'] ?? '';
          fuelTypeController.text = info['fuel_type'] ?? '';
          driveTypeController.text = info['drive_type'] ?? '';
          
          if (info['engine_cylinders'] != null || info['displacement_l'] != null) {
            engineController.text = '${info['displacement_l'] ?? ''}L ${info['engine_cylinders'] != null ? '${info['engine_cylinders']} Cyl' : ''}'.trim();
          }
          
          SnackbarHelper.showSuccess('VIN details populated successfully');
        } else {
          SnackbarHelper.showError('Invalid VIN or no details found');
        }
      } else {
        final error = jsonDecode(response.body);
        SnackbarHelper.showError(error['error'] ?? 'VIN Verification Failed');
      }
    } catch (e) {
      SnackbarHelper.showError('Network error during VIN verification');
    } finally {
      isVerifying.value = false;
    }
  }

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
    
    final category = selectedCategory.value;
    if (category != 'Boat' && category != 'Aircraft') {
      if (mileageController.text.trim().isEmpty) return false;
      if (vinController.text.trim().isEmpty) return false;
      if (transmissionController.text.trim().isEmpty) return false;
    }
    if (category != 'Aircraft' && category != 'Boat') {
        if (fuelTypeController.text.trim().isEmpty) return false;
    }
    
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

  Future<void> pickSelfie(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
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

  Future<void> nextStep(BuildContext context) async {
    if (isVerifying.value) return;

    if (currentStep.value == 1) {
      if (validateStep1()) {
        isVerifying.value = true;
        try {
          final response = await ApiService.post('/api/sell/posts/verify-vin/', {
            'vin_number': vinController.text.trim(),
            'make': makeController.text.trim(),
            'model': modelController.text.trim(),
          });
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            vinToken = data['verification_token'];
            currentStep.value++;
          } else {
            final error = jsonDecode(response.body);
            Get.log('Bypassing VIN verification due to backend error: ${error['error']}');
            SnackbarHelper.showError(error['error'] ?? 'VIN Verification Failed - Bypassing for testing');
            vinToken = 'mock_vin_token_123';
            currentStep.value++;
          }
        } catch (e) {
          SnackbarHelper.showError('Network error during verification');
        } finally {
          isVerifying.value = false;
        }
      } else {
        SnackbarHelper.showError('Please fill all required fields marked with *');
      }
    } else if (currentStep.value == 2) {
      if (validateStep2()) {
        if (selectedImagePaths.length < 15) {
          SnackbarHelper.showError('Please select at least 15 images');
          return;
        }
        isVerifying.value = true;
        try {
          final List<http.MultipartFile> files = [];
          for (String path in selectedImagePaths) {
            files.add(await http.MultipartFile.fromPath('uploaded_images', path));
          }
          final response = await ApiService.multipartRequest(
            'POST',
            '/api/sell/posts/verify-vehicle-image/',
            files: files,
          );
          final resStr = await response.stream.bytesToString();
          if (response.statusCode == 200) {
            final data = jsonDecode(resStr);
            imageToken = data['verification_token'];
            currentStep.value++;
          } else {
            final error = jsonDecode(resStr);
            // Bypass AWS verification on failure during testing
            Get.log('Bypassing AWS verification due to backend error or test image: ${error['error']}');
            imageToken = 'mock_image_token_123';
            currentStep.value++;
          }
        } catch (e) {
          SnackbarHelper.showError('Network error during verification');
        } finally {
          isVerifying.value = false;
        }
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
        if (selfieImagePath.value == null) {
          SnackbarHelper.showError('Please capture or upload your ID document');
          return;
        }
        isVerifying.value = true;
        try {
          final file = await http.MultipartFile.fromPath('government_id_image', selfieImagePath.value!);
          final response = await ApiService.multipartRequest(
            'POST',
            '/api/sell/posts/verify-id-document/',
            fields: {'id_type': selectedDocType.value == 'Driving License' ? 'license' : 'passport'},
            files: [file],
          );
          final resStr = await response.stream.bytesToString();
          if (response.statusCode == 200) {
            final data = jsonDecode(resStr);
            idToken = data['verification_token'];
            currentStep.value++;
          } else {
            final error = jsonDecode(resStr);
            // Bypass AWS verification on failure during testing
            Get.log('Bypassing AWS verification due to backend error or test ID: ${error['error']}');
            idToken = 'mock_id_token_123';
            currentStep.value++;
          }
        } catch (e) {
          SnackbarHelper.showError('Network error during verification');
        } finally {
          isVerifying.value = false;
        }
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
    if (selectedImagePaths.length >= 20) {
      SnackbarHelper.showError('You can list a maximum of 20 photos.');
      return;
    }

    try {
      if (source == ImageSource.gallery) {
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 85,
          maxWidth: 1080,
        );
        if (images.isNotEmpty) {
          final remainingCount = 20 - selectedImagePaths.length;
          final imagesToAdd = images.take(remainingCount);
          selectedImagePaths.addAll(imagesToAdd.map((img) => img.path));
          if (images.length > remainingCount) {
            SnackbarHelper.showError('Only the first $remainingCount selected photos were added (max 20 allowed).');
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
    isVerifying.value = true;
    try {
      final title = '${yearController.value ?? ''} ${makeController.text.trim()} ${modelController.text.trim()}';
      final cleanedStarting = startingBidController.text.trim().replaceAll(',', '');
      
      final cleanedBuyNow = buyNowPriceController.text.trim().replaceAll(',', '');
      final cleanedReserve = reservePriceController.text.trim().replaceAll(',', '');

      final Map<String, String> fields = {
        'title': title,
        'make': makeController.text.trim(),
        'model': modelController.text.trim(),
        'year': yearController.value ?? '2026',
        'mileage': mileageController.text.trim(),
        'vin_number': vinController.text.trim(),
        'transmission': transmissionController.text.trim(),
        'fuel_type': fuelTypeController.text.trim(),
        'description': descriptionController.text.trim(),
        'vehicle_type': selectedCategory.value,
        'starting_bid': cleanedStarting.isEmpty ? '18000' : cleanedStarting,
        'duration': selectedDuration.value.replaceAll(RegExp(r'[^0-9]'), ''),
        'title_status': titleStatusController.value ?? 'Clean',
        'country': countryController.text.trim(),
        'state': stateController.text.trim(),
        'city': cityController.text.trim(),
        'zip_code': zipCodeController.text.trim(),
      };

      if (exteriorColorController.text.trim().isNotEmpty) fields['exterior_color'] = exteriorColorController.text.trim();
      if (interiorColorController.text.trim().isNotEmpty) fields['interior_color'] = interiorColorController.text.trim();
      if (driveTypeController.text.trim().isNotEmpty) fields['drive_type'] = driveTypeController.text.trim();
      if (engineController.text.trim().isNotEmpty) fields['engine'] = engineController.text.trim();

      if (trimController.text.trim().isNotEmpty) fields['trim'] = trimController.text.trim();
      
      // Additional dynamic fields
      if (cabTypeController.text.trim().isNotEmpty) fields['cab_type'] = cabTypeController.text.trim();
      if (bedLengthController.text.trim().isNotEmpty) fields['bed_length'] = bedLengthController.text.trim();
      if (towingCapacityController.text.trim().isNotEmpty) fields['towing_capacity'] = towingCapacityController.text.trim();
      if (lengthController.text.trim().isNotEmpty) fields['length_ft'] = lengthController.text.trim();
      if (hullMaterialController.text.trim().isNotEmpty) fields['hull_material'] = hullMaterialController.text.trim();
      if (hullTypeController.text.trim().isNotEmpty) fields['hull_type'] = hullTypeController.text.trim();
      if (engineHoursController.text.trim().isNotEmpty) fields['engine_hours'] = engineHoursController.text.trim();
      if (flightHoursController.text.trim().isNotEmpty) fields['flight_hours'] = flightHoursController.text.trim();
      if (aircraftTypeController.text.trim().isNotEmpty) fields['aircraft_type'] = aircraftTypeController.text.trim();
      if (registrationNumberController.text.trim().isNotEmpty) fields['registration_number'] = registrationNumberController.text.trim();
      if (engineCcController.text.trim().isNotEmpty) fields['engine_cc'] = engineCcController.text.trim();
      
      if (featuresController.text.trim().isNotEmpty) {
        // Convert comma-separated features to JSON array string
        final featureList = featuresController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        fields['features'] = jsonEncode(featureList);
      }

      fields['id_type'] = selectedDocType.value == 'Driving License' ? 'license' : 'passport';
      fields['latitude'] = '25.160124'; // Default/Mock for now
      fields['longitude'] = '55.362947'; // Default/Mock for now

      if (cleanedBuyNow.isNotEmpty) fields['buy_now_price'] = cleanedBuyNow;
      if (cleanedReserve.isNotEmpty) fields['reserve_price'] = cleanedReserve;
      if (vinToken != null) fields['vin_verification_token'] = vinToken!;
      if (imageToken != null) fields['image_verification_token'] = imageToken!;
      if (idToken != null) fields['id_verification_token'] = idToken!;

      final response = await ApiService.multipartRequest(
        'POST',
        '/api/sell/posts/',
        fields: fields,
      );

      if (response.statusCode == 201) {
        if (Get.isRegistered<SellController>()) {
          Get.find<SellController>().fetchListedVehicles();
        }
        if (context.mounted) {
          Navigator.of(context).pop(); // Exit wizard
        }
        SnackbarHelper.showSuccess('Vehicle listed successfully!');
      } else {
        final resStr = await response.stream.bytesToString();
        Get.log('Sell Post Creation Failed: $resStr');
        try {
          final error = jsonDecode(resStr);
          String errorMessage = 'Failed to list vehicle. Please try again.';
          if (error is Map) {
            if (error.containsKey('error')) {
              errorMessage = error['error'];
            } else if (error.isNotEmpty) {
              // Extract first error message from DRF validation errors
              final firstKey = error.keys.first;
              final firstValue = error[firstKey];
              if (firstValue is List && firstValue.isNotEmpty) {
                errorMessage = '$firstKey: ${firstValue.first}';
              } else {
                errorMessage = '$firstKey: $firstValue';
              }
            }
          }
          SnackbarHelper.showError(errorMessage);
        } catch (e) {
          SnackbarHelper.showError('Failed to list vehicle. Please try again.');
        }
      }
    } catch (e) {
      SnackbarHelper.showError('An error occurred during submission');
    } finally {
      isVerifying.value = false;
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
    cabTypeController.dispose();
    bedLengthController.dispose();
    towingCapacityController.dispose();
    lengthController.dispose();
    hullMaterialController.dispose();
    hullTypeController.dispose();
    engineHoursController.dispose();
    flightHoursController.dispose();
    aircraftTypeController.dispose();
    registrationNumberController.dispose();
    engineCcController.dispose();
    super.onClose();
  }
}

