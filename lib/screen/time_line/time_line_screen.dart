import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/component/app_disney_cell.dart';
import 'package:disney_app/component/app_empty_screen.dart';
import 'package:disney_app/constants/color_constants.dart';
import 'package:disney_app/model/account.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';

class TimeLineScreen extends StatefulWidget {
  const TimeLineScreen({Key? key}) : super(key: key);

  @override
  State<TimeLineScreen> createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  Account myAccount = Authentication.myAccount!;
  bool isMaster = false;

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
                  return (postSnapshot.data!.docs.isNotEmpty)
                      ? ListView.builder(
                          itemCount: postSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            isMaster = FunctionUtils()
                                .checkMasterAccount(myAccount.id);
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
                            return GestureDetector(
                              onTap: () {
                                NavigationUtils.detailScreen(
                                  context,
                                  postAccount,
                                  post,
                                  myAccount.id,
                                );
                              },
                              child: AppDisneyCell(
                                index: index,
                                account: postAccount,
                                post: post,
                                myAccount: myAccount.id,
                                isMaster: isMaster,
                                onTapImage: () {
                                  NavigationUtils.detailAccountScreen(
                                    context,
                                    postAccount,
                                    post,
                                    myAccount.id,
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : const Center(child: AppEmptyScreen());
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.appColor,
        onPressed: () {
          NavigationUtils.postScreen(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
