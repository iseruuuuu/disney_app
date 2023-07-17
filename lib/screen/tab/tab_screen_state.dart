import 'package:freezed_annotation/freezed_annotation.dart';

part 'tab_screen_state.freezed.dart';

@freezed
class TabScreenState with _$TabScreenState {
  const factory TabScreenState({
    @Default(0) int selectedIndex,
  }) = _TabScreenState;
}
