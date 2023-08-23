import 'package:disney_app/core/component/component.dart';
import 'package:disney_app/core/constants/account.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/screen/detail/detail_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({
    super.key,
    required this.account,
    required this.post,
    required this.myAccount,
    required this.onTapImage,
  });

  final Account account;
  final Post post;
  final String myAccount;
  final VoidCallback onTapImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppAppBar(
            image: Assets.header.detailHeader.path,
            text: Text(
              l10n.tweet,
              style: AppTextStyle.tweetTextStyle,
            ),
          ),
          Screenshot(
            controller: ref.watch(detailViewModelProvider).screenshotController,
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onTapImage,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: CircleAvatar(
                          radius: 28,
                          foregroundImage: NetworkImage(account.imagePath),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              account.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.appBold18TextStyle,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, right: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Text(
                              '@${account.userId}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.app15GreyTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // (account.id == MasterAccount.masterAccount)
                    account.isOfficial
                        ? Image.asset(
                            Assets.images.badge.path,
                            fit: BoxFit.fill,
                            width: 45,
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          AppRating(
                            rank: post.rank,
                            isSelect: false,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              '${post.rank}${l10n.score}',
                              style: AppTextStyle.detailRankTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        post.attractionName,
                        style: AppTextStyle.detailAttractionNameTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        post.content,
                        style: AppTextStyle.detailContentTextStyle,
                      ),
                    ),
                    const Divider(color: Colors.grey),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Text(
                              DateFormat('yyyy/MM/dd').format(
                                post.createdTime!.toDate(),
                              ),
                              style: AppTextStyle.detailCreatedTimeTextStyle,
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () =>
                                  ref.read(detailViewModelProvider).share(post),
                              iconSize: 30,
                              icon: const Icon(
                                CupertinoIcons.share,
                                color: AppColorStyle.appColor,
                              ),
                            ),
                            (post.postAccountId == myAccount)
                                ? GestureDetector(
                                    onTap: () => ref
                                        .read(detailViewModelProvider)
                                        .openCheckDialog(
                                          context,
                                          post.id,
                                          post,
                                          ref,
                                        ),
                                    child: const Icon(
                                      Icons.more_horiz,
                                      color: Colors.black,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
