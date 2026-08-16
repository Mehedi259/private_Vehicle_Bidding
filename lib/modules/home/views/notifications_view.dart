import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_routes.dart';
import '../../../data/models/notification_model.dart';
import '../controllers/home_controller.dart';
import '../../../shared/widgets/app_back_button.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Back button left-aligned
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: AppBackButton(),
                  ),
                  // Centered Title
                  Text(
                    'Notification',
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

            // 2. Notifications List
            Expanded(
              child: Obx(() {
                final list = controller.notifications;

                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'No notifications found.',
                      style: GoogleFonts.outfit(
                        color: const Color(0x992A2A2A),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: list.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final isSuccess = item.type == NotificationType.success;

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      decoration: ShapeDecoration(
                        color: isSuccess ? const Color(0xFFEBFFEF) : const Color(0xFFFFEAE6),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1.w,
                            color: isSuccess
                                ? const Color(0x3305BE28)
                                : const Color(0x33F96248),
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x12000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Circular Icon Container
                          Container(
                            width: 36.r,
                            height: 36.r,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.w,
                                  color: isSuccess
                                      ? const Color(0xFF05BE28)
                                      : const Color(0xFFF86247),
                                ),
                                borderRadius: BorderRadius.circular(36.r),
                              ),
                            ),
                            child: Icon(
                              isSuccess
                                  ? Icons.check_circle_rounded
                                  : Icons.warning_amber_rounded,
                              color: isSuccess
                                  ? const Color(0xFF05BE28)
                                  : const Color(0xFFF86247),
                              size: 18.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Text Content Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF2A2A2A),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  item.message,
                                  style: GoogleFonts.inter(
                                    color: const Color(0x99323232),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                GestureDetector(
                                  onTap: () {
                                    context.push(AppRoutes.auctionDetailsPath(item.vehicleId));
                                  },
                                  child: Text(
                                    'View Vehicle',
                                    style: GoogleFonts.inter(
                                      color: isSuccess
                                          ? const Color(0xFF05BE28)
                                          : const Color(0xFFF86247),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
