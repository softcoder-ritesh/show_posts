import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/post_bloc.dart';
import '../blocs/post_event.dart';
import '../blocs/post_state.dart';
import '../widgets/post_item.dart';

class PostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PostLoadedState) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                final isRead = state.readPosts.contains(post.id);
                return PostItem(post: post, isRead: isRead);
              },
            );
          } else if (state is PostErrorState) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Unknown error'));
          }
        },
      ),
    );
  }
}
