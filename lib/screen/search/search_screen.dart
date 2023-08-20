import 'package:disney_app/core/component/app_no_search_screen.dart';
import 'package:disney_app/core/component/component.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/repository/user_repository.dart';
import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/screen/search/search_screen_view_model.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAccount = AuthenticationService.myAccount!;
    final state = ref.watch(searchScreenProvider);
    final posts = ref.watch(postWithAttractionNameFamily(state.attractionName));
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
            child: RefreshIndicator(
              onRefresh: () async => ref.read(
                postWithAttractionNameFamily(state.attractionName),
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
                              error: (error, track) => const SizedBox(),
                              loading: SizedBox.new,
                            );
                          },
                        )
                      : const AppNoSearchScreen();
                },
                error: (error, track) => AppErrorScreen(
                  onPressed: () => ref.read(
                    postWithAttractionNameFamily(state.attractionName),
                  ),
                ),
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
    );
  }
}
