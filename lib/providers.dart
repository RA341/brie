import 'dart:io';

import 'package:brie/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

final basePathProvider = StateProvider<String>((ref) {
  if (kIsWeb) {
    return html.window.location.toString();
  }
  return '';
});

final apiProvider = Provider<GoudaApi?>((ref) {
  final basePath = ref.watch(basePathProvider);
  if (basePath.isEmpty) {
    return null;
  }

  return GoudaApi(basePath: basePath);
});
