import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:private_vehicle_bidding/modules/profile/controllers/contact_support_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ContactSupportController controller;

  setUp(() {
    controller = Get.put(ContactSupportController());
  });

  tearDown(() {
    Get.delete<ContactSupportController>();
  });

  group('ContactSupportController Test Suite', () {
    test('Initializes with default states', () {
      expect(controller.subjectController.text, isEmpty);
      expect(controller.emailController.text, isEmpty);
      expect(controller.messageController.text, isEmpty);
      expect(controller.selectedScreenshotPath.value, isEmpty);
      expect(controller.isLoading.value, isFalse);
    });

    test('Clear screenshot resets path to empty string', () {
      controller.selectedScreenshotPath.value = 'dummy/path/screenshot.png';
      expect(controller.selectedScreenshotPath.value, 'dummy/path/screenshot.png');

      controller.clearScreenshot();
      expect(controller.selectedScreenshotPath.value, isEmpty);
    });

    testWidgets('submitTicket form validation and ticket submission triggers successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.subjectController,
                        validator: (val) => val == null || val.isEmpty ? 'Error Subject' : null,
                      ),
                      TextFormField(
                        controller: controller.emailController,
                        validator: (val) => val == null || val.isEmpty ? 'Error Email' : null,
                      ),
                      TextFormField(
                        controller: controller.messageController,
                        validator: (val) => val == null || val.isEmpty ? 'Error Message' : null,
                      ),
                      ElevatedButton(
                        onPressed: () => controller.submitTicket(context),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Validate inputs are initially empty and form is invalid
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('Error Subject'), findsOneWidget);
      expect(find.text('Error Email'), findsOneWidget);
      expect(find.text('Error Message'), findsOneWidget);

      // Populate text fields with valid values
      controller.subjectController.text = 'Payment Issue';
      controller.emailController.text = 'user@example.com';
      controller.messageController.text = 'My deposit failed to display.';
      await tester.pump();

      // Submit valid form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Ensure loading state triggers
      expect(controller.isLoading.value, isTrue);

      // Settle simulated network delay (1000ms)
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Ensure form is reset and loader is completed
      expect(controller.isLoading.value, isFalse);
      expect(controller.subjectController.text, isEmpty);
      expect(controller.emailController.text, isEmpty);
      expect(controller.messageController.text, isEmpty);
    });
  });
}
