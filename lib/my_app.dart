import 'package:disney_app/screen/login/login_screen.dart';
import 'package:flutter/material.dart';

import 'l10n/l10n.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.light),
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: const [
        Locale('ja'),
      ],
      home: const LoginScreen(),
    );
  }
}
