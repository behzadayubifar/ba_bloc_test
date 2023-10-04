import 'package:ba_flutter_testing_block/bloc/bloc_actions.dart';
import 'package:ba_flutter_testing_block/models/person.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    //
    on<LoadPersonAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        final cachedPerson = _cache[url]!;
        final result = FetchResult(
          persons: cachedPerson,
          isRetrievedFromCache: true,
        );
        emit(result);
      } else {
        final loader = event.loader;
        final persons = await loader(url);
        _cache[url] = persons;
        final result = FetchResult(
          persons: persons,
          isRetrievedFromCache: false,
        );
        emit(result);
      }
    });
  }
}

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() =>
      'FetchResult (isRetrievedFromCache: $isRetrievedFromCache) persons: $persons';

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualToIgnoringOrdering(other.persons) &&
      isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hashCode => Object.hash(persons, isRetrievedFromCache);
}

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}
