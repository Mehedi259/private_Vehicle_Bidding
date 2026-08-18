import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../controllers/payment_methods_controller.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_back_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentMethodsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24.h, left: 24.w, right: 24.w),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: AppBackButton(),
                  ),
                  Text(
                    'Payment Methods',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF323232),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value && controller.cards.isEmpty) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: const Color(0xFF1B4E9F),
                        size: 40.r,
                      ),
                    );
                  }

                  return Column(
                    children: [
                      if (controller.cards.isEmpty)
                        Expanded(
                          child: Center(
                            child: Text(
                              'No saved payment methods.',
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                color: const Color(0xFF718096),
                              ),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(16.w),
                            itemCount: controller.cards.length,
                            separatorBuilder: (context, index) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final card = controller.cards[index];
                              return _buildCardTile(context, controller, card);
                            },
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: AppButton(
                          text: 'Add Test Card (Mock)',
                          onPressed: controller.isLoading.value ? null : () => controller.addTestCard(),
                          backgroundColor: const Color(0xFF1B4E9F),
                          textColor: Colors.white,
                          isLoading: controller.isLoading.value,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTile(BuildContext context, PaymentMethodsController controller, dynamic card) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Center(
              child: Text(
                card.cardBrand.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B4E9F),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•••• •••• •••• ${card.last4}',
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Expires ${card.expMonth.toString().padLeft(2, '0')}/${card.expYear}',
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFE53E3E)),
            onPressed: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                title: 'Remove Card',
                desc: 'Are you sure you want to remove this card?',
                btnCancelOnPress: () {},
                btnOkOnPress: () => controller.removeCard(card.id),
              ).show();
            },
          ),
        ],
      ),
    );
  }
}
