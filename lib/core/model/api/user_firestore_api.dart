import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserFirestoreAPI {
  UserFirestoreAPI()
      : firebaseStoreInstance = FirebaseFirestore.instance,
        storage = FirebaseStorage.instance {
    users = firebaseStoreInstance.collection('users');
  }

  final FirebaseFirestore firebaseStoreInstance;
  final FirebaseStorage storage;

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

  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String uid) {
    return users
        .doc(uid)
        .collection('my_posts')
        .orderBy('created_time', descending: true)
        .snapshots();
  }

  Reference getStorageReference(String filePath) {
    return storage.ref(filePath);
  }

  Reference refFromURL(String filePath) {
    return FirebaseStorage.instance.refFromURL(filePath);
  }
}
