import 'dart:io';
import 'package:disney_app/core/component/app_elevated_button.dart';
import 'package:disney_app/core/component/app_text_field.dart';
import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? image;

  @override
  Widget build(BuildContext context) {
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
                onPressed: () async {
                  Navigator.pop(context);
                },
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
                onTap: () async {
                  var result = await FunctionUtils.getImageFromGallery();
                  if (result != null) {
                    setState(() {
                      image = File(result.path);
                    });
                  }
                },
                child: CircleAvatar(
                  backgroundColor: AppColorStyle.appColor,
                  foregroundImage: image == null ? null : FileImage(image!),
                  radius: 45,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: nameController,
                hintText: '名前',
                maxLines: 1,
              ),
              AppTextField(
                controller: userIdController,
                hintText: 'ユーザーID',
                maxLines: 1,
              ),
              AppTextField(
                controller: selfIntroductionController,
                hintText: '自己紹介',
                maxLines: 3,
              ),
              AppTextField(
                controller: emailController,
                hintText: 'メールアドレス',
                maxLines: 1,
              ),
              AppTextField(
                controller: passwordController,
                hintText: 'パスワード(６文字以上)',
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15),
                child: AppElevatedButton(
                  title: 'アカウント作成',
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (nameController.text.isNotEmpty &&
                        userIdController.text.isNotEmpty &&
                        selfIntroductionController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty &&
                        image != null) {
                      var result = await Authentication.signUp(
                        email: emailController.text,
                        pass: passwordController.text,
                      );
                      if (result is UserCredential) {
                        String imagePath = await FunctionUtils.uploadImage(
                          result.user!.uid,
                          image!,
                        );
                        Account newAccount = Account(
                          id: result.user!.uid,
                          name: nameController.text,
                          userId: userIdController.text,
                          selfIntroduction: selfIntroductionController.text,
                          imagePath: imagePath,
                        );
                        var result0 = await UserFireStore.setUser(newAccount);
                        if (result0 == true) {
                          if (!mounted) return;
                          Navigator.pop(context);
                        }
                      } else {
                        final errorMessage = FunctionUtils()
                            .checkRegisterError(result.toString());
                        if (!mounted) return;
                        SnackBarUtils.snackBar(context, errorMessage);
                      }
                    } else {
                      SnackBarUtils.snackBar(context, '登録してた内容に不備があります');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
