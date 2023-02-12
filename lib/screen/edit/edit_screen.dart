import 'dart:io';
import 'package:disney_app/model/account.dart';
import 'package:disney_app/screen/login/login_screen.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:disney_app/utils/function_utils.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
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
                foregroundImage: getImage(),
                radius: 40,
                child: const Icon(Icons.add),
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
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    userIdController.text.isNotEmpty &&
                    selfIntroductionController.text.isNotEmpty) {
                  String imagePath = '';
                  if (image == null) {
                    imagePath = myAccount.imagePath;
                  } else {
                    var result =
                        await FunctionUtils.uploadImage(myAccount.id, image!);
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
                    Navigator.pop(context, true);
                  }
                }
              },
              child: const Text('更新'),
            ),
            ElevatedButton(
              onPressed: () {
                Authentication.signOut();
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('ログアウト'),
            ),
            ElevatedButton(
              onPressed: () {
                UserFireStore.deleteUser(myAccount.id);
                Authentication.deleteAuth();
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('アカウントを削除'),
            ),
          ],
        ),
      ),
    );
  }
}
