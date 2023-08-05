import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<User>()])
class FakeUser {
  Account mockAccount() {
    return Account(
      name: 'test',
      userId: 'test',
      selfIntroduction: 'test',
      imagePath: 'test.png',
      createdTime: Timestamp.now(),
      updateTime: Timestamp.now(),
    );
  }

  List<String> mockIds = ['1', '2', '3'];

  String mockAccountId = 'test';

  Account account1 = Account(
    id: '1',
    name: 'John',
    userId: 'john123',
    selfIntroduction: 'Hello, I am John',
    imagePath: '/path/to/image',
    createdTime: Timestamp.now(),
    updateTime: Timestamp.now(),
  );

  Account account2 = Account(
    id: '2',
    name: 'Jane',
    userId: 'jane123',
    selfIntroduction: 'Hello, I am Jane',
    imagePath: '/path/to/image',
    createdTime: Timestamp.now(),
    updateTime: Timestamp.now(),
  );

  String mockImage =
      'https://quality-start.in/wp-content/uploads/2021/07/flutter-logo-sharing.png';

  final fakeMockIds = <String>['1', '2', '3'];
  final mockData = {
    'name': 'Test Name',
    'user_id': 'Test User Id',
    'self_introduction': 'Hello, this is test.',
    'image_path': '/path/to/image',
    'created_time': Timestamp.now(),
    'updated_time': Timestamp.now(),
  };
}
