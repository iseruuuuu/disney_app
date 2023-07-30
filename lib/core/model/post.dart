import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    this.id = '',
    this.content = '',
    this.postAccountId = '',
    this.createdTime,
    this.rank = 0,
    this.attractionName = '',
    this.isSpoiler = false,
  });

  String id;
  String content;
  String postAccountId;
  Timestamp? createdTime;
  bool isSpoiler;
  int rank;
  String attractionName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Post &&
        other.id == id &&
        other.content == content &&
        other.postAccountId == postAccountId &&
        other.createdTime == createdTime &&
        other.isSpoiler == isSpoiler &&
        other.rank == rank &&
        other.attractionName == attractionName;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      content.hashCode ^
      postAccountId.hashCode ^
      (createdTime?.hashCode ?? 0) ^
      isSpoiler.hashCode ^
      rank.hashCode ^
      attractionName.hashCode;
}
