import 'package:ba_flutter_testing_block/apis/login_api.dart';
import 'package:ba_flutter_testing_block/apis/notes_api.dart';
import 'package:ba_flutter_testing_block/bloc/actions.dart';
import 'package:ba_flutter_testing_block/bloc/app_state.dart';
import 'package:ba_flutter_testing_block/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.initial()) {
    on<LoginAction>(
      (event, emit) async {
        // start loading
        emit(state.copyWith(isLoading: true));
        // log the user in
        final loginHandle = await loginApi.login(
          email: event.email,
          password: event.password,
        );
        emit(
          state.copyWith(
            isLoading: false,
            loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandle,
          ),
        );
      },
    );

    // load notes
    on<LoadNotesAction>(
      (event, emit) async {
        // start loading
        emit(state.copyWith(isLoading: true));
        final loginHandle = state.loginHandle;
        if (loginHandle != const LoginHandle.fooBar()) {
          // invalid login handle, cannot fetch notes
          emit(
            state.copyWith(
              isLoading: false,
              loginError: LoginErrors.invalidHandle,
              loginHandle: loginHandle,
            ),
          );
          return;
        }

        // we have a valid login handle and want to fetch notes
        final notes = await notesApi.getNotes(
          loginHandle: loginHandle!,
        );
        emit(
          state.copyWith(
            isLoading: false,
            loginError: null,
            loginHandle: loginHandle,
            notes: notes,
          ),
        );
      },
    );
  }
}
