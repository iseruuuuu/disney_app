import 'package:disney_app/core/component/app_elevated_button.dart';
import 'package:disney_app/core/component/app_text_button.dart';
import 'package:disney_app/core/component/app_text_field.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/assets.gen.dart';
import 'package:disney_app/l10n/l10n.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/screen/login/login_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginScreenViewModelProvider.notifier);
    final loading = ref.watch(loadingProvider);
    final l10n = L10n.of(context)!;
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(loginScreenViewModelProvider).checkLogin(context, ref);
        });
        return null;
      },
      const [],
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: AppColorStyle.appColor,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                l10n.app_bar_login,
                style: AppTextStyle.appBarLoginTextStyle,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        Assets.images.empty.path,
                        width: 70,
                        height: 70,
                      ),
                      Text(
                        l10n.app_name,
                        style: AppTextStyle.appBold20TextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  AppTextField(
                    controller: state.emailController,
                    hintText: l10n.email,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 50),
                  AppTextField(
                    controller: state.passwordController,
                    hintText: l10n.password,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 80),
                  AppElevatedButton(
                    title: l10n.log_in,
                    onPressed: () => ref
                        .read(loginScreenViewModelProvider.notifier)
                        .login(context, ref),
                  ),
                  const SizedBox(height: 30),
                  AppTextButton(
                    onPressed: () => ref
                        .read(loginScreenViewModelProvider.notifier)
                        .createAccountScreen(context),
                    title: l10n.register_screen,
                    color: Colors.lightBlue,
                  ),
                  AppTextButton(
                    onPressed: () => ref
                        .read(loginScreenViewModelProvider.notifier)
                        .passwordResetScreen(context),
                    title: l10n.login_screen,
                    color: Colors.lightBlue,
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
