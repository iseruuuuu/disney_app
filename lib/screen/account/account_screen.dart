import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/component/app_disney_cell.dart';
import 'package:disney_app/component/app_header.dart';
import 'package:disney_app/component/empty_screen.dart';
import 'package:disney_app/constants/color_constants.dart';
import 'package:disney_app/model/account.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/screen/edit/edit_screen.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:disney_app/utils/navigation_utils.dart';
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
            const SizedBox(height: 20),
            AppHeader(
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
              isMyAccount: true,
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
                          return (snapshot.data!.isNotEmpty)
                              ? ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    Post post = snapshot.data![index];
                                    return GestureDetector(
                                      onTap: () {
                                        NavigationUtils.detailScreen(
                                          context,
                                          myAccount,
                                          post,
                                          myAccount.id,
                                        );
                                      },
                                      child: AppDisneyCell(
                                        index: index,
                                        account: myAccount,
                                        post: post,
                                        myAccount: myAccount.id,
                                        isMaster: false,
                                        onTapImage: () {
                                          NavigationUtils.detailAccountScreen(
                                            context,
                                            myAccount,
                                            post,
                                            myAccount.id,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                              : const EmptyScreen();
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.appColor,
        onPressed: () {
          NavigationUtils.postScreen(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
