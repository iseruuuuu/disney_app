import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    this.id = '',
    this.content = '',
    this.postAccountId = '',
    this.postId = '',
    this.createdTime,
    this.rank = 0.0,
    this.attractionName = '',
    this.isSpoiler = false,
    this.heart = 0,
    this.superGood = 0,
  });

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      content: map['content'],
      postAccountId: map['post_account_id'],
      postId: map['post_id'],
      createdTime: map['created_time'],
      rank: map['rank'],
      attractionName: map['attraction_name'],
      isSpoiler: map['is_spoiler'],
      heart: map['heart'],
      superGood: map['super_good'],
    );
  }

  String id;
  String content;
  String postAccountId;
  String postId;
  Timestamp? createdTime;
  bool isSpoiler;
  double rank;
  String attractionName;
  int heart;
  int superGood;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Post &&
        other.id == id &&
        other.content == content &&
        other.postAccountId == postAccountId &&
        other.postId == postId &&
        other.createdTime == createdTime &&
        other.isSpoiler == isSpoiler &&
        other.rank == rank &&
        other.attractionName == attractionName &&
        other.heart == heart &&
        other.superGood == superGood;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      content.hashCode ^
      postAccountId.hashCode ^
      postId.hashCode ^
      (createdTime?.hashCode ?? 0) ^
      isSpoiler.hashCode ^
      rank.hashCode ^
      attractionName.hashCode ^
      heart.hashCode ^
      superGood.hashCode;

  Post fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      content: map['content'],
      postAccountId: map['post_account_id'],
      postId: map['post_id'],
      createdTime: map['created_time'],
      rank: map['rank'],
      attractionName: map['attraction_name'],
      isSpoiler: map['is_spoiler'],
      heart: map['heart'],
      superGood: map['super_good'],
    );
  }
}
