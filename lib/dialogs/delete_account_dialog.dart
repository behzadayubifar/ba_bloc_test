import 'package:ba_flutter_testing_block/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<bool> showDeleteAccountDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete account',
    content:
        'Are you sure you want to delete your account? You cannot undo this operation!',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete account': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
