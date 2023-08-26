import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_ja.dart';

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n? of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ja')
  ];

  /// No description provided for @app_name.
  ///
  /// In ja, this message translates to:
  /// **'TDR APP'**
  String get app_name;

  /// No description provided for @attraction.
  ///
  /// In ja, this message translates to:
  /// **'アトラクション'**
  String get attraction;

  /// No description provided for @no_post.
  ///
  /// In ja, this message translates to:
  /// **'投稿がまだありません'**
  String get no_post;

  /// No description provided for @edit.
  ///
  /// In ja, this message translates to:
  /// **'編集'**
  String get edit;

  /// No description provided for @sns_edit.
  ///
  /// In ja, this message translates to:
  /// **'SNS'**
  String get sns_edit;

  /// No description provided for @post.
  ///
  /// In ja, this message translates to:
  /// **'投稿'**
  String get post;

  /// No description provided for @name.
  ///
  /// In ja, this message translates to:
  /// **'名前'**
  String get name;

  /// No description provided for @user_id.
  ///
  /// In ja, this message translates to:
  /// **'ユーザーID'**
  String get user_id;

  /// No description provided for @self_introduction.
  ///
  /// In ja, this message translates to:
  /// **'自己紹介'**
  String get self_introduction;

  /// No description provided for @email.
  ///
  /// In ja, this message translates to:
  /// **'メールアドレス'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ja, this message translates to:
  /// **'パスワード(６文字以上)'**
  String get password;

  /// No description provided for @create_account.
  ///
  /// In ja, this message translates to:
  /// **'アカウント作成'**
  String get create_account;

  /// No description provided for @tweet.
  ///
  /// In ja, this message translates to:
  /// **'tweet'**
  String get tweet;

  /// No description provided for @update.
  ///
  /// In ja, this message translates to:
  /// **'更新'**
  String get update;

  /// No description provided for @log_out.
  ///
  /// In ja, this message translates to:
  /// **'ログアウト'**
  String get log_out;

  /// No description provided for @log_in.
  ///
  /// In ja, this message translates to:
  /// **'ログイン'**
  String get log_in;

  /// No description provided for @app_title.
  ///
  /// In ja, this message translates to:
  /// **'TDR APP'**
  String get app_title;

  /// No description provided for @score.
  ///
  /// In ja, this message translates to:
  /// **'点'**
  String get score;

  /// No description provided for @impressions.
  ///
  /// In ja, this message translates to:
  /// **'感想'**
  String get impressions;

  /// No description provided for @is_spoiler_true.
  ///
  /// In ja, this message translates to:
  /// **'ネタバレあり!'**
  String get is_spoiler_true;

  /// No description provided for @is_spoiler_false.
  ///
  /// In ja, this message translates to:
  /// **'ネタバレなし!'**
  String get is_spoiler_false;

  /// No description provided for @twitter_hint_text.
  ///
  /// In ja, this message translates to:
  /// **'TwitterのID'**
  String get twitter_hint_text;

  /// No description provided for @instagram_hint_text.
  ///
  /// In ja, this message translates to:
  /// **'InstagramのID'**
  String get instagram_hint_text;

  /// No description provided for @sns_title.
  ///
  /// In ja, this message translates to:
  /// **'🚫 SNS情報公開に関する警告 🚫'**
  String get sns_title;

  /// No description provided for @sns_description.
  ///
  /// In ja, this message translates to:
  /// **'SNS上での情報公開には慎重な取り扱いが求められます。よく理解し、自身の情報を保護するための対策を講じてください。\n\n公開情報の管理は各自の責任で行ってください。\n\nもし、なりすましを疑われるアカウントを発見された場合、以下のフォームに情報を入力してください。'**
  String get sns_description;

  /// No description provided for @sns_report.
  ///
  /// In ja, this message translates to:
  /// **'報告する'**
  String get sns_report;

  /// No description provided for @register_screen.
  ///
  /// In ja, this message translates to:
  /// **'新規登録はこちら'**
  String get register_screen;

  /// No description provided for @login_screen.
  ///
  /// In ja, this message translates to:
  /// **'パスワードを忘れた場合'**
  String get login_screen;

  /// No description provided for @reset_password.
  ///
  /// In ja, this message translates to:
  /// **'パスワードの再設定'**
  String get reset_password;

  /// No description provided for @send_reset_message.
  ///
  /// In ja, this message translates to:
  /// **'メールアドレスにパスワード再設定のメールを送信します。'**
  String get send_reset_message;

  /// No description provided for @send_email.
  ///
  /// In ja, this message translates to:
  /// **'メールを送る'**
  String get send_email;

  /// No description provided for @send_message.
  ///
  /// In ja, this message translates to:
  /// **'メールを送信しました。'**
  String get send_message;

  /// No description provided for @completed_to_create_account.
  ///
  /// In ja, this message translates to:
  /// **'アカウント登録完了'**
  String get completed_to_create_account;

  /// No description provided for @completed_to_create_account_content.
  ///
  /// In ja, this message translates to:
  /// **'アカウントの登録が完了しました。\n確認用のメールをお送りしました。\nメール内のリンクをクリックし、\n認証を行ってください。'**
  String get completed_to_create_account_content;

  /// No description provided for @error_empty_register.
  ///
  /// In ja, this message translates to:
  /// **'登録してた内容に不備があります'**
  String get error_empty_register;

  /// No description provided for @error_empty_email.
  ///
  /// In ja, this message translates to:
  /// **'メールアドレスを入力してください'**
  String get error_empty_email;

  /// No description provided for @error_empty_post.
  ///
  /// In ja, this message translates to:
  /// **'いずれかの値が未記入となっています'**
  String get error_empty_post;

  /// No description provided for @error_badly_formatted.
  ///
  /// In ja, this message translates to:
  /// **'メールアドレスの形式が不正です。'**
  String get error_badly_formatted;

  /// No description provided for @error_6_characters.
  ///
  /// In ja, this message translates to:
  /// **'パスワードは６文字以上に設定してください。'**
  String get error_6_characters;

  /// No description provided for @error_already.
  ///
  /// In ja, this message translates to:
  /// **'このメールアドレスはすでに使用されています。'**
  String get error_already;

  /// No description provided for @error_other.
  ///
  /// In ja, this message translates to:
  /// **'不鮮明のエラーです。運営側にお伝えください。'**
  String get error_other;

  /// No description provided for @error_no_mail.
  ///
  /// In ja, this message translates to:
  /// **'メールアドレスの認証が完了していません。'**
  String get error_no_mail;

  /// No description provided for @error_screen.
  ///
  /// In ja, this message translates to:
  /// **'アプリに問題が発生しました。'**
  String get error_screen;

  /// No description provided for @error_invalid_email.
  ///
  /// In ja, this message translates to:
  /// **'メールアドレスが間違っています。'**
  String get error_invalid_email;

  /// No description provided for @error_wrong_password.
  ///
  /// In ja, this message translates to:
  /// **'パスワードが間違っています。'**
  String get error_wrong_password;

  /// No description provided for @error_user_not_found.
  ///
  /// In ja, this message translates to:
  /// **'このアカウントは存在しません。'**
  String get error_user_not_found;

  /// No description provided for @error_user_disabled.
  ///
  /// In ja, this message translates to:
  /// **'このメールアドレスは無効になっています。'**
  String get error_user_disabled;

  /// No description provided for @error_too_many_requests.
  ///
  /// In ja, this message translates to:
  /// **'回線が混雑しています。もう一度試してみてください'**
  String get error_too_many_requests;

  /// No description provided for @error_operation_not_allowed.
  ///
  /// In ja, this message translates to:
  /// **'メールアドレスとパスワードでのログインは有効になっていません。'**
  String get error_operation_not_allowed;

  /// No description provided for @error_email_already_exists.
  ///
  /// In ja, this message translates to:
  /// **'このメールアドレスはすでに登録されています。'**
  String get error_email_already_exists;

  /// No description provided for @error_undefined.
  ///
  /// In ja, this message translates to:
  /// **'予期せぬエラーが発生しました。'**
  String get error_undefined;

  /// No description provided for @retry.
  ///
  /// In ja, this message translates to:
  /// **'リトライ'**
  String get retry;

  /// No description provided for @dialog_spoiler_cell_text.
  ///
  /// In ja, this message translates to:
  /// **'ネタバレがあります!!!\n遷移して確認ください🙇‍'**
  String get dialog_spoiler_cell_text;

  /// No description provided for @dialog_contact_title.
  ///
  /// In ja, this message translates to:
  /// **'お問い合わせ画面に遷移'**
  String get dialog_contact_title;

  /// No description provided for @dialog_contact_contents.
  ///
  /// In ja, this message translates to:
  /// **'投稿について問い合わせるサイトに\n遷移します。よろしいですか？'**
  String get dialog_contact_contents;

  /// No description provided for @dialog_delete_check_title.
  ///
  /// In ja, this message translates to:
  /// **'削除確認'**
  String get dialog_delete_check_title;

  /// No description provided for @dialog_delete_check_content.
  ///
  /// In ja, this message translates to:
  /// **'投稿を削除してもよろしいでしょうか？\n復元はできなくなっております。'**
  String get dialog_delete_check_content;

  /// No description provided for @dialog_cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get dialog_cancel;

  /// No description provided for @dialog_ok.
  ///
  /// In ja, this message translates to:
  /// **'OK'**
  String get dialog_ok;

  /// No description provided for @dialog_log_out_check_title.
  ///
  /// In ja, this message translates to:
  /// **'ログアウト確認'**
  String get dialog_log_out_check_title;

  /// No description provided for @dialog_log_out_check_content.
  ///
  /// In ja, this message translates to:
  /// **'ログアウトします。\nよろしいでしょうか？'**
  String get dialog_log_out_check_content;

  /// No description provided for @dialog_delete_account_title.
  ///
  /// In ja, this message translates to:
  /// **'アカウント削除確認'**
  String get dialog_delete_account_title;

  /// No description provided for @dialog_delete_account_content.
  ///
  /// In ja, this message translates to:
  /// **'アカウントの情報を削除します。\n投稿内容も全て削除されます。\nよろしいでしょうか？'**
  String get dialog_delete_account_content;

  /// No description provided for @dialog_delete_account.
  ///
  /// In ja, this message translates to:
  /// **'アカウントを削除'**
  String get dialog_delete_account;

  /// No description provided for @dialog_register_account_title.
  ///
  /// In ja, this message translates to:
  /// **'アカウント登録完了'**
  String get dialog_register_account_title;

  /// No description provided for @dialog_register_account_content.
  ///
  /// In ja, this message translates to:
  /// **'アカウントの登録が完了しました。\n確認用のメールをお送りしました。\nメール内のリンクをクリックし、\n認証を行ってください。'**
  String get dialog_register_account_content;

  /// No description provided for @app_bar_create_account.
  ///
  /// In ja, this message translates to:
  /// **'Create Account'**
  String get app_bar_create_account;

  /// No description provided for @app_bar_login.
  ///
  /// In ja, this message translates to:
  /// **'Login'**
  String get app_bar_login;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ja': return L10nJa();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
