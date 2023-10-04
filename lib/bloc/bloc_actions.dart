import 'package:ba_flutter_testing_block/models/person.dart';
import 'package:flutter/foundation.dart' show immutable;

const String person1Url = "http://10.0.2.2:5500/api/person1.json";
const String person2Url = "http://10.0.2.2:5500/api/person2.json";

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final String url;
  final PersonsLoader loader;

  const LoadPersonAction({required this.loader, required this.url}) : super();
}
