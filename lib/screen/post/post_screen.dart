import 'dart:convert';
import 'package:disney_app/constants/attraction.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController controller = TextEditingController();
  int rank = 0;
  String attractionName = '';

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
          GestureDetector(
            onTap: () {
              Picker(
                adapter: NumberPickerAdapter(
                  data: [const NumberPickerColumn(begin: 0, end: 100)],
                ),
                hideHeader: true,
                onConfirm: (Picker picker, List value) {
                  setState(
                    () {
                      rank = value[0];
                    },
                  );
                },
              ).showDialog(context);
            },
            child: Container(
              width: double.infinity,
              height: 100,
              color: Colors.grey,
              child: Center(
                child: Text(
                  rank.toString(),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Picker(
                adapter: PickerDataAdapter<String>(
                  pickerData: const JsonDecoder().convert(attraction),
                ),
                changeToFirst: true,
                hideHeader: false,
                onConfirm: (Picker picker, List value) {
                  setState(() {
                    var text1 = picker.adapter.text.replaceAll('[', '');
                    var result2 = text1.replaceAll(']', '');
                    var result3 = result2.replaceAll(' ', '');
                    List<String> result4 = result3.split(',');
                    attractionName = result4[1];
                  });
                },
              ).showModal(this.context);
            },
            child: Container(
              width: double.infinity,
              height: 100,
              color: Colors.grey.shade200,
              child: Center(
                child: Text(attractionName),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty && attractionName != '') {
                Post newPost = Post(
                  content: controller.text,
                  postAccountId: Authentication.myAccount!.id,
                  rank: rank,
                  attractionName: attractionName,
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
