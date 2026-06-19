import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';

/// Shared chrome for admin list pages (pushed routes and shell tab pages).
class AdminListScaffold extends StatelessWidget {
  const AdminListScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.tabs,
    this.tabController,
    this.header,
    this.floatingActionButton,
    this.embedded = false,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final List<String>? tabs;
  final TabController? tabController;
  final Widget? header;
  final Widget? floatingActionButton;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (embedded) _EmbeddedTitle(title: title),
        ?header,
        Expanded(child: body),
      ],
    );

    if (embedded) {
      return Scaffold(
        backgroundColor: FuvekonColors.darkBg,
        floatingActionButton: floatingActionButton,
        body: SafeArea(child: content),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        bottom: tabs != null && tabController != null
            ? TabBar(
                controller: tabController,
                tabs: [for (final tab in tabs!) Tab(text: tab)],
              )
            : null,
      ),
      floatingActionButton: floatingActionButton,
      body: content,
    );
  }
}

class _EmbeddedTitle extends StatelessWidget {
  const _EmbeddedTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FuvekonSpacing.page,
        12,
        FuvekonSpacing.page,
        0,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: FuvekonColors.darkAppBarTitle,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class AdminListSearchField extends StatelessWidget {
  const AdminListSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FuvekonSpacing.page,
        12,
        FuvekonSpacing.page,
        4,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  icon: const Icon(Icons.close_rounded),
                )
              : null,
        ),
      ),
    );
  }
}

class AdminListFilterRow extends StatelessWidget {
  const AdminListFilterRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: FuvekonSpacing.page,
        vertical: 4,
      ),
      child: Row(children: children),
    );
  }
}

class AdminListFilterChip extends StatelessWidget {
  const AdminListFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: FuvekonColors.darkPrimary.withValues(alpha: 0.25),
        checkmarkColor: FuvekonColors.darkPrimary,
        labelStyle: TextStyle(
          color: selected
              ? FuvekonColors.darkPrimary
              : FuvekonColors.darkTextSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected
              ? FuvekonColors.darkPrimary
              : FuvekonColors.darkBorder,
        ),
        backgroundColor: FuvekonColors.darkSurfaceElevated,
      ),
    );
  }
}

class AdminListBody extends StatelessWidget {
  const AdminListBody({
    super.key,
    required this.loading,
    required this.error,
    required this.isEmpty,
    required this.onRetry,
    required this.onRefresh,
    required this.emptyState,
    required this.child,
    this.loadingMore = false,
    this.listBottomPadding = 0,
    this.onLoadMore,
    this.hasMore = false,
  });

  final bool loading;
  final String? error;
  final bool isEmpty;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final EmptyState emptyState;
  final Widget child;
  final bool loadingMore;
  final double listBottomPadding;
  final VoidCallback? onLoadMore;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    if (loading && isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && isEmpty) {
      return AdminListErrorState(message: error!, onRetry: onRetry);
    }

    if (isEmpty) {
      return emptyState;
    }

    Widget content = RefreshIndicator(onRefresh: onRefresh, child: child);

    if (onLoadMore != null) {
      content = NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 200 &&
              !loadingMore &&
              hasMore) {
            onLoadMore!();
          }
          return false;
        },
        child: content,
      );
    }

    return content;
  }
}

class AdminListErrorState extends StatelessWidget {
  const AdminListErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FuvekonSpacing.page),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: FuvekonColors.darkTextSecondary,
                  ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }
}

class AdminListLoadMoreIndicator extends StatelessWidget {
  const AdminListLoadMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
