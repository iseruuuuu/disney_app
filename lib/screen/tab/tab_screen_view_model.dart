import 'package:disney_app/screen/account/account_screen.dart';
import 'package:disney_app/screen/search/search_screen.dart';
import 'package:disney_app/screen/tab/tab_screen_state.dart';
import 'package:disney_app/screen/time_line/time_line_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabScreenViewModelProvider =
    StateNotifierProvider<TabScreenViewModel, TabScreenState>(
  (ref) {
    return TabScreenViewModel(
      state: const TabScreenState(),
    );
  },
);

class TabScreenViewModel extends StateNotifier<TabScreenState> {
  TabScreenViewModel({required TabScreenState state}) : super(state);

  List<Widget> pageList = [
    const TimeLineScreen(),
    const SearchScreen(),
    const AccountScreen(),
  ];

  void onTap(int index) {
    state = state.copyWith(
      selectedIndex: index,
    );
  }
}
