import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/info/faq_content.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final _searchController = TextEditingController();
  int? _expandedIndex;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_FaqCategory> _categories(BuildContext context) {
    return FaqContent.categories(context.l10n)
        .map(
          (c) => _FaqCategory(
            title: c.title,
            icon: c.icon,
            items: c.items.map((i) => (i.question, i.answer)).toList(),
          ),
        )
        .toList();
  }

  List<_FaqCategory> _filteredCategories(List<_FaqCategory> categories) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return categories;

    return categories
        .map((category) {
          if (category.title.toLowerCase().contains(query)) {
            return category;
          }
          final items = category.items.where((item) {
            return item.$1.toLowerCase().contains(query) ||
                item.$2.toLowerCase().contains(query);
          }).toList();
          if (items.isEmpty) return null;
          return _FaqCategory(
            title: category.title,
            icon: category.icon,
            items: items,
          );
        })
        .whereType<_FaqCategory>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final allCategories = _categories(context);
    final categories = _filteredCategories(allCategories);

    return FuvekonNavScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.faqPageTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 26,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.faqPageSubtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 14.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: l10n.faqSearchHint,
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: _FaqColors.categoryBg.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: categories.isEmpty
                ? Center(
                    child: Text(
                      l10n.faqNoResults,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    itemCount: categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final originalIndex = allCategories.indexOf(category);
                      final expanded = _expandedIndex == originalIndex;

                      return _FaqCategoryTile(
                        category: category,
                        expanded: expanded,
                        onTap: () {
                          setState(() {
                            _expandedIndex =
                                expanded ? null : originalIndex;
                          });
                        },
                      );
                    },
                  ),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: GestureDetector(
              onTap: () {},
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(text: l10n.faqNeedHelp),
                    TextSpan(
                      text: l10n.faqContactUs,
                      style: TextStyle(
                        color: _FaqColors.titleAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

abstract final class _FaqColors {
  static const titleAccent = FuvekonColors.darkPrimary;
  static const categoryBg = FuvekonColors.mintCard;
  static const textDark = FuvekonColors.darkButtonText;
}

class _FaqCategory {
  const _FaqCategory({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<(String, String)> items;
}

class _FaqCategoryTile extends StatelessWidget {
  const _FaqCategoryTile({
    required this.category,
    required this.expanded,
    required this.onTap,
  });

  final _FaqCategory category;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: _FaqColors.categoryBg,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Icon(category.icon, color: _FaqColors.textDark, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      category.title,
                      style: const TextStyle(
                        color: _FaqColors.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: _FaqColors.textDark.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            decoration: BoxDecoration(
              color: FuvekonColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _FaqColors.categoryBg.withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < category.items.length; i++) ...[
                  if (i > 0)
                    Divider(
                      color: Colors.white.withValues(alpha: 0.08),
                      height: 20,
                    ),
                  Text(
                    category.items[i].$1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.items[i].$2,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 13.5,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          crossFadeState:
              expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
