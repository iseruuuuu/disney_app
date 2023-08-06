import 'package:disney_app/core/constants/account.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/model/usecase/post_firestore_usecase.dart';
import 'package:disney_app/core/theme/app_text_style.dart';
import 'package:disney_app/gen/assets.gen.dart';
import 'package:disney_app/l10n/l10n.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDisneyCell extends ConsumerWidget {
  const AppDisneyCell({
    super.key,
    required this.index,
    required this.account,
    required this.post,
    required this.onTapImage,
    required this.myAccount,
    required this.isMaster,
  });

  final int index;
  final Account account;
  final Post post;
  final VoidCallback onTapImage;
  final String myAccount;
  final bool isMaster;

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
                      foregroundImage: NetworkImage(account.imagePath),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.4,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            account.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.cellNameTextStyle,
                          ),
                          const SizedBox(width: 5),
                          (post.postAccountId == MasterAccount.masterAccount)
                              ? Image.asset(
                                  Assets.images.badge.path,
                                  fit: BoxFit.fill,
                                  width: 25,
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                      Text(
                        '@${account.userId}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.cellUserIdTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              (post.postAccountId == myAccount) || isMaster
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10, right: 20),
                      child: GestureDetector(
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
                        child: const Icon(Icons.more_horiz),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 15, right: 20),
                      child: GestureDetector(
                        onTap: () {
                          FunctionUtils.openDialog(
                            context: context,
                            title: l10n.dialog_contact_title,
                            content: l10n.dialog_contact_contents,
                            onTap: () async {
                              final url = Uri.parse(
                                'https://forms.gle/Mo71XmZtA74AKBTo9',
                              );
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            },
                          );
                        },
                        child: const Icon(Icons.reorder),
                      ),
                    ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 70),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Text(
                post.attractionName,
                style: AppTextStyle.appBold15TextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 70),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: !post.isSpoiler
                  ? Text(
                      post.content,
                      style: AppTextStyle.app15TextStyle,
                      overflow: TextOverflow.visible,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.dialog_spoiler_cell_text,
                          style: AppTextStyle.cellSpoilerDescriptionTextStyle,
                          overflow: TextOverflow.visible,
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.red,
                          size: 40,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
