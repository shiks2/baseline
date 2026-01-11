import 'package:flutter/material.dart';
import 'route.dart';
import 'app_theme.dart';

final router = AppGlobalRouter();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Candence',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode
          .system, // Automatically switches between light/dark based on system
      routerConfig: router.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
