import 'package:flutter/foundation.dart' show immutable;

class LoginHandle {
  final String token;

  LoginHandle({
    required this.token,
  });

  const LoginHandle.fooBar() : token = 'fooBar';

  @override
  bool operator ==(covariant LoginHandle other) {
    return token == other.token;
  }

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() => 'LoginHandle(token: $token)';
}

enum LoginErrors {
  invalidHandle,
}

@immutable
class Note {
  final String title;

  Note({
    required this.title,
  });

  @override
  String toString() => 'Note{title: $title}';

  static final mockNotes =
      Iterable.generate(3, (i) => Note(title: 'Note ${i + 1}'));
}
