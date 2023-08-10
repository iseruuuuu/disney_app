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

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      content: map['content'],
      postAccountId: map['post_account_id'],
      createdTime: map['created_time'],
      rank: map['rank'],
      attractionName: map['attraction_name'],
      isSpoiler: map['is_spoiler'],
    );
  }

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

  Post fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      content: map['content'],
      postAccountId: map['post_account_id'],
      createdTime: map['created_time'],
      rank: map['rank'],
      attractionName: map['attraction_name'],
      isSpoiler: map['is_spoiler'],
    );
  }
}
