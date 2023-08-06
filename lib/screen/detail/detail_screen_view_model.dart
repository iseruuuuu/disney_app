import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/model/usecase/post_firestore_usecase.dart';
import 'package:disney_app/core/theme/app_text_style.dart';
import 'package:disney_app/l10n/l10n.dart';
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
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.dialog_delete_check_title,
            style: AppTextStyle.appBold17TextStyle,
            textAlign: TextAlign.center,
          ),
          content: Text(
            l10n.dialog_contact_contents,
            style: AppTextStyle.app15TextStyle,
            textAlign: TextAlign.center,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextButton(
                child: Text(
                  l10n.dialog_cancel,
                  style: AppTextStyle.cancelTextStyle,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  deletePosts(
                    context,
                    accountId,
                    newPost,
                    ref,
                  );
                },
                child: Text(
                  l10n.dialog_ok,
                  style: AppTextStyle.okTextStyle,
                ),
              ),
            ),
          ],
        );
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
