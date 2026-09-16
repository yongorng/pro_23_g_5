import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_color.dart';

class DeletePostDialog extends StatelessWidget {
  final Function onDelete;

  const DeletePostDialog({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Post'),
      content: const Text('Are you sure you want to delete this post?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onDelete();
            Get.back();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColor.error),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}