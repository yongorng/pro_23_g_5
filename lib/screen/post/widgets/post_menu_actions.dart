import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/post_model.dart';
import '../../../controller/post_controller.dart';
import '../../../theme/app_color.dart';
import 'edit_post_screen.dart';
import 'delete_post_dialog.dart';

class PostMenuActions extends StatelessWidget {
  final PostModel post;
  final PostController controller;

  const PostMenuActions({
    super.key,
    required this.post,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: AppColor.surface,
      icon: const Icon(Icons.more_vert, color: AppColor.textSecondary),
      onSelected: (value) => _handleMenuAction(context, value),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: AppColor.primary),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'toggle_status',
          child: Row(
            children: [
              Icon(
                post.status == 'published'
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColor.warning,
              ),
              const SizedBox(width: 8),
              Text(post.status == 'published' ? 'Unpublish' : 'Publish'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: AppColor.error),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPostScreen(post: post),
          ),
        );
        break;

      case 'toggle_status':
        controller.togglePublishStatus(post);
        break;

      case 'delete':
        Get.dialog(
          DeletePostDialog(
            onDelete: () {
              if (post.id != null) {
                controller.deletePost(post.id!);
              }
            },
          ),
        );
        break;
    }
  }
}