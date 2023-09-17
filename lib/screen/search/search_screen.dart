import 'package:disney_app/core/component/app_no_search_screen.dart';
import 'package:disney_app/core/component/app_search_elevated_button.dart';
import 'package:disney_app/core/component/app_skeletons_loading.dart';
import 'package:disney_app/core/component/component.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/repository/user_repository.dart';
import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/gen/l10n.dart';
import 'package:disney_app/screen/search/search_screen_view_model.dart';
import 'package:disney_app/utils/log.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAccount = AuthenticationService.myAccount!;
    final state = ref.watch(searchScreenProvider);
    final posts = ref.watch(postWithAttractionNameFamily(state.attractionName));
    final l10n = L10n.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSearchElevatedButton(
              onTap: state.isAttractionSearch
                  ? null
                  : () => ref
                      .read(searchScreenProvider.notifier)
                      .changeSearch(isAttractionSearch: true),
              title: l10n.search_attraction,
            ),
            AppSearchElevatedButton(
              onTap: state.isAttractionSearch
                  ? () => ref
                      .read(searchScreenProvider.notifier)
                      .changeSearch(isAttractionSearch: false)
                  : null,
              title: l10n.search_star,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: AppAttraction(
              onTap: () => ref
                  .read(searchScreenProvider.notifier)
                  .pickAttraction(context),
              attractionName: state.attractionName,
              isSelected: true,
            ),
          ),
          Expanded(
            child: EasyRefresh(
              onRefresh: () async => ref.read(
                postWithAttractionNameFamily(state.attractionName),
              ),
              child: posts.when(
                data: (post) {
                  return post.isNotEmpty
                      ? ListView.builder(
                          itemCount: post.length,
                          itemBuilder: (context, index) {
                            final users = ref
                                .watch(usersFamily(post[index].postAccountId));
                            return users.when(
                              data: (postAccount) {
                                return GestureDetector(
                                  onTap: () {
                                    NavigationUtils.detailScreen(
                                      context,
                                      postAccount,
                                      post[index],
                                      myAccount.id,
                                    );
                                  },
                                  child: AppDisneyCell(
                                    index: index,
                                    account: postAccount,
                                    post: post[index],
                                    myAccount: myAccount.id,
                                    onTapImage: () {
                                      NavigationUtils.detailAccountScreen(
                                        context,
                                        postAccount,
                                        post[index],
                                        myAccount.id,
                                      );
                                    },
                                  ),
                                );
                              },
                              error: (error, track) {
                                Log.e(error);
                                return const SizedBox();
                              },
                              loading: AppSkeletonsLoading.new,
                            );
                          },
                        )
                      : const AppNoSearchScreen();
                },
                error: (error, track) {
                  Log.e(error);
                  return AppErrorScreen(
                    onPressed: () => ref.read(
                      postWithAttractionNameFamily(state.attractionName),
                    ),
                  );
                },
                loading: AppSkeletonsLoading.new,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
