import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../blocs/post_bloc.dart';
import '../blocs/post_event.dart';
import '../blocs/post_state.dart';
import '../models/post_model.dart';
import '../screens/post_detail_screen.dart';

class PostItem extends StatefulWidget {
  final PostModel post;
  final bool isRead;

  const PostItem({required this.post, required this.isRead, Key? key}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late int timerDuration;
  int currentDuration = 0;
  Timer? _timer;
  bool isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    timerDuration = Random().nextInt(15) + 10; // Random duration between 10-25 seconds
    currentDuration = timerDuration;
  }

  // Start the timer
  void startTimer() {
    if (!isTimerRunning) {
      isTimerRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (currentDuration > 0) {
          setState(() {
            currentDuration--;
          });
        } else {
          timer.cancel();
          setState(() {
            isTimerRunning = false;
          });
        }
      });
    }
  }

  // Stop the timer
  void stopTimer() {
    if (isTimerRunning) {
      _timer?.cancel();
      setState(() {
        isTimerRunning = false;
      });
    }
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        // Determine if the current post is read
        bool currentIsRead = state is PostLoadedState && state.readPosts.contains(widget.post.id);

        return VisibilityDetector(
          key: Key(widget.post.id.toString()),
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0) {
              startTimer();  // Start the timer when the post item is visible
            } else {
              stopTimer();  // Stop the timer when the post item is not visible
            }
          },
          child: GestureDetector(
            onTap: () {
              // Mark the post as read when tapped
              context.read<PostBloc>().add(MarkPostAsReadEvent(widget.post.id));

              // After marking as read, update the state so the background color will change
              setState(() {
                // This will update the background color immediately
              });

              // Navigate to the Post Detail Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailScreen(post: widget.post),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: currentIsRead ? Colors.white : Colors.yellow[100], // Change color based on read status
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.post.title,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 8),
                        Text(
                          widget.post.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Icon(Icons.timer, color: Colors.grey),
                      Text(
                        '$currentDuration s',
                        style: TextStyle(color: Colors.grey),
                      ), // Timer duration
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
