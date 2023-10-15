import 'package:disney_app/core/component/component.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/screen/post/post_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(postScreenViewModelProvider.notifier);
    final state = ref.watch(postScreenViewModelProvider);
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
              onPressed: (state.attractionName.isNotEmpty)
                  ? () => ref
                      .read(postScreenViewModelProvider.notifier)
                      .post(context, ref)
                  : null,
              child: Text(
                l10n.post,
                style: (state.attractionName.isNotEmpty)
                    ? AppTextStyle.appBoldBlue18TextStyle
                    : AppTextStyle.appBoldGrey18TextStyle,
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
            SingleChildScrollView(
              child: Column(
                children: [
                  AppRating(
                    onTap: controller.rankPicker,
                    rank: state.rank,
                    isSelect: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 50,
                      horizontal: 10,
                    ),
                    child: AppAttraction(
                      onTap: () => ref
                          .read(postScreenViewModelProvider.notifier)
                          .attractionPicker(context),
                      attractionName: state.attractionName,
                      isSelected: state.isSelected,
                      style: AppTextStyle.appBoldBlack16TextStyle,
                    ),
                  ),
                  AppTextField(
                    controller: controller.controller,
                    hintText: l10n.impressions,
                    maxLines: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        state.isSpoiler
                            ? l10n.is_spoiler_true
                            : l10n.is_spoiler_false,
                        style: AppTextStyle.appBold20GoogleFontsTextStyle,
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          activeColor: AppColorStyle.appColor,
                          value: state.isSpoiler,
                          onChanged: (value) => ref
                              .read(postScreenViewModelProvider.notifier)
                              .onChanged(value: value!),
                        ),
                      ),
                    ],
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
