import 'package:disney_app/core/component/component.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/screen/authentication/password_reset/password_reset_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PasswordResetScreen extends ConsumerWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(passwordResetScreenViewModelProvider);
    final loading = ref.watch(loadingProvider);
    final l10n = L10n.of(context)!;
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
                    Text(
                      l10n.reset_password,
                      style: AppTextStyle.resetPasswordTextStyle,
                    ),
                  ],
                ),
                const Spacer(),
                AppTextField(
                  controller: state.emailController,
                  hintText: l10n.email,
                  maxLines: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    l10n.send_reset_message,
                    style: AppTextStyle.sendResetMessageTextStyle,
                  ),
                ),
                const Spacer(),
                AppElevatedButton(
                  onPressed: () => ref
                      .read(passwordResetScreenViewModelProvider)
                      .sendEmail(context, ref),
                  title: l10n.send_email,
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
