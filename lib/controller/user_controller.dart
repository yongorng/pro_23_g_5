import 'package:get/get.dart';
import 'package:flutter/material.dart';

class UserController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> _users = <Map<String, dynamic>>[].obs;
  final RxString searchQuery = ''.obs;

  // Mock Data (ជំនួសដោយ API ពេលក្រោយ)
  final List<Map<String, dynamic>> _mockUsers = [
    {'id': 1, 'name': 'Admin', 'email': 'admin@example.com', 'role': 'AD'},
    {'id': 2, 'name': 'Student', 'email': 'ny168@example.com', 'role': 'ST'},
    {'id': 3, 'name': 'Tha Bunna', 'email': 'bona84908@gmail.com', 'role': 'TH'},
    {'id': 4, 'name': 'BK', 'email': 'bk@gmail.com', 'role': 'BK'},
    {'id': 5, 'name': 'Vannak', 'email': 'vannak@example.com', 'role': 'VA'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      // TODO: ហៅ API ជំនួសវិញពេលក្រោយ
      await Future.delayed(const Duration(milliseconds: 500));
      _users.clear();
      _users.addAll(_mockUsers);
      debugPrint('ទាញយកអ្នកប្រើរប្រាស់ ${_users.length} នាក់');
    } catch (e) {
      debugPrint('Error: $e');
      Get.snackbar('Error', 'Failed to load users',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get users {
    if (searchQuery.value.isEmpty) {
      return _users;
    }
    return _users.where((user) {
      final name = user['name'].toString().toLowerCase();
      final email = user['email'].toString().toLowerCase();
      final query = searchQuery.value.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();
  }

  Future<void> deleteUser(int userId) async {
    try {
      // TODO: ហៅ API ដើម្បីលុប
      await Future.delayed(const Duration(milliseconds: 300));
      _users.removeWhere((user) => user['id'] == userId);
      Get.snackbar('Success', 'User deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> updateUser(Map<String, dynamic> updatedUser) async {
    try {
      // TODO: ហៅ API ដើម្បី update
      await Future.delayed(const Duration(milliseconds: 300));
      final index = _users.indexWhere((user) => user['id'] == updatedUser['id']);
      if (index != -1) {
        _users[index] = updatedUser;
      }
      Get.snackbar('Success', 'User updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
  Future<void> addUser(Map<String, dynamic> newUser) async {
    try {
      // TODO: ហៅ API ដើម្បីបន្ថែម
      await Future.delayed(const Duration(milliseconds: 300));


      final newId = _users.isEmpty ? 1 : _users.map((u) => u['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
      newUser['id'] = newId;


      _users.add(newUser);

      Get.snackbar('Success', 'User added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add user',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}