import 'package:flutter/material.dart';

import 'colors.dart';
import 'radius.dart';
import 'typography.dart';

/// Pre-configured Material [ThemeData] for the Mitumba design system.
class MitumbaTheme {
  MitumbaTheme._();

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
  );
}
