import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';

abstract final class AppTheme {
  static ThemeData get light => _buildTheme(
        brightness: Brightness.light,
        extension: FuvekonThemeExtension.light,
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
          onError: Colors.white,
          surface: FuvekonColors.paper,
          onSurface: FuvekonColors.textSecondary,
          onSurfaceVariant: FuvekonColors.textPrimary,
          outline: FuvekonColors.inputBorder,
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
        inputFill: FuvekonColors.inputFill,
        dividerColor: const Color(0x3348715B),
        appBarForeground: FuvekonColors.textPrimary,
        bodyMuted: FuvekonColors.textSecondary,
      );

  static ThemeData get dark => _buildTheme(
        brightness: Brightness.dark,
        extension: FuvekonThemeExtension.dark,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: FuvekonColors.darkButton,
          onPrimary: FuvekonColors.darkButtonText,
          primaryContainer: FuvekonColors.sageGreenContainer,
          onPrimaryContainer: Color(0xFFE5FFED),
          secondary: FuvekonColors.dustyRose,
          onSecondary: FuvekonColors.onDustyRose,
          secondaryContainer: FuvekonColors.dustyRoseContainer,
          onSecondaryContainer: Color(0xFFFCDAE5),
          tertiary: FuvekonColors.lightGold,
          onTertiary: FuvekonColors.onLightGold,
          error: Color(0xFFFFB4AB),
          onError: Color(0xFF690005),
          surface: FuvekonColors.darkSurface,
          onSurface: FuvekonColors.darkText,
          onSurfaceVariant: FuvekonColors.darkTextSecondary,
          outline: FuvekonColors.outlineToken,
          outlineVariant: FuvekonColors.outlineVariantToken,
          shadow: Color(0x66000000),
          scrim: Color(0x99000000),
          inverseSurface: FuvekonColors.darkText,
          onInverseSurface: FuvekonColors.darkBg,
          inversePrimary: FuvekonColors.darkPrimary,
          surfaceTint: FuvekonColors.darkPrimary,
        ),
        scaffoldBackground: FuvekonColors.darkBg,
        cardColor: FuvekonColors.darkCard,
        inputFill: FuvekonColors.inputFill,
        dividerColor: FuvekonColors.darkBorder,
        appBarForeground: FuvekonColors.darkAppBarTitle,
        bodyMuted: FuvekonColors.darkTextSecondary,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required FuvekonThemeExtension extension,
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required Color cardColor,
    required Color inputFill,
    required Color dividerColor,
    required Color appBarForeground,
    required Color bodyMuted,
  }) {
    final isLight = brightness == Brightness.light;
    final headlineColor =
        isLight ? FuvekonColors.textPrimary : FuvekonColors.darkText;
    final cardHeadline = extension.contentOnCard;
    final cardBody = extension.contentOnCardMuted;

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
        fontWeight: FontWeight.w700,
        color: headlineColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: headlineColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: cardHeadline,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: colorScheme.primary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: bodyMuted, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, color: bodyMuted, height: 1.5),
      bodySmall: TextStyle(fontSize: 12, color: bodyMuted, height: 1.4),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: cardHeadline,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: cardHeadline,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      dividerColor: dividerColor,
      textTheme: textTheme,
      extensions: [extension],
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scaffoldBackground,
        foregroundColor: appBarForeground,
        iconTheme: IconThemeData(color: appBarForeground),
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: appBarForeground),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FuvekonRadii.card),
          side: BorderSide(
            color: isLight
                ? const Color(0x22000000)
                : Colors.transparent,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: isLight ? Colors.white : FuvekonColors.darkDeep,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? colorScheme.primary : bodyMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? colorScheme.primary : bodyMuted,
            size: 24,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: textTheme.labelMedium,
        hintStyle: TextStyle(
          color: cardBody.withValues(alpha: 0.65),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FuvekonRadii.input),
          borderSide: const BorderSide(color: FuvekonColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FuvekonRadii.input),
          borderSide: const BorderSide(color: FuvekonColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FuvekonRadii.input),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FuvekonRadii.input),
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
          disabledForegroundColor:
              colorScheme.onPrimary.withValues(alpha: 0.5),
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: extension.link,
          side: BorderSide(color: extension.link, width: 1.5),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FuvekonRadii.input),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: extension.link,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return inputFill;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: const BorderSide(color: FuvekonColors.inputBorder, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isLight
            ? FuvekonColors.textPrimary
            : FuvekonColors.darkSurfaceElevated,
        contentTextStyle: TextStyle(
          color: isLight ? FuvekonColors.main : FuvekonColors.darkText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FuvekonRadii.input),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: extension.contentOnCard,
        textColor: extension.contentOnCard,
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(color: cardBody),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FuvekonRadii.input),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.primary.withValues(alpha: 0.16),
        labelStyle: TextStyle(
          color: isLight ? FuvekonColors.textPrimary : FuvekonColors.darkPrimary,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
