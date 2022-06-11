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
    PostFetched event,
    Emitter<PostState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostStatus.initial) {
        final posts = await repository.getPosts();
        return emit(state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasReachedMax: false,
        ));
      }
      final posts = await repository.getPosts();
      emit(posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: PostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: false,
            ));
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }
}
