import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/component/app_disney_cell.dart';
import 'package:disney_app/core/component/app_empty_screen.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/model/usecase/post_firestore_usecase.dart';
import 'package:disney_app/core/model/usecase/user_firestore_usecase.dart';
import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/gen/assets.gen.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeLineScreen extends ConsumerWidget {
  const TimeLineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Account myAccount = Authentication.myAccount!;
    bool isMaster = false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          Assets.images.empty.path,
          fit: BoxFit.fill,
          width: 50,
          height: 50,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.read(postUsecaseProvider).stream(),
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
              future: ref
                  .read(userFirestoreUsecaseProvider)
                  .getPostUserMap(postAccountIds),
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
        backgroundColor: AppColorStyle.appColor,
        onPressed: () {
          NavigationUtils.postScreen(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
