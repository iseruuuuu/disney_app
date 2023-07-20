import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingProvider = StateNotifierProvider.autoDispose<Loading, bool>(
  (ref) {
    return Loading(loading: false);
  },
);

class Loading extends StateNotifier<bool> {
  Loading({required bool loading}) : super(loading);

  bool get isLoading => state;

  set isLoading(bool loading) {
    state = loading;
  }
}
