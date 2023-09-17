import 'package:disney_app/core/component/app_skeletons_loading.dart';
import 'package:disney_app/core/component/component.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/repository/user_repository.dart';
import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/provider/launch_url_provider.dart';
import 'package:disney_app/screen/account/account_screen_view_model.dart';
import 'package:disney_app/utils/log.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAccount = AuthenticationService.myAccount!;
    final state = ref.watch(accountScreenViewModelProvider);
    final posts = ref.watch(postsWithAccountIdFamily(state.myAccount.id));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            AppHeader(
              account: myAccount,
              onTapEditProfile: () => ref
                  .read(accountScreenViewModelProvider.notifier)
                  .onTapEdit(context),
              onTapEditSNS: () => ref
                  .read(accountScreenViewModelProvider.notifier)
                  .onTapSNS(context),
              onTapTwitter: () => ref
                  .read(launchUrlProvider)
                  .openTwitter(context, state.myAccount.twitter),
              onTapInstagram: () => ref
                  .read(launchUrlProvider)
                  .openInstagram(context, state.myAccount.instagram),
              isMyAccount: true,
              isHasTwitter: myAccount.twitter.isNotEmpty,
              isHasInstagram: myAccount.instagram.isNotEmpty,
            ),
            Expanded(
              child: EasyRefresh(
                onRefresh: () async => ref.read(
                  postsWithAccountIdFamily(state.myAccount.id),
                ),
                child: posts.when(
                  data: (data) {
                    return data.isNotEmpty
                        ? ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final post = data[index];
                              final users =
                                  ref.watch(usersFamily(post.postAccountId));
                              return users.when(
                                data: (data) {
                                  return GestureDetector(
                                    onTap: () {
                                      NavigationUtils.detailScreen(
                                        context,
                                        myAccount,
                                        post,
                                        myAccount.id,
                                      );
                                    },
                                    child: AppDisneyCell(
                                      index: index,
                                      account: myAccount,
                                      post: post,
                                      myAccount: myAccount.id,
                                      onTapImage: () {
                                        NavigationUtils.detailAccountScreen(
                                          context,
                                          myAccount,
                                          post,
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
                                loading: AppSkeletonsCellLoading.new,
                              );
                            },
                          )
                        : const AppEmptyScreen();
                  },
                  error: (error, track) {
                    Log.e(error);
                    return AppErrorScreen(
                      onPressed: () => ref.read(
                        postsWithAccountIdFamily(state.myAccount.id),
                      ),
                    );
                  },
                  loading: AppSkeletonsLoading.new,
                ),
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
