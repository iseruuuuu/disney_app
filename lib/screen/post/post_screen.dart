import 'package:disney_app/core/component/app_attraction.dart';
import 'package:disney_app/core/component/app_rating.dart';
import 'package:disney_app/core/component/app_text_field.dart';
import 'package:disney_app/screen/post/post_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(postScreenViewModelProvider.notifier);
    final state = ref.watch(postScreenViewModelProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('投稿'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(postScreenViewModelProvider.notifier).post(context),
            child: const Text(
              '投稿',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppRating(
              onTap: controller.rankPicker,
              rank: state.rank,
              isSelect: true,
            ),
            AppAttraction(
              onTap: () => ref
                  .read(postScreenViewModelProvider.notifier)
                  .attractionPicker(context),
              attractionName: state.attractionName,
              isSelected: state.isSelected,
            ),
            AppTextField(
              controller: controller.controller,
              hintText: '感想',
              maxLines: 10,
            )
          ],
        ),
      ),
    );
  }
}
