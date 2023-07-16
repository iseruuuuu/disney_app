import 'package:disney_app/model/account.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDisneyCell extends StatelessWidget {
  const AppDisneyCell({
    Key? key,
    required this.index,
    required this.account,
    required this.post,
    required this.onTapImage,
    required this.myAccount,
    required this.isMaster,
  }) : super(key: key);

  final int index;
  final Account account;
  final Post post;
  final Function() onTapImage;
  final String myAccount;
  final bool isMaster;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: index == 0
            ? const Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              )
            : const Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10),
                  child: GestureDetector(
                    onTap: onTapImage,
                    child: CircleAvatar(
                      radius: 28,
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: Text(
                  DateFormat('yyyy/MM/dd').format(
                    post.createdTime!.toDate(),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
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
                            title: '削除確認',
                            content: '投稿を削除してもよろしいでしょうか？\n'
                                '復元はできなくなっております',
                            onTap: () async {
                              PostFirestore.deletePost(post.id, post);
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
                                  'https://forms.gle/Mo71XmZtA74AKBTo9');
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 70),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: Text(
                post.content,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.black,
                ),
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
