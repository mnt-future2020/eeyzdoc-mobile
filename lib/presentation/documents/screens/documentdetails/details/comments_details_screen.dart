import 'package:flutter/material.dart';

class CommentsDetailsScreen extends StatefulWidget {
  const CommentsDetailsScreen({super.key});

  @override
  State<CommentsDetailsScreen> createState() => _CommentsDetailsScreenState();
}

class _CommentsDetailsScreenState extends State<CommentsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Comment Tab"));
  }
}
