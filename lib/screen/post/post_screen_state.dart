// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_screen_state.freezed.dart';

@freezed
class PostScreenState with _$PostScreenState {
  const factory PostScreenState({
    @Default(0) int rank,
    @Default("") String attractionName,
    @Default(false) bool isSelected,
  }) = _PostScreenState;
}
