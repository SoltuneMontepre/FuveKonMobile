import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => _buildTheme(
        brightness: Brightness.light,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: FuvekonColors.button,
          onPrimary: FuvekonColors.onPrimary,
          primaryContainer: FuvekonColors.primary,
          onPrimaryContainer: FuvekonColors.textPrimary,
          secondary: FuvekonColors.secondary,
          onSecondary: FuvekonColors.onPrimary,
          secondaryContainer: FuvekonColors.bgSecondary,
          onSecondaryContainer: FuvekonColors.textPrimary,
          tertiary: FuvekonColors.outline,
          onTertiary: FuvekonColors.onPrimary,
          error: Color(0xFFB3261E),
          onError: FuvekonColors.onPrimary,
          surface: FuvekonColors.paper,
          onSurface: FuvekonColors.textSecondary,
          onSurfaceVariant: FuvekonColors.textPrimary,
          outline: Color(0x668C8C8C),
          outlineVariant: Color(0x3348715B),
          shadow: Color(0x1A154C5B),
          scrim: Color(0x80000000),
          inverseSurface: FuvekonColors.textPrimary,
          onInverseSurface: FuvekonColors.main,
          inversePrimary: FuvekonColors.primary,
          surfaceTint: FuvekonColors.button,
        ),
        scaffoldBackground: FuvekonColors.main,
        cardColor: Colors.white,
        inputFill: Colors.white,
        dividerColor: const Color(0x3348715B),
      );

  static ThemeData get dark => _buildTheme(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: FuvekonColors.darkButton,
          onPrimary: FuvekonColors.darkBg,
          primaryContainer: FuvekonColors.darkPrimary,
          onPrimaryContainer: FuvekonColors.darkBg,
          secondary: FuvekonColors.secondary,
          onSecondary: FuvekonColors.darkBg,
          secondaryContainer: FuvekonColors.darkSurfaceElevated,
          onSecondaryContainer: FuvekonColors.darkText,
          tertiary: FuvekonColors.outline,
          onTertiary: FuvekonColors.darkBg,
          error: Color(0xFFF2B8B5),
          onError: Color(0xFF601410),
          surface: FuvekonColors.darkSurface,
          onSurface: FuvekonColors.darkText,
          onSurfaceVariant: FuvekonColors.darkTextSecondary,
          outline: FuvekonColors.darkBorder,
          outlineVariant: Color(0x4D2A4034),
          shadow: Color(0x66000000),
          scrim: Color(0x99000000),
          inverseSurface: FuvekonColors.darkText,
          onInverseSurface: FuvekonColors.darkBg,
          inversePrimary: FuvekonColors.darkPrimary,
          surfaceTint: FuvekonColors.darkPrimary,
        ),
        scaffoldBackground: FuvekonColors.darkBg,
        cardColor: FuvekonColors.darkSurfaceElevated,
        inputFill: FuvekonColors.darkSurface,
        dividerColor: FuvekonColors.darkBorder,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required Color cardColor,
    required Color inputFill,
    required Color dividerColor,
  }) {
    final isLight = brightness == Brightness.light;
    final headlineColor =
        isLight ? FuvekonColors.textPrimary : FuvekonColors.darkText;
    final bodyColor =
        isLight ? FuvekonColors.textSecondary : FuvekonColors.darkTextSecondary;

    final textTheme = TextTheme(
      displaySmall: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: headlineColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: headlineColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: headlineColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: headlineColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: headlineColor,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: bodyColor, height: 1.4),
      bodyMedium: TextStyle(fontSize: 14, color: bodyColor, height: 1.4),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: headlineColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: isLight ? FuvekonColors.button : FuvekonColors.darkPrimary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      dividerColor: dividerColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scaffoldBackground,
        foregroundColor: headlineColor,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: isLight ? 2 : 0,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isLight
                ? const Color(0x3348715B)
                : FuvekonColors.darkBorder,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: cardColor,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? colorScheme.primary : bodyColor,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? colorScheme.primary : bodyColor,
            size: 24,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        labelStyle: TextStyle(color: bodyColor),
        hintStyle: TextStyle(color: bodyColor.withValues(alpha: 0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isLight
                ? const Color(0x4D8C8C8C)
                : FuvekonColors.darkBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isLight
                ? const Color(0x4D8C8C8C)
                : FuvekonColors.darkBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.4),
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          elevation: isLight ? 1 : 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isLight ? FuvekonColors.outline : FuvekonColors.darkPrimary,
          side: BorderSide(
            color: isLight ? FuvekonColors.outline : FuvekonColors.darkPrimary,
            width: 2,
          ),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isLight
            ? FuvekonColors.textPrimary
            : FuvekonColors.darkSurfaceElevated,
        contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        textColor: headlineColor,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
        labelStyle: TextStyle(
          color: isLight ? FuvekonColors.button : FuvekonColors.darkPrimary,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
