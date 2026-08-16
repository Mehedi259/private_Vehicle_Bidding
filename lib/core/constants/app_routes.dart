class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String verification = '/verification';
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordVerification = '/forgot-password-verification';
  static const String resetPassword = '/reset-password';
  static const String resetSuccess = '/reset-success';
  static const String home = '/home';
  static const String browse = '/browse';
  static const String myBid = '/my-bid';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String profileVerification = '/profile-verification';
  static const String security = '/security';
  static const String changePassword = '/change-password';
  static const String supportHelp = '/support-help';
  static const String faq = '/faq';
  static const String contactSupport = '/contact-support';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';
  static const String featuredAuctions = '/featured-auctions';
  static const String auctionDetails = '/auction/:id';
  static const String notifications = '/notifications';
  static const String addVehicle = '/add-vehicle';
  static const String addVehiclePreview = '/add-vehicle-preview';

  static String auctionDetailsPath(String id) => '/auction/$id';
}
