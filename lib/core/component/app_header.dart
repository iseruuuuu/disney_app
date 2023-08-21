import 'package:disney_app/core/constants/account.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.account,
    required this.isMyAccount,
    this.onTapEdit,
    this.onTapSNS,
    this.onTapTwitter,
    this.onTapInstagram,
  });

  final Account account;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapSNS;
  final VoidCallback? onTapTwitter;
  final VoidCallback? onTapInstagram;
  final bool isMyAccount;

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
                  child: CircleAvatar(
                    radius: 40,
                    foregroundImage: NetworkImage(account.imagePath),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.accountNameTextStyle,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '@${account.userId}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.accountUserIdTextStyle,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: onTapTwitter,
                            icon: const Icon(
                              FontAwesomeIcons.twitter,
                              color: Colors.lightBlue,
                            ),
                          ),
                          IconButton(
                            onPressed: onTapInstagram,
                            icon: const Icon(
                              FontAwesomeIcons.instagram,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                (account.id == MasterAccount.masterAccount)
                    ? Image.asset(
                        Assets.images.badge.path,
                        fit: BoxFit.fill,
                        width: 40,
                      )
                    : const SizedBox.shrink(),
                const SizedBox(width: 10),
                Column(
                  children: [
                    isMyAccount
                        ? OutlinedButton(
                            onPressed: onTapEdit,
                            child: Text(
                              l10n.edit,
                              style: const TextStyle(
                                color: AppColorStyle.appColor,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    isMyAccount
                        ? OutlinedButton(
                            onPressed: onTapSNS,
                            child: Text(
                              l10n.sns_edit,
                              style: const TextStyle(
                                color: AppColorStyle.appColor,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              right: 15,
              left: 15,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                account.selfIntroduction,
                style: AppTextStyle.accountSelfIntroductionTextStyle,
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
              style: AppTextStyle.appBold17TextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
