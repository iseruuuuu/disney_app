import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/component/app_disney_cell.dart';
import 'package:disney_app/core/component/app_empty_screen.dart';
import 'package:disney_app/core/component/app_header.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/model/usecase/post_firestore_usecase.dart';
import 'package:disney_app/core/model/usecase/user_firestore_usecase.dart';
import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/screen/account/account_screen_view_model.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountScreenViewModelProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            AppHeader(
              account: state.myAccount,
              onTapEdit: () => ref
                  .read(accountScreenViewModelProvider.notifier)
                  .onTapEdit(context),
              isMyAccount: true,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: ref
                    .read(userFirestoreUsecaseProvider)
                    .stream(state.myAccount.id),
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
                                          state.myAccount,
                                          post,
                                          state.myAccount.id,
                                        );
                                      },
                                      child: AppDisneyCell(
                                        index: index,
                                        account: state.myAccount,
                                        post: post,
                                        myAccount: state.myAccount.id,
                                        isMaster: false,
                                        onTapImage: () {
                                          NavigationUtils.detailAccountScreen(
                                            context,
                                            state.myAccount,
                                            post,
                                            state.myAccount.id,
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
