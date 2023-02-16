import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/component/disney_cell.dart';
import 'package:disney_app/component/empty_screen.dart';
import 'package:disney_app/model/account.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/screen/detail/component/detail_account_container.dart';
import 'package:disney_app/screen/detail/component/detail_account_header.dart';
import 'package:disney_app/screen/detail/detail_screen.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:flutter/material.dart';

class DetailAccountScreen extends StatelessWidget {
  const DetailAccountScreen({
    Key? key,
    required this.account,
    required this.post,
  }) : super(key: key);

  final Account account;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          DetailAccountHeader(account: account),
          const DetailAccountContainer(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: UserFireStore.users
                  .doc(account.id)
                  .collection('my_posts')
                  .orderBy(
                    'created_time',
                    descending: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> myPostIds =
                      List.generate(snapshot.data!.docs.length, (index) {
                    return snapshot.data!.docs[index].id;
                  });
                  return FutureBuilder<List<Post>?>(
                    future: PostFirestore.getPostsFromIds(myPostIds),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return (snapshot.data!.isNotEmpty)
                            ? ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  Post post = snapshot.data![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                            account: account,
                                            post: post,
                                            myAccount: account.id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: DisneyCell(
                                      index: index,
                                      account: account,
                                      post: post,
                                      myAccount: account.id,
                                      onTapImage: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailAccountScreen(
                                              account: account,
                                              post: post,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              )
                            : const EmptyScreen();
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
