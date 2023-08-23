import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/screen/account/account_screen_state.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountScreenViewModelProvider = StateNotifierProvider.autoDispose<
    AccountScreenViewModel, AccountScreenState>(
  (ref) {
    final myAccount = AuthenticationService.myAccount!;
    return AccountScreenViewModel(
      state: AccountScreenState(myAccount: myAccount),
    );
  },
);

class AccountScreenViewModel extends StateNotifier<AccountScreenState> {
  AccountScreenViewModel({required AccountScreenState state}) : super(state) {
    fetch();
  }

  AccountScreenState get currentState => state;

  void fetch() {
    final myAccount = AuthenticationService.myAccount!;
    state = state.copyWith(myAccount: myAccount);
  }

  Future<void> onTapEdit(BuildContext context) async {
    final result = await NavigationUtils.editScreen(context);
    if (result == true) {
      state = state.copyWith(
        myAccount: AuthenticationService.myAccount!,
      );
    }
  }

  Future<void> onTapSNS(BuildContext context) async {
    final result = await NavigationUtils.snsEditScreen(context);
    if (result == true) {
      state = state.copyWith(
        myAccount: AuthenticationService.myAccount!,
      );
    }
  }
}
