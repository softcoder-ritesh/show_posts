import '../models/post_model.dart';
abstract class PostState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}


class PostLoadingState extends PostState {}

class PostLoadedState extends PostState {
  final List<PostModel> posts;
  final Set<int> readPosts;

  PostLoadedState(this.posts, this.readPosts);

  @override
  List<Object> get props => [posts, readPosts];
}

class PostErrorState extends PostState {
  final String message;

  PostErrorState(this.message);

  @override
  List<Object> get props => [message];
}
