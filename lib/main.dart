import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omnibook_app/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'providers/booking_provider.dart';
import 'screens/service_selection/service_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  /// 
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

        /// 
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        /// 
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
