import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/component/app_header.dart';
import 'package:disney_app/component/disney_cell.dart';
import 'package:disney_app/component/empty_screen.dart';
import 'package:disney_app/model/account.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/screen/edit/edit_screen.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:flutter/material.dart';

class DetailAccountScreen extends StatefulWidget {
  const DetailAccountScreen({
    Key? key,
    required this.postAccount,
    required this.post,
  }) : super(key: key);

  final Account postAccount;
  final Post post;

  @override
  State<DetailAccountScreen> createState() => _DetailAccountScreenState();
}

class _DetailAccountScreenState extends State<DetailAccountScreen> {
  Account myAccount = Authentication.myAccount!;

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
          AppHeader(
            account: widget.postAccount,
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
            isMyAccount: widget.post.postAccountId == myAccount.id,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: UserFireStore.users
                  .doc(widget.postAccount.id)
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
                                        widget.postAccount,
                                        post,
                                        myAccount.id,
                                      );
                                    },
                                    child: DisneyCell(
                                      index: index,
                                      account: widget.postAccount,
                                      post: post,
                                      myAccount: myAccount.id,
                                      isMaster: false,
                                      onTapImage: () {
                                        NavigationUtils.detailAccountScreen(
                                          context,
                                          widget.postAccount,
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
                        return const Center(child: CircularProgressIndicator());
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
    );
  }
}
