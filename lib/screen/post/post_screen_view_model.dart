import 'dart:convert';
import 'package:disney_app/core/constants/attraction.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/screen/post/post_screen_state.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postScreenViewModelProvider =
    StateNotifierProvider.autoDispose<PostScreenViewModel, PostScreenState>(
  (ref) {
    return PostScreenViewModel(
      state: const PostScreenState(
        rank: 0,
        attractionName: '',
        isSelected: false,
      ),
    );
  },
);

class PostScreenViewModel extends StateNotifier<PostScreenState> {
  PostScreenViewModel({required PostScreenState state}) : super(state);
  TextEditingController controller = TextEditingController();

  void rankPicker(double rating) {
    state = state.copyWith(
      rank: rating.round(),
    );
  }

  void attractionPicker(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter<String>(
        pickerData: const JsonDecoder().convert(attraction),
      ),
      changeToFirst: true,
      hideHeader: false,
      height: 400,
      textStyle: const TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      onConfirm: (Picker picker, List value) {
        var text1 = picker.adapter.text.replaceAll('[', '');
        var result2 = text1.replaceAll(']', '');
        var result3 = result2.replaceAll(' ', '');
        List<String> result4 = result3.split(',');
        state = state.copyWith(
          attractionName: result4[1],
          isSelected: true,
        );
      },
    ).showModal(context);
  }

  void post(BuildContext context) async {
    if (controller.text.isNotEmpty && state.attractionName != '') {
      Post newPost = Post(
        content: controller.text,
        postAccountId: Authentication.myAccount!.id,
        rank: state.rank,
        attractionName: state.attractionName,
      );
      var result = await PostFirestore.addPost(newPost);
      if (result == true) {
        Future.delayed(const Duration(seconds: 1)).then((_) {
          Navigator.pop(context);
        });
      }
    } else {
      SnackBarUtils.snackBar(context, 'いずれかの値が未記入となっています');
    }
  }
}
