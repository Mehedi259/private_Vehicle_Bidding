import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/app_back_button.dart';

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({super.key});

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
                        'Terms & Conditions',
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

                // 2. Terms Text Context
                Text(
                  'Welcome to Private Vehicle Bidding. By using our platform (including mobile and web applications), you agree to these Terms & Conditions. Read carefully.\n\n'
                  '1. Terms Acceptance\n'
                  'Using Private Vehicle Bidding means you:\n'
                  '  *  Are 18 years of age or older\n'
                  '  *  Possess legal capacity to enter into binding agreements\n'
                  '  *  Accept and follow these Terms and all applicable local vehicle transaction laws\n'
                  'If you do not agree to these terms, please do not use our platform.\n\n'
                  '2. User Accounts\n'
                  'An account is required to place bids or list vehicles. You agree to:\n'
                  '  *  Provide accurate and up-to-date registration information\n'
                  '  *  Verify your identity through the Profile Verification screen before listing or bidding\n'
                  '  *  Maintain the security and confidentiality of your credentials\n'
                  '  *  Take full responsibility for all activities on your account\n'
                  'Accounts violating verification rules or engaging in fraudulent bids may be suspended immediately.\n\n'
                  '3. Bidding, Listings & Payments\n'
                  'Private Vehicle Bidding offers multiple tiers of interaction:\n'
                  '  *  Bidder Tier: Completely free to register, browse, and place active bids.\n'
                  '  *  Seller Tier: Fees apply when listing vehicles or finalizing auctions.\n'
                  '  *  Dealer Tier: Paid subscription offering auto-bidding agents, priority listings, and dealer badges.\n'
                  'Payment rules:\n'
                  '  *  Subscription plans are billed automatically and are non-refundable.\n'
                  '  *  Listings and reserve prices must follow fair market rules.\n'
                  '  *  Pricing tiers may change with advance notice.\n\n'
                  '4. Intellectual Property & Usage\n'
                  'All site layout, graphics, text, and proprietary bidding systems are protected by copyright.\n'
                  'You agree:\n'
                  '  *  Not to copy, scraped, or modify platform code or lists without authorization\n'
                  '  *  Not to run automated scripts, scrapers, or bots targeting active auctions\n\n'
                  '5. User-Generated Content\n'
                  'Sellers uploading listings:\n'
                  '  *  Must legally own the vehicle or represent the owner with written authorization\n'
                  '  *  Grant us permission to display vehicle images, specifications, and comments globally\n'
                  'We retain the right to:\n'
                  '  *  Review listing details before publishing\n'
                  '  *  Remove any content that violates platform safety or pricing policies\n\n'
                  '6. Moderation & Safety\n'
                  'We actively moderate:\n'
                  '  *  Vehicle listings and condition reports\n'
                  '  *  Comments and bidder messages\n'
                  'We remove harmful, abusive, or copyrighted items and coordinate with local authorities for reported fraud.\n\n'
                  '7. Community Rules\n'
                  'Interactive spaces require respectful communications:\n'
                  '  *  No abusive language, harassment, or defamatory comments toward other bidders or sellers\n'
                  'We reserve the right to ban users who disrupt live auctions or make false bidding claims.\n\n'
                  '8. Live Auction Streaming\n'
                  'Private Vehicle Bidding offers live bids and state updates. We note that:\n'
                  '  *  Server latencies can cause brief delays in active bid receipts\n'
                  '  *  Active bids cannot be retracted once placed\n'
                  '  *  Vehicle availability depends on active seller validation\n\n'
                  '9. Advertising\n'
                  'Free tier users will encounter sparse banner advertising. Verified dealers and premium listings are ad-free.\n\n'
                  '10. Account Termination\n'
                  'We may terminate or suspend accounts due to:\n'
                  '  *  Violations of bidding guidelines (e.g. shill bidding)\n'
                  '  *  Failure to complete a won vehicle transaction\n'
                  '  *  Fraudulent verification documents\n'
                  'You may close your account at any time via Profile Settings.\n\n'
                  '11. Liability Limit\n'
                  'Private Vehicle Bidding is not liable for:\n'
                  '  *  Auction outages or internet connectivity dropouts on bidder device\n'
                  '  *  Misleading descriptions from private sellers (buyers are encouraged to verify vehicle parameters)\n'
                  '  *  Financial transactions made outside our approved platform pathways\n\n'
                  '12. Third-Party Integrations\n'
                  'We work with external payment processing and identity verification services. We do not control or take responsibility for their terms or server stability.\n\n'
                  '13. Term Changes\n'
                  'We may update these terms at any time. Continued usage of the bidding service represents acceptance of terms updates.\n\n'
                  '14. Governing Law\n'
                  'These Terms are governed by and construed in accordance with the laws of this jurisdiction.\n\n'
                  '15. Contact Information\n'
                  'Questions regarding these Terms?\n'
                  '  *  Email: support@privatevehiclebidding.com\n'
                  '  *  Help Center: www.privatevehiclebidding.com/help',
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
