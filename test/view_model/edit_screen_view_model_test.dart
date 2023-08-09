import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/usecase/user_usecase.dart';
import 'package:disney_app/screen/edit/edit_screen_view_model.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_screen_view_model_test.mocks.dart';

@GenerateMocks([
  Account,
  BuildContext,
  WidgetRef,
  UserUsecase,
  FunctionUtils,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('EditScreenViewModel', () {
    late EditScreenViewModel viewModel;
    late MockAccount mockAccount;
    late MockFunctionUtils mockFunctionUtils;

    setUpAll(() {
      const channel = MethodChannel('plugins.flutter.io/image_picker');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'pickImage') {
          return 'dummy_path';
        }
        return null;
      });

      const sharedPreferencesChannel =
          MethodChannel('plugins.flutter.io/shared_preferences');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(sharedPreferencesChannel,
              (MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, dynamic>{};
        }
        return null;
      });
    });

    setUp(() {
      mockAccount = MockAccount();
      mockFunctionUtils = MockFunctionUtils();
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

    test('fetch ', () {
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

    test('select image', () async {
      final file = XFile('dummy_path');
      when(mockFunctionUtils.getImageFromGallery())
          .thenAnswer((_) async => file);
      await viewModel.selectImage();
      expect(viewModel.image!.path, equals('dummy_path'));
    });
  });
}
