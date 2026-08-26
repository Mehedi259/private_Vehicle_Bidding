import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime? endTime;

  const CountdownTimerWidget({super.key, this.endTime});

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late String _timeLeft;
  // Use a Future for delayed updates to avoid memory leaks with Timer
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void didUpdateWidget(CountdownTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.endTime != oldWidget.endTime) {
      _updateTime();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _updateTime() {
    if (_isDisposed) return;
    
    setState(() {
      if (widget.endTime == null) {
        _timeLeft = 'Time not set';
      } else {
        final now = DateTime.now();
        if (now.isAfter(widget.endTime!)) {
          _timeLeft = 'Auction Ended';
        } else {
          final diff = widget.endTime!.difference(now);
          final totalHours = diff.inHours.toString().padLeft(2, '0');
          final mins = diff.inMinutes.remainder(60).toString().padLeft(2, '0');
          final secs = diff.inSeconds.remainder(60).toString().padLeft(2, '0');
          
          _timeLeft = '${totalHours}h ${mins}m ${secs}s Left';
        }
      }
    });

    if (widget.endTime != null && widget.endTime!.isAfter(DateTime.now())) {
      Future.delayed(const Duration(seconds: 1), _updateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeLeft,
      style: GoogleFonts.poppins(
        color: const Color(0xFFF86247),
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
