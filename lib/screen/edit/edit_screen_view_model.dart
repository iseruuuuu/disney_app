import 'dart:io';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editScreenViewModelProvider =
    StateNotifierProvider<EditScreenViewModel, ImageProvider?>(
  (ref) {
    Account myAccount = Authentication.myAccount!;
    return EditScreenViewModel(
      state: NetworkImage(myAccount.imagePath),
    );
  },
);

class EditScreenViewModel extends StateNotifier<ImageProvider?> {
  EditScreenViewModel({required ImageProvider state}) : super(state) {
    fetch();
  }

  TextEditingController controller = TextEditingController();
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

  void fetch() {
    nameController = TextEditingController(text: myAccount.name);
    userIdController = TextEditingController(text: myAccount.userId);
    selfIntroductionController =
        TextEditingController(text: myAccount.selfIntroduction);
  }

  void update(BuildContext context) async {
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
      image = File(result.path);
      state = getImage();
    }
  }

  void signOut(BuildContext context) async {
    Authentication.signOut();
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    NavigationUtils.loginScreen(context);
  }

  void delete(BuildContext context) {
    UserFireStore.deleteUser(myAccount.id);
    Authentication.deleteAuth();
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    NavigationUtils.loginScreen(context);
  }
}
