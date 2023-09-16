import 'package:disney_app/core/component/app_skeletons_loading.dart';
import 'package:disney_app/core/component/component.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/repository/user_repository.dart';
import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/utils/log.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeLineScreen extends ConsumerWidget {
  const TimeLineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAccount = AuthenticationService.myAccount!;
    final posts = ref.watch(postsProvider);
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
      body: EasyRefresh(
        onRefresh: () async => ref.read(postsProvider),
        child: posts.when(
          data: (data) {
            return data.isNotEmpty
                ? ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final post = data[index];
                      final users = ref.watch(usersFamily(post.postAccountId));
                      return users.when(
                        data: (data) {
                          final postAccount = data;
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
          error: (error, track) => AppErrorScreen(
            onPressed: () => ref.read(postsProvider),
          ),
          loading: AppSkeletonsLoading.new,
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
