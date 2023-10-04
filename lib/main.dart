import 'dart:convert';
import 'dart:io';

import 'package:ba_flutter_testing_block/bloc/bloc_actions.dart';
import 'package:ba_flutter_testing_block/bloc/persons_bloc.dart';
import 'package:ba_flutter_testing_block/models/person.dart';
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
      home: BlocProvider(
        create: (_) => PersonsBloc(),
        child: HomePage(),
      ),
    );
  }
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                      LoadPersonAction(url: person1Url, loader: getPersons));
                },
                child: Text('Load Person #1'),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                      LoadPersonAction(url: person2Url, loader: getPersons));
                },
                child: Text('Load Person #2'),
              ),
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (previousResult, currentResult) {
              return previousResult?.persons != currentResult?.persons;
            },
            builder: (context, fetchResult) {
              final persons = fetchResult?.persons;
              if (persons == null) {
                return SizedBox();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index]!;
                    return ListTile(
                      title: Text(person.name),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}
