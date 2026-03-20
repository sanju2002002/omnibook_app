import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omnibook_app/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'providers/booking_provider.dart';
import 'screens/service_selection/service_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 EDGE-TO-EDGE UI
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  /// 🔥 STATUS BAR STYLE
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BookingProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OmniBook',

        /// 💎 CLEAN THEME SYSTEM
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        /// 🔥 GLOBAL SYSTEM UI (STATUS BAR FIX)
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: child!,
          );
        },

        /// 🔹 START SCREEN
        home: const ServiceScreen(),
      ),
    );
  }
}
