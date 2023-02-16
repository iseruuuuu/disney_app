import 'dart:convert';
import 'package:disney_app/constants/attraction.dart';
import 'package:disney_app/model/post.dart';
import 'package:disney_app/screen/post/component/attraction_picker.dart';
import 'package:disney_app/screen/post/component/comment_text_field.dart';
import 'package:disney_app/screen/post/component/rank_picker.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/posts_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  void rankPicker() {
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
  }

  void attractionPicker() {
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
    ).showModal(context);
  }

  void post() async {
    await EasyLoading.show(status: 'loading....');
    if (controller.text.isNotEmpty && attractionName != '') {
      Post newPost = Post(
        content: controller.text,
        postAccountId: Authentication.myAccount!.id,
        rank: rank,
        attractionName: attractionName,
      );
      var result = await PostFirestore.addPost(newPost);
      if (result == true) {
        if (!mounted) return;
        Navigator.pop(context);
      }
    }
    await EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('投稿'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: post,
            child: const Text(
              '投稿する',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            RankPicker(
              onTap: rankPicker,
              rank: rank.toString(),
            ),
            AttractionPicker(
              onTap: attractionPicker,
              attractionName: attractionName,
            ),
            CommentTextField(controller: controller),
          ],
        ),
      ),
    );
  }
}
