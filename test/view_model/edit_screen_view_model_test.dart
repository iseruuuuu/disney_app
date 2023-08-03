import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/screen/edit/edit_screen_view_model.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_screen_view_model_test.mocks.dart';

@GenerateMocks([
  Account,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('EditScreenViewModel', () {
    late EditScreenViewModel viewModel;
    late MockAccount mockAccount;

    setUp(() {
      mockAccount = MockAccount();
      when(mockAccount.name).thenReturn('Test Name');
      when(mockAccount.userId).thenReturn('Test UserId');
      when(mockAccount.selfIntroduction).thenReturn('Test Introduction');
      when(mockAccount.imagePath).thenReturn('Test Image Path');
      final container = ProviderContainer(
        overrides: [
          editScreenViewModelProvider.overrideWith(
            (ref) {
              return EditScreenViewModel(
                state: NetworkImage(mockAccount.imagePath),
                ref: ref,
              );
            },
          ),
        ],
      );
      Authentication.myAccount = mockAccount;
      viewModel = EditScreenViewModel(
        state: NetworkImage(mockAccount.imagePath),
        ref: container.read(editScreenViewModelProvider.notifier).ref,
      );
    });

    test('fetch method', () {
      viewModel.fetch();
      expect(viewModel.nameController.text, equals('Test Name'));
      expect(viewModel.userIdController.text, equals('Test UserId'));
      expect(
        viewModel.selfIntroductionController.text,
        equals('Test Introduction'),
      );
      expect(
        viewModel.debugState,
        const NetworkImage('Test Image Path'),
      );
    });
  });
}
