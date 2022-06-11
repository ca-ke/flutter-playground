import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/page/post_page.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(App()),
  );
}

class App extends MaterialApp {
  App() : super(home: PostPage());
}
