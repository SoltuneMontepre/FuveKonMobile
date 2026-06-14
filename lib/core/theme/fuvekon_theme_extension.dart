import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';

@immutable
class FuvekonThemeExtension extends ThemeExtension<FuvekonThemeExtension> {
  const FuvekonThemeExtension({
    required this.contentCard,
    required this.contentOnCard,
    required this.contentOnCardMuted,
    required this.appBarTitle,
    required this.uploadZoneBackground,
    required this.uploadZoneBorder,
    required this.infoAccent,
    required this.infoTitle,
    required this.notesSurface,
    required this.link,
  });

  final Color contentCard;
  final Color contentOnCard;
  final Color contentOnCardMuted;
  final Color appBarTitle;
  final Color uploadZoneBackground;
  final Color uploadZoneBorder;
  final Color infoAccent;
  final Color infoTitle;
  final Color notesSurface;
  final Color link;

  static const light = FuvekonThemeExtension(
    contentCard: Colors.white,
    contentOnCard: FuvekonColors.textOnCard,
    contentOnCardMuted: FuvekonColors.textSecondary,
    appBarTitle: FuvekonColors.textPrimary,
    uploadZoneBackground: FuvekonColors.uploadZoneBg,
    uploadZoneBorder: FuvekonColors.uploadZoneBorder,
    infoAccent: FuvekonColors.infoAccent,
    infoTitle: FuvekonColors.textPrimary,
    notesSurface: FuvekonColors.bgSecondary,
    link: FuvekonColors.outline,
  );

  static const dark = FuvekonThemeExtension(
    contentCard: FuvekonColors.darkCard,
    contentOnCard: FuvekonColors.darkCardText,
    contentOnCardMuted: FuvekonColors.textSecondary,
    appBarTitle: FuvekonColors.darkAppBarTitle,
    uploadZoneBackground: FuvekonColors.uploadZoneBg,
    uploadZoneBorder: FuvekonColors.uploadZoneBorder,
    infoAccent: FuvekonColors.infoAccent,
    infoTitle: FuvekonColors.infoTitle,
    notesSurface: FuvekonColors.darkNotesSurface,
    link: FuvekonColors.darkPrimary,
  );

  @override
  FuvekonThemeExtension copyWith({
    Color? contentCard,
    Color? contentOnCard,
    Color? contentOnCardMuted,
    Color? appBarTitle,
    Color? uploadZoneBackground,
    Color? uploadZoneBorder,
    Color? infoAccent,
    Color? infoTitle,
    Color? notesSurface,
    Color? link,
  }) {
    return FuvekonThemeExtension(
      contentCard: contentCard ?? this.contentCard,
      contentOnCard: contentOnCard ?? this.contentOnCard,
      contentOnCardMuted: contentOnCardMuted ?? this.contentOnCardMuted,
      appBarTitle: appBarTitle ?? this.appBarTitle,
      uploadZoneBackground:
          uploadZoneBackground ?? this.uploadZoneBackground,
      uploadZoneBorder: uploadZoneBorder ?? this.uploadZoneBorder,
      infoAccent: infoAccent ?? this.infoAccent,
      infoTitle: infoTitle ?? this.infoTitle,
      notesSurface: notesSurface ?? this.notesSurface,
      link: link ?? this.link,
    );
  }

  @override
  FuvekonThemeExtension lerp(
    covariant ThemeExtension<FuvekonThemeExtension>? other,
    double t,
  ) {
    if (other is! FuvekonThemeExtension) return this;
    return FuvekonThemeExtension(
      contentCard: Color.lerp(contentCard, other.contentCard, t)!,
      contentOnCard: Color.lerp(contentOnCard, other.contentOnCard, t)!,
      contentOnCardMuted:
          Color.lerp(contentOnCardMuted, other.contentOnCardMuted, t)!,
      appBarTitle: Color.lerp(appBarTitle, other.appBarTitle, t)!,
      uploadZoneBackground:
          Color.lerp(uploadZoneBackground, other.uploadZoneBackground, t)!,
      uploadZoneBorder:
          Color.lerp(uploadZoneBorder, other.uploadZoneBorder, t)!,
      infoAccent: Color.lerp(infoAccent, other.infoAccent, t)!,
      infoTitle: Color.lerp(infoTitle, other.infoTitle, t)!,
      notesSurface: Color.lerp(notesSurface, other.notesSurface, t)!,
      link: Color.lerp(link, other.link, t)!,
    );
  }
}

extension FuvekonThemeContext on BuildContext {
  FuvekonThemeExtension get fuvekonTheme =>
      Theme.of(this).extension<FuvekonThemeExtension>()!;
}
