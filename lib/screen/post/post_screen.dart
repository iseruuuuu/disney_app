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
  TextEditingController rankController = TextEditingController();
  TextEditingController attractionNameController = TextEditingController();

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
          TextField(
            controller: rankController,
          ),
          TextField(
            controller: attractionNameController,
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty &&
                  rankController.text.isNotEmpty &&
                  attractionNameController.text.isNotEmpty) {
                Post newPost = Post(
                  content: controller.text,
                  postAccountId: Authentication.myAccount!.id,
                  rank: int.parse(rankController.text),
                  attractionName: attractionNameController.text,
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
