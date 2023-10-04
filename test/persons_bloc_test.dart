import 'package:ba_flutter_testing_block/bloc/bloc_actions.dart';
import 'package:ba_flutter_testing_block/bloc/persons_bloc.dart';
import 'package:ba_flutter_testing_block/models/person.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPersons1 = [
  Person(name: "foo", age: 22),
  Person(name: "Bar", age: 62),
];

const mockedPersons2 = [
  Person(name: "foo", age: 22),
  Person(name: "Bar", age: 62),
];

Future<Iterable<Person>> mockGetPerson1(String _) =>
    Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPerson2(String _) =>
    Future.value(mockedPersons2);

void main() {
  group(
    'Testing blov',
    () {
      // write our tests

      late PersonsBloc bloc;

      setUp(() {
        bloc = PersonsBloc();
      });

      blocTest<PersonsBloc, FetchResult?>(
        'Test initial state',
        build: () => bloc,
        verify: (bloc) => expect(bloc.state, null),
      );

      // fetch mock data (persons1) and compare it with FetchResult
      blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving persons from first iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonAction(loader: mockGetPerson1, url: 'dummy_url_1'),
          );
          bloc.add(
            const LoadPersonAction(loader: mockGetPerson1, url: 'dummy_url_1'),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPersons1,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPersons1,
            isRetrievedFromCache: true,
          ),
        ],
      );

      // fetch mock data (persons2) and compare it with FetchResult
      blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving persons from first iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonAction(loader: mockGetPerson2, url: 'dummy_url_2'),
          );
          bloc.add(
            const LoadPersonAction(loader: mockGetPerson2, url: 'dummy_url_2'),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPersons2,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPersons2,
            isRetrievedFromCache: true,
          ),
        ],
      );
    },
  );
}
