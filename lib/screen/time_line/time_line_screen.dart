import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/model/account.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/screen/post/post_screen.dart';
import 'package:disney_app/screen/time_line/component/empty_time_line_screen.dart';
import 'package:disney_app/screen/time_line/component/time_line_cell.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:flutter/material.dart';

class TimeLineScreen extends StatefulWidget {
  const TimeLineScreen({Key? key}) : super(key: key);

  @override
  State<TimeLineScreen> createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: PostFirestore.posts
            .orderBy('created_time', descending: true)
            .snapshots(),
        builder: (context, postSnapshot) {
          if (postSnapshot.hasData) {
            List<String> postAccountIds = [];
            for (var doc in postSnapshot.data!.docs) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              if (!postAccountIds.contains(data['post_account_id'])) {
                postAccountIds.add(data['post_account_id']);
              }
            }
            return FutureBuilder<Map<String, Account>?>(
                future: UserFireStore.getPostUserMap(postAccountIds),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasData &&
                      userSnapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: postSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data =
                            postSnapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        Post post = Post(
                          id: postSnapshot.data!.docs[index].id,
                          content: data['content'],
                          postAccountId: data['post_account_id'],
                          createdTime: data['created_time'],
                          rank: data['rank'],
                          attractionName: data['attraction_name'],
                        );
                        Account postAccount =
                            userSnapshot.data![post.postAccountId]!;
                        return TimeLineCell(
                          index: index,
                          postAccount: postAccount,
                          post: post,
                        );
                      },
                    );
                  } else {
                    return const EmptyTimeLineScreen();
                  }
                });
          } else {
            return const EmptyTimeLineScreen();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A67AD),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
