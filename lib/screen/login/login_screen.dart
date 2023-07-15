import 'package:disney_app/component/login_button.dart';
import 'package:disney_app/component/login_new_button.dart';
import 'package:disney_app/component/login_text_field.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = const FlutterSecureStorage();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordHidden = true;
  bool savePassword = true;

  Future<void> readFromStorage() async {
    emailController.text = await storage.read(key: "KEY_USERNAME") ?? '';
    passwordController.text = await storage.read(key: "KEY_PASSWORD") ?? '';
  }

  store() async {
    await storage.write(key: "KEY_USERNAME", value: emailController.text);
    await storage.write(key: "KEY_PASSWORD", value: passwordController.text);
  }

  @override
  void initState() {
    super.initState();
    readFromStorage();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: const Color(0xFF4A67AD),
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Login',
                style: GoogleFonts.pattaya(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/empty.png',
                        width: 70,
                        height: 70,
                      ),
                      Text(
                        'TDR APP',
                        style: GoogleFonts.pattaya(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  LoginTextField(
                    controller: emailController,
                    hintText: 'メールアドレス',
                  ),
                  const SizedBox(height: 50),
                  LoginTextField(
                    controller: passwordController,
                    hintText: 'パスワード',
                  ),
                  const SizedBox(height: 80),
                  LoginButton(
                    onPressed: () async {
                      var result = await Authentication.signIn(
                        email: emailController.text,
                        pass: passwordController.text,
                      );
                      if (result is UserCredential) {
                        var result0 =
                            await UserFireStore.getUser(result.user!.uid);
                        if (result0 == true) {
                          store();
                          if (!mounted) return;
                          NavigationUtils.tabScreen(context);
                        }
                      } else {
                        final errorMessage =
                            FunctionUtils().checkLoginError(result.toString());
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            behavior: SnackBarBehavior.fixed,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  LoginNewButton(
                    onPressed: () {
                      NavigationUtils.createAccountScreen(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
