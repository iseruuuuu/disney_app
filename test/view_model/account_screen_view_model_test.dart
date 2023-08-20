import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/screen/account/account_screen_state.dart';
import 'package:disney_app/screen/account/account_screen_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AccountScreenViewModel viewModel;

  setUp(() {
    AuthenticationService.myAccount = Account();
    viewModel = AccountScreenViewModel(
      state: AccountScreenState(
        myAccount: AuthenticationService.myAccount!,
      ),
    );
  });
  tearDown(() {
    AuthenticationService.myAccount = null;
  });

  test('fetch', () {
    viewModel.fetch();
    expect(viewModel.currentState.myAccount, AuthenticationService.myAccount);
  });
}
