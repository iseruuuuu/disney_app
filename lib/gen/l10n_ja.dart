import 'l10n.dart';

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get app_name => 'TDR APP';

  @override
  String get attraction => 'アトラクション';

  @override
  String get no_post => '投稿がまだありません';

  @override
  String get edit => '編集';

  @override
  String get sns_edit => 'SNS';

  @override
  String get post => '投稿';

  @override
  String get name => '名前';

  @override
  String get user_id => 'ユーザーID';

  @override
  String get self_introduction => '自己紹介';

  @override
  String get email => 'メールアドレス';

  @override
  String get password => 'パスワード(６文字以上)';

  @override
  String get create_account => 'アカウント作成';

  @override
  String get tweet => 'tweet';

  @override
  String get update => '更新';

  @override
  String get log_out => 'ログアウト';

  @override
  String get log_in => 'ログイン';

  @override
  String get app_title => 'TDR APP';

  @override
  String get score => '点';

  @override
  String get impressions => '感想';

  @override
  String get is_spoiler_true => 'ネタバレあり!';

  @override
  String get is_spoiler_false => 'ネタバレなし!';

  @override
  String get twitter_hint_text => 'TwitterのID';

  @override
  String get instagram_hint_text => 'InstagramのID';

  @override
  String get sns_title => '🚫 SNS情報公開に関する警告 🚫';

  @override
  String get sns_description => 'SNS上での情報公開には慎重な取り扱いが求められます。よく理解し、自身の情報を保護するための対策を講じてください。\n\n公開情報の管理は各自の責任で行ってください。\n\nもし、なりすましを疑われるアカウントを発見された場合、以下のフォームに情報を入力してください。';

  @override
  String get sns_report => '報告する';

  @override
  String get register_screen => '新規登録はこちら';

  @override
  String get login_screen => 'パスワードを忘れた場合';

  @override
  String get reset_password => 'パスワードの再設定';

  @override
  String get send_reset_message => 'メールアドレスにパスワード再設定のメールを送信します。';

  @override
  String get send_email => 'メールを送る';

  @override
  String get send_message => 'メールを送信しました。';

  @override
  String get completed_to_create_account => 'アカウント登録完了';

  @override
  String get completed_to_create_account_content => 'アカウントの登録が完了しました。\n確認用のメールをお送りしました。\nメール内のリンクをクリックし、\n認証を行ってください。';

  @override
  String get error_empty_register => '登録してた内容に不備があります';

  @override
  String get error_empty_email => 'メールアドレスを入力してください';

  @override
  String get error_empty_post => 'いずれかの値が未記入となっています';

  @override
  String get error_badly_formatted => 'メールアドレスの形式が不正です。';

  @override
  String get error_6_characters => 'パスワードは６文字以上に設定してください。';

  @override
  String get error_already => 'このメールアドレスはすでに使用されています。';

  @override
  String get error_other => '不鮮明のエラーです。運営側にお伝えください。';

  @override
  String get error_password => 'パスワード or メールアドレスが間違っています';

  @override
  String get error_disabled => 'ログイン試行過多により、アカウントが一時ロックされています。';

  @override
  String get error_no_user => 'アカウントが存在しない or 削除された可能性があります。';

  @override
  String get error_no_mail => 'メールアドレスの認証が完了していません。';

  @override
  String get error_screen => 'アプリに問題が発生しました。';

  @override
  String get retry => 'リトライ';

  @override
  String get dialog_spoiler_cell_text => 'ネタバレがあります!!!\n遷移して確認ください🙇‍';

  @override
  String get dialog_contact_title => 'お問い合わせ画面に遷移';

  @override
  String get dialog_contact_contents => '投稿について問い合わせるサイトに\n遷移します。よろしいですか？';

  @override
  String get dialog_delete_check_title => '削除確認';

  @override
  String get dialog_delete_check_content => '投稿を削除してもよろしいでしょうか？\n復元はできなくなっております。';

  @override
  String get dialog_cancel => 'キャンセル';

  @override
  String get dialog_ok => 'OK';

  @override
  String get dialog_log_out_check_title => 'ログアウト確認';

  @override
  String get dialog_log_out_check_content => 'ログアウトします。\nよろしいでしょうか？';

  @override
  String get dialog_delete_account_title => 'アカウント削除確認';

  @override
  String get dialog_delete_account_content => 'アカウントの情報を削除します。\n投稿内容も全て削除されます。\nよろしいでしょうか？';

  @override
  String get dialog_delete_account => 'アカウントを削除';

  @override
  String get dialog_register_account_title => 'アカウント登録完了';

  @override
  String get dialog_register_account_content => 'アカウントの登録が完了しました。\n確認用のメールをお送りしました。\nメール内のリンクをクリックし、\n認証を行ってください。';

  @override
  String get app_bar_create_account => 'Create Account';

  @override
  String get app_bar_login => 'Login';
}
