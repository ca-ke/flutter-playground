import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_infinite_list/data/post_repository.dart';
import 'package:flutter_infinite_list/model/post.dart';
import 'package:flutter_infinite_list/model/post_status_model.dart';

part 'post_event.dart';
part 'post_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class PostsBloc extends Bloc<PostEvent, PostState> {
  PostsBloc({
    required this.repository,
  }) : super(const PostState()) {
    on<PostFetched>(_onPostFetched);
  }

  final IPostRepository repository;

  Future<void> _onPostFetched(
      PostFetched event, Emitter<PostState> emitter) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostStatus.initial) {
        return await getInitialPosts();
      } else {
        getPosts();
      }
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<void> getPosts() async {
    final posts = await repository.getPosts();
    if (posts.isEmpty) {
      emit(state.copyWith(hasReachedMax: true));
    } else {
      emit(
        state.copyWith(
          status: PostStatus.success,
          posts: List.of(state.posts)..addAll(posts),
          hasReachedMax: false,
        ),
      );
    }
  }

  Future<void> getInitialPosts() async {
    final posts = await repository.getPosts();
    return emit(
      state.copyWith(
        posts: posts,
        status: PostStatus.success,
        hasReachedMax: false,
      ),
    );
  }
}
