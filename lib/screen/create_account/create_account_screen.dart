import 'package:disney_app/core/component/app_elevated_button.dart';
import 'package:disney_app/core/component/app_text_field.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/l10n/l10n.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/screen/create_account/create_account_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CreateAccountScreen extends ConsumerWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createAccountScreenViewModelProvider.notifier);
    final state = ref.watch(createAccountScreenViewModelProvider);
    final loading = ref.watch(loadingProvider);
    final l10n = L10n.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: AppColorStyle.appColor,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                l10n.app_bar_create_account,
                style: AppTextStyle.appBarCreateAccountTextStyle,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => ref
                        .read(createAccountScreenViewModelProvider.notifier)
                        .selectImage(),
                    child: CircleAvatar(
                      backgroundColor: AppColorStyle.appColor,
                      foregroundImage: state != null ? FileImage(state) : null,
                      radius: 45,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: controller.nameController,
                    hintText: l10n.name,
                    maxLines: 1,
                  ),
                  AppTextField(
                    controller: controller.userIdController,
                    hintText: l10n.user_id,
                    maxLines: 1,
                  ),
                  AppTextField(
                    controller: controller.selfIntroductionController,
                    hintText: l10n.self_introduction,
                    maxLines: 3,
                  ),
                  AppTextField(
                    controller: controller.emailController,
                    hintText: l10n.email,
                    maxLines: 1,
                  ),
                  AppTextField(
                    controller: controller.passwordController,
                    hintText: l10n.password,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: AppElevatedButton(
                      title: l10n.create_account,
                      onPressed: () => controller.createAccount(context, ref),
                    ),
                  ),
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
      ),
    );
  }
}
