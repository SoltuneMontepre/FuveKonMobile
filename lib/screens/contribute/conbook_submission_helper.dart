import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/api/conbook_api.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:go_router/go_router.dart';

typedef ConbookDescriptionParts = ({
  String? genre,
  String idea,
  String portfolio,
});

abstract final class ConbookSubmissionHelper {
  static ConbookDescriptionParts parseDescription(String description) {
    if (description.trim().isEmpty) {
      return (genre: null, idea: '', portfolio: '');
    }

    String? genre;
    var portfolio = '';
    final ideaParts = <String>[];

    for (final part in description.split('\n\n')) {
      if (part.startsWith('Thể loại: ')) {
        genre = part.substring('Thể loại: '.length).trim();
      } else if (part.startsWith('Portfolio: ')) {
        portfolio = part.substring('Portfolio: '.length).trim();
      } else if (part.isNotEmpty) {
        ideaParts.add(part);
      }
    }

    return (genre: genre, idea: ideaParts.join('\n\n'), portfolio: portfolio);
  }

  static String buildDescription({
    required String? genre,
    required String idea,
    required String portfolio,
  }) {
    final parts = <String>[];
    if (genre != null && genre.isNotEmpty) {
      parts.add('Thể loại: $genre');
    }
    if (idea.isNotEmpty) parts.add(idea);
    if (portfolio.isNotEmpty) parts.add('Portfolio: $portfolio');
    final text = parts.join('\n\n');
    return text.length > 500 ? text.substring(0, 500) : text;
  }

  static Future<bool> submit({
    required BuildContext context,
    required String title,
    required String handle,
    required String description,
    required String? imageUrl,
    required String successRoute,
  }) async {
    final l10n = context.l10n;
    if (!sl<AuthSessionNotifier>().isAuthenticated) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.artbookLoginRequired)));
      context.go(Routes.login);
      return false;
    }

    if (imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.artbookPreviewRequired)));
      return false;
    }

    try {
      await sl<ConbookApi>().upload({
        'title': title,
        'handle': handle,
        'description': description,
        'image_url': imageUrl,
      });
      if (!context.mounted) return false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.artbookSubmitSuccess)));
      context.go(successRoute);
      return true;
    } catch (e) {
      if (!context.mounted) return false;
      final message = e is ServerException
          ? e.message
          : l10n.artbookSubmitFailed;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return false;
    }
  }

  static Future<bool> update({
    required BuildContext context,
    required String id,
    required String title,
    required String handle,
    required String description,
    required String? imageUrl,
    required String successRoute,
  }) async {
    final l10n = context.l10n;
    if (imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.artbookPreviewRequired)));
      return false;
    }

    try {
      await sl<ConbookApi>().update(id, {
        'title': title,
        'handle': handle,
        'description': description,
        'image_url': imageUrl,
      });
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật và gửi lại tác phẩm')),
      );
      context.go(successRoute);
      return true;
    } catch (e) {
      if (!context.mounted) return false;
      final message = e is ServerException
          ? e.message
          : l10n.artbookSubmitFailed;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return false;
    }
  }
}
