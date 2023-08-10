import 'package:disney_app/core/component/app_app_bar.dart';
import 'package:disney_app/core/component/app_disney_cell.dart';
import 'package:disney_app/core/component/app_error_screen.dart';
import 'package:disney_app/core/component/app_header.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/gen/assets.gen.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailAccountScreen extends ConsumerWidget {
  const DetailAccountScreen({
    super.key,
    required this.postAccount,
    required this.post,
    required this.myAccountId,
  });

  final Account postAccount;
  final Post post;
  final String myAccountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsWithAccountIdFamily(postAccount.id));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppAppBar(
          image: Assets.header.detailAccountHeader.path,
          text: const SizedBox.shrink(),
        ),
      ),
      body: Column(
        children: [
          AppHeader(
            account: postAccount,
            isMyAccount: false,
          ),
          Expanded(
            child: posts.when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        NavigationUtils.detailScreen(
                          context,
                          postAccount,
                          data[index],
                          myAccountId,
                        );
                      },
                      child: AppDisneyCell(
                        index: index,
                        account: postAccount,
                        post: data[index],
                        myAccount: myAccountId,
                        isMaster: false,
                        onTapImage: () {
                          NavigationUtils.detailAccountScreen(
                            context,
                            postAccount,
                            data[index],
                            myAccountId,
                          );
                        },
                      ),
                    );
                  },
                );
              },
              error: (error, track) => AppErrorScreen(
                onPressed: () {
                  //TODO リロードできるようにする。
                },
              ),
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
