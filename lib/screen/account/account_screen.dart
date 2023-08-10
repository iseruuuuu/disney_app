import 'package:disney_app/core/component/app_disney_cell.dart';
import 'package:disney_app/core/component/app_error_screen.dart';
import 'package:disney_app/core/component/app_header.dart';
import 'package:disney_app/core/repository/post_repository.dart';
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
    final posts = ref.watch(postsWithAccountIdFamily(state.myAccount.id));
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
              child: posts.when(
                data: (data) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final post = data[index];
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
