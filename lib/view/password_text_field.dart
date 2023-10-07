import 'package:flutter/material.dart';

import 'package:ba_flutter_testing_block/constants/strings.dart'
    show enterYourPasswordHere;

class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;
  const PasswordTextField({super.key, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: true,
      obscuringCharacter: "*",
      decoration: const InputDecoration(
        hintText: enterYourPasswordHere,
      ),
    );
  }
}
