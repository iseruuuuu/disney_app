import 'dart:convert';

import 'package:disney_app/core/constants/attraction.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/screen/search/search_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchScreenProvider =
    StateNotifierProvider<SearchScreenViewModel, SearchScreenState>((ref) {
  return SearchScreenViewModel(
    const SearchScreenState(),
    ref,
  );
});

class SearchScreenViewModel extends StateNotifier<SearchScreenState> {
  SearchScreenViewModel(
    super._state,
    this.ref,
  );

  final Ref ref;

  Loading get loading => ref.read(loadingProvider.notifier);

  void pickAttraction(BuildContext context) {
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
        );
        ref.read(postWithAttractionNameFamily(state.attractionName));
      },
    ).showModal<void>(context);
  }
}