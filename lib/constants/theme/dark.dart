import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

final ThemeData darkTheme = FlexThemeData.dark(
  scheme: FlexScheme.espresso,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 18,
  appBarStyle: FlexAppBarStyle.background,
  appBarOpacity: 0.59,
  appBarElevation: 0,
  transparentStatusBar: true,
  tabBarStyle: FlexTabBarStyle.forAppBar,
  tooltipsMatchBackground: true,
  swapColors: false,
  darkIsTrueBlack: false,
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  // To use playground font, add GoogleFonts package and uncomment:
  // fontFamily: GoogleFonts.notoSans().fontFamily,
  subThemesData: const FlexSubThemesData(
    useTextTheme: true,
    fabUseShape: false,
    interactionEffects: true,
    bottomNavigationBarElevation: 0,
    bottomNavigationBarOpacity: 0.95,
    navigationBarOpacity: 0.95,
    navigationBarMutedUnselectedIcon: true,
    inputDecoratorIsFilled: true,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorUnfocusedHasBorder: true,
    blendOnColors: true,
    blendTextTheme: true,
    popupMenuOpacity: 0.95,
  ),
);
