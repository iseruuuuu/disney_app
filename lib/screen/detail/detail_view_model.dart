import 'dart:io';

import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/usecase/post_usecase.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

final detailViewModelProvider =
    ChangeNotifierProvider.autoDispose<DetailViewModel>(
  (ref) {
    return DetailViewModel();
  },
);

class DetailViewModel extends ChangeNotifier {
  DetailViewModel();

  ScreenshotController screenshotController = ScreenshotController();

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

  void share(Post post) {
    screenshotController.capture().then((capturedImage) async {
      if (capturedImage != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(capturedImage);
        if (Platform.isIOS) {
          //TODO リリースされたら、AppleStoreのリンクを載せる。
          await Share.shareXFiles(
            [XFile(imagePath.path)],
            subject: '${post.attractionName}の評価は${post.rank}点でした!!\n\n'
                '${post.content}\n\n'
                '#TDL_APP',
          );
        } else {
          //TODO リリースされたら、GooglePlayのリンクを載せる。
          await Share.shareXFiles(
            [XFile(imagePath.path)],
            subject: '${post.attractionName}の評価は${post.rank}点でした!!\n\n'
                '${post.content}\n\n'
                '#TDL_APP',
          );
        }
      }
    });
  }
}
