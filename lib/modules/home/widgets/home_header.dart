import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Bidding ',
                  style: GoogleFonts.oswald(
                    color: const Color(0xFF1B4E9F),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: 'Motors',
                  style: GoogleFonts.oswald(
                    color: const Color(0xFF2A2A2A),
                    fontSize: 18.sp,
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
            child: Icon(
              Icons.notifications_none_rounded,
              color: const Color(0xFF1B4E9F),
              size: 24.r,
            ),
          ),
        ],
      ),
    );
  }
}
