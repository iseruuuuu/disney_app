import 'dart:io';

import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/usecase/post_usecase.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final detailScreenViewModelProvider =
    ChangeNotifierProvider.autoDispose<DetailScreenViewModel>(
  (ref) {
    return DetailScreenViewModel();
  },
);

class DetailScreenViewModel extends ChangeNotifier {
  DetailScreenViewModel();

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

  Future<void> openTwitter(BuildContext context, String twitter) async {
    if (twitter.isNotEmpty) {
      final url = 'twitter://user?screen_name=$twitter';
      final secondUrl = 'https://twitter.com/$twitter';
      final twitterUrl = Uri.parse(url);
      final twitterSecondUrk = Uri.parse(secondUrl);
      if (await canLaunchUrl(twitterUrl)) {
        await launchUrl(twitterUrl);
      } else if (await canLaunchUrl(twitterSecondUrk)) {
        await launchUrl(twitterSecondUrk);
      } else {
        await Future.microtask(() {
          SnackBarUtils.snackBar(context, 'URLが開けませんでした');
        });
      }
    }
  }

  Future<void> openInstagram(BuildContext context, String instagram) async {
    if (instagram.isNotEmpty) {
      final nativeUrl = 'instagram://user?username=$instagram';
      final webUrl = 'https://www.instagram.com/$instagram/';
      final instagramUrl = Uri.parse(nativeUrl);
      final instagramSecondUrk = Uri.parse(webUrl);
      if (await canLaunchUrl(instagramUrl)) {
        await launchUrl(instagramUrl);
      } else if (await canLaunchUrl(instagramSecondUrk)) {
        await launchUrl(instagramSecondUrk);
      } else {
        await Future.microtask(() {
          SnackBarUtils.snackBar(context, 'URLが開けませんでした');
        });
      }
    }
  }

  void share(Post post) {
    screenshotController.capture().then((capturedImage) async {
      if (capturedImage != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(capturedImage);
        if (Platform.isIOS) {
          //リリースされたら、AppleStoreのリンクを載せる。
          await Share.shareXFiles(
            [XFile(imagePath.path)],
            subject: '${post.attractionName}の評価は${post.rank}点でした!!\n\n'
                '${post.content}\n\n'
                '#TDL_APP',
          );
        } else {
          //リリースされたら、GooglePlayのリンクを載せる。
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
