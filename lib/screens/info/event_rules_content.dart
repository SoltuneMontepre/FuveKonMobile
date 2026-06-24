import 'package:flutter/material.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';

class EventRulesGroup {
  const EventRulesGroup({required this.title, required this.cards});

  final String title;
  final List<EventRulesCardData> cards;
}

class EventRulesCardData {
  const EventRulesCardData({
    required this.icon,
    required this.iconBg,
    this.title,
    this.paragraphs = const [],
    this.items = const [],
    this.trailingParagraphs = const [],
  });

  final IconData icon;
  final Color iconBg;
  final String? title;
  final List<String> paragraphs;
  final List<String> items;
  final List<String> trailingParagraphs;
}

abstract final class EventRulesContent {
  static List<EventRulesGroup> groups(AppLocalizations l10n) => [
    EventRulesGroup(
      title: l10n.rulesAttendeeSection,
      cards: [
        EventRulesCardData(
          icon: Icons.badge_outlined,
          iconBg: const Color(0xFF3D6B52),
          title: l10n.rulesTicketsTitle,
          items: [
            l10n.rulesTickets1,
            l10n.rulesTickets2,
            l10n.rulesTickets3,
            l10n.rulesTickets4,
          ],
        ),
        EventRulesCardData(
          icon: Icons.gavel_outlined,
          iconBg: const Color(0xFF5A5A5A),
          title: l10n.rulesConductTitle,
          items: [
            l10n.rulesConduct1,
            l10n.rulesConduct2,
            l10n.rulesConduct3,
            l10n.rulesConduct4,
            l10n.rulesConduct5,
            l10n.rulesConduct6,
          ],
        ),
        EventRulesCardData(
          icon: Icons.block_outlined,
          iconBg: const Color(0xFFC45C5C),
          title: l10n.rulesProhibitedItemsTitle,
          items: [
            l10n.rulesProhibitedItems1,
            l10n.rulesProhibitedItems2,
            l10n.rulesProhibitedItems3,
            l10n.rulesProhibitedItems4,
            l10n.rulesProhibitedItems5,
            l10n.rulesProhibitedItems6,
          ],
        ),
        EventRulesCardData(
          icon: Icons.checkroom_outlined,
          iconBg: const Color(0xFFE879A8),
          title: l10n.rulesClothingTitle,
          paragraphs: [
            l10n.rulesClothingIntro,
            l10n.rulesClothingProhibitedIntro,
          ],
          items: [
            l10n.rulesClothingProhibited1,
            l10n.rulesClothingProhibited2,
            l10n.rulesClothingProhibited3,
            l10n.rulesClothingProhibited4,
          ],
          trailingParagraphs: [
            l10n.rulesClothingNote1,
            l10n.rulesClothingNote2,
            l10n.rulesClothingNote3,
            l10n.rulesClothingNote4,
          ],
        ),
        EventRulesCardData(
          icon: Icons.camera_alt_outlined,
          iconBg: const Color(0xFF4A7FC4),
          title: l10n.rulesPhotographyTitle,
          items: _photographyItems(l10n),
        ),
        EventRulesCardData(
          icon: Icons.admin_panel_settings_outlined,
          iconBg: const Color(0xFF7A6BB5),
          title: l10n.rulesOrganizerAttendeeTitle,
          items: [
            l10n.rulesOrganizerAttendee1,
            l10n.rulesOrganizerAttendee2,
            l10n.rulesOrganizerAttendee3,
            l10n.rulesOrganizerAttendee4,
            l10n.rulesOrganizerAttendee5,
            l10n.rulesOrganizerAttendee6,
          ],
        ),
      ],
    ),
    EventRulesGroup(
      title: l10n.rulesProductSection,
      cards: [
        EventRulesCardData(
          icon: Icons.inventory_2_outlined,
          iconBg: const Color(0xFFE8B84A),
          title: l10n.rulesProductSection,
          paragraphs: [
            l10n.rulesProductIntro,
            l10n.rulesProductAllowedIntro,
          ],
          items: [
            l10n.rulesProductAllowed1,
            l10n.rulesProductAllowed2,
            l10n.rulesProductAllowed3,
          ],
          trailingParagraphs: [l10n.rulesProductProhibitedIntro],
        ),
        EventRulesCardData(
          icon: Icons.do_not_disturb_on_outlined,
          iconBg: const Color(0xFFC45C5C),
          items: [
            l10n.rulesProductProhibited1,
            l10n.rulesProductProhibited2,
            l10n.rulesProductProhibited3,
            l10n.rulesProductProhibited4,
            l10n.rulesProductProhibited5,
          ],
          trailingParagraphs: [
            l10n.rulesProductFireSafety,
            l10n.rulesProductViolation1,
            l10n.rulesProductViolation2,
            l10n.rulesProductLiability,
          ],
        ),
      ],
    ),
    EventRulesGroup(
      title: l10n.rulesDealerSection,
      cards: [
        EventRulesCardData(
          icon: Icons.storefront_outlined,
          iconBg: const Color(0xFF3D8B6B),
          title: l10n.rulesDealerAreaTitle,
          items: [
            l10n.rulesDealerArea1,
            l10n.rulesDealerArea2,
            l10n.rulesDealerArea3,
            l10n.rulesDealerArea4,
            l10n.rulesDealerArea5,
            l10n.rulesDealerArea6,
          ],
        ),
        EventRulesCardData(
          icon: Icons.admin_panel_settings_outlined,
          iconBg: const Color(0xFF7A6BB5),
          title: l10n.rulesOrganizerDealerTitle,
          items: [l10n.rulesOrganizerDealer1, l10n.rulesOrganizerDealer2],
        ),
      ],
    ),
  ];

  static List<String> _photographyItems(AppLocalizations l10n) => [
    l10n.rulesPhotography1,
    l10n.rulesPhotography2,
    l10n.rulesPhotography3,
    l10n.rulesPhotography4,
    if (l10n.rulesPhotography5.isNotEmpty) l10n.rulesPhotography5,
    if (l10n.rulesPhotography6.isNotEmpty) l10n.rulesPhotography6,
  ];
}
