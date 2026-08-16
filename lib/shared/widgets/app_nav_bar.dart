import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/snackbar_helper.dart';

class AppNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AppNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double systemNavBarHeight = MediaQuery.of(context).viewPadding.bottom;

    final double barHeight = 80.h;
    final double fabSize = 55.r;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: barHeight + 10.h,
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              // Custom Painted background bar with cutout and shadow
              CustomPaint(
                size: Size(screenWidth, barHeight),
                painter: NavBarPainter(barHeight: barHeight),
              ),

              // Navigation Items Row
              Container(
                height: barHeight,
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Row(
                  children: [
                    Expanded(
                      child: _NavBarItem(
                        label: 'Home',
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home,
                        isSelected: selectedIndex == 0,
                        onTap: () => onItemTapped(0),
                      ),
                    ),
                    Expanded(
                      child: _NavBarItem(
                        label: 'Browse',
                        icon: Icons.search_outlined,
                        activeIcon: Icons.search,
                        isSelected: selectedIndex == 1,
                        onTap: () => onItemTapped(1),
                      ),
                    ),
                    SizedBox(width: 100.w), // Space for center FAB
                    Expanded(
                      child: _NavBarItem(
                        label: 'My Bids',
                        icon: Icons.gavel_outlined,
                        activeIcon: Icons.gavel,
                        isSelected: selectedIndex == 3,
                        onTap: () => onItemTapped(3),
                      ),
                    ),
                    Expanded(
                      child: _NavBarItem(
                        label: 'Profile',
                        icon: Icons.person_outline,
                        activeIcon: Icons.person,
                        isSelected: selectedIndex == 4,
                        onTap: () => onItemTapped(4),
                      ),
                    ),
                  ],
                ),
              ),

              // Center FAB with 'Sell' Text under it
              Positioned(
                top: 0,
                child: GestureDetector(
                  onTap: () => onItemTapped(2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: fabSize,
                        width: fabSize,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B4E9F),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4.r,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10.r,
                              offset: Offset(0, 4.h),
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 32.r,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Sell',
                        style: GoogleFonts.poppins(
                          color: selectedIndex == 2 ? const Color(0xFFF7F8FC) : const Color(0xB2F7F8FC),
                          fontSize: 12.sp,
                          fontWeight: selectedIndex == 2 ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (systemNavBarHeight > 0)
          Container(
            height: systemNavBarHeight,
            color: const Color(0xFF1B4E9F),
          ),
      ],
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? const Color(0xFFF7F8FC) : const Color(0xB2F7F8FC);
    final weight = isSelected ? FontWeight.w700 : FontWeight.w400;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            size: 24.sp,
            color: color,
          ),
          SizedBox(height: 5.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 12.sp,
                fontWeight: weight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarPainter extends CustomPainter {
  final double barHeight;
  NavBarPainter({required this.barHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1B4E9F)
      ..style = PaintingStyle.fill;

    final path = Path();

    final double cornerRadius = 35.r;

    path.moveTo(0, size.height);

    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 18.h, cornerRadius, 16.h);

    final double cx = size.width / 2;
    final double nw = 55.w;

    path.lineTo(cx - nw, 0);

    path.cubicTo(
      cx - nw + 20.w, 0,
      cx - nw + 20.w, barHeight * 0.60,
      cx, barHeight * 0.55,
    );
    path.cubicTo(
      cx + nw - 20.w, barHeight * 0.60,
      cx + nw - 20.w, 0,
      cx + nw, 0,
    );

    path.lineTo(size.width - cornerRadius, 16.h);
    path.quadraticBezierTo(size.width, 18.h, size.width, cornerRadius);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.12), 8.r, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant NavBarPainter oldDelegate) => oldDelegate.barHeight != barHeight;
}
