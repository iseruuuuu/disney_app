import 'package:disney_app/core/firebase/firebase.dart';
import 'package:disney_app/core/firebase/firebase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userSnapShotsFamily =
    FutureProvider.autoDispose.family<DocumentSnapshot<Object?>, String>(
  (ref, uid) {
    final users = ref.watch(firebaseFirestoreProvider).collection('users');
    return users.doc(uid).get();
  },
);

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(ref);
});

class UserService {
  UserService(ProviderRef<UserService> ref) {
    firebaseStore = ref.read(firebaseFirestoreProvider);
    firebaseStorage = ref.read(firebaseStorageProvider);
    users = firebaseStore.collection('users');
  }

  late final FirebaseFirestore firebaseStore;
  late final FirebaseStorage firebaseStorage;
  late final CollectionReference users;

  Future<DocumentSnapshot<Object?>> getUserDocument(String uid) {
    return users.doc(uid).get();
  }

  Future<void> setUserDocument(String id, Map<String, dynamic> data) {
    return users.doc(id).set(data);
  }

  Future<void> updateUserDocument(String id, Map<String, dynamic> data) {
    return users.doc(id).update(data);
  }

  Future<void> deleteUserDocument(String id) {
    return users.doc(id).delete();
  }

  Reference getStorageReference(String filePath) {
    return firebaseStorage.ref(filePath);
  }

  Reference refFromURL(String filePath) {
    return FirebaseStorage.instance.refFromURL(filePath);
  }
}
