import 'package:disney_app/core/component/app_disney_cell.dart';
import 'package:disney_app/core/component/app_error_screen.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/repository/user_repository.dart';
import 'package:disney_app/core/services/authentication.dart';
import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/gen/assets.gen.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeLineScreen extends ConsumerWidget {
  const TimeLineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAccount = Authentication.myAccount!;
    final isMaster = FunctionUtils().checkMasterAccount(myAccount.id);
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
      body: posts.when(
        data: (data) {
          return ListView.builder(
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
                error: (error, track) => const SizedBox(),
                loading: SizedBox.new,
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
