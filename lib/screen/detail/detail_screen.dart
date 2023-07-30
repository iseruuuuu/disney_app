import 'package:disney_app/core/component/app_app_bar.dart';
import 'package:disney_app/core/component/app_rating.dart';
import 'package:disney_app/core/constants/account.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/gen/assets.gen.dart';
import 'package:disney_app/screen/detail/detail_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppAppBar(
            image: Assets.header.detailHeader.path,
            text: Text(
              'Tweet',
              style: GoogleFonts.pattaya(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, right: 10),
                    child: Text(
                      '@${account.userId}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              (account.id == MasterAccount.masterAccount)
                  ? Image.asset(
                      Assets.images.badge.path,
                      fit: BoxFit.fill,
                      width: 35,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    AppRating(
                      rank: post.rank,
                      isSelect: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        '${post.rank}点',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  post.attractionName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  post.content,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              const Divider(color: Colors.grey),
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
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Spacer(),
                          (post.postAccountId == myAccount)
                              ? GestureDetector(
                                  onTap: () => ref
                                      .read(detailScreenViewModelProvider)
                                      .openCheckDialog(
                                        context,
                                        post.id,
                                        post,
                                        ref,
                                      ),
                                  child: const Icon(
                                    Icons.reorder,
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
        ],
      ),
    );
  }
}
