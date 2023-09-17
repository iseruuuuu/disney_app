import 'package:disney_app/core/component/app_search_elevated_button.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/gen/l10n.dart';
import 'package:disney_app/screen/search/children/attraction_search_body.dart';
import 'package:disney_app/screen/search/children/rank_search_body.dart';
import 'package:disney_app/screen/search/search_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAccount = AuthenticationService.myAccount!;
    final state = ref.watch(searchScreenProvider);
    final attractionPosts =
        ref.watch(postWithAttractionNameFamily(state.attractionName));
    final rankPosts = ref.watch(postWithRankAttractionNameFamily(state.rank));
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
      body: state.isAttractionSearch
          ? AttractionSearchBody(
              state: state,
              attractionPosts: attractionPosts,
              myAccount: myAccount,
            )
          : RankSearchBody(
              state: state,
              rankPosts: rankPosts,
              myAccount: myAccount,
            ),
    );
  }
}
