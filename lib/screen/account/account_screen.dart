import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/model/account.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/screen/edit/edit_screen.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            SizedBox(
              height: 200,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        foregroundImage: NetworkImage(myAccount.imagePath),
                      ),
                      Column(
                        children: [
                          Text(myAccount.name),
                          Text(myAccount.userId),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () async {
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
                        child: const Text('編集'),
                      ),
                    ],
                  ),
                  Text(myAccount.selfIntroduction),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.blue,
                    width: 3,
                  ),
                ),
              ),
              child: Text('投稿'),
            ),
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
                                        CircleAvatar(
                                          radius: 30,
                                          foregroundImage:
                                              NetworkImage(myAccount.imagePath),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(myAccount.name),
                                                Text(myAccount.userId),
                                                Text(
                                                  DateFormat('yyyy/MM/dd')
                                                      .format(
                                                    post.createdTime!.toDate(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(post.content),
                                          ],
                                        ),
                                      ],
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
