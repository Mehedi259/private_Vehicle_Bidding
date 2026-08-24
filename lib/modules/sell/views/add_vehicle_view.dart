import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/add_vehicle_controller.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/category_model.dart';
import '../../../shared/widgets/category_card.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/app_dropdown_field.dart';
import '../../../shared/widgets/app_back_button.dart';

class AddVehicleView extends StatelessWidget {
  const AddVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddVehicleController>(
      init: AddVehicleController(),
      dispose: (state) => Get.delete<AddVehicleController>(),
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // 1. Centered Header with Circular Back Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppBackButton(
                          onTap: () => controller.previousStep(context),
                        ),
                      ),
                      Text(
                        'Sell Your Vehicle',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF2A2A2A),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // 2. Step Progress Indicator
                Obx(() => _buildStepProgressIndicator(controller)),
                SizedBox(height: 24.h),

                // 3. Step Content (Flexible/Scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Obx(() => _buildCurrentStepView(controller, context)),
                  ),
                ),

                // 4. Sticky Bottom Action Buttons
                Obx(() => _buildBottomActionBar(controller, context)),
              ],
            ),
          ),
        );
      },
    );
  }

  // Current wizard step display
  Widget _buildCurrentStepView(AddVehicleController controller, BuildContext context) {
    switch (controller.currentStep.value) {
      case 1:
        return _buildStep1Form(controller);
      case 2:
        return _buildStep2Form(controller, context);
      case 3:
        return _buildStep3Form(controller);
      case 4:
        return _buildStep4Form(controller, context);
      case 5:
        return _buildStep5Form(controller, context);
      default:
        return const SizedBox();
    }
  }

  // Multi-step progress tracker
  Widget _buildStepProgressIndicator(AddVehicleController controller) {
    final activeStep = controller.currentStep.value;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final stepNum = index + 1;
              final isCompleted = stepNum < activeStep;
              final isActive = stepNum == activeStep;

              return Expanded(
                child: Row(
                  children: [
                    // Step Circle
                    Container(
                      width: 48.r,
                      height: 48.r,
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: isActive || isCompleted
                            ? const Color(0xFF1B4E9F)
                            : const Color(0xFFF3F4F6),
                        shape: const CircleBorder(),
                      ),
                      child: Text(
                        'Step $stepNum',
                        style: GoogleFonts.poppins(
                          color: isActive || isCompleted ? Colors.white : const Color(0x7F323232),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Connector Line
                    if (index < 4)
                      Expanded(
                        child: Container(
                          height: 6.h,
                          color: stepNum < activeStep
                              ? const Color(0xFF1B4E9F)
                              : const Color(0xFFA9C8FA),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 16.h),
          // Subtitle: Section Title
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.w,
                  color: Colors.black.withValues(alpha: 0.1),
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            child: Text(
              activeStep == 1
                  ? 'Vehicle Details'
                  : activeStep == 2
                      ? 'Upload Images'
                      : activeStep == 3
                          ? 'Auction Details'
                          : activeStep == 4
                              ? 'Verification'
                              : 'Preview Listing',
              style: GoogleFonts.outfit(
                color: const Color(0xFF2A2A2A),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step 1 Form Layout (2-column grids of inputs)
  Widget _buildStep1Form(AddVehicleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Categories Horizontal Selection
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: controller.categories.map((cat) {
              final isSelected = controller.selectedCategory.value == cat;

              IconData iconData;
              switch (cat) {
                case 'Car':
                  iconData = Icons.directions_car_outlined;
                  break;
                case 'Motorcycle':
                  iconData = Icons.motorcycle_outlined;
                  break;
                case 'Truck':
                  iconData = Icons.local_shipping_outlined;
                  break;
                case 'Boat':
                  iconData = Icons.directions_boat_outlined;
                  break;
                case 'Aircraft':
                  iconData = Icons.flight_outlined;
                  break;
                default:
                  iconData = Icons.more_horiz_outlined;
              }

              final categoryModel = CategoryModel(
                id: cat,
                title: cat,
                icon: iconData,
              );

              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: CategoryCard(
                  category: categoryModel,
                  isSelected: isSelected,
                  onTap: () => controller.setCategory(cat),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 24.h),

        // Grid of form inputs dynamically rendered
        Obx(() {
          final category = controller.selectedCategory.value;
          if (category == 'Motorcycle') {
            return _buildMotorcycleFields(controller);
          } else if (category == 'Truck') {
            return _buildTruckFields(controller);
          } else if (category == 'Boat') {
            return _buildBoatFields(controller);
          } else if (category == 'Aircraft') {
            return _buildAircraftFields(controller);
          } else if (category == 'Other') {
            return _buildOtherFields(controller);
          }
          return _buildCarFields(controller); // Default to Car
        }),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildCarFields(AddVehicleController controller) {
    return Column(
      children: [
        _buildLabelTextField(
          label: 'VIN Number',
          isRequired: true,
          hintText: 'Enter VIN and verify',
          controller: controller.vinController,
          suffixIcon: Obx(() => IconButton(
            icon: controller.isVerifying.value
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1B4E9F)),
                  )
                : const Icon(Icons.search, color: Color(0xFF1B4E9F)),
            onPressed: () => controller.verifyVinAndPopulate(),
          )),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Make', isRequired: true, hintText: 'write', controller: controller.makeController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Model', isRequired: true, hintText: 'write', controller: controller.modelController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelDropdown(label: 'Year', isRequired: true, hintText: 'Select year', value: controller.yearController.value, items: List.generate(27, (i) => (2026 - i).toString()), onChanged: (val) => controller.yearController.value = val)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Trim', hintText: 'write', controller: controller.trimController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Mileage', isRequired: true, hintText: 'write mileage', controller: controller.mileageController, keyboardType: TextInputType.number)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Transmission', isRequired: true, hintText: 'Transmission type', controller: controller.transmissionController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Fuel Type', isRequired: true, hintText: 'write fuel type', controller: controller.fuelTypeController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Drive Type', hintText: 'write drive type', controller: controller.driveTypeController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Engine', hintText: 'write engine type', controller: controller.engineController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Exterior color', hintText: 'write exterior color', controller: controller.exteriorColorController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Interior Color', hintText: 'write interior color', controller: controller.interiorColorController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelDropdown(label: 'Title Status', isRequired: true, hintText: 'Select car status', value: controller.titleStatusController.value, items: const ['Clean', 'Salvage', 'Rebuilt', 'Parts Only'], onChanged: (val) => controller.titleStatusController.value = val)),
          ],
        ),
      ],
    );
  }

  Widget _buildMotorcycleFields(AddVehicleController controller) {
    return Column(
      children: [
        _buildLabelTextField(
          label: 'VIN Number',
          isRequired: true,
          hintText: 'Enter VIN and verify',
          controller: controller.vinController,
          suffixIcon: Obx(() => IconButton(
            icon: controller.isVerifying.value
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1B4E9F)),
                  )
                : const Icon(Icons.search, color: Color(0xFF1B4E9F)),
            onPressed: () => controller.verifyVinAndPopulate(),
          )),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Make', isRequired: true, hintText: 'write', controller: controller.makeController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Model', isRequired: true, hintText: 'write', controller: controller.modelController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelDropdown(label: 'Year', isRequired: true, hintText: 'Select year', value: controller.yearController.value, items: List.generate(27, (i) => (2026 - i).toString()), onChanged: (val) => controller.yearController.value = val)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Mileage', isRequired: true, hintText: 'write mileage', controller: controller.mileageController, keyboardType: TextInputType.number)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Engine', hintText: 'write engine', controller: controller.engineController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Transmission', isRequired: true, hintText: 'Transmission type', controller: controller.transmissionController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Fuel Type', isRequired: true, hintText: 'write fuel type', controller: controller.fuelTypeController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Engine (CC)', hintText: 'write CC', controller: controller.engineCcController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Color', hintText: 'write color', controller: controller.exteriorColorController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelDropdown(label: 'Title Status', isRequired: true, hintText: 'Select status', value: controller.titleStatusController.value, items: const ['Clean', 'Salvage', 'Rebuilt', 'Parts Only'], onChanged: (val) => controller.titleStatusController.value = val)),
          ],
        ),
      ],
    );
  }

  Widget _buildTruckFields(AddVehicleController controller) {
    return Column(
      children: [
        _buildLabelTextField(
          label: 'VIN Number',
          isRequired: true,
          hintText: 'Enter VIN and verify',
          controller: controller.vinController,
          suffixIcon: Obx(() => IconButton(
            icon: controller.isVerifying.value
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1B4E9F)),
                  )
                : const Icon(Icons.search, color: Color(0xFF1B4E9F)),
            onPressed: () => controller.verifyVinAndPopulate(),
          )),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Make', isRequired: true, hintText: 'write', controller: controller.makeController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Model', isRequired: true, hintText: 'write', controller: controller.modelController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelDropdown(label: 'Year', isRequired: true, hintText: 'Select year', value: controller.yearController.value, items: List.generate(27, (i) => (2026 - i).toString()), onChanged: (val) => controller.yearController.value = val)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Mileage', isRequired: true, hintText: 'write mileage', controller: controller.mileageController, keyboardType: TextInputType.number)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Engine', hintText: 'write engine', controller: controller.engineController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Transmission', isRequired: true, hintText: 'Transmission type', controller: controller.transmissionController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Fuel Type', isRequired: true, hintText: 'write fuel type', controller: controller.fuelTypeController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Drive Type', hintText: 'write drive type', controller: controller.driveTypeController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Color', hintText: 'write color', controller: controller.exteriorColorController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Cab Type', hintText: 'e.g. SuperCrew', controller: controller.cabTypeController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Bed Length', hintText: 'e.g. 5.5 ft', controller: controller.bedLengthController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Towing Capacity', hintText: 'e.g. 8200', controller: controller.towingCapacityController)),
          ],
        ),
        SizedBox(height: 16.h),
        _buildLabelDropdown(label: 'Title Status', isRequired: true, hintText: 'Select status', value: controller.titleStatusController.value, items: const ['Clean', 'Salvage', 'Rebuilt', 'Parts Only'], onChanged: (val) => controller.titleStatusController.value = val),
      ],
    );
  }

  Widget _buildBoatFields(AddVehicleController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Make', isRequired: true, hintText: 'write', controller: controller.makeController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Model', isRequired: true, hintText: 'write', controller: controller.modelController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelDropdown(label: 'Year', isRequired: true, hintText: 'Select year', value: controller.yearController.value, items: List.generate(27, (i) => (2026 - i).toString()), onChanged: (val) => controller.yearController.value = val)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Length (ft)', hintText: 'e.g. 24.5', controller: controller.lengthController, keyboardType: TextInputType.number)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Hull Material', hintText: 'e.g. Fiberglass', controller: controller.hullMaterialController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Hull Type', hintText: 'e.g. Monohull', controller: controller.hullTypeController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Engine', hintText: 'write engine', controller: controller.engineController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Engine Hours', hintText: 'e.g. 300', controller: controller.engineHoursController, keyboardType: TextInputType.number)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Fuel Type', isRequired: true, hintText: 'write fuel type', controller: controller.fuelTypeController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Color', hintText: 'write color', controller: controller.exteriorColorController)),
          ],
        ),
        SizedBox(height: 16.h),
        _buildLabelDropdown(
          label: 'Title Status', isRequired: true, hintText: 'Select status', value: controller.titleStatusController.value, items: const ['Clean', 'Salvage', 'Rebuilt', 'Parts Only'], onChanged: (val) => controller.titleStatusController.value = val,
        ),
      ],
    );
  }

  Widget _buildAircraftFields(AddVehicleController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Make', isRequired: true, hintText: 'write', controller: controller.makeController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Model', isRequired: true, hintText: 'write', controller: controller.modelController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelDropdown(label: 'Year', isRequired: true, hintText: 'Select year', value: controller.yearController.value, items: List.generate(27, (i) => (2026 - i).toString()), onChanged: (val) => controller.yearController.value = val)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Registration Number', hintText: 'write registration', controller: controller.registrationNumberController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Aircraft Type', hintText: 'e.g. Single Engine', controller: controller.aircraftTypeController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Flight Hours', hintText: 'e.g. 2500', controller: controller.flightHoursController, keyboardType: TextInputType.number)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Engine', hintText: 'write engine', controller: controller.engineController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Fuel Type', isRequired: true, hintText: 'write fuel type', controller: controller.fuelTypeController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Color', hintText: 'write color', controller: controller.exteriorColorController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelDropdown(label: 'Title Status', isRequired: true, hintText: 'Select status', value: controller.titleStatusController.value, items: const ['Clean', 'Salvage', 'Rebuilt', 'Parts Only'], onChanged: (val) => controller.titleStatusController.value = val)),
          ],
        ),
      ],
    );
  }

  Widget _buildOtherFields(AddVehicleController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildLabelTextField(label: 'Make', isRequired: true, hintText: 'write', controller: controller.makeController)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelTextField(label: 'Model', isRequired: true, hintText: 'write', controller: controller.modelController)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildLabelDropdown(label: 'Year', isRequired: true, hintText: 'Select year', value: controller.yearController.value, items: List.generate(27, (i) => (2026 - i).toString()), onChanged: (val) => controller.yearController.value = val)),
            SizedBox(width: 16.w),
            Expanded(child: _buildLabelDropdown(label: 'Title Status', isRequired: true, hintText: 'Select status', value: controller.titleStatusController.value, items: const ['Clean', 'Salvage', 'Rebuilt', 'Parts Only'], onChanged: (val) => controller.titleStatusController.value = val)),
          ],
        ),
      ],
    );
  }

  // Step 2 Form Layout (Photos & Condition)
  Widget _buildStep2Form(AddVehicleController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and description section
        Center(
          child: Column(
            children: [
              Text(
                'Photos & Condition',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Add photos and tell buyers about the condition',
                style: GoogleFonts.poppins(
                  color: const Color(0xCC2A2A2A),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Add Photos Header
        Text(
          'Add Photos',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),

        // Custom dotted border upload card
        _buildImageUploadArea(controller, context),
        SizedBox(height: 24.h),

        // Description field
        _buildLabelDescriptionField(
          label: 'Description About Your Vehicle',
          isRequired: true,
          hintText: 'write description',
          controller: controller.descriptionController,
        ),
        SizedBox(height: 24.h),

        // Features field
        _buildLabelFeaturesField(
          label: 'Features',
          hintText: 'Write your vehicle feature',
          controller: controller.featuresController,
        ),
        SizedBox(height: 32.h),
      ],
    );
  }

  // Custom Image Upload Area / Grid View
  Widget _buildImageUploadArea(AddVehicleController controller, BuildContext context) {
    if (controller.selectedImagePaths.isEmpty) {
      return GestureDetector(
        onTap: () => _showImageSourceBottomSheet(context, controller),
        child: CustomPaint(
          painter: DashedBorderPainter(
            color: const Color(0xFF1B4E9F),
            strokeWidth: 2.w,
            borderRadius: 8.r,
          ),
          child: Container(
            width: double.infinity,
            height: 151.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_outlined,
                  color: const Color(0xFF1B4E9F),
                  size: 28.r,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Click to upload',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1B4E9F),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Minimum 10 photos required',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1B4E9F),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Synchronous Wrap layout to ensure direct state updates inside parent Obx build phase
      final double cardSize = (MediaQuery.of(context).size.width - 32.w - 20.w) / 3;

      return Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: [
          ...List.generate(controller.selectedImagePaths.length, (index) {
            final imagePath = controller.selectedImagePaths[index];
            final isAsset = imagePath.startsWith('assets');

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: cardSize,
                  height: cardSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.1),
                      width: 1.w,
                    ),
                    image: DecorationImage(
                      image: isAsset
                          ? AssetImage(imagePath) as ImageProvider
                          : FileImage(File(imagePath)) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: -4.h,
                  right: -4.w,
                  child: GestureDetector(
                    onTap: () => controller.removeImage(index),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(2.r),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14.r,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
          // "+" Add More Card
          GestureDetector(
            onTap: () => _showImageSourceBottomSheet(context, controller),
            child: CustomPaint(
              painter: DashedBorderPainter(
                color: const Color(0xFF1B4E9F),
                strokeWidth: 2.w,
                borderRadius: 8.r,
              ),
              child: Container(
                width: cardSize,
                height: cardSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.add_rounded,
                    color: const Color(0xFF1B4E9F),
                    size: 28.r,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  // Camera vs Gallery selfie source chooser bottom sheet
  void _showSelfieSourceBottomSheet(BuildContext context, AddVehicleController controller) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                Text(
                  'Select Selfie Source',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF2A2A2A),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        controller.pickSelfie(ImageSource.camera);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60.r,
                            height: 60.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: const Color(0xFF1B4E9F),
                              size: 28.r,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Camera',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2A2A2A),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        controller.pickSelfie(ImageSource.gallery);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60.r,
                            height: 60.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.photo_library_outlined,
                              color: const Color(0xFF1B4E9F),
                              size: 28.r,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Gallery',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2A2A2A),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  // Camera vs Gallery image source chooser bottom sheet
  void _showImageSourceBottomSheet(BuildContext context, AddVehicleController controller) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                Text(
                  'Select Image Source',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF2A2A2A),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        controller.pickImage(ImageSource.camera);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60.r,
                            height: 60.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: const Color(0xFF1B4E9F),
                              size: 28.r,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Camera',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF475569),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        controller.pickImage(ImageSource.gallery);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60.r,
                            height: 60.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.photo_library_rounded,
                              color: const Color(0xFF1B4E9F),
                              size: 28.r,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Gallery',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF475569),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      },
    );
  }

  // Label textfield builder with required star indicator
  Widget _buildLabelTextField({
    required String label,
    bool isRequired = false,
    required String hintText,
    required TextEditingController controller,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return AppTextField(
      labelText: label,
      isRequired: isRequired,
      hintText: hintText,
      controller: controller,
      keyboardType: keyboardType,
      suffixIcon: suffixIcon,
    );
  }

  // Description input field
  Widget _buildLabelDescriptionField({
    required String label,
    bool isRequired = false,
    required String hintText,
    required TextEditingController controller,
  }) {
    return AppTextField(
      labelText: label,
      isRequired: isRequired,
      hintText: hintText,
      controller: controller,
      maxLines: 4,
    );
  }

  // Features input field with green check icon
  Widget _buildLabelFeaturesField({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return AppTextField(
      labelText: label,
      hintText: hintText,
      controller: controller,
      suffixIcon: Icon(
        Icons.check_rounded,
        color: const Color(0xFF10B981),
        size: 16.r,
      ),
    );
  }

  // Dropdown builder with required star indicator
  Widget _buildLabelDropdown({
    required String label,
    bool isRequired = false,
    required String hintText,
    String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return AppDropdownField(
      labelText: label,
      isRequired: isRequired,
      hintText: hintText,
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }

  // Builder for subsequent mock steps
  Widget _buildMockStep(String title, IconData icon, String desc) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 72.r,
              color: const Color(0xFFA9C8FA),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: const Color(0xFF2A2A2A),
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: const Color(0xCC2A2A2A),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom action buttons: "Back" & "Next / Submit"
  Widget _buildBottomActionBar(AddVehicleController controller, BuildContext context) {
    if (controller.currentStep.value == 5) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.black.withValues(alpha: 0.05),
              width: 1.h,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              text: 'Publish Auction',
              onPressed: () => controller.submitForm(context),
              backgroundColor: const Color(0xFF1B4E9F),
              textColor: Colors.white,
              height: 48.0,
              borderRadius: 8.0,
              prefixIcon: Icon(
                Icons.rocket_launch_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your auction will go live immediately',
              style: GoogleFonts.poppins(
                color: const Color(0xCC2A2A2A),
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
            width: 1.h,
          ),
        ),
      ),
      child: Row(
        children: [
          // "Back" Button
          Expanded(
            child: AppButton(
              text: 'Back',
              onPressed: () => controller.previousStep(context),
              backgroundColor: const Color(0xFFF1F5F9),
              textColor: const Color(0xFF475569),
              height: 44.0,
              borderRadius: 8.0,
            ),
          ),
          SizedBox(width: 16.w),
          // "Next" Button
          Expanded(
            child: AppButton(
              text: controller.currentStep.value == 5 ? 'Submit' : 'Next',
              onPressed: () => controller.nextStep(context),
              backgroundColor: const Color(0xFF1B4E9F),
              textColor: Colors.white,
              height: 44.0,
              borderRadius: 8.0,
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Auction Setup Form
  Widget _buildStep3Form(AddVehicleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and description section
        Center(
          child: Column(
            children: [
              Text(
                'Auction Setup',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Set your auction preferences',
                style: GoogleFonts.poppins(
                  color: const Color(0xCC2A2A2A),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Center(
          child: Container(
            width: 285.w,
            height: 1.h,
            color: Colors.black.withValues(alpha: 0.10),
          ),
        ),
        SizedBox(height: 24.h),

        // Starting Bid Price
        _buildPriceField(
          label: 'Starting Bid Price',
          isRequired: true,
          controller: controller.startingBidController,
          subtext: 'This will be the opening bid for auction.',
        ),
        SizedBox(height: 24.h),

        // Reserve Price (optional)
        _buildPriceField(
          label: 'Reserve Price (optional)',
          isRequired: false,
          controller: controller.reservePriceController,
          subtext: 'The minimum amount you are willing to accept.',
        ),
        SizedBox(height: 24.h),

        // Buy Now Price (optional)
        _buildPriceField(
          label: 'Buy Now Price (optional)',
          isRequired: false,
          controller: controller.buyNowPriceController,
          subtext: 'Buyer can purchase immediately at this price.',
        ),
        SizedBox(height: 24.h),

        // Auction Duration Header
        Text(
          'Auction Duration',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),

        // Duration horizontal list selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: controller.durations.map((duration) {
            final isSelected = controller.selectedDuration.value == duration;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.selectedDuration.value = duration;
                },
                child: Container(
                  height: 66.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.all(4.r),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.w,
                        color: isSelected
                            ? const Color(0xFF96BFFF)
                            : Colors.black.withValues(alpha: 0.10),
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x28000000),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24.r,
                        height: 24.r,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.calendar_today_rounded,
                                size: 18.r,
                                color: isSelected
                                    ? const Color(0xFF1B4E9F)
                                    : const Color(0xCC2A2A2A),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(0.5.r),
                                child: Icon(
                                  Icons.access_time_filled_rounded,
                                  size: 9.r,
                                  color: isSelected
                                      ? const Color(0xFF1B4E9F)
                                      : const Color(0xCC2A2A2A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          duration,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            color: isSelected
                                ? const Color(0xFF1B4E9F)
                                : const Color(0xCC2A2A2A),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }

  // Price field builder helper
  Widget _buildPriceField({
    required String label,
    required bool isRequired,
    required TextEditingController controller,
    required String subtext,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFF86247),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 37.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: ShapeDecoration(
            color: const Color(0xFFF9FAFB),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.w,
                color: const Color(0xFFD1D5DB),
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Row(
            children: [
              Text(
                '\$',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF2A2A2A),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtext,
          style: GoogleFonts.poppins(
            color: const Color(0xCC2A2A2A),
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // Step 4: Verification Form
  Widget _buildStep4Form(AddVehicleController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and description section
        Center(
          child: Column(
            children: [
              Text(
                'Verification',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Verify your identity and location',
                style: GoogleFonts.poppins(
                  color: const Color(0xCC2A2A2A),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Center(
          child: Container(
            width: 285.w,
            height: 1.h,
            color: Colors.black.withValues(alpha: 0.10),
          ),
        ),
        SizedBox(height: 24.h),

        // Government ID Upload Section
        Text(
          'Government ID Upload',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),

        // Row of License / Passport
        Row(
          children: [
            Expanded(
              child: _buildDocTypeButton(
                controller: controller,
                docType: 'Driving License',
                label: 'Driving License',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildDocTypeButton(
                controller: controller,
                docType: 'Passport',
                label: 'Passport',
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildDocTypeButton(
          controller: controller,
          docType: 'State ID',
          label: 'State ID',
          isFullWidth: true,
        ),
        SizedBox(height: 24.h),

        // Selfie Verification
        Text(
          'Selfie Verification',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),

        // Selfie Picker
        _buildSelfieUploadArea(controller, context),
        SizedBox(height: 24.h),

        // Location Section
        Text(
          'Location',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),

        // Country Input (Optional)
        _buildLabelTextField(
          label: 'Country',
          hintText: 'Enter your country name',
          controller: controller.countryController,
        ),
        SizedBox(height: 16.h),

        // State & City (Required *)
        Row(
          children: [
            Expanded(
              child: _buildLabelTextField(
                label: 'State',
                isRequired: true,
                hintText: 'Enter state',
                controller: controller.stateController,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildLabelTextField(
                label: 'City',
                isRequired: true,
                hintText: 'Enter City',
                controller: controller.cityController,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // ZIP Code (Required *)
        _buildLabelTextField(
          label: 'ZIP Code',
          isRequired: true,
          hintText: 'Enter zip code',
          controller: controller.zipCodeController,
        ),
        SizedBox(height: 24.h),

        // Mock Map section & Address details
        _buildMapView(controller, context),
        SizedBox(height: 32.h),
      ],
    );
  }

  // Document Type Button builder helper
  Widget _buildDocTypeButton({
    required AddVehicleController controller,
    required String docType,
    required String label,
    bool isFullWidth = false,
  }) {
    return Obx(() {
      final isSelected = controller.selectedDocType.value == docType;
      return GestureDetector(
        onTap: () {
          controller.selectedDocType.value = docType;
        },
        child: Container(
          width: isFullWidth ? double.infinity : null,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: isSelected ? const Color(0xFFEFF5FF) : const Color(0xFFE6E7E9),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.w,
                color: isSelected ? const Color(0xFF1B4E9F) : Colors.black.withValues(alpha: 0.10),
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x28000000),
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: isSelected ? const Color(0xFF1B4E9F) : const Color(0xFF2A2A2A),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }

  // Selfie upload dotted card helper
  Widget _buildSelfieUploadArea(AddVehicleController controller, BuildContext context) {
    return Obx(() {
      if (controller.selfieImagePath.value == null) {
        return GestureDetector(
          onTap: () => _showSelfieSourceBottomSheet(context, controller),
          child: CustomPaint(
            painter: DashedBorderPainter(
              color: const Color(0xFF1B4E9F),
              strokeWidth: 2.w,
              borderRadius: 8.r,
            ),
            child: Container(
              width: double.infinity,
              height: 151.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: const Color(0xFF1B4E9F),
                    size: 24.r,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Take a Picture',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1B4E9F),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Take a clear selfie to verify it’s you.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1B4E9F),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 151.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.10),
                  width: 1.w,
                ),
                image: DecorationImage(
                  image: FileImage(File(controller.selfieImagePath.value!)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 8.h,
              right: 8.w,
              child: GestureDetector(
                onTap: () => controller.removeSelfie(),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(4.r),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16.r,
                  ),
                ),
              ),
            ),
          ],
        );
      }
    });
  }

  // Map view & address card layout helper
  Widget _buildMapView(AddVehicleController controller, BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([controller.stateController, controller.cityController]),
          builder: (context, child) {
            return MockMapWidget(
              state: controller.stateController.text.trim(),
              city: controller.cityController.text.trim(),
            );
          },
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 46.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: ShapeDecoration(
            color: const Color(0xFFFDFDFD),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.w,
                color: Colors.black.withValues(alpha: 0.10),
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x28000000),
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: const Color(0xFF1B4E9F),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Obx(() {
                  return Text(
                    controller.displayAddress.value,
                    style: GoogleFonts.poppins(
                      color: const Color(0xCC2A2A2A),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 28.r,
                height: 28.r,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.w,
                      color: Colors.black.withValues(alpha: 0.10),
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Icon(
                  Icons.my_location_rounded,
                  color: const Color(0xFF1B4E9F),
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 5 Form
  Widget _buildStep5Form(AddVehicleController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and description section
        Center(
          child: Column(
            children: [
              Text(
                'Review & Publish',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Review your listing details before going live',
                style: GoogleFonts.poppins(
                  color: const Color(0xCC2A2A2A),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Center(
          child: Container(
            width: 285.w,
            height: 1.h,
            color: Colors.black.withValues(alpha: 0.10),
          ),
        ),
        SizedBox(height: 24.h),

        // 1. Listing Preview Card
        _buildListingPreviewCard(controller, context),
        SizedBox(height: 24.h),

        // Section Title: Listing Summary
        Text(
          'Listing Summary',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),

        // 2. Collapsible Summary List
        Obx(() {
          return Column(
            children: [
              _buildSummaryItem(
                title: 'Vehicle Details',
                icon: Icons.directions_car_outlined,
                stepIndex: 0,
                isExpanded: controller.expandedSummaries[0],
                onToggle: () => controller.toggleSummary(0),
                onEdit: () => controller.currentStep.value = 1,
                content: _buildVehicleDetailsContent(controller),
              ),
              _buildSummaryItem(
                title: 'Photos & Condition',
                icon: Icons.photo_library_outlined,
                stepIndex: 1,
                isExpanded: controller.expandedSummaries[1],
                onToggle: () => controller.toggleSummary(1),
                onEdit: () => controller.currentStep.value = 2,
                content: _buildPhotosConditionContent(controller),
              ),
              _buildSummaryItem(
                title: 'Auction Setup',
                icon: Icons.gavel_rounded,
                stepIndex: 2,
                isExpanded: controller.expandedSummaries[2],
                onToggle: () => controller.toggleSummary(2),
                onEdit: () => controller.currentStep.value = 3,
                content: _buildAuctionSetupContent(controller),
              ),
              _buildSummaryItem(
                title: 'Verification',
                icon: Icons.verified_user_outlined,
                stepIndex: 3,
                isExpanded: controller.expandedSummaries[3],
                onToggle: () => controller.toggleSummary(3),
                onEdit: () => controller.currentStep.value = 4,
                content: _buildVerificationContent(controller),
              ),
            ],
          );
        }),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildListingPreviewCard(AddVehicleController controller, BuildContext context) {
    final imagePath = controller.selectedImagePaths.isNotEmpty 
        ? controller.selectedImagePaths.first 
        : controller.getDefaultImagePath();
    final isAsset = imagePath.startsWith('assets');
    final vehicleTitle = '${controller.yearController.value ?? ''} ${controller.makeController.text} ${controller.modelController.text}'.trim();
    final displayTitle = vehicleTitle.isNotEmpty ? vehicleTitle : 'Vehicle Preview';
    
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.w,
            color: Colors.black.withValues(alpha: 0.08),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image block
          Container(
            height: 160.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
              image: DecorationImage(
                image: isAsset
                    ? AssetImage(imagePath) as ImageProvider
                    : FileImage(File(imagePath)) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B4E9F).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'PREVIEW',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Details block
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle,
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF2A2A2A),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Starting Bid',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF6B7280),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '\$${controller.startingBidController.text}',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF1B4E9F),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.addVehiclePreview),
                  child: Container(
                    width: double.infinity,
                    height: 38.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF5FF),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: const Color(0xFF96BFFF),
                        width: 1.w,
                      ),
                    ),
                    child: Text(
                      'View Full Details',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF1B4E9F),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required IconData icon,
    required int stepIndex,
    required bool isExpanded,
    required VoidCallback onToggle,
    required VoidCallback onEdit,
    required Widget content,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.w,
            color: Colors.black.withValues(alpha: 0.08),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6.r,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          // Header Row
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: const Color(0xFF1B4E9F),
                    size: 20.r,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF2A2A2A),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onEdit,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Icon(
                        Icons.edit_outlined,
                        color: const Color(0xFF1B4E9F),
                        size: 18.r,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded 
                        ? Icons.keyboard_arrow_up_rounded 
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF6B7280),
                    size: 20.r,
                  ),
                ],
              ),
            ),
          ),
          // Expanded Content
          if (isExpanded) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    height: 1.h,
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                  SizedBox(height: 12.h),
                  content,
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVehicleDetailsContent(AddVehicleController controller) {
    return Column(
      children: [
        _buildSummaryRow('Make', controller.makeController.text),
        _buildSummaryRow('Model', controller.modelController.text),
        _buildSummaryRow('Year', controller.yearController.value ?? 'N/A'),
        _buildSummaryRow('Trim', controller.trimController.text.isNotEmpty ? controller.trimController.text : 'N/A'),
        _buildSummaryRow('Mileage', controller.mileageController.text),
        _buildSummaryRow('VIN', controller.vinController.text),
        _buildSummaryRow('Transmission', controller.transmissionController.text),
        _buildSummaryRow('Fuel Type', controller.fuelTypeController.text),
        _buildSummaryRow('Title Status', controller.titleStatusController.value ?? 'N/A'),
      ],
    );
  }

  Widget _buildPhotosConditionContent(AddVehicleController controller) {
    final hasImages = controller.selectedImagePaths.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryRow('Photos count', '${controller.selectedImagePaths.length} photos'),
        if (hasImages) ...[
          SizedBox(height: 8.h),
          SizedBox(
            height: 48.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.selectedImagePaths.length,
              itemBuilder: (context, index) {
                final img = controller.selectedImagePaths[index];
                final isAsset = img.startsWith('assets');
                return Container(
                  width: 48.h,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.08),
                      width: 1.w,
                    ),
                    image: DecorationImage(
                      image: isAsset
                          ? AssetImage(img) as ImageProvider
                          : FileImage(File(img)) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        SizedBox(height: 12.h),
        Text(
          'Description',
          style: GoogleFonts.poppins(
            color: const Color(0xFF6B7280),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.05),
              width: 1.w,
            ),
          ),
          child: Text(
            controller.descriptionController.text.isNotEmpty 
                ? controller.descriptionController.text 
                : 'No description provided.',
            style: GoogleFonts.poppins(
              color: const Color(0xFF2A2A2A),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Features',
          style: GoogleFonts.poppins(
            color: const Color(0xFF6B7280),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 6.h),
        _buildFeaturesWrap(controller),
      ],
    );
  }

  Widget _buildFeaturesWrap(AddVehicleController controller) {
    final featuresStr = controller.featuresController.text.trim();
    final featuresList = featuresStr.isNotEmpty
        ? featuresStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
        : <String>[];
        
    if (featuresList.isEmpty) {
      return Text(
        'No features listed.',
        style: GoogleFonts.poppins(
          color: const Color(0xFF2A2A2A),
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    }
    
    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: featuresList.map((feature) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1FF),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_rounded,
                color: const Color(0xFF1B4E9F),
                size: 12.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                feature,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1B4E9F),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAuctionSetupContent(AddVehicleController controller) {
    final reserveText = controller.reservePriceController.text.trim();
    final buyNowText = controller.buyNowPriceController.text.trim();
    return Column(
      children: [
        _buildSummaryRow('Starting Bid', '\$${controller.startingBidController.text}'),
        _buildSummaryRow(
          'Reserve Price',
          reserveText.isNotEmpty ? '\$$reserveText' : 'Not Set (No Reserve)',
        ),
        _buildSummaryRow(
          'Buy Now Price',
          buyNowText.isNotEmpty ? '\$$buyNowText' : 'Not Set',
        ),
        _buildSummaryRow('Auction Duration', controller.selectedDuration.value),
      ],
    );
  }

  Widget _buildVerificationContent(AddVehicleController controller) {
    final selfieUploaded = controller.selfieImagePath.value != null;
    return Column(
      children: [
        _buildSummaryRow('Document Type', controller.selectedDocType.value),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selfie Verification',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF6B7280),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  if (selfieUploaded) ...[
                    Container(
                      width: 24.r,
                      height: 24.r,
                      margin: EdgeInsets.only(right: 6.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.08),
                          width: 1.w,
                        ),
                        image: DecorationImage(
                          image: FileImage(File(controller.selfieImagePath.value!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.check_circle_rounded,
                      color: const Color(0xFF10B981),
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Uploaded',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF10B981),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else ...[
                    Icon(
                      Icons.error_outline_rounded,
                      color: const Color(0xFFF59E0B),
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Not Uploaded',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFF59E0B),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
        _buildSummaryRow('Location', controller.displayAddress.value),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: const Color(0xFF6B7280),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 16.w),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                color: const Color(0xFF2A2A2A),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// Styled mock vector map widget
class MockMapWidget extends StatelessWidget {
  final String city;
  final String state;

  const MockMapWidget({
    super.key,
    required this.city,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 146.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.10),
          width: 1.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            Positioned(
              left: -50.w,
              top: -20.h,
              child: Container(
                width: 250.w,
                height: 180.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
            Positioned(
              right: -30.w,
              bottom: -40.h,
              child: Container(
                width: 200.w,
                height: 150.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 50.h,
              child: Container(
                height: 6.h,
                color: Colors.white,
              ),
            ),
            Positioned(
              left: 80.w,
              top: 0,
              bottom: 0,
              child: Container(
                width: 6.w,
                color: Colors.white,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 30.h,
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(15 / 360),
                child: Container(
                  height: 6.h,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 40.w,
              top: 30.h,
              child: _buildRouteBadge('D68'),
            ),
            Positioned(
              right: 60.w,
              bottom: 45.h,
              child: _buildRouteBadge('D83'),
            ),
            Positioned(
              left: 60.w,
              top: 20.h,
              child: Text(
                state.isNotEmpty ? state : 'State',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              right: 50.w,
              bottom: 30.h,
              child: Text(
                city.isNotEmpty ? city : 'City',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteBadge(String code) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        code,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 8.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Custom Painter to draw a clean dashed border for the upload card
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = _buildDashedPath(path, 6.0, 4.0);
    canvas.drawPath(dashPath, paint);
  }

  Path _buildDashedPath(Path source, double dashLength, double gapLength) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double length = draw ? dashLength : gapLength;
        final double end = (distance + length).clamp(0.0, metric.length);
        if (draw) {
          dest.addPath(metric.extractPath(distance, end), Offset.zero);
        }
        distance = end;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

