import 'dart:io';
import 'package:disney_app/model/account.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
        title: const Text('新規作成'),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 30),
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
                foregroundImage: image == null ? null : FileImage(image!),
                radius: 40,
                child: Icon(Icons.add),
              ),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: '名前'),
            ),
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(hintText: 'ユーザーID'),
            ),
            TextField(
              controller: selfIntroductionController,
              decoration: const InputDecoration(hintText: '自己紹介'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'メールアドレス'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(hintText: 'パスワード'),
            ),
            ElevatedButton(
              onPressed: () async {
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
                  }
                }
              },
              child: const Text('アカウントを作成'),
            ),
          ],
        ),
      ),
    );
  }
}
