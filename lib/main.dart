import 'package:ba_flutter_testing_block/apis/login_api.dart';
import 'package:ba_flutter_testing_block/apis/notes_api.dart';
import 'package:ba_flutter_testing_block/bloc/actions.dart';
import 'package:ba_flutter_testing_block/bloc/app_bloc.dart';
import 'package:ba_flutter_testing_block/bloc/app_state.dart';
import 'package:ba_flutter_testing_block/constants/strings.dart';
import 'package:ba_flutter_testing_block/dialog/generic_dialog.dart';
import 'package:ba_flutter_testing_block/dialog/loading_screen.dart';
import 'package:ba_flutter_testing_block/models/models.dart';
import 'package:ba_flutter_testing_block/view/iterable_list_view.dart';
import 'package:ba_flutter_testing_block/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // loading screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            // display possible errors
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog<bool>(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogDescription,
                optionBuilder: () => {ok: true},
              );
            }
            // if we are logged in, but we have no fetched notes, fetch them
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.notes == null) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
          builder: (context, appState) {
            final notes = appState.notes;
            if (notes == null) {
              return LoginView(
                (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
