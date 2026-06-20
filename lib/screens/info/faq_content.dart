import 'package:flutter/material.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class FaqCategoryData {
  const FaqCategoryData({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<FaqItem> items;
}

/// Hardcoded FAQ — thay bằng API khi backend sẵn sàng.
abstract final class FaqContent {
  static List<FaqCategoryData> categories(AppLocalizations l10n) => [
    FaqCategoryData(
      title: l10n.faqCatTickets,
      icon: Icons.confirmation_number_outlined,
      items: [
        FaqItem(question: l10n.faqTicketsQ1, answer: l10n.faqTicketsA1),
        FaqItem(question: l10n.faqTicketsQ2, answer: l10n.faqTicketsA2),
        FaqItem(question: l10n.faqTicketsQ3, answer: l10n.faqTicketsA3),
        FaqItem(question: l10n.faqTicketsQ4, answer: l10n.faqTicketsA4),
        FaqItem(question: l10n.faqTicketsQ5, answer: l10n.faqTicketsA5),
        FaqItem(question: l10n.faqTicketsQ6, answer: l10n.faqTicketsA6),
      ],
    ),
    FaqCategoryData(
      title: l10n.faqCatRegister,
      icon: Icons.person_add_outlined,
      items: [
        FaqItem(question: l10n.faqRegisterQ1, answer: l10n.faqRegisterA1),
        FaqItem(question: l10n.faqRegisterQ2, answer: l10n.faqRegisterA2),
        FaqItem(question: l10n.faqRegisterQ3, answer: l10n.faqRegisterA3),
        FaqItem(question: l10n.faqRegisterQ4, answer: l10n.faqRegisterA4),
        FaqItem(question: l10n.faqRegisterQ5, answer: l10n.faqRegisterA5),
      ],
    ),
    FaqCategoryData(
      title: l10n.faqCatDealer,
      icon: Icons.storefront_outlined,
      items: [
        FaqItem(question: l10n.faqDealerQ1, answer: l10n.faqDealerA1),
        FaqItem(question: l10n.faqDealerQ2, answer: l10n.faqDealerA2),
        FaqItem(question: l10n.faqDealerQ3, answer: l10n.faqDealerA3),
        FaqItem(question: l10n.faqDealerQ4, answer: l10n.faqDealerA4),
        FaqItem(question: l10n.faqDealerQ5, answer: l10n.faqDealerA5),
      ],
    ),
    FaqCategoryData(
      title: l10n.faqCatTalent,
      icon: Icons.mic_outlined,
      items: [
        FaqItem(question: l10n.faqTalentQ1, answer: l10n.faqTalentA1),
        FaqItem(question: l10n.faqTalentQ2, answer: l10n.faqTalentA2),
        FaqItem(question: l10n.faqTalentQ3, answer: l10n.faqTalentA3),
        FaqItem(question: l10n.faqTalentQ4, answer: l10n.faqTalentA4),
      ],
    ),
    FaqCategoryData(
      title: l10n.faqCatPanel,
      icon: Icons.groups_outlined,
      items: [
        FaqItem(question: l10n.faqPanelQ1, answer: l10n.faqPanelA1),
        FaqItem(question: l10n.faqPanelQ2, answer: l10n.faqPanelA2),
        FaqItem(question: l10n.faqPanelQ3, answer: l10n.faqPanelA3),
        FaqItem(question: l10n.faqPanelQ4, answer: l10n.faqPanelA4),
      ],
    ),
    FaqCategoryData(
      title: l10n.faqCatSchedule,
      icon: Icons.calendar_month_outlined,
      items: [
        FaqItem(question: l10n.faqScheduleQ1, answer: l10n.faqScheduleA1),
        FaqItem(question: l10n.faqScheduleQ2, answer: l10n.faqScheduleA2),
        FaqItem(question: l10n.faqScheduleQ3, answer: l10n.faqScheduleA3),
        FaqItem(question: l10n.faqScheduleQ4, answer: l10n.faqScheduleA4),
      ],
    ),
    FaqCategoryData(
      title: l10n.faqCatLostFound,
      icon: Icons.search_outlined,
      items: [
        FaqItem(question: l10n.faqLostFoundQ1, answer: l10n.faqLostFoundA1),
        FaqItem(question: l10n.faqLostFoundQ2, answer: l10n.faqLostFoundA2),
        FaqItem(question: l10n.faqLostFoundQ3, answer: l10n.faqLostFoundA3),
        FaqItem(question: l10n.faqLostFoundQ4, answer: l10n.faqLostFoundA4),
      ],
    ),
  ];
}
