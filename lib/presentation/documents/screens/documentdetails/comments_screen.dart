import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/request/CommentArgs.dart';
import '../../../../data/models/response/comment_model.dart';

class CommentsScreen extends StatelessWidget {
  final CommentArgs commentArgs;

  CommentsScreen({super.key, required this.commentArgs});

  final controller = Get.find<DocumentsController>();

  @override
  Widget build(BuildContext context) {

    return FocusDetector(
      onVisibilityGained: (){
        controller.getCommentList(commentArgs.documentId);
      },
      child: Scaffold(
          appBar: commentArgs.flagAppbar?AppBar(
            backgroundColor: Colors.red,
            elevation: 2,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                controller.commentModelList.clear();
                controller.commentsTextEditingController.clear();
                GoRouter.of(context).pop();
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Comments",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,

                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                 Text(
                   commentArgs.documentName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            centerTitle: false,
          ):null,
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.commentModelList.isEmpty) {
                  return const Center(child: Text("No comments yet"));
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.commentModelList.length,
                  itemBuilder: (_, index) =>
                      _commentCard(controller.commentModelList[index], context),
                );
              }),
            ),
            _commentInput(),
          ],
        ),

      ),
    );
  }

  Widget _commentCard(CommentModel comment,BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                comment.createdByName.isEmpty?SizedBox.shrink():  CircleAvatar(
                  backgroundColor: Colors.red.shade100,
                  child: Text(
                    comment.createdByName[0],
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.createdByName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a')
                            .format(comment.createdDate.toLocal()),
                        style:
                        TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      controller.deleteCommentDialog( commentArgs.documentId,comment.id,context),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              comment.comment.isNotEmpty
                  ? comment.comment
                  : "No comment text",
              style: comment.comment.isNotEmpty
                  ? const TextStyle()
                  : TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _commentInput() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.commentsTextEditingController,
              decoration: const InputDecoration(
                hintText: "Add a comment...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.red),
            onPressed: () => controller.addComments(documentId: commentArgs.documentId,description: controller.commentsTextEditingController.text),
          )
        ],
      ),
    );
  }
}
