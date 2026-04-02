import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class ExportHelper {
  static Future<File?> captureWidget(GlobalKey key, {String fileName = 'brandr_result'}) async {
    try {
      final RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // pixel ratio controls the resolution. 3.0 gives standard high-res scale.
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/$fileName.png').create();
      await file.writeAsBytes(pngBytes);
      return file;
    } catch (e) {
      debugPrint("Capture error: \$e");
      return null;
    }
  }

  static Future<bool> saveToGallery(GlobalKey key) async {
    try {
      final file = await captureWidget(key);
      if (file != null) {
        // Must check permission before using Gal.putImage otherwise it throws
        final hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          await Gal.requestAccess();
        }
        await Gal.putImage(file.path, album: 'Brandr');
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> shareResult(GlobalKey key) async {
    final file = await captureWidget(key);
    if (file != null) {
      await Share.shareXFiles(
        [XFile(file.path)], 
        text: 'BRANDR(브랜더) 자가진단 결과 🌟\\n내 브랜드의 현주소를 확인해 보세요!'
      );
    }
  }
}
