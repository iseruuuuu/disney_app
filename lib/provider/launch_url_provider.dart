import 'package:disney_app/core/constants/url.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

final launchUrlProvider = Provider<LaunchUrl>(
  (ref) => LaunchUrl(),
);

class LaunchUrl extends ChangeNotifier {
  Future<void> openTwitter(BuildContext context, String twitter) async {
    if (twitter.isNotEmpty) {
      final url = Uri.parse('${Url.twitter}$twitter');
      final secondUrl = Uri.parse('${Url.twitterSecond}$twitter');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else if (await canLaunchUrl(secondUrl)) {
        await launchUrl(secondUrl);
      } else {
        await Future.microtask(() {
          SnackBarUtils.snackBar(context, 'URLが開けませんでした');
        });
      }
    }
  }

  Future<void> openInstagram(BuildContext context, String instagram) async {
    if (instagram.isNotEmpty) {
      final nativeUrl = Uri.parse('${Url.instagram}$instagram');
      final webUrl = Uri.parse('${Url.instagramSecond}$instagram/');
      if (await canLaunchUrl(nativeUrl)) {
        await launchUrl(nativeUrl);
      } else if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl);
      } else {
        await Future.microtask(() {
          SnackBarUtils.snackBar(context, 'URLが開けませんでした');
        });
      }
    }
  }

  Future<void> reportSNS(BuildContext context) async {
    final url = Uri.parse(Url.reportSNS);
    if (!await launchUrl(url)) {
      await Future.microtask(() {
        SnackBarUtils.snackBar(context, 'URLが開けませんでした');
      });
    }
  }

  Future<void> reportPost(BuildContext context) async {
    final reportUrl = Uri.parse(Url.reportPost);
    if (await canLaunchUrl(reportUrl)) {
      await launchUrl(reportUrl);
    } else {
      await Future.microtask(() {
        SnackBarUtils.snackBar(context, 'URLが開けませんでした');
      });
    }
  }
}
