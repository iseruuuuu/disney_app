import 'package:disney_app/core/component/app_text_button.dart';
import 'package:disney_app/core/component/app_text_field.dart';
import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/screen/edit/edit_screen_view_model.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EditScreen extends ConsumerWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(editScreenViewModelProvider.notifier);
    final image = ref.watch(editScreenViewModelProvider);
    final loading = ref.watch(loadingProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => ref
                .read(editScreenViewModelProvider.notifier)
                .update(context, ref),
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
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => ref
                      .read(editScreenViewModelProvider.notifier)
                      .selectImage(),
                  child: CircleAvatar(
                    foregroundImage: image,
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
                          .delete(context, ref),
                    );
                  },
                  title: 'アカウントを削除',
                  color: Colors.red,
                ),
                const Spacer(),
              ],
            ),
          ),
          loading
              ? Center(
                  child: LoadingAnimationWidget.dotsTriangle(
                    color: AppColorStyle.appColor,
                    size: 50,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
