import 'package:disney_app/core/component/app_text_button.dart';
import 'package:disney_app/core/component/app_text_field.dart';
import 'package:disney_app/screen/edit/edit_screen_view_model.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditScreen extends ConsumerWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(editScreenViewModelProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(editScreenViewModelProvider.notifier).update(context),
            child: const Text(
              '更新する',
              style: TextStyle(fontSize: 18),
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
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            GestureDetector(
              onTap: () =>
                  ref.read(editScreenViewModelProvider.notifier).selectImage(),
              child: CircleAvatar(
                // foregroundImage: getImage(),
                // foregroundImage: state.getImage(),
                // foregroundImage: (state.image == controller.myAccount.imagePath)
                //     ? NetworkImage(controller.myAccount.imagePath)
                //     : FileImage(File(state.image)),
                // foregroundImage: (state.image == controller.myAccount.imagePath)
                //     ? NetworkImage(controller.myAccount.imagePath) as ImageProvider<Object>?
                //     : FileImage(File(state.image)) as ImageProvider<Object>?,

                foregroundImage: controller.getImage(),

                // foregroundImage: NetworkImage(controller.myAccount.imagePath),
                // foregroundImage:  FileImage(File(state.image)),
                radius: 70,
                child: const Icon(Icons.add),
              ),
            ),
            const Spacer(),
            AppTextField(
              controller: controller.nameController,
              hintText: '名前',
              maxLines: 1,
            ),
            const Spacer(),
            AppTextField(
              controller: controller.userIdController,
              hintText: 'ユーザーID',
              maxLines: 1,
            ),
            const Spacer(),
            AppTextField(
              controller: controller.selfIntroductionController,
              hintText: '自己紹介',
              maxLines: 3,
            ),
            const Spacer(),
            AppTextButton(
              onPressed: () {
                FunctionUtils.openDialog(
                  context: context,
                  title: 'ログアウト確認',
                  content: 'ログアウトします。\n'
                      'よろしいでしょうか？',
                  onTap: () => ref
                      .read(editScreenViewModelProvider.notifier)
                      .signOut(context),
                );
              },
              title: 'ログアウト',
              color: Colors.red,
            ),
            AppTextButton(
              onPressed: () {
                FunctionUtils.openDialog(
                  context: context,
                  title: 'アカウント削除確認',
                  content: 'アカウントの情報を削除します。\n'
                      '投稿内容も全て削除されます。\n'
                      'よろしいでしょうか？',
                  onTap: () => ref
                      .read(editScreenViewModelProvider.notifier)
                      .delete(context),
                );
              },
              title: 'アカウントを削除',
              color: Colors.red,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
