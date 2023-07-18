import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String content;
  String postAccountId;
  Timestamp? createdTime;

  int rank;
  String attractionName;

  Post({
    this.id = '',
    this.content = '',
    this.postAccountId = '',
    this.createdTime,

    this.rank = 0,
    this.attractionName = '',
  });
}
