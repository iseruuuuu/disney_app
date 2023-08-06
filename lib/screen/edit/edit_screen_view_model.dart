import 'dart:io';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/usecase/user_firestore_usecase.dart';
import 'package:disney_app/l10n/l10n.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final editScreenViewModelProvider =
    StateNotifierProvider<EditScreenViewModel, ImageProvider>(
  (ref) {
    final myAccount = Authentication.myAccount!;
    return EditScreenViewModel(
      state: NetworkImage(myAccount.imagePath),
      ref: ref,
    );
  },
);

class EditScreenViewModel extends StateNotifier<ImageProvider> {
  EditScreenViewModel({
    required ImageProvider state,
    required this.ref,
  }) : super(state) {
    fetch();
  }

  final StateNotifierProviderRef<EditScreenViewModel, ImageProvider<Object>>
      ref;
  TextEditingController controller = TextEditingController();
  Account myAccount = Authentication.myAccount!;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  File? image;

  Loading get loading => ref.read(loadingProvider.notifier);

  void fetch() {
    nameController = TextEditingController(text: myAccount.name);
    userIdController = TextEditingController(text: myAccount.userId);
    selfIntroductionController =
        TextEditingController(text: myAccount.selfIntroduction);
    state = NetworkImage(myAccount.imagePath);
  }

  Future<void> update(BuildContext context, WidgetRef ref) async {
    final l10n = L10n.of(context)!;
    loading.isLoading = true;
    if (nameController.text.isNotEmpty &&
        userIdController.text.isNotEmpty &&
        selfIntroductionController.text.isNotEmpty) {
      var imagePath = '';
      if (image == null) {
        imagePath = myAccount.imagePath;
      } else {
        final result = await FunctionUtils.uploadImage(myAccount.id, image!);
        imagePath = result;
      }
      final updateAccount = Account(
        id: myAccount.id,
        name: nameController.text,
        userId: userIdController.text,
        selfIntroduction: selfIntroductionController.text,
        imagePath: imagePath,
      );
      Authentication.myAccount = updateAccount;
      final result = await ref
          .read(userFirestoreUsecaseProvider)
          .updateUser(updateAccount);
      if (result == true) {
        if (!mounted) {
          return;
        }
        loading.isLoading = false;
        Navigator.pop(context, true);
      }
    }
    loading.isLoading = false;
    await Future<void>.delayed(const Duration(seconds: 2)).then((_) {
      SnackBarUtils.snackBar(context, l10n.error_empty_post);
    });
  }

  Future<void> selectImage() async {
    final XFile? result = await FunctionUtils().getImageFromGallery();
    if (result != null) {
      image = File(result.path);
      state = FileImage(File(result.path));
    }
  }

  Future<void> signOut(BuildContext context) async {
    final prefs = await _prefs;
    await prefs.setBool('IS_AUTO_LOGIN', false);
    await Authentication.signOut();
    await Future<void>.delayed(Duration.zero).then((_) {
      while (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      NavigationUtils.loginScreen(context);
    });
  }

  Future<void> delete(BuildContext context, WidgetRef ref) async {
    final prefs = await _prefs;
    await prefs.setBool('IS_AUTO_LOGIN', false);
    await ref.read(userFirestoreUsecaseProvider).deleteUser(myAccount, ref);
    await Future<void>.delayed(Duration.zero).then((_) {
      Authentication.deleteAuth();
      while (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      NavigationUtils.loginScreen(context);
    });
  }
}
