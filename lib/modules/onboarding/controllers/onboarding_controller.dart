import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/custom_assets.dart';

class OnboardingStepModel {
  final String title;
  final String description;
  final String imagePath;
  final String buttonText;

  const OnboardingStepModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.buttonText,
  });
}

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  final List<OnboardingStepModel> steps = const [
    OnboardingStepModel(
      title: 'Buy & Sell Vehicles Safely',
      description: 'Auction cars, trucks, boats and more through verified sellers.',
      imagePath: CustomAssets.onboardingTruck,
      buttonText: 'Next',
    ),
    OnboardingStepModel(
      title: 'Verified Sellers Only',
      description: 'Government ID and VIN verification help reduce fraud.',
      imagePath: CustomAssets.onboardingCar,
      buttonText: 'Next',
    ),
    OnboardingStepModel(
      title: 'Bid With Confidence',
      description: 'Secure transactions powered by Escrow protection.',
      imagePath: CustomAssets.onboardingMotorcycle,
      buttonText: 'Get Started',
    ),
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage(BuildContext context) {
    if (currentIndex.value < steps.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  void skipOnboarding(BuildContext context) {
    context.go(AppRoutes.login);
  }
}
