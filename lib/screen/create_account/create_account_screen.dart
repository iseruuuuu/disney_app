import 'package:disney_app/core/component/app_elevated_button.dart';
import 'package:disney_app/core/component/app_text_field.dart';
import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/screen/create_account/create_account_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountScreen extends ConsumerWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createAccountScreenViewModelProvider.notifier);
    final state = ref.watch(createAccountScreenViewModelProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: AppColorStyle.appColor,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Create Account',
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
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => ref
                    .read(createAccountScreenViewModelProvider.notifier)
                    .selectImage(),
                child: CircleAvatar(
                  backgroundColor: AppColorStyle.appColor,
                  foregroundImage: state != null ? FileImage(state) : null,
                  radius: 45,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: controller.nameController,
                hintText: '名前',
                maxLines: 1,
              ),
              AppTextField(
                controller: controller.userIdController,
                hintText: 'ユーザーID',
                maxLines: 1,
              ),
              AppTextField(
                controller: controller.selfIntroductionController,
                hintText: '自己紹介',
                maxLines: 3,
              ),
              AppTextField(
                controller: controller.emailController,
                hintText: 'メールアドレス',
                maxLines: 1,
              ),
              AppTextField(
                controller: controller.passwordController,
                hintText: 'パスワード(６文字以上)',
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15),
                child: AppElevatedButton(
                  title: 'アカウント作成',
                  onPressed: () => controller.createAccount(context, ref),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
