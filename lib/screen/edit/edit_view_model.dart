import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/core/usecase/user_usecase.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final editViewModelProvider =
    StateNotifierProvider.autoDispose<EditScreenViewModel, ImageProvider>(
  (ref) {
    final myAccount = AuthenticationService.myAccount!;
    return EditScreenViewModel(
      state: CachedNetworkImageProvider(myAccount.imagePath),
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

  final Ref ref;
  TextEditingController controller = TextEditingController();
  Account myAccount = AuthenticationService.myAccount!;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  File? image;

  Loading get loading => ref.read(loadingProvider.notifier);

  void fetch() {
    nameController = TextEditingController(text: myAccount.name);
    userIdController = TextEditingController(text: myAccount.userId);
    selfIntroductionController =
        TextEditingController(text: myAccount.selfIntroduction);
    state = CachedNetworkImageProvider(myAccount.imagePath);
    twitterController = TextEditingController(text: myAccount.twitter);
    instagramController = TextEditingController(text: myAccount.instagram);
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
        isOfficial: myAccount.isOfficial,
        twitter: myAccount.twitter,
        instagram: myAccount.instagram,
      );
      AuthenticationService.myAccount = updateAccount;
      final result =
          await ref.read(userUsecaseProvider).updateUser(updateAccount);
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

  Future<void> signOut(BuildContext context, WidgetRef ref) async {
    await ref.read(authenticationServiceProvider).signOut();
    final prefs = await _prefs;
    await prefs.setBool('IS_AUTO_LOGIN', false);
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
    await ref.read(userUsecaseProvider).deleteUser(myAccount, ref);
    await Future<void>.delayed(Duration.zero).then((_) {
      ref.read(authenticationServiceProvider).deleteAuth();
      while (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      NavigationUtils.loginScreen(context);
    });
  }

  Future<void> updateSNS(BuildContext context) async {
    final l10n = L10n.of(context)!;
    loading.isLoading = true;
    final updateAccount = Account(
      id: myAccount.id,
      name: nameController.text,
      userId: userIdController.text,
      selfIntroduction: selfIntroductionController.text,
      imagePath: myAccount.imagePath,
      isOfficial: myAccount.isOfficial,
      twitter: twitterController.text,
      instagram: instagramController.text,
    );
    AuthenticationService.myAccount = updateAccount;
    final result =
        await ref.read(userUsecaseProvider).updateUser(updateAccount);
    if (result == true) {
      if (!mounted) {
        return;
      }
      loading.isLoading = false;
      Navigator.pop(context, true);
    } else {
      loading.isLoading = false;
      await Future<void>.delayed(const Duration(seconds: 2)).then((_) {
        SnackBarUtils.snackBar(context, l10n.error_empty_post);
      });
    }
  }
}
