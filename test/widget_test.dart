// This is a basic Flutter widget test for the onboarding, login, and registration flow.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:get/get.dart';
import 'package:private_vehicle_bidding/main.dart';
import 'package:private_vehicle_bidding/modules/auth/controllers/sign_up_controller.dart';
import 'package:private_vehicle_bidding/shared/widgets/app_email_field.dart';
import 'package:private_vehicle_bidding/shared/widgets/app_full_name_field.dart';
import 'package:private_vehicle_bidding/shared/widgets/app_password_field.dart';
import 'package:private_vehicle_bidding/shared/widgets/app_confirm_password_field.dart';

void main() {
  testWidgets('Full Onboarding to Login flow smoke test', (WidgetTester tester) async {
    // Set physical size and device pixel ratio to simulate standard device layout.
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      Get.reset();
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Page 0: Verify first onboarding screen
    expect(find.text('Buy & Sell Vehicles Safely', findRichText: true), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next to go to Page 1
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Page 1: Verify second onboarding screen
    expect(find.text('Verified Sellers Only', findRichText: true), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next to go to Page 2
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Page 2: Verify third onboarding screen
    expect(find.text('Bid With Confidence', findRichText: true), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap Get Started to go to Login screen
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Login View: Verify login elements
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Remember me'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Don’t have an account yet? Sign up', findRichText: true), findsOneWidget);

    // Tap Forgot password? to go to Forgot Password screen
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    // Forgot Password View: Verify elements
    expect(find.text('Forget your password'), findsOneWidget);
    expect(find.textContaining('account recovery'), findsOneWidget);
    expect(find.byType(AppEmailField), findsOneWidget);
    expect(find.text('Forget password'), findsOneWidget);
    expect(find.text('Return to login'), findsOneWidget);

    // Enter email
    await tester.enterText(find.byType(AppEmailField), 'reset@company.com');

    // Tap privacy checkbox off and on to verify interactivity since it defaults to true
    await tester.tap(find.byKey(const Key('privacy_checkbox_icon')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('privacy_checkbox_icon')));
    await tester.pumpAndSettle();

    // Submit Forgot Password
    await tester.tap(find.text('Forget password'));
    await tester.pump(); // Start delayed future

    // Advance mock timer by 1500ms
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    // Verify we are on Forgot Password Verification View
    expect(find.text('Verify your email address'), findsOneWidget);
    expect(find.textContaining('We emailed you a six-digit code to'), findsOneWidget);
    expect(find.text('Verify'), findsOneWidget);

    // Enter 6-digit OTP code
    final otpFields = find.byType(TextFormField);
    await tester.enterText(otpFields.at(0), '1');
    await tester.enterText(otpFields.at(1), '2');
    await tester.enterText(otpFields.at(2), '3');
    await tester.enterText(otpFields.at(3), '4');
    await tester.enterText(otpFields.at(4), '5');
    await tester.enterText(otpFields.at(5), '6');
    await tester.pumpAndSettle();

    // Submit Verification
    await tester.tap(find.text('Verify'));
    await tester.pump(); // Start delayed future

    // Advance mock timer by 1500ms
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    // Verify we are on Reset Password View
    expect(find.text('Create new password'), findsOneWidget);
    expect(find.text('Your new password must be different from previous used passwords.'), findsOneWidget);

    // Enter passwords
    await tester.enterText(find.byType(AppPasswordField), 'newpassword123');
    await tester.enterText(find.byType(AppConfirmPasswordField), 'newpassword123');

    // Tap privacy checkbox off and on to verify interactivity since it defaults to true
    await tester.tap(find.byKey(const Key('privacy_checkbox_icon')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('privacy_checkbox_icon')));
    await tester.pumpAndSettle();

    // Submit Reset Password (using the user's updated Confirm text)
    await tester.tap(find.text('Confirm'));
    await tester.pump(); // Start delayed future

    // Advance mock timer by 1500ms
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    // Verify we are on Reset Success View
    expect(find.text('Verified'), findsOneWidget);
    expect(find.text('You have successfully verified your account.'), findsOneWidget);
    expect(find.text('Login to your Account'), findsOneWidget);

    // Tap Login to your Account
    await tester.tap(find.text('Login to your Account'));
    await tester.pumpAndSettle();

    // Verify we are back on Login View
    expect(find.text('Log in'), findsOneWidget);

    // Tap Sign up to go to Sign Up screen
    await tester.tap(find.text('Don’t have an account yet? Sign up', findRichText: true));
    await tester.pumpAndSettle();

    // Sign Up View: Verify sign up elements
    expect(find.text('Create your free account'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('I accept the Terms and Conditions', findRichText: true), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);

    // Fill in the sign up form to test successful validation
    await tester.enterText(find.byType(AppEmailField), 'name@company.com');
    await tester.enterText(find.byType(AppFullNameField), 'Bonnie Green');
    await tester.enterText(find.byType(AppPasswordField), 'password123');
    await tester.enterText(find.byType(AppConfirmPasswordField), 'password123');
    // Tap terms checkbox off and on to verify interactivity since it defaults to true
    final checkboxFinder = find.byKey(const Key('terms_checkbox_gesture'));
    await tester.tapAt(tester.getTopLeft(checkboxFinder) + const Offset(8, 8));
    await tester.pumpAndSettle();
    await tester.tapAt(tester.getTopLeft(checkboxFinder) + const Offset(8, 8));
    await tester.pumpAndSettle();

    // Submit Create Account
    await tester.tap(find.text('Create account'));
    await tester.pump(); // Start delayed future

    // Advance mock timer by 1500ms for mock network call completion
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    // Verify email verification screen loads successfully
    expect(find.text('Verify your email address'), findsOneWidget);
    expect(find.text('We emailed you a six-digit code to name@company.com. Enter the code below to confirm your email address.', findRichText: true), findsOneWidget);
    expect(find.text('Please keep this window open while you check your inbox.'), findsOneWidget);
    expect(find.text('Verify'), findsOneWidget);

    // Enter OTP digits to verify email registration completion
    final signupOtpFields = find.byType(TextFormField);
    await tester.enterText(signupOtpFields.at(0), '1');
    await tester.enterText(signupOtpFields.at(1), '2');
    await tester.enterText(signupOtpFields.at(2), '3');
    await tester.enterText(signupOtpFields.at(3), '4');
    await tester.enterText(signupOtpFields.at(4), '5');
    await tester.enterText(signupOtpFields.at(5), '6');
    await tester.pumpAndSettle();

    // Tap Verify
    await tester.tap(find.text('Verify'));
    await tester.pump(); // Start verifyOtp call (has 2s mock delay)

    // Advance mock timer by 2000ms for OTP mock repository call
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    // Verify we landed on Home screen
    expect(find.byKey(const ValueKey('home')), findsOneWidget);

    // Verify redesigned bottom nav bar items are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Browse'), findsOneWidget);
    expect(find.text('Sell'), findsOneWidget);
    expect(find.text('My Bids'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
