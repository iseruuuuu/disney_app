import 'package:disney_app/core/component/component.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/screen/edit/edit_view_model.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EditScreen extends ConsumerWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(editViewModelProvider.notifier);
    final image = ref.watch(editViewModelProvider);
    final loading = ref.watch(loadingProvider);
    final l10n = L10n.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => ref
                .read(editViewModelProvider.notifier)
                .update(context, ref),
            child: Text(
              l10n.update,
              style: AppTextStyle.appBoldBlue18TextStyle,
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
                      .read(editViewModelProvider.notifier)
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
                  hintText: l10n.name,
                  maxLines: 1,
                ),
                const Spacer(),
                AppTextField(
                  controller: controller.userIdController,
                  hintText: l10n.user_id,
                  maxLines: 1,
                ),
                const Spacer(),
                AppTextField(
                  controller: controller.selfIntroductionController,
                  hintText: l10n.self_introduction,
                  maxLines: 3,
                ),
                const Spacer(),
                AppTextButton(
                  onPressed: () {
                    FunctionUtils.openDialog(
                      context: context,
                      title: l10n.dialog_log_out_check_title,
                      content: l10n.dialog_log_out_check_content,
                      onTap: () => ref
                          .read(editViewModelProvider.notifier)
                          .signOut(context, ref),
                    );
                  },
                  title: l10n.log_out,
                  color: Colors.red,
                ),
                AppTextButton(
                  onPressed: () {
                    FunctionUtils.openDialog(
                      context: context,
                      title: l10n.dialog_delete_account_title,
                      content: l10n.dialog_delete_account_content,
                      onTap: () => ref
                          .read(editViewModelProvider.notifier)
                          .delete(context, ref),
                    );
                  },
                  title: l10n.dialog_delete_account,
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
