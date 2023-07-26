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
}
