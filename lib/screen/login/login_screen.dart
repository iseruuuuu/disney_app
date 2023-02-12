import 'package:disney_app/screen/create_account/create_account_screen.dart';
import 'package:disney_app/screen/tab/tab_screen.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Text('ログイン'),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'メールアドレス',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'パスワード',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateAccountScreen(),
                    ),
                  );
                },
                child: const Text('新規登録'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var result = await Authentication.signIn(
                    email: emailController.text,
                    pass: passwordController.text,
                  );
                  if (result is UserCredential) {
                    var result0 = await UserFireStore.getUser(result.user!.uid);
                    if (result0 == true) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TabScreen(),
                        ),
                      );
                    }
                  }
                },
                child: const Text('ログイン'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
