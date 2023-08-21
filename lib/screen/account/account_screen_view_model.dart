import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/screen/account/account_screen_state.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

final accountScreenViewModelProvider = StateNotifierProvider.autoDispose<
    AccountScreenViewModel, AccountScreenState>(
  (ref) {
    final myAccount = AuthenticationService.myAccount!;
    return AccountScreenViewModel(
      state: AccountScreenState(
        myAccount: myAccount,
      ),
    );
  },
);

class AccountScreenViewModel extends StateNotifier<AccountScreenState> {
  AccountScreenViewModel({required AccountScreenState state}) : super(state) {
    fetch();
  }

  AccountScreenState get currentState => state;

  void fetch() {
    final myAccount = AuthenticationService.myAccount!;
    state = state.copyWith(myAccount: myAccount);
  }

  Future<void> onTapEdit(BuildContext context) async {
    final result = await NavigationUtils.editScreen(context);
    if (result == true) {
      state = state.copyWith(
        myAccount: AuthenticationService.myAccount!,
      );
    }
  }

  Future<void> onTapSNS(BuildContext context) async {
    final result = await NavigationUtils.snsEditScreen(context);
    if (result == true) {
      state = state.copyWith(
        myAccount: AuthenticationService.myAccount!,
      );
    }
  }

  Future<void> openTwitter(BuildContext context) async {
    if (state.myAccount.instagram.isNotEmpty) {
      final url = 'twitter://user?screen_name=${state.myAccount.twitter}';
      final secondUrl = 'https://twitter.com/${state.myAccount.twitter}';
      final twitterUrl = Uri.parse(url);
      final twitterSecondUrk = Uri.parse(secondUrl);
      if (await canLaunchUrl(twitterUrl)) {
        await launchUrl(twitterUrl);
      } else if (await canLaunchUrl(twitterSecondUrk)) {
        await launchUrl(twitterSecondUrk);
      } else {
        await Future.microtask(() {
          SnackBarUtils.snackBar(context, 'URLが開けませんでした');
        });
      }
    }
  }

  Future<void> openInstagram(BuildContext context) async {
    if (state.myAccount.instagram.isNotEmpty) {
      final nativeUrl =
          'instagram://user?username=${state.myAccount.instagram}';
      final webUrl = 'https://www.instagram.com/${state.myAccount.instagram}/';
      final instagramUrl = Uri.parse(nativeUrl);
      final instagramSecondUrk = Uri.parse(webUrl);
      if (await canLaunchUrl(instagramUrl)) {
        await launchUrl(instagramUrl);
      } else if (await canLaunchUrl(instagramSecondUrk)) {
        await launchUrl(instagramSecondUrk);
      } else {
        await Future.microtask(() {
          SnackBarUtils.snackBar(context, 'URLが開けませんでした');
        });
      }
    }
  }
}
