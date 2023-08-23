import 'package:disney_app/core/component/app_text_button.dart';
import 'package:disney_app/core/component/app_text_field.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/l10n.dart';
import 'package:disney_app/provider/launch_url_provider.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/screen/edit/edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EditSNSScreen extends ConsumerWidget {
  const EditSNSScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(editViewModelProvider.notifier);
    final loading = ref.watch(loadingProvider);
    final l10n = L10n.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () =>
                  ref.read(editViewModelProvider.notifier).updateSNS(context),
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
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AppTextField(
                        controller: controller.twitterController,
                        hintText: l10n.twitter_hint_text,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AppTextField(
                        controller: controller.instagramController,
                        hintText: l10n.instagram_hint_text,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      l10n.sns_title,
                      style: AppTextStyle.appBold20TextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        l10n.sns_description,
                        style: AppTextStyle.app16TextStyle,
                      ),
                    ),
                    const Spacer(),
                    AppTextButton(
                      onPressed: () =>
                          ref.read(launchUrlProvider).reportSNS(context),
                      title: l10n.sns_report,
                      color: Colors.red,
                    ),
                    const Spacer(flex: 2),
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
      ),
    );
  }
}
