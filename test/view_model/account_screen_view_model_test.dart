import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/screen/account/account_screen_state.dart';
import 'package:disney_app/screen/account/account_screen_view_model.dart';
import 'package:disney_app/core/services/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AccountScreenViewModel viewModel;

  setUp(() {
    Authentication.myAccount = Account();
    viewModel = AccountScreenViewModel(
      state: AccountScreenState(
        myAccount: Authentication.myAccount!,
      ),
    );
  });
  tearDown(() {
    Authentication.myAccount = null;
  });

  test('fetch', () {
    viewModel.fetch();
    expect(viewModel.currentState.myAccount, Authentication.myAccount);
  });
}
