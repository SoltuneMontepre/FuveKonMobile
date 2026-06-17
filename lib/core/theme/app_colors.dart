import 'package:flutter/material.dart';

/// Brand palette: legacy web tokens + FUVEKON Premium Mobile ([color.md]).
abstract final class FuvekonColors {
  // ── Premium mobile (color.md / Figma) ──
  static const premiumCanvas = Color(0xFF1E1E1E);
  static const premiumBackground = Color(0xFF131313);
  static const premiumNav = Color(0xFF07131A);
  static const premiumPrimary = Color(0xFFA9CFB8);
  static const premiumOnPrimary = Color(0xFF133726);
  static const premiumSecondary = Color(0xFFDFBEC9);
  static const premiumTertiary = Color(0xFFE9C349);
  static const premiumOnSurface = Color(0xFFE5E2E1);
  static const premiumOnSurfaceVariant = Color(0xFFC1C8C2);
  static const premiumOutline = Color(0xFF8B928C);
  static const premiumMintCard = Color(0xFFE4EEE3);
  static const premiumOnMintCard = Color(0xFF1E3D32);
  static const premiumOnMintCardMuted = Color(0xFF48715B);
  static const premiumDecorativeGold = Color(0xFFE9C349);
  static const premiumSurfaceContainer = Color(0xFF202020);
  static const premiumSurfaceContainerHigh = Color(0xFF2A2A2A);

  // ── Light surfaces (legacy) ──
  static const main = Color(0xFFE9F5E7);
  static const paper = Color(0xFFE9F0E9);
  static const bg = Color(0xFFE2EEE2);
  static const bgSecondary = Color(0xFFD2DDD2);

  // ── Brand greens (legacy) ──
  static const primary = Color(0xFF7CBC97);
  static const secondary = Color(0xFF548780);
  static const button = Color(0xFF9CCCA9);
  static const buttonHover = Color(0xFF8BBF9A);
  static const buttonActive = Color(0xFF7AB38D);
  static const outline = Color(0xFF2D9B63);
  static const available = Color(0xFF10B981);

  // ── Text (legacy) ──
  static const textPrimary = Color(0xFF154C5B);
  static const textSecondary = Color(0xFF48715B);
  static const textOnCard = Color(0xFF1E3D32);
  static const onPrimary = Color(0xFF154C5B);

  // ── Inputs & upload ──
  static const inputFill = Color(0xFFFFFFFF);
  static const inputBorder = Color(0xFFD8E0D8);
  static const uploadZoneBg = Color(0xFFF3F8F4);
  static const uploadZoneBorder = Color(0xFFB8D4C0);

  // ── Info / notes ──
  static const infoAccent = Color(0xFFE8A0A8);
  static const infoTitle = Color(0xFFF0C4C8);

  // ── Ticket tier accents ──
  static const tier1 = Color(0xFF2D3C3F);
  static const tier2 = Color(0xFF979591);
  static const tier3 = Color(0xFFB99B59);
  static const tier4 = Color(0xFF673095);

  // ── Dark mode (customer shell uses premium tokens below) ──
  static const darkBg = premiumCanvas;
  static const darkSurface = Color(0xFF1A1F1C);
  static const darkSurfaceElevated = premiumSurfaceContainerHigh;
  static const darkBorder = Color(0xFF2E3A34);
  static const darkText = premiumOnSurface;
  static const darkTextSecondary = premiumOnSurfaceVariant;
  static const darkAppBarTitle = premiumPrimary;
  static const darkPrimary = premiumPrimary;
  static const darkButton = premiumPrimary;
  static const darkButtonText = premiumOnPrimary;
  static const darkCard = premiumMintCard;
  static const darkCardText = premiumOnMintCard;
  static const darkNotesSurface = Color(0xFF1E2421);

  // ── Status badge colors ──
  static const statusSuccessBg = Color(0xFFC4ECD3);
  static const statusPendingBg = Color(0xFF567A66);
  static const statusDeniedBg = Color(0xFFFCDAE5);
  static const statusDeniedText = Color(0xFF690005);
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
