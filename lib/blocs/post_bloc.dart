import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/post_repository.dart';
import '../models/post_model.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  PostBloc({required this.repository}) : super(PostLoadingState()) {
    // Load posts event
    on<LoadPostsEvent>((event, emit) async {
      emit(PostLoadingState());
      try {
        // Fetch posts from repository
        final posts = await repository.fetchPosts();
        // Emit loaded state with posts and an empty set for read posts
        emit(PostLoadedState(posts, {}));
      } catch (e) {
        emit(PostErrorState('Failed to load posts'));
      }
    });

    // Mark post as read event
    on<MarkPostAsReadEvent>((event, emit) {
      if (state is PostLoadedState) {
        // Get current state
        final currentState = state as PostLoadedState;

        // Add the post ID to the read posts set
        final updatedReadPosts = Set<int>.from(currentState.readPosts)..add(event.postId);

        // Emit the updated state with the new read posts set
        emit(PostLoadedState(currentState.posts, updatedReadPosts));
      }
    });
  }
}
