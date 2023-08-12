import 'package:disney_app/core/component/app_disney_cell.dart';
import 'package:disney_app/core/component/app_header.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/services/authentication.dart';
import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/screen/account/account_screen_view_model.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAccount = Authentication.myAccount!;
    final state = ref.watch(accountScreenViewModelProvider);
    final posts = ref.watch(postsWithAccountIdFamily(state.myAccount.id));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            AppHeader(
              account: myAccount,
              onTapEdit: () => ref
                  .read(accountScreenViewModelProvider.notifier)
                  .onTapEdit(context),
              isMyAccount: true,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.read(postsWithAccountIdFamily(state.myAccount.id));
                },
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
                            isMaster: false,
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
                    );
                  },
                  error: (error, track) {
                    return GestureDetector(
                      onTap: () {
                        print(error);
                        print(track);
                      },
                      child: Text(error.toString()),
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
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
