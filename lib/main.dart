import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/post_bloc.dart';
import 'blocs/post_event.dart';
import 'repositories/post_repository.dart';
import 'screens/post_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: RepositoryProvider(
        create: (_) => PostRepository(),
        child: BlocProvider(
          create: (context) =>
          PostBloc(repository: context.read<PostRepository>())..add(LoadPostsEvent()),
          child: PostListScreen(),
        ),
      ),
    );
  }
}
