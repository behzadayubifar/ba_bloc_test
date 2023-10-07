import 'package:ba_flutter_testing_block/constants/strings.dart';
import 'package:ba_flutter_testing_block/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

typedef OnLoginTapped = void Function(
  String email,
  String password,
);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTapped onLoginTapped;
  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTapped,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(login),
      onPressed: () {
        final email = emailController.text;
        final password = passwordController.text;
        if (email.isEmpty || password.isEmpty) {
          showGenericDialog(
            context: context,
            title: emailOrPassWordEmptyDialogTitle,
            content: emailOrPassWordEmptyDialogDescription,
            optionBuilder: () => {
              ok: true,
            },
          );
        } else {
          onLoginTapped(
            email,
            password,
          );
        }
      },
    );
  }
}
