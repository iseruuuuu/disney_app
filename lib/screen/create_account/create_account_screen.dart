import 'dart:io';
import 'package:disney_app/model/account.dart';
import 'package:disney_app/screen/create_account/component/create_account_button.dart';
import 'package:disney_app/screen/create_account/component/create_account_text_field.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A67AD),
        elevation: 0,
        title: Text(
          'Create Account',
          style: GoogleFonts.pattaya(
            fontSize: 30,
            fontWeight: FontWeight.bold,
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
                backgroundColor: const Color(0xFF4A67AD),
                foregroundImage: image == null ? null : FileImage(image!),
                radius: 55,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            CreateAccountTextField(
              controller: nameController,
              hintText: '名前',
              maxLines: 1,
            ),
            CreateAccountTextField(
              controller: userIdController,
              hintText: 'ユーザーID',
              maxLines: 1,
            ),
            CreateAccountTextField(
              controller: selfIntroductionController,
              hintText: '自己紹介',
              maxLines: 3,
            ),
            CreateAccountTextField(
              controller: emailController,
              hintText: 'メールアドレス',
              maxLines: 1,
            ),
            CreateAccountTextField(
              controller: passwordController,
              hintText: 'パスワード(６文字以上)',
              maxLines: 1,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15),
              child: CreateAccountButton(
                onPressed: () async {
                  await EasyLoading.show(status: 'loading....');
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
                        Navigator.pop(context);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('登録エラー $result'),
                          behavior: SnackBarBehavior.fixed,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('登録してた内容に不備があります'),
                        behavior: SnackBarBehavior.fixed,
                      ),
                    );
                  }
                  await EasyLoading.dismiss();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
