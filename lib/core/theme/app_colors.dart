import 'package:flutter/material.dart';

/// Brand palette aligned with Fuvekon web `globals.css` and ticket UI.
abstract final class FuvekonColors {
  // ── Surfaces & backgrounds ──
  static const main = Color(0xFFE9F5E7);
  static const paper = Color(0xFFE2EEE2);
  static const bg = Color(0xFFE2EEE2);
  static const bgSecondary = Color(0xFFD2DDD2);

  // ── Brand greens ──
  static const primary = Color(0xFF7CBC97);
  static const secondary = Color(0xFF548780);
  static const button = Color(0xFF48715B);
  static const buttonHover = Color(0xFF248C56);
  static const buttonActive = Color(0xFF1E7A4A);
  static const outline = Color(0xFF2D9B63);
  static const available = Color(0xFF10B981);

  // ── Text ──
  static const textPrimary = Color(0xFF154C5B);
  static const textSecondary = Color(0xFF48715B);
  static const onPrimary = Color(0xFFFFFFFF);

  // ── Ticket tier accents (TicketDisplay.tsx) ──
  static const tier1 = Color(0xFF2D3C3F);
  static const tier2 = Color(0xFF979591);
  static const tier3 = Color(0xFFB99B59);
  static const tier4 = Color(0xFF673095);

  // ── Dark mode (inferred from web dark: utilities) ──
  static const darkBg = Color(0xFF0E1612);
  static const darkSurface = Color(0xFF16241E);
  static const darkSurfaceElevated = Color(0xFF1E3028);
  static const darkBorder = Color(0xFF2A4034);
  static const darkText = Color(0xFFE2EEE2);
  static const darkTextSecondary = Color(0xFF9BB8A8);
  static const darkPrimary = Color(0xFF7CBC97);
  static const darkButton = Color(0xFF5A9A78);
}
