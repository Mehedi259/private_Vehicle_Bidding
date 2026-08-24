import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingActionBar extends StatefulWidget {
  final String buttonText;
  final int currentIndex;
  final VoidCallback onNextTap;
  final VoidCallback onSkip;

  const OnboardingActionBar({
    super.key,
    required this.buttonText,
    required this.currentIndex,
    required this.onNextTap,
    required this.onSkip,
  });

  @override
  State<OnboardingActionBar> createState() => _OnboardingActionBarState();
}

class _OnboardingActionBarState extends State<OnboardingActionBar> {
  double _dragOffset = 0.0;
  bool _isFinished = false;

  @override
  void didUpdateWidget(covariant OnboardingActionBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      setState(() {
        _dragOffset = 0.0;
        _isFinished = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.27),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFC4C4C4),
          ),
          borderRadius: BorderRadius.circular(56.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10.3,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double trackWidth = constraints.maxWidth;
          final double buttonWidth = 140.w;
          final double maxDrag = trackWidth - buttonWidth;

          return SizedBox(
            width: trackWidth,
            height: constraints.maxHeight,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Arrows positioned on the right
                Positioned(
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4.w,
                    children: List.generate(
                      5,
                      (arrowIndex) {
                        final double opacity = ((arrowIndex + 1) / 5) * (widget.currentIndex == 2 ? 1.0 : 0.7);

                        return Opacity(
                          opacity: opacity,
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: const Color(0xFF4CAF50),
                            size: 20.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Draggable Button
                Positioned(
                  left: _dragOffset,
                  child: GestureDetector(
                    onTap: widget.onNextTap,
                    onPanUpdate: (details) {
                      if (_isFinished) return;
                      setState(() {
                        _dragOffset += details.delta.dx;
                        if (_dragOffset < 0) _dragOffset = 0;
                        if (_dragOffset >= maxDrag) {
                          _dragOffset = maxDrag;
                          _isFinished = true;
                          widget.onSkip();
                        }
                      });
                    },
                    onPanEnd: (details) {
                      if (!_isFinished) {
                        setState(() {
                          _dragOffset = 0.0;
                        });
                      }
                    },
                    child: Container(
                      height: 47.h,
                      width: buttonWidth,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1B4E9F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(37.r),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.buttonText,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
