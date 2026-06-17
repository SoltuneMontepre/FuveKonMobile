import 'package:flutter/material.dart';

/// FUVEKON Premium Mobile System palette from [color.md].
abstract final class FuvekonColors {
  // ── Design system tokens (color.md YAML) ──
  static const surface = Color(0xFF131313);
  static const surfaceBright = Color(0xFF393939);
  static const surfaceContainerLowest = Color(0xFF0E0E0E);
  static const surfaceContainerLow = Color(0xFF1B1B1C);
  static const surfaceContainer = Color(0xFF202020);
  static const surfaceContainerHigh = Color(0xFF2A2A2A);
  static const surfaceContainerHighest = Color(0xFF353535);
  static const deepNavy = Color(0xFF07131A);
  static const charcoal = Color(0xFF1E1E1E);
  static const mintCard = Color(0xFFE4EEE3);
  static const onSurface = Color(0xFFE5E2E1);
  static const onSurfaceVariant = Color(0xFFC1C8C2);
  static const outlineToken = Color(0xFF8B928C);
  static const outlineVariantToken = Color(0xFF414843);
  static const sageGreen = Color(0xFFA9CFB8);
  static const onSageGreen = Color(0xFF133726);
  static const sageGreenContainer = Color(0xFF567A66);
  static const onSageGreenContainer = Color(0xFFE5FFED);
  static const dustyRose = Color(0xFFDFBEC9);
  static const onDustyRose = Color(0xFF402A33);
  static const dustyRoseContainer = Color(0xFF584049);
  static const onDustyRoseContainer = Color(0xFFCDADB8);
  static const lightGold = Color(0xFFE9C349);
  static const onLightGold = Color(0xFF3C2F00);
  static const goldContainer = Color(0xFFCCA730);
  static const primaryFixed = Color(0xFFC4ECD3);
  static const secondaryFixed = Color(0xFFFCDAE5);
  static const onError = Color(0xFF690005);

  // ── Semantic aliases used by customer UI widgets ──
  static const premiumCanvas = charcoal;
  static const premiumBackground = charcoal;
  static const premiumNav = deepNavy;
  static const premiumPrimary = sageGreen;
  static const premiumOnPrimary = onSageGreen;
  static const premiumSecondary = dustyRose;
  static const premiumTertiary = lightGold;
  static const premiumOnSurface = onSurface;
  static const premiumOnSurfaceVariant = onSurfaceVariant;
  static const premiumOutline = outlineToken;
  static const premiumMintCard = mintCard;
  static const premiumOnMintCard = onSageGreen;
  static const premiumOnMintCardMuted = Color(0xFF48715B);
  static const premiumDecorativeGold = lightGold;
  static const premiumSurfaceContainer = surfaceContainer;
  static const premiumSurfaceContainerHigh = surfaceContainerHigh;

  // ── Light surfaces ──
  static const main = mintCard;
  static const paper = mintCard;
  static const bg = Color(0xFFEAF3E9);
  static const bgSecondary = Color(0xFFD6E2D7);

  // ── Brand ──
  static const primary = sageGreen;
  static const secondary = sageGreenContainer;
  static const button = sageGreen;
  static const buttonHover = primaryFixed;
  static const buttonActive = Color(0xFF8EBDA3);
  static const outline = outlineToken;
  static const available = Color(0xFF10B981);

  // ── Text ──
  static const textPrimary = onSageGreen;
  static const textSecondary = Color(0xFF426653);
  static const textOnCard = onSageGreen;
  static const onPrimary = onSageGreen;

  // ── Inputs & upload ──
  static const inputFill = Color(0xFFFFFFFF);
  static const inputBorder = outlineVariantToken;
  static const uploadZoneBg = Color(0xFFF1F7F0);
  static const uploadZoneBorder = sageGreen;

  // ── Info / notes ──
  static const infoAccent = dustyRose;
  static const infoTitle = dustyRose;

  // ── Ticket tier accents ──
  static const tier1 = sageGreenContainer;
  static const tier2 = dustyRoseContainer;
  static const tier3 = goldContainer;
  static const tier4 = surfaceContainerHighest;

  // ── Dark mode (elevation layering per color.md) ──
  static const darkBg = charcoal;
  static const darkDeep = deepNavy;
  static const darkSurface = surfaceContainerLow;
  static const darkSurfaceElevated = surfaceContainerHigh;
  static const darkSurfaceHighest = surfaceContainerHighest;
  static const darkBorder = outlineVariantToken;
  static const darkText = onSurface;
  static const darkTextSecondary = onSurfaceVariant;
  static const darkAppBarTitle = sageGreen;
  static const darkPrimary = sageGreen;
  static const darkButton = sageGreen;
  static const darkButtonText = onSageGreen;
  static const darkCard = mintCard;
  static const darkCardText = onSageGreen;
  static const darkNotesSurface = surfaceContainer;

  // ── Status badges (color.md Components → Badges) ──
  static const statusSuccessBg = primaryFixed;
  static const statusPendingBg = sageGreenContainer;
  static const statusDeniedBg = secondaryFixed;
  static const statusDeniedText = onError;
}

/// Layout tokens shared across light and dark themes.
abstract final class FuvekonRadii {
  static const card = 24.0;
  static const cardLg = 28.0;
  static const input = 12.0;
  static const button = 999.0;
  static const notes = 20.0;
  static const upload = 16.0;
}

abstract final class FuvekonSpacing {
  static const page = 20.0;
  static const card = 20.0;
  static const field = 16.0;
  static const section = 32.0;
  static const stackGapLg = 24.0;
  static const stackGapMd = 16.0;
  static const stackGapSm = 8.0;
}
