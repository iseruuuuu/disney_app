import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:disney_app/core/component/app_app_bar.dart';
import 'package:disney_app/core/component/app_disney_cell.dart';
import 'package:disney_app/core/component/app_empty_screen.dart';
import 'package:disney_app/core/component/app_header.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/model/usecase/post_firestore_usecase.dart';
import 'package:disney_app/core/model/usecase/user_firestore_usecase.dart';
import 'package:disney_app/gen/assets.gen.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/navigation_utils.dart';

class DetailAccountScreen extends ConsumerWidget {
  const DetailAccountScreen({
    super.key,
    required this.postAccount,
    required this.post,
  });

  final Account postAccount;
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Account myAccount = Authentication.myAccount!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppAppBar(
          image: Assets.header.detailAccountHeader.path,
          text: const SizedBox.shrink(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          AppHeader(
            account: postAccount,
            isMyAccount: false,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  ref.read(userFirestoreUsecaseProvider).stream(postAccount.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> myPostIds =
                      List.generate(snapshot.data!.docs.length, (index) {
                    return snapshot.data!.docs[index].id;
                  });
                  return FutureBuilder<List<Post>?>(
                    future: ref
                        .read(postUsecaseProvider)
                        .getPostsFromIds(myPostIds),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return (snapshot.data!.isNotEmpty)
                            ? ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  Post post = snapshot.data![index];
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
                                      isMaster: false,
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
                            : const AppEmptyScreen();
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
          ),
        ],
      ),
    );
  }
}
