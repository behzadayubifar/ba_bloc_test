import 'package:flutter/material.dart';
import 'dart:math' as math show Random;

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

const names = ['bar', 'foo', 'baz'];

extension RandomElemment<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() => emit(names.getRandomElement());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit _namesCubit;

  @override
  void initState() {
    super.initState();
    _namesCubit = NamesCubit();
  }

  @override
  void dispose() {
    super.dispose();
    _namesCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: StreamBuilder<String?>(
          stream: _namesCubit.stream,
          builder: (context, snapshot) {
            final button = TextButton(
                onPressed: () => _namesCubit.pickRandomName(),
                child: Text('Pick a random name'));

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return button;
              case ConnectionState.waiting:
                return button;
              case ConnectionState.active:
                return Column(
                  children: [Text(snapshot.data ?? ''), button],
                );
              case ConnectionState.done:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Random Name:',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.data ?? 'No name picked yet',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 32),
                    button,
                  ],
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ));
  }
}
