import 'dart:convert';
import 'package:disney_app/core/constants/attraction.dart';
import 'package:disney_app/core/constants/rank.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/theme/app_text_style.dart';
import 'package:disney_app/gen/l10n.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/screen/search/search_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchScreenProvider =
    StateNotifierProvider<SearchScreenViewModel, SearchScreenState>(
  (ref) {
    return SearchScreenViewModel(
      const SearchScreenState(),
      ref,
    );
  },
);

class SearchScreenViewModel extends StateNotifier<SearchScreenState> {
  SearchScreenViewModel(
    super._state,
    this.ref,
  );

  final Ref ref;

  Loading get loading => ref.read(loadingProvider.notifier);

  final List<dynamic>? attractionData = const JsonDecoder().convert(attraction);
  final List<dynamic>? rankData = const JsonDecoder().convert(rank);

  void pickAttraction(BuildContext context) {
    final l10n = L10n.of(context)!;
    Picker(
      confirmText: l10n.confirm,
      confirmTextStyle: AppTextStyle.appBoldBlue15TextStyle,
      cancelText: l10n.cancel,
      cancelTextStyle: AppTextStyle.appBoldRed15TextStyle,
      adapter: PickerDataAdapter<String>(pickerData: attractionData),
      changeToFirst: true,
      height: MediaQuery.sizeOf(context).height / 2.5,
      textStyle: const TextStyle(fontSize: 15, color: Colors.black),
      onConfirm: (Picker picker, List<dynamic> value) {
        final attractionName =
            picker.adapter.text.replaceAll(RegExp(r'[\[\]]'), '');
        state = state.copyWith(attractionName: attractionName);
        ref.read(postWithAttractionNameFamily(state.attractionName));
      },
    ).showModal<void>(context);
  }

  void pickRank(BuildContext context) {
    final l10n = L10n.of(context)!;
    Picker(
      confirmText: l10n.confirm,
      confirmTextStyle: AppTextStyle.appBoldBlue15TextStyle,
      cancelText: l10n.cancel,
      cancelTextStyle: AppTextStyle.appBoldRed15TextStyle,
      adapter: PickerDataAdapter<String>(pickerData: rankData),
      changeToFirst: true,
      height: MediaQuery.sizeOf(context).height / 2.5,
      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
      onConfirm: (Picker picker, List<dynamic> value) {
        final rank = picker.adapter.text.replaceAll(RegExp(r'[\[\]]'), '');
        state = state.copyWith(rank: double.parse(rank));
        ref.read(postWithRankAttractionNameFamily(state.rank));
      },
    ).showModal<void>(context);
  }

  void changeSearch({required bool isAttractionSearch}) {
    state = state.copyWith(
      isAttractionSearch: isAttractionSearch,
      attractionName: 'アクアトピア',
      rank: 5,
    );
  }
}
