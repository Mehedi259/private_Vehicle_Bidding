import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/auction_item.dart';
import '../../core/utils/snackbar_helper.dart';

class PlaceBidDialog extends StatefulWidget {
  final AuctionItem item;

  const PlaceBidDialog({super.key, required this.item});

  static Future<double?> show(BuildContext context, AuctionItem item) {
    return showDialog<double>(
      context: context,
      barrierDismissible: true,
      builder: (context) => PlaceBidDialog(item: item),
    );
  }

  @override
  State<PlaceBidDialog> createState() => _PlaceBidDialogState();
}

class _PlaceBidDialogState extends State<PlaceBidDialog> {
  int _selectedOptionIndex = 0; // 0, 1, 2, 3 = increments, 4 = custom amount
  final TextEditingController _customAmountController = TextEditingController();
  final FocusNode _customFocusNode = FocusNode();

  late final double _currentBid;
  late final List<double> _bidOptions;

  @override
  void initState() {
    super.initState();
    _currentBid = widget.item.currentBid;
    // Increments of 500, 1000, 1500, 2000
    _bidOptions = [
      _currentBid + 500,
      _currentBid + 1000,
      _currentBid + 1500,
      _currentBid + 2000,
    ];
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    _customFocusNode.dispose();
    super.dispose();
  }

  void _submitBid() {
    double bidAmount = 0.0;
    if (_selectedOptionIndex < 4) {
      bidAmount = _bidOptions[_selectedOptionIndex];
    } else {
      final customText = _customAmountController.text.trim().replaceAll(RegExp(r'[^0-9.]'), '');
      final amount = double.tryParse(customText);
      if (amount == null || amount <= _currentBid) {
        final formattedMin = NumberFormat.simpleCurrency(name: '\$', decimalDigits: 0).format(_currentBid);
        SnackbarHelper.showError('Please enter a valid bid amount higher than the current bid of $formattedMin.');
        return;
      }
      bidAmount = amount;
    }

    Navigator.of(context).pop(bidAmount);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(name: '\$', decimalDigits: 0);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 10,
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      clipBehavior: Clip.none,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Close button positioned top-right overlapping the dialog border
          Positioned(
            right: -8.w,
            top: -8.h,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 26.r,
                height: 26.r,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
          ),

          // Dialog Body
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Current Bid text label (Centered)
                Text(
                  'Current Bid',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF2A2A2A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                // Underlined Bid Price (Centered)
                Text(
                  currencyFormat.format(_currentBid),
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF1B4E9F),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF1B4E9F),
                  ),
                ),
                SizedBox(height: 20.h),

                // Place Your Bid Subtitle (Centered)
                Text(
                  'Place Your Bid',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF2A2A2A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),

                // Bid options grid (2 columns, 2 rows)
                Row(
                  children: [
                    Expanded(
                      child: _BidOptionTile(
                        amount: _bidOptions[0],
                        isSelected: _selectedOptionIndex == 0,
                        onTap: () {
                          setState(() {
                            _selectedOptionIndex = 0;
                          });
                          _customFocusNode.unfocus();
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _BidOptionTile(
                        amount: _bidOptions[1],
                        isSelected: _selectedOptionIndex == 1,
                        onTap: () {
                          setState(() {
                            _selectedOptionIndex = 1;
                          });
                          _customFocusNode.unfocus();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _BidOptionTile(
                        amount: _bidOptions[2],
                        isSelected: _selectedOptionIndex == 2,
                        onTap: () {
                          setState(() {
                            _selectedOptionIndex = 2;
                          });
                          _customFocusNode.unfocus();
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _BidOptionTile(
                        amount: _bidOptions[3],
                        isSelected: _selectedOptionIndex == 3,
                        onTap: () {
                          setState(() {
                            _selectedOptionIndex = 3;
                          });
                          _customFocusNode.unfocus();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Custom amount row (Full width)
                _CustomAmountTile(
                  isSelected: _selectedOptionIndex == 4,
                  onTap: () {
                    setState(() {
                      _selectedOptionIndex = 4;
                    });
                    _customFocusNode.requestFocus();
                  },
                  controller: _customAmountController,
                  focusNode: _customFocusNode,
                ),
                SizedBox(height: 24.h),

                // Add Bid button at bottom of dialog
                GestureDetector(
                  onTap: _submitBid,
                  child: Container(
                    width: double.infinity,
                    height: 44.h,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1B4E9F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Add Bid',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BidOptionTile extends StatelessWidget {
  final double amount;
  final bool isSelected;
  final VoidCallback onTap;

  const _BidOptionTile({
    required this.amount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(name: '\$', decimalDigits: 0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFF0F5FF) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: isSelected ? 1.5.w : 1.w,
              color: isSelected ? const Color(0xFF1B4E9F) : const Color(0xFFE5E7EB),
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 18.r,
              height: 18.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF1B4E9F) : const Color(0xFFD1D5DB),
                  width: isSelected ? 5.w : 1.5.w,
                ),
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  currencyFormat.format(amount),
                  style: GoogleFonts.outfit(
                    color: isSelected ? const Color(0xFF1B4E9F) : const Color(0xFF2A2A2A),
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomAmountTile extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final TextEditingController controller;
  final FocusNode focusNode;

  const _CustomAmountTile({
    required this.isSelected,
    required this.onTap,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFF0F5FF) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: isSelected ? 1.5.w : 1.w,
              color: isSelected ? const Color(0xFF1B4E9F) : const Color(0xFFE5E7EB),
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 18.r,
              height: 18.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF1B4E9F) : const Color(0xFFD1D5DB),
                  width: isSelected ? 5.w : 1.5.w,
                ),
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: isSelected
                  ? Row(
                      children: [
                        Text(
                          '\$',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF1B4E9F),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            focusNode: focusNode,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF1B4E9F),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter Custom Amount',
                              hintStyle: GoogleFonts.outfit(
                                color: const Color(0x7F323232),
                                fontSize: 14.sp,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Custom Amount',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF2A2A2A),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
