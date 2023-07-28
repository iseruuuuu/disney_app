import 'dart:convert';

import 'package:disney_app/core/constants/attraction.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/model/usecase/post_firestore_usecase.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/screen/post/post_screen_state.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postScreenViewModelProvider =
    StateNotifierProvider.autoDispose<PostScreenViewModel, PostScreenState>(
  (ref) {
    return PostScreenViewModel(
      const PostScreenState(),
      ref,
    );
  },
);

class PostScreenViewModel extends StateNotifier<PostScreenState> {
  PostScreenViewModel(
    super._state,
    this.ref,
  );

  TextEditingController controller = TextEditingController();
  final AutoDisposeStateNotifierProviderRef<PostScreenViewModel,
      PostScreenState> ref;

  Loading get loading => ref.read(loadingProvider.notifier);

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
      height: 400,
      textStyle: const TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      onConfirm: (Picker picker, List<dynamic> value) {
        final text1 = picker.adapter.text.replaceAll('[', '');
        final result2 = text1.replaceAll(']', '');
        final result3 = result2.replaceAll(' ', '');
        final result4 = result3.split(',');
        state = state.copyWith(
          attractionName: result4[1],
          isSelected: true,
        );
      },
    ).showModal<void>(context);
  }

  Future<void> post(BuildContext context, WidgetRef ref) async {
    loading.isLoading = true;
    if (controller.text.isNotEmpty && state.attractionName != '') {
      final newPost = Post(
        content: controller.text,
        postAccountId: Authentication.myAccount!.id,
        rank: state.rank,
        attractionName: state.attractionName,
        isSpoiler: state.isSpoiler,
      );
      final result = await ref.read(postUsecaseProvider).addPost(newPost);
      if (result == true) {
        await Future<void>.delayed(const Duration(seconds: 2)).then((_) {
          loading.isLoading = false;
          Navigator.pop(context);
        });
      }
    } else {
      loading.isLoading = false;
      SnackBarUtils.snackBar(context, 'いずれかの値が未記入となっています');
    }
  }

  void onChanged({required bool value}) {
    state = state.copyWith(
      isSpoiler: value,
    );
  }
}
