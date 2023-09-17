import 'package:disney_app/core/component/app_attraction.dart';
import 'package:disney_app/core/component/app_disney_cell.dart';
import 'package:disney_app/core/component/app_error_screen.dart';
import 'package:disney_app/core/component/app_no_search_screen.dart';
import 'package:disney_app/core/component/app_skeletons_loading.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/repository/user_repository.dart';
import 'package:disney_app/core/theme/app_text_style.dart';
import 'package:disney_app/screen/search/search_screen_state.dart';
import 'package:disney_app/screen/search/search_screen_view_model.dart';
import 'package:disney_app/utils/log.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AttractionSearchBody extends StatelessWidget {
  const AttractionSearchBody({
    super.key,
    required this.ref,
    required this.state,
    required this.attractionPosts,
    required this.myAccount,
  });

  final WidgetRef ref;
  final SearchScreenState state;
  final AsyncValue<List<Post>> attractionPosts;
  final Account myAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: AppAttraction(
            onTap: () =>
                ref.read(searchScreenProvider.notifier).pickAttraction(context),
            attractionName: state.attractionName,
            isSelected: true,
            style: AppTextStyle.appBoldBlack16TextStyle,
          ),
        ),
        Expanded(
          child: EasyRefresh(
            onRefresh: () async => ref.read(
              postWithAttractionNameFamily(state.attractionName),
            ),
            child: attractionPosts.when(
              data: (post) {
                return post.isNotEmpty
                    ? ListView.builder(
                        itemCount: post.length,
                        itemBuilder: (context, index) {
                          final users =
                              ref.watch(usersFamily(post[index].postAccountId));
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
    );
  }
}
