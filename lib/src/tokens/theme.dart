import 'package:flutter/material.dart';

import 'colors.dart';
import 'radius.dart';
import 'typography.dart';

/// Pre-configured Material [ThemeData] for the Mitumba design system.
class MitumbaTheme {
  MitumbaTheme._();

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: MitumbaTypography.fontFamily,
    colorScheme: ColorScheme.dark(
      primary: MitumbaColors.green,
      primaryContainer: MitumbaColors.greenDark,
      secondary: MitumbaColors.earth,
      secondaryContainer: MitumbaColors.earthDark,
      surface: MitumbaColors.surfaceDark,
      error: MitumbaColors.error,
      errorContainer: MitumbaColors.errorDark,
      onPrimary: MitumbaColors.white,
      onSecondary: MitumbaColors.white,
      onSurface: MitumbaColors.white,
      onError: MitumbaColors.white,
      outline: MitumbaColors.border,
      outlineVariant: MitumbaColors.divider,
    ),
    scaffoldBackgroundColor: MitumbaColors.backgroundDark,
    dividerColor: MitumbaColors.divider,
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: MitumbaTypography.fontFamily,
    colorScheme: ColorScheme.light(
      primary: MitumbaColors.green,
      primaryContainer: MitumbaColors.greenLight,
      secondary: MitumbaColors.earth,
      secondaryContainer: MitumbaColors.earthLight,
      surface: MitumbaColors.surface,
      error: MitumbaColors.error,
      errorContainer: MitumbaColors.errorLight,
      onPrimary: MitumbaColors.textOnGreen,
      onSecondary: MitumbaColors.textOnEarth,
      onSurface: MitumbaColors.textPrimary,
      onError: MitumbaColors.white,
      outline: MitumbaColors.border,
      outlineVariant: MitumbaColors.divider,
    ),
    scaffoldBackgroundColor: MitumbaColors.background,
    dividerColor: MitumbaColors.divider,
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MitumbaRadius.xl),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MitumbaRadius.md),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MitumbaRadius.md),
        ),
        textStyle: MitumbaTypography.button,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: MitumbaColors.surface,
      foregroundColor: MitumbaColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: MitumbaTypography.h5.copyWith(color: MitumbaColors.textPrimary),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: MitumbaColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(MitumbaRadius.xxl)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: MitumbaColors.background,
      selectedColor: MitumbaColors.greenLight,
      checkmarkColor: MitumbaColors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MitumbaRadius.full),
      ),
      labelStyle: MitumbaTypography.caption,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: MitumbaColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MitumbaRadius.xxxl),
      ),
      titleTextStyle: MitumbaTypography.h4.copyWith(color: MitumbaColors.textPrimary),
      contentTextStyle: MitumbaTypography.body2.copyWith(color: MitumbaColors.textSecondary),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: MitumbaColors.textPrimary,
      contentTextStyle: MitumbaTypography.body2.copyWith(color: MitumbaColors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MitumbaRadius.md),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: MitumbaColors.green,
        textStyle: MitumbaTypography.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MitumbaRadius.md),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: MitumbaColors.textPrimary,
        side: const BorderSide(color: MitumbaColors.border),
        textStyle: MitumbaTypography.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MitumbaRadius.md),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: MitumbaColors.green,
      foregroundColor: MitumbaColors.white,
      elevation: 4,
    ),
    dividerTheme: const DividerThemeData(
      color: MitumbaColors.divider,
      thickness: 1,
      space: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return MitumbaColors.white;
        return MitumbaColors.textDisabled;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return MitumbaColors.green;
        return MitumbaColors.border;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return MitumbaColors.green;
        return MitumbaColors.textSecondary;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return MitumbaColors.green;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(MitumbaColors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MitumbaRadius.xs),
      ),
    ),
  );
}
