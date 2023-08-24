import 'package:disney_app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // キャッシュの上限を設定する 100枚の画像をキャッシュに保存
  PaintingBinding.instance.imageCache.maximumSize = 100;
  // キャッシュの容量を設定する 50MBまで
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
