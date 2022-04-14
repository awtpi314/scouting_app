import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const seed = Color(0xFF6750A4);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006591),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFC7E6FF),
  onPrimaryContainer: Color(0xFF001E2F),
  secondary: Color(0xFF474ECE),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFDFE0FF),
  onSecondaryContainer: Color(0xFF00006F),
  tertiary: Color(0xFF265DAC),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFD6E3FF),
  onTertiaryContainer: Color(0xFF001A40),
  error: Color(0xFFB3261E),
  errorContainer: Color(0xFFF9DEDC),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410E0B),
  background: Color(0xFFFFFBFE),
  onBackground: Color(0xFF1C1B1F),
  surface: Color(0xFFFFFBFE),
  onSurface: Color(0xFF1C1B1F),
  surfaceVariant: Color(0xFFE7E0EC),
  onSurfaceVariant: Color(0xFF49454F),
  outline: Color(0xFF79747E),
  onInverseSurface: Color(0xFFF4EFF4),
  inverseSurface: Color(0xFF313033),
  inversePrimary: Color(0xFF85CEFF),
  shadow: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF85CEFF),
  onPrimary: Color(0xFF00344E),
  primaryContainer: Color(0xFF004C6F),
  onPrimaryContainer: Color(0xFFC7E6FF),
  secondary: Color(0xFFBEC2FF),
  onSecondary: Color(0xFF0E0FA1),
  secondaryContainer: Color(0xFF2D32B6),
  onSecondaryContainer: Color(0xFFDFE0FF),
  tertiary: Color(0xFFA9C7FF),
  onTertiary: Color(0xFF002F68),
  tertiaryContainer: Color(0xFF004591),
  onTertiaryContainer: Color(0xFFD6E3FF),
  error: Color(0xFFF2B8B5),
  errorContainer: Color(0xFF8C1D18),
  onError: Color(0xFF601410),
  onErrorContainer: Color(0xFFF9DEDC),
  background: Color(0xFF1C1B1F),
  onBackground: Color(0xFFE6E1E5),
  surface: Color(0xFF1C1B1F),
  onSurface: Color(0xFFE6E1E5),
  surfaceVariant: Color(0xFF49454F),
  onSurfaceVariant: Color(0xFFCAC4D0),
  outline: Color(0xFF938F99),
  onInverseSurface: Color(0xFF1C1B1F),
  inverseSurface: Color(0xFFE6E1E5),
  inversePrimary: Color(0xFF006591),
  shadow: Color(0xFF000000),
);

TextTheme appTextTheme = GoogleFonts.openSansTextTheme(
  ThemeData.dark().textTheme,
).copyWith(
  headline1: GoogleFonts.montserrat(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  ),
  headline2: GoogleFonts.montserrat(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  ),
  headline3: GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  ),
  headline4: GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  ),
  headline5: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  ),
  headline6: GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  ),
  button: GoogleFonts.openSans(
    fontWeight: FontWeight.bold,
  ),
);

AppBarTheme darkAppBarTheme = AppBarTheme(
  color: darkColorScheme.secondaryContainer,
  titleTextStyle: appTextTheme.headline2?.copyWith(
    color: darkColorScheme.onSecondaryContainer,
  ),
);

BottomNavigationBarThemeData darkNavigationBarTheme =
    BottomNavigationBarThemeData(
  backgroundColor: darkColorScheme.secondaryContainer,
  type: BottomNavigationBarType.fixed,
  selectedItemColor: darkColorScheme.primary,
  unselectedItemColor: darkColorScheme.onPrimaryContainer,
);
