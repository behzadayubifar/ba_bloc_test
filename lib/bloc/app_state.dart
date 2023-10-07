import 'package:ba_flutter_testing_block/models/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? notes;

  const AppState({
    required this.isLoading,
    required this.loginError,
    required this.loginHandle,
    required this.notes,
  });

  const AppState.initial()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        notes = null;

  AppState copyWith({
    bool? isLoading,
    LoginErrors? loginError,
    LoginHandle? loginHandle,
    Iterable<Note>? notes,
  }) =>
      AppState(
        isLoading: isLoading ?? this.isLoading,
        loginError: loginError ?? this.loginError,
        loginHandle: loginHandle ?? this.loginHandle,
        notes: notes ?? this.notes,
      );
}
