import 'package:disney_app/model/account.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class DisneyCell extends StatelessWidget {
  const DisneyCell({
    Key? key,
    required this.index,
    required this.account,
    required this.post,
    required this.onTapImage,
    required this.myAccount,
  }) : super(key: key);

  final int index;
  final Account account;
  final Post post;
  final Function() onTapImage;
  final String myAccount;

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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: onTapImage,
              child: CircleAvatar(
                radius: 30,
                foregroundImage: NetworkImage(account.imagePath),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          account.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: Text(
                        DateFormat('yyyy/MM/dd').format(
                          post.createdTime!.toDate(),
                        ),
                      ),
                    ),
                    (post.postAccountId == myAccount)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 15, right: 20),
                            child: GestureDetector(
                              onTap: () {
                                FunctionUtils.openDialog(
                                  context: context,
                                  title: '削除確認',
                                  content: '投稿を削除してもよろしいでしょうか？\n'
                                      '復元はできなくなっております',
                                  onTap: () async {
                                    await EasyLoading.show(
                                        status: 'loading....');
                                    PostFirestore.deletePost(post.id, post);
                                    await EasyLoading.dismiss();
                                  },
                                );
                              },
                              child: const Icon(Icons.reorder),
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.only(top: 15, right: 40),
                            child: SizedBox(),
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 80,
                  child: Text(
                    post.attractionName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
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
        ],
      ),
    );
  }
}
