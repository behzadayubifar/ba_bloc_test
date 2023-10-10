import 'package:ba_flutter_testing_block/bloc/app_state.dart';
import 'package:ba_flutter_testing_block/bloc/bloc_events.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allurls);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        math.Random().nextInt(length),
      );
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> allurls) => allurls.getRandomElement();

  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
  }) : super(const AppState.initial()) {
    // start loading
    on<LoadNextUrlEvent>(
      (event, emit) async {
        emits(
          const AppState(isLoading: true, data: null, error: null),
        );
        final url = (urlPicker ?? _pickRandomUrl)(urls);
        try {
          if (waitBeforeLoading != null) {
            await Future.delayed(waitBeforeLoading);
          }
          final bundle = NetworkAssetBundle(Uri.parse(url));
          final data = (await bundle.load(url)).buffer.asUint8List();
          emit(
            AppState(
              isLoading: false,
              data: data,
              error: null,
            ),
          );
        } catch (e) {
          emit(
            AppState(isLoading: false, data: null, error: e),
          );
        }
      },
    );
  }
}
