import 'package:disney_app/core/services/authentication.dart';
import 'package:disney_app/screen/account/account_screen_state.dart';
import 'package:disney_app/screen/edit/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountScreenViewModelProvider = StateNotifierProvider.autoDispose<
    AccountScreenViewModel, AccountScreenState>(
  (ref) {
    final myAccount = Authentication.myAccount!;
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

  AccountScreenState get currentState => state;

  void fetch() {
    final myAccount = Authentication.myAccount!;
    state = state.copyWith(myAccount: myAccount);
  }

  Future<void> onTapEdit(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
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
