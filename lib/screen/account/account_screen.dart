import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/component/disney_cell.dart';
import 'package:disney_app/model/account.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/screen/account/component/account_container.dart';
import 'package:disney_app/screen/account/component/account_header.dart';
import 'package:disney_app/screen/detail/detail_account_screen.dart';
import 'package:disney_app/screen/detail/detail_screen.dart';
import 'package:disney_app/screen/edit/edit_screen.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Account myAccount = Authentication.myAccount!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AccountHeader(
              account: myAccount,
              onTapEdit: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditScreen(),
                  ),
                );
                if (result == true) {
                  setState(() {
                    myAccount = Authentication.myAccount!;
                  });
                }
              },
            ),
            const AccountContainer(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: UserFireStore.users
                      .doc(myAccount.id)
                      .collection('my_posts')
                      .orderBy(
                        'created_time',
                        descending: true,
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> myPostIds =
                          List.generate(snapshot.data!.docs.length, (index) {
                        return snapshot.data!.docs[index].id;
                      });
                      return FutureBuilder<List<Post>?>(
                          future: PostFirestore.getPostsFromIds(myPostIds),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  Post post = snapshot.data![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                            account: myAccount,
                                            post: post,
                                          ),
                                        ),
                                      );
                                    },
                                    child: DisneyCell(
                                      index: index,
                                      account: myAccount,
                                      post: post,
                                      onTapImage: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailAccountScreen(
                                              account: myAccount,
                                              post: post,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Container();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
