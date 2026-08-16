import 'package:go_router/go_router.dart';

import '../../modules/onboarding/views/onboarding_view.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/sign_up_view.dart';
import '../../modules/auth/views/verification_view.dart';
import '../../modules/auth/views/forgot_password_view.dart';
import '../../modules/auth/views/forgot_password_verification_view.dart';
import '../../modules/auth/views/reset_password_view.dart';
import '../../modules/auth/views/reset_success_view.dart';
import '../../modules/shell/views/main_shell_view.dart';
import '../../modules/browse/views/browse_view.dart';
import '../../modules/my_bid/views/my_bid_view.dart';
import '../../modules/profile/views/profile_view.dart';
import '../../modules/profile/views/edit_profile_view.dart';
import '../../modules/profile/views/profile_verification_view.dart';
import '../../modules/profile/views/security_view.dart';
import '../../modules/profile/views/change_password_view.dart';
import '../../modules/profile/views/support_help_view.dart';
import '../../modules/profile/views/faq_view.dart';
import '../../modules/profile/views/contact_support_view.dart';
import '../../modules/profile/views/privacy_policy_view.dart';
import '../../modules/profile/views/terms_conditions_view.dart';
import '../../modules/home/views/featured_auctions_view.dart';
import '../../modules/home/views/auction_details_view.dart';
import '../../modules/home/views/notifications_view.dart';
import '../../modules/sell/views/add_vehicle_view.dart';
import '../../modules/sell/views/add_vehicle_preview_details_view.dart';
import '../constants/app_routes.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: AppRoutes.verification,
        builder: (context, state) {
          final phoneNumber = state.uri.queryParameters['phone'] ?? '';
          final email = state.uri.queryParameters['email'] ?? '';
          return VerificationView(phoneNumber: phoneNumber, email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: AppRoutes.forgotPasswordVerification,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return ForgotPasswordVerificationView(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordView(),
      ),
      GoRoute(
        path: AppRoutes.resetSuccess,
        builder: (context, state) => const ResetSuccessView(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainShellView(),
      ),
      GoRoute(
        path: AppRoutes.browse,
        builder: (context, state) => const BrowseView(),
      ),
      GoRoute(
        path: AppRoutes.myBid,
        builder: (context, state) => const MyBidView(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileView(),
      ),
      GoRoute(
        path: AppRoutes.profileVerification,
        builder: (context, state) => const ProfileVerificationView(),
      ),
      GoRoute(
        path: AppRoutes.security,
        builder: (context, state) => const SecurityView(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (context, state) => const ChangePasswordView(),
      ),
      GoRoute(
        path: AppRoutes.supportHelp,
        builder: (context, state) => const SupportHelpView(),
      ),
      GoRoute(
        path: AppRoutes.faq,
        builder: (context, state) => const FaqView(),
      ),
      GoRoute(
        path: AppRoutes.contactSupport,
        builder: (context, state) => const ContactSupportView(),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyView(),
      ),
      GoRoute(
        path: AppRoutes.termsConditions,
        builder: (context, state) => const TermsConditionsView(),
      ),
      GoRoute(
        path: AppRoutes.featuredAuctions,
        builder: (context, state) => const FeaturedAuctionsView(),
      ),
      GoRoute(
        path: AppRoutes.auctionDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return AuctionDetailsView(itemId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsView(),
      ),
      GoRoute(
        path: AppRoutes.addVehicle,
        builder: (context, state) => const AddVehicleView(),
      ),
      GoRoute(
        path: AppRoutes.addVehiclePreview,
        builder: (context, state) => const AddVehiclePreviewDetailsView(),
      ),
    ],
  );
}
