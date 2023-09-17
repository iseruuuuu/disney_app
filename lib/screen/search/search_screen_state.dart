import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_screen_state.freezed.dart';

@freezed
class SearchScreenState with _$SearchScreenState {
  const factory SearchScreenState({
    @Default('アクアトピア') String attractionName,
    @Default(5.0) double rank,
    @Default(true) bool isAttractionSearch,
  }) = _SearchScreennState;
}
