import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuvekonmobile/core/utils/s3_url.dart';

/// Badge name and role labels on the name card template.
const _nameCardLightText = Color(0xFFF2EDE9);

/// Mirrors Fuvekon web `renderNamecardBlob.ts`.
class RenderNamecardOptions {
  const RenderNamecardOptions({
    required this.tierCodeNumber,
    this.avatarUrl,
    required this.previewName,
    this.referenceCode,
    this.isFursuiter = false,
    this.isFursuitStaff = false,
    this.isDealer = false,
    this.pixelRatio = 2,
  });

  final int tierCodeNumber;
  final String? avatarUrl;
  final String previewName;
  final String? referenceCode;
  final bool isFursuiter;
  final bool isFursuitStaff;
  final bool isDealer;
  final double pixelRatio;

  static const templateWidth = 652.0;
  static const templateHeight = 1001.0;

  static const _tierTemplateAssets = {
    1: 'assets/images/ticket/thestandard.png',
    2: 'assets/images/ticket/thevip.png',
    3: 'assets/images/ticket/thesponsor.png',
    4: 'assets/images/ticket/thesupersponsor.png',
    5: 'assets/images/ticket/thegoh.png',
  };
}

class NamecardRenderer {
  NamecardRenderer({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<Uint8List> renderPng(RenderNamecardOptions options) async {
    final tier = options.tierCodeNumber.clamp(1, 5);
    final templateAsset =
        RenderNamecardOptions._tierTemplateAssets[tier] ??
        RenderNamecardOptions._tierTemplateAssets[1]!;

    final templateImage = await _loadAssetImage(templateAsset);
    ui.Image? avatarImage;
    if (options.avatarUrl != null && options.avatarUrl!.isNotEmpty) {
      final resolved = S3Url.isS3Url(options.avatarUrl!)
          ? S3Url.resolveImageUrl(options.avatarUrl!)
          : options.avatarUrl!;
      avatarImage = await _loadNetworkImage(resolved);
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final scale = options.pixelRatio;
    canvas.scale(scale);

    const w = RenderNamecardOptions.templateWidth;
    const h = RenderNamecardOptions.templateHeight;
    const previewToCanvas = w / 310;

    // Avatar under template.
    const avatarX = w * 0.155;
    const avatarY = h * 0.29;
    const avatarW = w * 0.53;
    const avatarH = h * 0.35;
    canvas.drawRect(
      const Rect.fromLTWH(avatarX, avatarY, avatarW, avatarH),
      Paint()..color = const Color(0xFFFFFFFF),
    );
    if (avatarImage != null) {
      _drawCoverImage(canvas, avatarImage, avatarX, avatarY, avatarW, avatarH);
    }

    canvas.drawImageRect(
      templateImage,
      Rect.fromLTWH(
        0,
        0,
        templateImage.width.toDouble(),
        templateImage.height.toDouble(),
      ),
      const Rect.fromLTWH(0, 0, w, h),
      Paint(),
    );

    final refFontPx = 13 * previewToCanvas;
    const refX = w * 0.12;
    const refY = h * 0.735;
    if (options.referenceCode != null && options.referenceCode!.isNotEmpty) {
      final label = '#${options.referenceCode}'.toUpperCase();
      final tracking = 0.22 * refFontPx;
      const refColor = Color.fromRGBO(15, 35, 40, 0.75);
      var cursorX = refX;
      for (final ch in label.characters) {
        final builder =
            ui.ParagraphBuilder(
                ui.ParagraphStyle(
                  fontSize: refFontPx,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Comic Sans MS',
                ),
              )
              ..pushStyle(ui.TextStyle(color: refColor))
              ..addText(ch);
        final paragraph = builder.build()
          ..layout(const ui.ParagraphConstraints(width: double.infinity));
        canvas.drawParagraph(paragraph, Offset(cursorX, refY));
        cursorX += paragraph.maxIntrinsicWidth + tracking;
      }
    }

    final nameFontPx = 50 * previewToCanvas;
    const nameX = refX;
    final nameY = refY + refFontPx + 40 * previewToCanvas + -62;
    final nameMaxWidth = 210 * previewToCanvas;
    _drawFittedText(
      canvas,
      options.previewName.toUpperCase(),
      nameX,
      nameY,
      nameMaxWidth,
      nameFontPx,
      _nameCardLightText,
      FontWeight.w800,
    );

    final labelFontPx = 10 * previewToCanvas;
    const labelX = w * 0.1275;
    const labelY = h * 0.934;
    final labels = <String>[
      if (options.isFursuitStaff) 'Fursuit Staff',
      if (options.isFursuiter) 'Fursuiter',
      if (options.isDealer) 'Dealer',
    ];
    if (labels.isNotEmpty) {
      final builder =
          ui.ParagraphBuilder(
              ui.ParagraphStyle(
                fontSize: labelFontPx,
                fontWeight: FontWeight.w600,
              ),
            )
            ..pushStyle(ui.TextStyle(color: _nameCardLightText))
            ..addText(labels.join(' · ').toUpperCase());
      final paragraph = builder.build()
        ..layout(ui.ParagraphConstraints(width: w - labelX));
      canvas.drawParagraph(paragraph, const Offset(labelX, labelY));
    }

    templateImage.dispose();
    avatarImage?.dispose();

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (w * scale).round(),
      (h * scale).round(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (byteData == null) {
      throw StateError('Failed to encode name card PNG');
    }
    return byteData.buffer.asUint8List();
  }

  Future<ui.Image> _loadAssetImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<ui.Image?> _loadNetworkImage(String url) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        return null;
      }
      final codec = await ui.instantiateImageCodec(Uint8List.fromList(bytes));
      final frame = await codec.getNextFrame();
      return frame.image;
    } on Object {
      return null;
    }
  }

  void _drawCoverImage(
    Canvas canvas,
    ui.Image image,
    double dx,
    double dy,
    double dw,
    double dh,
  ) {
    final srcAspect = image.width / image.height;
    final dstAspect = dw / dh;
    var sx = 0.0;
    var sy = 0.0;
    var sw = image.width.toDouble();
    var sh = image.height.toDouble();
    if (srcAspect > dstAspect) {
      sw = image.height * dstAspect;
      sx = (image.width - sw) / 2;
    } else if (srcAspect < dstAspect) {
      sh = image.width / dstAspect;
      sy = (image.height - sh) / 2;
    }
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(sx, sy, sw, sh),
      Rect.fromLTWH(dx, dy, dw, dh),
      Paint(),
    );
  }

  void _drawFittedText(
    Canvas canvas,
    String text,
    double x,
    double y,
    double maxWidth,
    double baseFontPx,
    Color color,
    FontWeight weight,
  ) {
    if (text.isEmpty) return;
    final builder =
        ui.ParagraphBuilder(
            ui.ParagraphStyle(fontSize: baseFontPx, fontWeight: weight),
          )
          ..pushStyle(ui.TextStyle(color: color))
          ..addText(text);
    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: maxWidth));
    final measured = paragraph.maxIntrinsicWidth;
    final scale = measured > maxWidth ? maxWidth / measured : 1.0;
    canvas.save();
    canvas.translate(x, y);
    canvas.scale(scale, scale);
    canvas.drawParagraph(paragraph, Offset.zero);
    canvas.restore();
  }
}

int tierCodeFromTierCodeString(String? tierCode) {
  if (tierCode == null) return 0;
  if (tierCode.toUpperCase() == 'WS') return 1;
  final match = RegExp(r'^T(\d+)$', caseSensitive: false).firstMatch(tierCode);
  return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
}
