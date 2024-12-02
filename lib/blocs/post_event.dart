
// post_event.dart
abstract class PostEvent {}

class LoadPostsEvent extends PostEvent {}

class MarkPostAsReadEvent extends PostEvent {
  final int postId;

  MarkPostAsReadEvent(this.postId);

  @override
  List<Object> get props => [postId];
}
