import 'package:cached_network_image/cached_network_image.dart';
import 'package:disney_app/core/constants/account.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.account,
    required this.isMyAccount,
    this.onTapEditProfile,
    this.onTapEditSNS,
    required this.onTapTwitter,
    required this.onTapInstagram,
    required this.isHasTwitter,
    required this.isHasInstagram,
  });

  final Account account;
  final VoidCallback? onTapEditProfile;
  final VoidCallback? onTapEditSNS;
  final VoidCallback onTapTwitter;
  final VoidCallback onTapInstagram;
  final bool isMyAccount;
  final bool isHasTwitter;
  final bool isHasInstagram;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () =>
                        FunctionUtils().imageDialog(context, account.imagePath),
                    child: CircleAvatar(
                      radius: 40,
                      foregroundImage:
                          CachedNetworkImageProvider(account.imagePath),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.appBoldBlack20TextStyle,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '@${account.userId}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.appBoldGrey16TextStyle,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: isHasTwitter ? onTapTwitter : null,
                            icon: Icon(
                              FontAwesomeIcons.twitter,
                              color:
                                  isHasTwitter ? Colors.lightBlue : Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: isHasInstagram ? onTapInstagram : null,
                            icon: Icon(
                              FontAwesomeIcons.instagram,
                              color: isHasInstagram ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 45),
                      child: account.isOfficial
                          ? Image.asset(
                              Assets.images.official.path,
                              fit: BoxFit.fill,
                              width: 40,
                            )
                          : (account.id == MasterAccount.masterAccount)
                              ? Image.asset(
                                  Assets.images.dev.path,
                                  fit: BoxFit.fill,
                                  width: 30,
                                )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Row(
            children: [
              const Spacer(),
              isMyAccount
                  ? OutlinedButton(
                      onPressed: onTapEditProfile,
                      child: Text(
                        l10n.edit,
                        style: const TextStyle(
                          color: AppColorStyle.appColor,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(width: 20),
              isMyAccount
                  ? OutlinedButton(
                      onPressed: onTapEditSNS,
                      child: Text(
                        l10n.sns_edit,
                        style: const TextStyle(
                          color: AppColorStyle.appColor,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(width: 20),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              right: 15,
              left: 15,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                account.selfIntroduction,
                style: AppTextStyle.app500Black16TextStyle,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColorStyle.appColor,
                  width: 3,
                ),
              ),
            ),
            child: Text(
              l10n.post,
              style: AppTextStyle.appBoldBlack17TextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
