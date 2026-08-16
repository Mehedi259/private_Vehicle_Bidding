import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/app_back_button.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Navigation / Header Row
                Padding(
                  padding: EdgeInsets.only(top: 24.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: AppBackButton(),
                      ),
                      Text(
                        'Privacy Policy',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF323232),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.10,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),

                // 2. Policy Text Context
                Text(
                  'Welcome to Private Vehicle Bidding. Your privacy matters. This Privacy Policy details how we handle your data across our platform, including our mobile and web applications.\n\n'
                  '1. Data Collection\n'
                  ' a. Personal Data\n'
                  '   We collect data you provide directly:\n'
                  '   - Full Name\n'
                  '   - Contact Email\n'
                  '   - Mobile Number\n'
                  '   - Login Details\n'
                  '   - Identity Verification documents (e.g. driving license, passport, selfie)\n'
                  '   - Payment & Billing details (for listing fees or dealer packages)\n'
                  ' b. Usage Data\n'
                  '   We automatically track:\n'
                  '   - Bidding & Auction history\n'
                  '   - Searched and viewed vehicle listings\n'
                  '   - Device Specifications & OS info\n'
                  '   - In-app actions & navigation history\n'
                  ' c. Vehicle & Listing Content\n'
                  '   For sellers listing vehicles, we gather:\n'
                  '   - Uploaded Vehicle Images and Specifications\n'
                  '   - Auction metadata (starting price, reserve price, details)\n'
                  '   - User comments, bid submissions, and bidding values\n\n'
                  '2. Data Usage\n'
                  '   We use your data to:\n'
                  '   - Deliver, secure, and refine our bidding and auction services\n'
                  '   - Tailor vehicle recommendations and search relevance\n'
                  '   - Handle accounts and security checks\n'
                  '   - Process listing payments and fee transactions\n'
                  '   - Assess system performance and traffic\n'
                  '   - Enforce policy compliance and bidding rules\n\n'
                  '3. Tracking Technologies\n'
                  '   We employ cookies and secure local storage to:\n'
                  '   - Improve user experience\n'
                  '   - Save preferences and sessions\n'
                  '   - Evaluate system analytics and speed\n\n'
                  '4. Data Sharing\n'
                  '   We do not sell your data. We may share with:\n'
                  '   - Payment gateway providers\n'
                  '   - Analytics services\n   - Identity verification providers\n'
                  '   - Legal entities when legally required\n\n'
                  '5. Advertising\n'
                  '   Free users may encounter limited banner or display ads. Partners may use limited diagnostic data for relevant ads.\n\n'
                  '6. Data Protection\n'
                  '   We use modern encryption measures to protect your data, but absolute transmission security is not guaranteed.\n\n'
                  '7. Content Guidelines\n'
                  '   Sellers are accountable for their listings. We may:\n'
                  '   - Review, edit, or remove listings violating guidelines\n'
                  '   - Terminate policy-violating or fraudulent accounts\n\n'
                  '8. User Rights\n'
                  '   You can:\n'
                  '   - Access your stored data\n'
                  '   - Modify your profile details\n'
                  '   - Request account deletion\n'
                  '   - Adjust notification configurations\n\n'
                  '9. Children\'s Policy\n'
                  '   Our bidding platform is strictly for users 18+. We do not collect minor\'s data.\n\n'
                  '10. External Services\n'
                  '    We are not responsible for the privacy practices of third-party links or services.\n\n'
                  '11. Data Storage\n'
                  '    We retain data as needed for service delivery, legal requirements, and operations.\n\n'
                  '12. Policy Updates\n'
                  '    We may update this policy and will notify users of major changes.\n\n'
                  '13. Contact Information\n'
                  '    For questions, reach out to:\n'
                  '    - Email: support@privatevehiclebidding.com\n'
                  '    - Help Center: help.privatevehiclebidding.com',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF323232),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),

                // Bottom spacing
                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
