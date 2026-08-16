import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_page_content.dart';
import '../widgets/onboarding_action_bar.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: const Color(0xFFE7ECEF),
      body: SafeArea(
        child: Stack(
          children: [
            // Centered Header (Logo & Company text)
            Positioned(
              top: 20.h,
              left: 0,
              right: 0,
              child: const OnboardingHeader(),
            ),

            // Content PageView (Illustrations & Texts)
            Positioned.fill(
              top: 140.h,
              bottom: 110.h,
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.steps.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  return OnboardingPageContent(
                    step: controller.steps[index],
                    index: index,
                  );
                },
              ),
            ),

            // Floating Custom Bottom Action Bar
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 24.h,
              child: Obx(
                () => OnboardingActionBar(
                  buttonText: controller.steps[controller.currentIndex.value].buttonText,
                  currentIndex: controller.currentIndex.value,
                  onNextTap: () => controller.nextPage(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
