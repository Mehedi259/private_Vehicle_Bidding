import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:private_vehicle_bidding/modules/profile/controllers/support_help_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SupportHelpController controller;

  setUp(() {
    controller = SupportHelpController();
  });

  group('SupportHelpController Test Suite', () {
    test('Initializes with default states', () {
      expect(controller.isLoading.value, isFalse);
    });

    testWidgets('interactions execute without errors', (WidgetTester tester) async {
      BuildContext? capturedContext;
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          ),
          GoRoute(
            path: '/faq',
            builder: (context, state) => const SizedBox(),
          ),
          GoRoute(
            path: '/contact-support',
            builder: (context, state) => const SizedBox(),
          ),
          GoRoute(
            path: '/privacy-policy',
            builder: (context, state) => const SizedBox(),
          ),
          GoRoute(
            path: '/terms-conditions',
            builder: (context, state) => const SizedBox(),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      expect(capturedContext, isNotNull);
      // Calling FAQ interaction after initial build
      controller.openFaqs(capturedContext!);
      await tester.pumpAndSettle();

      // Calling report problem interaction
      controller.reportProblem(capturedContext!);
      await tester.pumpAndSettle();

      // Calling privacy policy interaction
      controller.openPrivacyPolicy(capturedContext!);
      await tester.pumpAndSettle();

      // Calling terms & conditions interaction
      controller.openTermsConditions(capturedContext!);
      await tester.pumpAndSettle();
      
      expect(controller.isLoading.value, isFalse);
    });
  });
}
