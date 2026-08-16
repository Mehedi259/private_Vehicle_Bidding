import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDropdownField extends StatelessWidget {
  final String labelText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? hintText;
  final Color fillColor;

  final bool isRequired;

  const AppDropdownField({
    super.key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.fillColor = const Color(0xFFF9FAFB),
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // External Label
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: labelText,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2D292E),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFF86247),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        // Styled Dropdown Container
        Container(
          height: 48.h, // Standard height matching AppTextField
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF6B7280),
                size: 24.sp,
              ),
              elevation: 16,
              style: GoogleFonts.poppins(
                color: const Color(0xFF2D292E),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              onChanged: onChanged,
              hint: hintText != null
                  ? Text(
                      hintText!,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF6B7280),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : null,
              items: items.map<DropdownMenuItem<String>>((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
