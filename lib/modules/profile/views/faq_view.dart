import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_faq_tile.dart';
import '../controllers/faq_controller.dart';
import '../../../shared/widgets/app_back_button.dart';

class FaqView extends StatelessWidget {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FaqController>(
      init: FaqController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Navigation / Header Row
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: AppBackButton(),
                          ),
                          Text(
                            'FAQ',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF323232),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 48.h),

                    // 2. Collapsible FAQs List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.faqs.length,
                      separatorBuilder: (context, index) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final faq = controller.faqs[index];
                        return AppFaqTile(
                          question: faq.question,
                          answer: faq.answer,
                        );
                      },
                    ),

                    // Bottom spacing
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
