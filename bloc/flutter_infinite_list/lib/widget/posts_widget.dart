import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/bloc/posts_bloc.dart';
import 'package:flutter_infinite_list/model/post.dart';
import 'package:flutter_infinite_list/model/post_status_model.dart';
import 'package:flutter_infinite_list/widget/bottom_loader_widget.dart';
import 'package:flutter_infinite_list/widget/post_widget.dart';

class PostsWidget extends StatefulWidget {
  PostsWidget({Key? key}) : super(key: key);

  @override
  State<PostsWidget> createState() => _PostsWidgetState();
}

class _PostsWidgetState extends State<PostsWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostState>(builder: _blocBuilder);
  }

  Widget _blocBuilder(BuildContext context, PostState state) {
    switch (state.status) {
      case PostStatus.initial:
        return Center(child: CircularProgressIndicator());
      case PostStatus.success:
        return _buildPostList(state.posts, state.hasReachedMax);
      case PostStatus.failure:
        return Center(
          child: Text("Não foi possível obter a listagem de posts."),
        );
    }
  }

  Widget _buildPostList(List<Post> posts, bool hasReachedBottom) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return index >= posts.length
            ? BottomLoaderWidget()
            : PostWidget(post: posts[index]);
      },
      itemCount: hasReachedBottom ? posts.length : posts.length + 1,
      controller: _scrollController,
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<PostsBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
