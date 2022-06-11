import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/bloc/posts_bloc.dart';
import 'package:flutter_infinite_list/data/post_repository.dart';
import 'package:flutter_infinite_list/widget/posts_widget.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Posts")),
      body: BlocProvider(
        create: (_) =>
            PostsBloc(repository: PostRepository())..add(PostFetched()),
        child: PostsWidget(),
      ),
    );
  }
}
