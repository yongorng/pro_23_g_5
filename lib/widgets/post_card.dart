import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/post_model.dart';
import '../controller/post_controller.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final PostController controller = Get.find<PostController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildImage(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        post.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    if (post.status == 'draft') _buildDraftBadge(),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  post.description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${post.date}',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          _buildPopupMenu(context, controller),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (post.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 60,
          height: 60,
          child: Image.network(
            post.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, ___) => _buildDefaultIcon(),
          ),
        ),
      );
    }
    return _buildDefaultIcon();
  }

  Widget _buildDefaultIcon() {
    final isDraft = post.status == 'draft';
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isDraft ? Colors.orange.shade100 : Colors.teal.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        isDraft ? Icons.article_outlined : Icons.article,
        color: isDraft ? Colors.orange : Colors.teal,
        size: 30,
      ),
    );
  }

  Widget _buildDraftBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Draft',
        style: TextStyle(color: Colors.red.shade700, fontSize: 12),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, PostController controller) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'edit') {
          _showEditDialog(context, controller);
        } else if (value == 'unpublish') {
          controller.togglePublishStatus(post);
          Get.snackbar(
            'Status Changed',
            post.status == 'published' ? 'Post unpublished' : 'Post published',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        } else if (value == 'delete') {
          _showDeleteConfirmation(context, controller);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(children: [Icon(Icons.edit, size: 20), SizedBox(width: 12), Text('Edit')]),
        ),
        const PopupMenuItem(
          value: 'unpublish',
          child: Row(children: [Icon(Icons.visibility_off, size: 20), SizedBox(width: 12), Text('Unpublish')]),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 20), SizedBox(width: 12), Text('Delete', style: TextStyle(color: Colors.red))]),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, PostController controller) {
    final titleController = TextEditingController(text: post.title);
    final descController = TextEditingController(text: post.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                controller.updatePost(PostModel(
                  id: post.id,
                  title: titleController.text,
                  description: descController.text,
                  author: post.author,
                  date: post.date,
                  status: post.status,
                  imageUrl: post.imageUrl,
                ));
                Navigator.pop(context);
                Get.snackbar('Success', 'Post updated successfully',
                    snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, PostController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: Text('Are you sure you want to delete "${post.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (post.id != null) {
                controller.deletePost(post.id!);
              }
              Navigator.pop(context);
              Get.snackbar('Deleted', 'Post "${post.title}" deleted',
                  snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}