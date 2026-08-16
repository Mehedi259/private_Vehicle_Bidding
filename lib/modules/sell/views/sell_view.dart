import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/interfaces/i_sell_repository.dart';
import '../../../data/repositories/sell_repository_impl.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/sell_controller.dart';
import '../widgets/listed_vehicle_card.dart';

class SellView extends StatefulWidget {
  const SellView({super.key});

  @override
  State<SellView> createState() => _SellViewState();
}

class _SellViewState extends State<SellView> {
  late final SellController controller;

  @override
  void initState() {
    super.initState();
    // Register dependencies if they are not already active
    if (!Get.isRegistered<ISellRepository>()) {
      Get.lazyPut<ISellRepository>(() => SellRepositoryImpl());
    }
    controller = Get.put(SellController(Get.find<ISellRepository>()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sell Your Vehicle',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF2A2A2A),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'List your vehicle in a few simple steps',
                              style: GoogleFonts.outfit(
                                color: const Color(0xB22A2A2A),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.notifications);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: const Color(0xFF1B4E9F),
                            size: 24.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),

                // 2. Main Scrollable List Section
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value && controller.listedVehicles.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1B4E9F),
                        ),
                      );
                    }

                    if (controller.listedVehicles.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Text(
                            'No vehicles listed yet.',
                            style: GoogleFonts.outfit(
                              color: const Color(0x992A2A2A),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        top: 8.h,
                        bottom: 160.h, // Spacing to avoid bottom nav bar & float button overlap
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 176 / 247,
                      ),
                      itemCount: controller.listedVehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = controller.listedVehicles[index];
                        return ListedVehicleCard(
                          vehicle: vehicle,
                          onTap: () {
                            context.push(AppRoutes.auctionDetailsPath(vehicle.id));
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),

            // 3. Floating Bottom "+ Sell Vehicle" Action Button
            Positioned(
              left: 0,
              right: 0,
              bottom: 95.h, // Placed precisely above custom bottom navigation bar
              child: Center(
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.addVehicle),
                  child: Container(
                    width: 228.w,
                    height: 38.h,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1B4E9F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x28000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 20.r,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Sell Vehicle',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
