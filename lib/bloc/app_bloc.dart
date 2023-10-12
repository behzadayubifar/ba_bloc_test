import 'dart:io';

import 'package:ba_flutter_testing_block/auth/auth_error.dart';
import 'package:ba_flutter_testing_block/bloc/app_event.dart';
import 'package:ba_flutter_testing_block/bloc/app_state.dart';
import 'package:ba_flutter_testing_block/utils/upload_image.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLoggedOut(isLoading: false)) {
    on<AppEventGoToRegistration>(
      (event, emit) {
        emit(
          const AppStateIsInRegistrationView(
            isLoading: false,
          ),
        );
      },
    );

    on<AppEventLogIn>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));
// log the user in
      try {
        final email = event.email;
        final password = event.password;
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        final user = userCredential.user!;
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedOut(isLoading: false, authError: AuthError.from(e)));
      }
      // get images for the user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }
      final images = await _getImages(user.uid);
      emit(
        AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: images,
        ),
      );
    });

    on<AppEventGoToLogin>(
      (event, emit) {
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
      },
    );

    on<AppEventRegister>(
      (event, emit) async {
        // start the loading process
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        final email = event.email;
        final password = event.password;
        try {
          final userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: userCredential.user!,
              images: const [],
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateIsInRegistrationView(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AppEventInitialize>(
      (event, emit) async {
        // get the current user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(const AppStateLoggedOut(isLoading: false));
        } else {
          // go grab the user's uploaded images
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: images,
            ),
          );
        }
      },
    );

    // log out event
    on<AppEventLogOut>(
      (event, emit) async {
        // start the loading process
        emit(const AppStateLoggedOut(isLoading: true));
        // log the user out
        await FirebaseAuth.instance.signOut();
        // log the user out in the UI as well
        emit(const AppStateLoggedOut(isLoading: false));
      },
    );

    // handle account deletion
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      // log the user out if we don't have a user
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }
      // start the loading process
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ),
      );
      // delete the user folder
      try {
        // delete user folder from Firebase Storage
        final folderContents =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folderContents.items) {
          await item.delete().catchError((_) {}); // maybe handle the error?
        }
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});

        // delete user from Firebase Auth
        await user.delete();
        // log the user out
        await FirebaseAuth.instance.signOut();
        // log the user out in the UI as well
        emit(const AppStateLoggedOut(isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: state.images ?? [],
            authError: AuthError.from(e),
          ),
        );
      } on FirebaseException {
        // we might not be able to delete the user folder
        // log the user out
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
      }
    });

    // handle uploading images
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }
      // start the loading process
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ),
      );
      // upload the image
      final file = File(event.filePathToUpload);
      await uploadImage(file: file, userId: user.uid);
      // after uploading the image, get the images again
      final images = await _getImages(user.uid);
      // emit the new images and stop the loading process
      emit(
        AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: images,
        ),
      );
    });
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
