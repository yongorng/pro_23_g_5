import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_controller.dart';
import '../../theme/app_color.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});


  void _showUserMenu(BuildContext context, Map<String, dynamic> user) {
    final UserController controller = Get.find<UserController>();

    Get.bottomSheet(
      Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: AppColor.primary),
                title: const Text('Edit User'),
                onTap: () {
                  Get.back();
                  _showEditUserDialog(context, user);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete, color: AppColor.error),
                title: const Text(
                  'Delete User',
                  style: TextStyle(color: AppColor.error),
                ),
                onTap: () {
                  Get.back();
                  _showDeleteConfirmDialog(context, user, controller);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(
      BuildContext context, Map<String, dynamic> user, UserController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteUser(user['id']);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, Map<String, dynamic> user) {
    final TextEditingController nameController = TextEditingController(text: user['name']);
    final TextEditingController emailController = TextEditingController(text: user['email']);
    final UserController controller = Get.find<UserController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedUser = Map<String, dynamic>.from(user);
              updatedUser['name'] = nameController.text;
              updatedUser['email'] = emailController.text;
              Get.back();
              controller.updateUser(updatedUser);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  void _showAddUserDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController roleController = TextEditingController();
    final UserController controller = Get.find<UserController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Add New User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                hintText: 'Enter name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                hintText: 'email@example.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: 'Role ( initials )',
                border: OutlineInputBorder(),
                hintText: 'AD, ST, etc.',
              ),
              maxLength: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty || emailController.text.isEmpty) {
                Get.snackbar('Error', 'Please fill in all fields',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white);
                return;
              }

              Get.back();
              controller.addUser({
                'name': nameController.text,
                'email': emailController.text,
                'role': roleController.text.toUpperCase(),
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final UserController controller = Get.put(UserController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'អ្នកប្រើប្រាស់'.tr,
          style: TextStyle(color: AppColor.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() => TextField(
              decoration: InputDecoration(
                hintText: 'ស្វែងរក...'.tr,
                prefixIcon: const Icon(Icons.search, color: AppColor.primary),
                suffixIcon: controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColor.textSecondary),
                  onPressed: () => controller.searchQuery.value = '',
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColor.primary),
                ),
                filled: true,
                fillColor: AppColor.surface,
              ),
              onChanged: (value) => controller.searchQuery.value = value,
            )),
          ),
          Obx(() {
            final users = controller.users;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'បង្ហាញ ${users.length} នាក់',
                  style: TextStyle(fontSize: 12, color: AppColor.textSecondary),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = controller.users;

              if (users.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: AppColor.textSecondary),
                      SizedBox(height: 16),
                      Text('No users found', style: TextStyle(color: AppColor.textSecondary)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final initials = user['role'] ?? user['name'].toString().substring(0, 2).toUpperCase();

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColor.primary.withValues(alpha: 0.1),
                        child: Text(
                          initials,
                          style: TextStyle(color: AppColor.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        user['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.textPrimary),
                      ),
                      subtitle: Text(user['email'], style: TextStyle(color: AppColor.textSecondary)),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert, color: AppColor.textSecondary),
                        onPressed: () => _showUserMenu(context, user),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'user_add_user',
        onPressed: () {
          _showAddUserDialog(context);
        },
        backgroundColor: AppColor.primary,
        icon: const Icon(Icons.person_add, color: AppColor.textOnPrimary),
        label: Text('បន្ថែមអ្នកប្រើប្រាស់ថ្មី'.tr, style: const TextStyle(color: AppColor.textOnPrimary)),
      ),
    );
  }
}