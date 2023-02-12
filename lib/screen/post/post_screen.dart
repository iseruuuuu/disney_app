import 'package:disney_app/model/post.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿'),
        elevation: 0,
      ),
      body: Column(
        children: [
          TextField(
            controller: controller,
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                Post newPost = Post(
                  content: controller.text,
                  postAccountId: Authentication.myAccount!.id,
                );
                var result = await PostFirestore.addPost(newPost);
                if (result == true) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('投稿'),
          ),
        ],
      ),
    );
  }
}
