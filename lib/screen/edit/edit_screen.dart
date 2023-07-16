import 'dart:io';
import 'package:disney_app/component/app_text_button.dart';
import 'package:disney_app/component/edit_text_field.dart';
import 'package:disney_app/model/account.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Account myAccount = Authentication.myAccount!;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  File? image;

  ImageProvider getImage() {
    if (image == null) {
      return NetworkImage(myAccount.imagePath);
    } else {
      return FileImage(image!);
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: myAccount.name);
    userIdController = TextEditingController(text: myAccount.userId);
    selfIntroductionController =
        TextEditingController(text: myAccount.selfIntroduction);
  }

  void update() async {
    if (nameController.text.isNotEmpty &&
        userIdController.text.isNotEmpty &&
        selfIntroductionController.text.isNotEmpty) {
      String imagePath = '';
      if (image == null) {
        imagePath = myAccount.imagePath;
      } else {
        var result = await FunctionUtils.uploadImage(myAccount.id, image!);
        imagePath = result;
      }
      Account updateAccount = Account(
        id: myAccount.id,
        name: nameController.text,
        userId: userIdController.text,
        selfIntroduction: selfIntroductionController.text,
        imagePath: imagePath,
      );
      Authentication.myAccount = updateAccount;
      var result = await UserFireStore.updateUser(updateAccount);
      if (result == true) {
        if (!mounted) return;
        Navigator.pop(context, true);
      }
    }
  }

  void selectImage() async {
    var result = await FunctionUtils.getImageFromGallery();
    if (result != null) {
      setState(() {
        image = File(result.path);
      });
    }
  }

  void signOut() async {
    Authentication.signOut();
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    NavigationUtils.loginScreen(context);
  }

  void delete() {
    UserFireStore.deleteUser(myAccount.id);
    Authentication.deleteAuth();
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    NavigationUtils.loginScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: update,
            child: const Text(
              '更新する',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            GestureDetector(
              onTap: selectImage,
              child: CircleAvatar(
                foregroundImage: getImage(),
                radius: 70,
                child: const Icon(Icons.add),
              ),
            ),
            const Spacer(),
            EditTextField(
              controller: nameController,
              hintText: '名前',
              maxLine: 1,
            ),
            const Spacer(),
            EditTextField(
              controller: userIdController,
              hintText: 'ユーザーID',
              maxLine: 1,
            ),
            const Spacer(),
            EditTextField(
              controller: selfIntroductionController,
              hintText: '自己紹介',
              maxLine: 3,
            ),
            const Spacer(),
            AppTextButton(
              onPressed: () {
                FunctionUtils.openDialog(
                  context: context,
                  title: 'ログアウト確認',
                  content: 'ログアウトします。\n'
                      'よろしいでしょうか？',
                  onTap: signOut,
                );
              },
              title: 'ログアウト',
              color: Colors.red,
            ),
            AppTextButton(
              onPressed: () {
                FunctionUtils.openDialog(
                  context: context,
                  title: 'アカウント削除確認',
                  content: 'アカウントの情報を削除します。\n'
                      '投稿内容も全て削除されます。\n'
                      'よろしいでしょうか？',
                  onTap: delete,
                );
              },
              title: 'アカウントを削除',
              color: Colors.red,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
