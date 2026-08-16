import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/app_nav_bar.dart';
import '../controllers/shell_controller.dart';
import '../../home/views/home_view.dart';
import '../../browse/views/browse_view.dart';
import '../../sell/views/sell_view.dart';
import '../../my_bid/views/my_bid_view.dart';
import '../../profile/views/profile_view.dart';

class MainShellView extends StatelessWidget {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShellController());

    final List<Widget> pages = [
      const HomeView(key: ValueKey('home')),
      const BrowseView(key: ValueKey('browse')),
      const SellView(key: ValueKey('sell')),
      const MyBidView(key: ValueKey('my_bid')),
      const ProfileView(key: ValueKey('profile')),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          // Main content
          Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: pages[controller.selectedIndex.value],
          )),

          // Custom NavBar at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() => AppNavBar(
              selectedIndex: controller.selectedIndex.value,
              onItemTapped: controller.changePage,
            )),
          ),
        ],
      ),
    );
  }
}
