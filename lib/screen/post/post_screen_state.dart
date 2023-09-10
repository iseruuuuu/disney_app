import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_screen_state.freezed.dart';

@freezed
class PostScreenState with _$PostScreenState {
  const factory PostScreenState({
    @Default(0) double rank,
    @Default('') String attractionName,
    @Default(false) bool isSelected,
    @Default(false) bool isSpoiler,
  }) = _PostScreenState;
}
