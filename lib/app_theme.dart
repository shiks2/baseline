import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppTheme {
  // Primary colors
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color darkGrey = Color(0xFF2D2D2D);
  static const Color mediumGrey = Color(0xFF4A4A4A);
  static const Color lightGrey = Color(0xFF6B6B6B);
  static const Color lighterGrey = Color(0xFF9E9E9E);
  static const Color lightestGrey = Color(0xFFF5F5F5);

  // Accent color - Light Orange
  static const Color lightOrange = Color(0xFFFFA726);
  static const Color lightOrangeLight = Color(0xFFFFCC80);
  static const Color lightOrangeDark = Color(0xFFFB8C00);

  // Semantic colors
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);
  static const Color infoColor = Color(0xFF1976D2);

  // Light theme
  static ThemeData lightTheme = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: lightOrange,
      primaryContainer: lightOrangeLight,
      secondary: primaryBlack,
      secondaryContainer: darkGrey,
      tertiary: mediumGrey,
      tertiaryContainer: lightGrey,
      error: errorColor,
    ),
    appBarStyle: FlexAppBarStyle.primary,
    appBarOpacity: 0.95,
    appBarElevation: 2,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    swapColors: false,
    lightIsWhite: false,
    useMaterial3: true,
    useMaterial3ErrorColors: true,
    // Text themes
    fontFamily: 'Roboto',
    // Sub-themes
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: true,
      inputDecoratorFocusedBorderWidth: 2.0,
      inputDecoratorPrefixIconSchemeColor: SchemeColor.onSurface,
      chipRadius: 12,
      cardRadius: 16,
      popupMenuRadius: 12,
      popupMenuElevation: 8,
      dialogRadius: 20,
      dialogElevation: 8,
      useInputDecoratorThemeInDialogs: true,
      snackBarRadius: 12,
      snackBarElevation: 4,
      appBarScrolledUnderElevation: 4,
      drawerWidth: 280,
      drawerRadius: 18,
      drawerElevation: 16,
      bottomSheetRadius: 20,
      bottomSheetElevation: 8,
      bottomSheetModalElevation: 16,
      bottomNavigationBarElevation: 8,
      bottomNavigationBarOpacity: 0.95,
      navigationBarElevation: 8,
      navigationBarOpacity: 0.95,
      navigationRailElevation: 8,
      navigationRailOpacity: 0.95,
      navigationRailLabelType: NavigationRailLabelType.all,
      navigationRailUseIndicator: true,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 0.2,
    ),
    // Visual density and platform
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // Text themes
    textTheme: _lightTextTheme,
    primaryTextTheme: _lightPrimaryTextTheme,
  );

  // Dark theme
  static ThemeData darkTheme = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: lightOrange,
      primaryContainer: lightOrangeDark,
      secondary: lightestGrey,
      secondaryContainer: lightGrey,
      tertiary: lighterGrey,
      tertiaryContainer: mediumGrey,
      error: errorColor,
    ),
    appBarStyle: FlexAppBarStyle.background,
    appBarOpacity: 0.95,
    appBarElevation: 2,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    swapColors: false,
    darkIsTrueBlack: false,
    useMaterial3: true,
    useMaterial3ErrorColors: true,
    // Text themes
    fontFamily: 'Roboto',
    // Sub-themes
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: true,
      inputDecoratorFocusedBorderWidth: 2.0,
      inputDecoratorPrefixIconSchemeColor: SchemeColor.onSurface,
      chipRadius: 12,
      cardRadius: 16,
      popupMenuRadius: 12,
      popupMenuElevation: 8,
      dialogRadius: 20,
      dialogElevation: 8,
      useInputDecoratorThemeInDialogs: true,
      snackBarRadius: 12,
      snackBarElevation: 4,
      appBarScrolledUnderElevation: 4,
      drawerWidth: 280,
      drawerRadius: 18,
      drawerElevation: 16,
      bottomSheetRadius: 20,
      bottomSheetElevation: 8,
      bottomSheetModalElevation: 16,
      bottomNavigationBarElevation: 8,
      bottomNavigationBarOpacity: 0.95,
      navigationBarElevation: 8,
      navigationBarOpacity: 0.95,
      navigationRailElevation: 8,
      navigationRailOpacity: 0.95,
      navigationRailLabelType: NavigationRailLabelType.all,
      navigationRailUseIndicator: true,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 0.2,
    ),
    // Visual density and platform
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // Text themes
    textTheme: _darkTextTheme,
    primaryTextTheme: _darkPrimaryTextTheme,
  );

  // Light text theme
  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  // Dark text theme
  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  // Light primary text theme
  static const TextTheme _lightPrimaryTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.white,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Colors.white,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
  );

  // Dark primary text theme
  static const TextTheme _darkPrimaryTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.black,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.black,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.black,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.black,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Colors.black,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Colors.black,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.black,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.black,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.black,
    ),
  );
}
