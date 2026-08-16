import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppDatePickerField extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final String hintText;
  final Color fillColor;

  const AppDatePickerField({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onTap,
    this.hintText = 'Select Date',
    this.fillColor = const Color(0xFFF9FAFB),
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
        : hintText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // External Label
        Text(
          labelText,
          style: GoogleFonts.poppins(
            color: const Color(0xFF2D292E),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        // Interactive Field Container
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48.h, // Standard height matching AppTextField
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 20.sp,
                  color: const Color(0xFF6B7280),
                ),
                SizedBox(width: 12.w),
                Text(
                  displayValue,
                  style: GoogleFonts.poppins(
                    color: selectedDate != null
                        ? const Color(0xFF2D292E)
                        : const Color(0xFF6B7280),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
