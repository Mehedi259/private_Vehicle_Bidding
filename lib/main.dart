import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview/device_preview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/router/app_router.dart';
import 'core/utils/page_transitions.dart';
import 'core/utils/snackbar_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    DevicePreview(
      enabled: false, // Turn flutter device preview on if needed manually
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return GetMaterialApp.router(
          scaffoldMessengerKey: SnackbarHelper.messengerKey,
          title: 'Private Vehicle Bidding',
          debugShowCheckedModeBanner: false,
          theme: _lightTheme,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routerDelegate: AppRouter.router.routerDelegate,
          routeInformationProvider: AppRouter.router.routeInformationProvider,

          // REQUIRED BY DevicePreview - Chain both builders if enabled
          builder: (context, widget) {
            if (DevicePreview.isEnabled(context)) {
              widget = DevicePreview.appBuilder(context, widget);
            }
            return widget ?? const SizedBox();
          },
          locale: DevicePreview.locale(context),
        );
      },
    );
  }

  ThemeData get _lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(), // Default font: Poppins
    // Custom page transitions to eliminate white flick during navigation
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: NoTransitionPageTransitionsBuilder(),
        TargetPlatform.iOS: NoTransitionPageTransitionsBuilder(),
        TargetPlatform.windows: NoTransitionPageTransitionsBuilder(),
        TargetPlatform.macOS: NoTransitionPageTransitionsBuilder(),
        TargetPlatform.linux: NoTransitionPageTransitionsBuilder(),
      },
    ),
  );
}
