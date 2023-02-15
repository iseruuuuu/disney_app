import 'package:disney_app/screen/create_account/create_account_screen.dart';
import 'package:disney_app/screen/login/component/login_button.dart';
import 'package:disney_app/screen/login/component/login_new_button.dart';
import 'package:disney_app/screen/login/component/login_text_field.dart';
import 'package:disney_app/screen/tab/tab_screen.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A67AD),
        elevation: 0,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(),
              LoginTextField(controller: emailController, hintText: 'メールアドレス'),
              const SizedBox(height: 50),
              LoginTextField(controller: passwordController, hintText: 'パスワード'),
              const Spacer(),
              LoginNewButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateAccountScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              LoginButton(
                onPressed: () async {
                  await EasyLoading.show(status: 'loading....');
                  var result = await Authentication.signIn(
                    email: emailController.text,
                    pass: passwordController.text,
                  );
                  if (result is UserCredential) {
                    var result0 = await UserFireStore.getUser(result.user!.uid);
                    if (result0 == true) {
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TabScreen(),
                        ),
                      );
                    }
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ログインの際にエラーが発生しました。'),
                        behavior: SnackBarBehavior.fixed,
                      ),
                    );
                  }
                  await EasyLoading.dismiss();
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
