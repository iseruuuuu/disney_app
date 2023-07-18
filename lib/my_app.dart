// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:disney_app/screen/login/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.light),
      home: const LoginScreen(),
    );
  }
}
