import 'dart:convert';

import 'package:disney_app/core/constants/attraction.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/core/usecase/post_usecase.dart';
import 'package:disney_app/l10n/l10n.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/screen/post/post_screen_state.dart';
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
  final Ref ref;

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
    final l10n = L10n.of(context)!;
    loading.isLoading = true;
    if (controller.text.isNotEmpty && state.attractionName != '') {
      final newPost = Post(
        content: controller.text,
        postAccountId: AuthenticationService.myAccount!.id,
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
      SnackBarUtils.snackBar(context, l10n.error_empty_post);
    }
  }

  void onChanged({required bool value}) {
    state = state.copyWith(
      isSpoiler: value,
    );
  }
}
