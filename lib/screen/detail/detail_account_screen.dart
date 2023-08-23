import 'package:disney_app/core/component/app_skeletons_loading.dart';
import 'package:disney_app/core/component/component.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/provider/launch_url_provider.dart';
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
            onTapTwitter: () => ref
                .read(launchUrlProvider)
                .openTwitter(context, postAccount.twitter),
            onTapInstagram: () => ref
                .read(launchUrlProvider)
                .openInstagram(context, postAccount.instagram),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.read(
                postsWithAccountIdFamily(postAccount.id),
              ),
              child: posts.when(
                data: (data) {
                  return data.isNotEmpty
                      ? ListView.builder(
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
                        )
                      : const AppEmptyScreen();
                },
                error: (error, track) => AppErrorScreen(
                  onPressed: () => ref.read(
                    postsWithAccountIdFamily(postAccount.id),
                  ),
                ),
                loading: AppSkeletonsLoading.new,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
