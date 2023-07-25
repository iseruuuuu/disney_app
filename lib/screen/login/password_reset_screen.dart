import 'package:disney_app/core/component/app_elevated_button.dart';
import 'package:disney_app/core/component/app_text_field.dart';
import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/gen/assets.gen.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/screen/login/password_reset_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PasswordResetScreen extends ConsumerWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(passwordResetScreenViewModelProvider);
    final loading = ref.watch(loadingProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColorStyle.appColor,
        elevation: 0,
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.images.empty.path,
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'パスワードの再設定',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: AppColorStyle.appColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                AppTextField(
                  controller: state.emailController,
                  hintText: 'メールアドレス',
                  maxLines: 1,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'メールアドレスにパスワード再設定のメールを送信します。',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
                const Spacer(),
                AppElevatedButton(
                  onPressed: () => ref
                      .read(passwordResetScreenViewModelProvider)
                      .sendEmail(context),
                  title: 'メールを送る',
                ),
                const Spacer(),
              ],
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
