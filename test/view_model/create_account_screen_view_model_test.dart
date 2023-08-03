import 'dart:io';

import 'package:disney_app/screen/create_account/create_account_screen_view_model.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_account_screen_view_model_test.mocks.dart';

class MockRef extends Mock
    implements StateNotifierProviderRef<CreateAccountScreenViewModel, File?> {}

@GenerateMocks([
  FunctionUtils,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('create account screen view model test', () {
    late CreateAccountScreenViewModel viewModel;
    late MockRef ref;
    late MockFunctionUtils mockFunctionUtils;
    setUp(() {
      mockFunctionUtils = MockFunctionUtils();
      ref = MockRef();
      viewModel = CreateAccountScreenViewModel(mockFunctionUtils, null, ref);
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
