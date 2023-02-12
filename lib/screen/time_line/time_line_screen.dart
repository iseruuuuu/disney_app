import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/model/account.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/screen/post/post_screen.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLineScreen extends StatefulWidget {
  const TimeLineScreen({Key? key}) : super(key: key);

  @override
  State<TimeLineScreen> createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント'),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: PostFirestore.posts
              .orderBy(
                'created_time',
                descending: true,
              )
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
                          );
                          Account postAccount =
                              userSnapshot.data![post.postAccountId]!;
                          return Container(
                            decoration: BoxDecoration(
                              border: index == 0
                                  ? const Border(
                                      top: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    )
                                  : const Border(
                                      bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  foregroundImage:
                                      NetworkImage(postAccount.imagePath),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(postAccount.name),
                                        Text(postAccount.userId),
                                        Text(
                                          DateFormat('yyyy/MM/dd').format(
                                            post.createdTime!.toDate(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(post.content),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  });
            } else {
              return Container();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostScreen(),
            ),
          );
        },
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
