import 'package:flutter/material.dart';

/// Brand palette aligned with Fuvekon web and mobile dealer-registration UI.
abstract final class FuvekonColors {
  // ── Light surfaces ──
  static const main = Color(0xFFE9F5E7);
  static const paper = Color(0xFFE9F0E9);
  static const bg = Color(0xFFE2EEE2);
  static const bgSecondary = Color(0xFFD2DDD2);

  // ── Brand greens ──
  static const primary = Color(0xFF7CBC97);
  static const secondary = Color(0xFF548780);
  static const button = Color(0xFF9CCCA9);
  static const buttonHover = Color(0xFF8BBF9A);
  static const buttonActive = Color(0xFF7AB38D);
  static const outline = Color(0xFF2D9B63);
  static const available = Color(0xFF10B981);

  // ── Text ──
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

  // ── Dark mode ──
  static const darkBg = Color(0xFF121212);
  static const darkSurface = Color(0xFF1A1F1C);
  static const darkSurfaceElevated = Color(0xFF242B27);
  static const darkBorder = Color(0xFF2E3A34);
  static const darkText = Color(0xFFE2EEE2);
  static const darkTextSecondary = Color(0xFFB0C4B8);
  static const darkAppBarTitle = Color(0xFFB8D4C0);
  static const darkPrimary = Color(0xFF9CCCA9);
  static const darkButton = Color(0xFF9CCCA9);
  static const darkButtonText = Color(0xFF154C5B);
  static const darkCard = Color(0xFFE9F0E9);
  static const darkCardText = Color(0xFF1E3D32);
  static const darkNotesSurface = Color(0xFF1E2421);
}

/// Layout tokens shared across light and dark themes.
abstract final class FuvekonRadii {
  static const card = 28.0;
  static const input = 12.0;
  static const button = 999.0;
  static const notes = 20.0;
  static const upload = 16.0;
}

abstract final class FuvekonSpacing {
  static const page = 20.0;
  static const card = 24.0;
  static const field = 16.0;
  static const section = 24.0;
}
