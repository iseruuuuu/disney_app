import 'package:disney_app/model/account.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/screen/detail/component/detail_account_container.dart';
import 'package:disney_app/screen/detail/component/detail_account_header.dart';
import 'package:flutter/material.dart';

class DetailAccountScreen extends StatelessWidget {
  const DetailAccountScreen({
    Key? key,
    required this.account,
    required this.post,
  }) : super(key: key);

  final Account account;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          DetailAccountHeader(account: account),
          const DetailAccountContainer(),
          //TODO 選択したアカウントのリストを取得する
        ],
      ),
    );
  }
}
