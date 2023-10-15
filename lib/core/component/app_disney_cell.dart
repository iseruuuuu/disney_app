import 'package:cached_network_image/cached_network_image.dart';
import 'package:disney_app/core/component/component.dart';
import 'package:disney_app/core/constants/account.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/core/usecase/post_usecase.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/provider/launch_url_provider.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDisneyCell extends ConsumerWidget {
  const AppDisneyCell({
    super.key,
    required this.index,
    required this.account,
    required this.post,
    required this.onTapImage,
    required this.myAccount,
  });

  final int index;
  final Account account;
  final Post post;
  final VoidCallback onTapImage;
  final String myAccount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: index == 0
            ? const Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
              )
            : const Border(
                bottom: BorderSide(color: Colors.grey),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 65,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10),
                  child: GestureDetector(
                    onTap: onTapImage,
                    child: CircleAvatar(
                      radius: 30,
                      foregroundImage:
                          CachedNetworkImageProvider(account.imagePath),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.appBoldBlack18TextStyle,
                              ),
                              Text(
                                post.attractionName,
                                style: AppTextStyle.appBoldGrey16TextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: account.isOfficial
                    ? Image.asset(
                        Assets.images.official.path,
                        fit: BoxFit.fill,
                        width: 25,
                      )
                    : (post.postAccountId == MasterAccount.masterAccount)
                        ? Image.asset(
                            Assets.images.dev.path,
                            fit: BoxFit.fill,
                            width: 25,
                          )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 75, top: 5, bottom: 10),
            child: Row(
              children: [
                AppCellRating(rank: post.rank),
                const SizedBox(width: 10),
                Text(
                  '${post.rank}点',
                  style: AppTextStyle.appBoldBlack17TextStyle,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 75),
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              decoration: BoxDecoration(
                color:
                    !post.isSpoiler ? Colors.grey.shade200 : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: !post.isSpoiler
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        post.content,
                        style: AppTextStyle.appNormalBlack18TextStyle,
                        overflow: TextOverflow.visible,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.dialog_spoiler_cell_text,
                          style: AppTextStyle.appBoldRed15TextStyle,
                          overflow: TextOverflow.visible,
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.red,
                          size: 30,
                        ),
                      ],
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 60),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    final updatePost = {
                      'content': post.content,
                      'post_account_id': post.postAccountId,
                      'post_id': post.postId,
                      'created_time': post.createdTime,
                      'rank': post.rank,
                      'attraction_name': post.attractionName,
                      'is_spoiler': post.isSpoiler,
                      'heart': post.heart + 1,
                    };
                    ref.read(postUsecaseProvider).updatePosts(
                          post.postId,
                          updatePost,
                        );
                    ref.read(postUsecaseProvider).updateUserPost(
                          post.postAccountId,
                          post.postId,
                          updatePost,
                        );
                  },
                  iconSize: 23,
                  icon: const Icon(
                    CupertinoIcons.heart,
                    color: Colors.pinkAccent,
                  ),
                ),
                Text(
                  post.heart.toString(),
                  style: AppTextStyle.appNormalBlack18TextStyle,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 5),
                  child: (post.postAccountId == myAccount) ||
                          (myAccount == MasterAccount.masterAccount)
                      ? GestureDetector(
                          onTap: () {
                            FunctionUtils.openDialog(
                              context: context,
                              title: l10n.dialog_delete_check_title,
                              content: l10n.dialog_delete_check_content,
                              onTap: () async {
                                await ref
                                    .read(postUsecaseProvider)
                                    .deletePost(post.id, post);
                              },
                            );
                          },
                          child: const Icon(
                            Icons.more_horiz,
                            size: 30,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            FunctionUtils.openDialog(
                              context: context,
                              title: l10n.dialog_contact_title,
                              content: l10n.dialog_contact_contents,
                              onTap: () => ref
                                  .read(launchUrlProvider)
                                  .reportPost(context),
                            );
                          },
                          child: const Icon(Icons.reorder, size: 30),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
