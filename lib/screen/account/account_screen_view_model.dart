import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/screen/account/account_screen_state.dart';
import 'package:disney_app/screen/edit/edit_screen.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountScreenViewModelProvider = StateNotifierProvider.autoDispose<
    AccountScreenViewModel, AccountScreenState>(
  (ref) {
    var myAccount = Authentication.myAccount!;
    return AccountScreenViewModel(
      state: AccountScreenState(
        myAccount: myAccount,
      ),
    );
  },
);

class AccountScreenViewModel extends StateNotifier<AccountScreenState> {
  AccountScreenViewModel({required AccountScreenState state}) : super(state) {
    fetch();
  }

  void fetch() {
    final Account myAccount = Authentication.myAccount!;
    state = state.copyWith(myAccount: myAccount);
  }

  void onTapEdit(BuildContext context) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditScreen(),
      ),
    );
    if (result == true) {
      state = state.copyWith(
        myAccount: Authentication.myAccount!,
      );
    }
  }
}
