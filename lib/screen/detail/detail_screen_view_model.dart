import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/model/usecase/post_usecase.dart';
import 'package:disney_app/l10n/l10n.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final detailScreenViewModelProvider =
    ChangeNotifierProvider.autoDispose<DetailScreenViewModel>(
  (ref) {
    return DetailScreenViewModel();
  },
);

class DetailScreenViewModel extends ChangeNotifier {
  DetailScreenViewModel();

  void openCheckDialog(
    BuildContext context,
    String accountId,
    Post newPost,
    WidgetRef ref,
  ) {
    final l10n = L10n.of(context)!;
    FunctionUtils.openDialog(
      context: context,
      title: l10n.dialog_delete_check_title,
      content: l10n.dialog_delete_check_content,
      onTap: () {
        deletePosts(context, accountId, newPost, ref);
      },
    );
  }

  Future<void> deletePosts(
    BuildContext context,
    String accountId,
    Post newPost,
    WidgetRef ref,
  ) async {
    final navigator = Navigator.of(context);
    await ref.read(postUsecaseProvider).deletePost(accountId, newPost);
    navigator.pop();
  }
}
