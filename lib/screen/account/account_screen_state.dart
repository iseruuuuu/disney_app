import 'package:disney_app/core/model/account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_screen_state.freezed.dart';

@freezed
class AccountScreenState with _$AccountScreenState {
  const factory AccountScreenState({
    required Account myAccount,
  }) = _AccountScreenState;
}
