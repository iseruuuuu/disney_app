import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:disney_app/core/component/app_elevated_button.dart';
import 'package:disney_app/core/component/app_text_button.dart';
import 'package:disney_app/core/component/app_text_field.dart';
import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/gen/assets.gen.dart';
import 'package:disney_app/screen/login/login_screen_view_model.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginScreenViewModelProvider.notifier);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: AppColorStyle.appColor,
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    Assets.images.empty.path,
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
              AppTextField(
                controller: state.emailController,
                hintText: 'メールアドレス',
                maxLines: 1,
              ),
              const SizedBox(height: 50),
              AppTextField(
                controller: state.passwordController,
                hintText: 'パスワード',
                maxLines: 1,
              ),
              const SizedBox(height: 80),
              AppElevatedButton(
                title: 'ログイン',
                onPressed: () => ref
                    .read(loginScreenViewModelProvider.notifier)
                    .login(context, ref),
              ),
              const SizedBox(height: 30),
              AppTextButton(
                onPressed: () => ref
                    .read(loginScreenViewModelProvider.notifier)
                    .createAccountScreen(context),
                title: '新規登録はこちら',
                color: Colors.lightBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
