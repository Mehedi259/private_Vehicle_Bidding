import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/add_vehicle_controller.dart';
import 'add_vehicle_view.dart';
import '../../../shared/widgets/app_back_button.dart';

class AddVehiclePreviewDetailsView extends StatelessWidget {
  const AddVehiclePreviewDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddVehicleController>();

    final imagePath = controller.selectedImagePaths.isNotEmpty
        ? controller.selectedImagePaths.first
        : controller.getDefaultImagePath();
    final isAsset = imagePath.startsWith('assets');
    
    final vehicleTitle = '${controller.yearController.value ?? ''} ${controller.makeController.text} ${controller.modelController.text}'.trim();
    final displayTitle = vehicleTitle.isNotEmpty ? vehicleTitle : 'Vehicle Preview';

    final reserveText = controller.reservePriceController.text.trim();
    final buyNowText = controller.buyNowPriceController.text.trim();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Center(
          child: AppBackButton(),
        ),
        title: Text(
          'Listing Details Preview',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image Carousel / Hero Image
            _buildHeroImage(controller, imagePath, isAsset),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Primary info card
                  _buildPrimaryInfoCard(displayTitle, controller),
                  SizedBox(height: 20.h),

                  // 3. Pricing details
                  _buildPricingCard(controller, reserveText, buyNowText),
                  SizedBox(height: 20.h),

                  // 4. Specifications Grid
                  _buildSpecificationsSection(controller),
                  SizedBox(height: 20.h),

                  // 5. Description
                  _buildDescriptionSection(controller),
                  SizedBox(height: 20.h),

                  // 6. Features
                  _buildFeaturesSection(controller),
                  SizedBox(height: 20.h),

                  // 7. Verification & Seller Info
                  _buildVerificationSection(controller),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage(AddVehicleController controller, String imagePath, bool isAsset) {
    return Container(
      height: 240.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        image: DecorationImage(
          image: isAsset
              ? AssetImage(imagePath) as ImageProvider
              : FileImage(File(imagePath)) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: controller.selectedImagePaths.length > 1
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(12.r),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '1 / ${controller.selectedImagePaths.length} Photos',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _buildPrimaryInfoCard(String title, AddVehicleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF5FF),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            controller.selectedCategory.value.toUpperCase(),
            style: GoogleFonts.poppins(
              color: const Color(0xFF1B4E9F),
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          title,
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (controller.trimController.text.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            controller.trimController.text,
            style: GoogleFonts.poppins(
              color: const Color(0xFF6B7280),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPricingCard(AddVehicleController controller, String reserveText, String buyNowText) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.06),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Starting Bid',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF6B7280),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$${controller.startingBidController.text}',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF1B4E9F),
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (buyNowText.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Buy Now Price',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF6B7280),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '\$$buyNowText',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF10B981),
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (reserveText.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Divider(color: Colors.black.withOpacity(0.06), height: 1.h),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reserve Price Status',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF6B7280),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Set to \$$reserveText',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF2A2A2A),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecificationsSection(AddVehicleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specifications',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.black.withOpacity(0.04),
              width: 1.w,
            ),
          ),
          child: Column(
            children: [
              _buildSpecRow('Year', controller.yearController.value ?? 'N/A', 'Mileage', '${controller.mileageController.text} km'),
              _buildSpecRow('Transmission', controller.transmissionController.text, 'Fuel Type', controller.fuelTypeController.text),
              _buildSpecRow('Drive Type', controller.driveTypeController.text.isNotEmpty ? controller.driveTypeController.text : 'N/A', 'Engine', controller.engineController.text.isNotEmpty ? controller.engineController.text : 'N/A'),
              _buildSpecRow('Exterior Color', controller.exteriorColorController.text.isNotEmpty ? controller.exteriorColorController.text : 'N/A', 'Interior Color', controller.interiorColorController.text.isNotEmpty ? controller.interiorColorController.text : 'N/A'),
              _buildSingleSpecRow('VIN Number', controller.vinController.text),
              _buildSingleSpecRow('Title Status', controller.titleStatusController.value ?? 'N/A', isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(String label1, String val1, String label2, String val2) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label1, style: GoogleFonts.poppins(color: const Color(0xFF6B7280), fontSize: 12.sp, fontWeight: FontWeight.w400)),
                Flexible(child: Text(val1, style: GoogleFonts.poppins(color: const Color(0xFF2A2A2A), fontSize: 12.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          Container(width: 1.w, height: 16.h, color: Colors.black.withOpacity(0.06), margin: EdgeInsets.symmetric(horizontal: 16.w)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label2, style: GoogleFonts.poppins(color: const Color(0xFF6B7280), fontSize: 12.sp, fontWeight: FontWeight.w400)),
                Flexible(child: Text(val2, style: GoogleFonts.poppins(color: const Color(0xFF2A2A2A), fontSize: 12.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleSpecRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.poppins(color: const Color(0xFF6B7280), fontSize: 12.sp, fontWeight: FontWeight.w400)),
              Text(value, style: GoogleFonts.poppins(color: const Color(0xFF2A2A2A), fontSize: 12.sp, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        if (!isLast) Divider(color: Colors.black.withOpacity(0.04), height: 1.h),
      ],
    );
  }

  Widget _buildDescriptionSection(AddVehicleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          controller.descriptionController.text.isNotEmpty
              ? controller.descriptionController.text
              : 'No description provided.',
          style: GoogleFonts.poppins(
            color: const Color(0xFF4B5563),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(AddVehicleController controller) {
    final featuresStr = controller.featuresController.text.trim();
    final featuresList = featuresStr.isNotEmpty
        ? featuresStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
        : <String>[];

    if (featuresList.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: featuresList.map((feature) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF5FF),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: const Color(0xFF96BFFF).withOpacity(0.5),
                  width: 1.w,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_rounded, color: const Color(0xFF1B4E9F), size: 14.r),
                  SizedBox(width: 6.w),
                  Text(
                    feature,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1B4E9F),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVerificationSection(AddVehicleController controller) {
    final selfieUploaded = controller.selfieImagePath.value != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seller & Verification Status',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.black.withOpacity(0.06), width: 1.w),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Verification Method', style: GoogleFonts.poppins(color: const Color(0xFF6B7280), fontSize: 12.sp, fontWeight: FontWeight.w400)),
                  Text(controller.selectedDocType.value, style: GoogleFonts.poppins(color: const Color(0xFF2A2A2A), fontSize: 12.sp, fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(height: 12.h),
              Divider(color: Colors.black.withOpacity(0.04), height: 1.h),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Selfie Uploaded', style: GoogleFonts.poppins(color: const Color(0xFF6B7280), fontSize: 12.sp, fontWeight: FontWeight.w400)),
                  Row(
                    children: [
                      if (selfieUploaded) ...[
                        Container(
                          width: 24.r,
                          height: 24.r,
                          margin: EdgeInsets.only(right: 6.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(File(controller.selfieImagePath.value!)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Icon(Icons.check_circle, color: const Color(0xFF10B981), size: 16.sp),
                      ] else ...[
                        Icon(Icons.cancel, color: const Color(0xFFEF4444), size: 16.sp),
                      ],
                      SizedBox(width: 4.w),
                      Text(selfieUploaded ? 'Verified' : 'Pending', style: GoogleFonts.poppins(color: selfieUploaded ? const Color(0xFF10B981) : const Color(0xFFEF4444), fontSize: 12.sp, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Divider(color: Colors.black.withOpacity(0.04), height: 1.h),
              SizedBox(height: 12.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Address Location', style: GoogleFonts.poppins(color: const Color(0xFF6B7280), fontSize: 12.sp, fontWeight: FontWeight.w400)),
                  SizedBox(width: 24.w),
                  Expanded(
                    child: Text(
                      controller.displayAddress.value,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF2A2A2A),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              MockMapWidget(
                city: controller.cityController.text.trim(),
                state: controller.stateController.text.trim(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
