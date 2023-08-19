import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  Account({
    this.id = '',
    this.name = '',
    this.imagePath = '',
    this.selfIntroduction = '',
    this.userId = '',
    this.createdTime,
    this.updateTime,
  });

  factory Account.fromMap(Map<String, dynamic> data, String uid) {
    return Account(
      id: uid,
      name: data['name'],
      userId: data['user_id'],
      selfIntroduction: data['self_introduction'],
      imagePath: data['image_path'],
      createdTime: data['created_time'],
      updateTime: data['updated_time'],
    );
  }

  String id;
  String name;
  String imagePath;
  String selfIntroduction;
  String userId;
  Timestamp? createdTime;
  Timestamp? updateTime;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Account &&
        other.name == name &&
        other.userId == userId &&
        other.selfIntroduction == selfIntroduction &&
        other.imagePath == imagePath &&
        other.createdTime == createdTime &&
        other.updateTime == updateTime;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      userId.hashCode ^
      selfIntroduction.hashCode ^
      imagePath.hashCode ^
      (createdTime?.hashCode ?? 0) ^
      (updateTime?.hashCode ?? 0);
}
