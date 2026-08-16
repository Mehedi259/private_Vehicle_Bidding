import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final IconData? leadingIcon;
  final Widget? leading;
  final VoidCallback onTap;
  final IconData trailingIcon;
  final bool showTrailingIcon;
  final bool showIconBorder;
  final Color cardBgColor;
  final Color iconBgColor;
  final Color iconColor;
  final Color titleColor;
  final double? width;

  const AppListTile({
    super.key,
    required this.title,
    this.leadingIcon,
    this.leading,
    required this.onTap,
    this.trailingIcon = Icons.chevron_right_rounded,
    this.showTrailingIcon = true,
    this.showIconBorder = false,
    this.cardBgColor = const Color(0xFFF0F0F0),
    this.iconBgColor = const Color(0xFFF4F7FD),
    this.iconColor = const Color(0xFF1B4E9F), // Matches the primary color of the app
    this.titleColor = const Color(0xFF323232),
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        padding: EdgeInsets.all(12.r),
        decoration: ShapeDecoration(
          color: cardBgColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.w,
              color: const Color(0x7FFEFEFE),
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 6,
              offset: Offset(0, 3),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                  ] else if (leadingIcon != null) ...[
                    Container(
                      width: 34.r,
                      height: 34.r,
                      decoration: ShapeDecoration(
                        color: iconBgColor,
                        shape: RoundedRectangleBorder(
                          side: showIconBorder
                              ? BorderSide(
                                  width: 1.w,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  color: const Color(0xFFC6C5C6),
                                )
                              : BorderSide.none,
                          borderRadius: BorderRadius.circular(17.r),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          leadingIcon!,
                          size: 18.sp,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ],
                  if (leading != null || leadingIcon != null)
                    SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: titleColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (showTrailingIcon)
              Icon(
                trailingIcon,
                size: 24.sp,
                color: titleColor,
              ),
          ],
        ),
      ),
    );
  }
}
