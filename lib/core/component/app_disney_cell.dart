import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/model/usecase/post_firestore_usecase.dart';
import 'package:disney_app/core/theme/app_text_style.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.4,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    account.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.cellNameTextStyle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: Text(
                  DateFormat('yyyy/MM/dd').format(
                    post.createdTime!.toDate(),
                  ),
                  style: AppTextStyle.cellDateTextStyle,
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
                            title: '削除確認',
                            content: '投稿を削除してもよろしいでしょうか？\n'
                                '復元はできなくなっております',
                            onTap: () async {
                              await ref
                                  .read(postUsecaseProvider)
                                  .deletePost(post.id, post);
                            },
                          );
                        },
                        child: const Icon(Icons.reorder),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 15, right: 20),
                      child: GestureDetector(
                        onTap: () {
                          FunctionUtils.openDialog(
                            context: context,
                            title: 'お問い合わせ画面に遷移',
                            content: '投稿について問い合わせるサイトに\n'
                                '遷移します。よろしいですか？',
                            onTap: () async {
                              final url = Uri.parse(
                                  'https://forms.gle/Mo71XmZtA74AKBTo9',);
                              if (!await launchUrl(url)) {
                                throw 'Could not launch $url';
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
                style: AppTextStyle.cellAttractionTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 70),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: Text(
                post.content,
                style: AppTextStyle.cellDescriptionTextStyle,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
