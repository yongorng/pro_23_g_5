import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/post_controller.dart';
import '../../theme/app_color.dart';
import '../post/create_post_screen.dart';
import 'widgets/post_menu_actions.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final RxString _searchQuery = ''.obs;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();


    final controller = Get.find<PostController>();
    controller.fetchPosts();

    // ២. Scroll Listener សម្រាប់ Load More
    _scrollController.addListener(() {
      if (_searchQuery.value.isEmpty &&
          _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        controller.loadMorePosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final controller = Get.find<PostController>();
    await controller.fetchPosts();

    // Reset search query when refreshing
    _searchQuery.value = '';
  }

  @override
  Widget build(BuildContext context) {
    final PostController controller = Get.find<PostController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'.tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'ស្វែងរកតាមចំណងជើង'.tr,
                    prefixIcon: const Icon(Icons.search, color: AppColor.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColor.primary),
                    ),
                    filled: true,
                    fillColor: AppColor.surface,
                  ),
                  onChanged: (value) {
                    _searchQuery.value = value;
                  },
                ),
                const SizedBox(height: 8),

                Obx(() {
                  final totalPosts = controller.allPosts.length;
                  final filteredCount = controller.posts.where((post) {
                    return post.title.toLowerCase().contains(_searchQuery.value.toLowerCase());
                  }).length;

                  final displayCount = _searchQuery.value.isEmpty
                      ? controller.posts.length
                      : filteredCount;

                  return Text(
                    'បង្ហាញ $displayCount ក្នុងចំណោម $totalPosts',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }),
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColor.primary,
              backgroundColor: Colors.white,
              displacement: 100,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredPosts = controller.posts.where((post) {
                  return post.title.toLowerCase().contains(_searchQuery.value.toLowerCase());
                }).toList();

                if (filteredPosts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 64,
                          color: AppColor.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.value.isEmpty ? 'No posts found' : 'No matching posts',
                          style: TextStyle(color: AppColor.textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredPosts.length + (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == filteredPosts.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final post = filteredPosts[index];
                    String displayText = 'No description';
                    if (post.description.isNotEmpty) {
                      displayText = post.description.length > 50
                          ? '${post.description.substring(0, 50)}...'
                          : post.description;
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColor.primary,
                          child: post.imageUrl != null && post.imageUrl!.isNotEmpty
                              ? ClipOval(
                            child: Image.network(
                              post.imageUrl!,
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.article, color: AppColor.textOnPrimary),
                            ),
                          )
                              : const Icon(Icons.article, color: AppColor.textOnPrimary),
                        ),
                        title: Text(
                          post.title,
                          style: const TextStyle(color: AppColor.textPrimary),
                        ),
                        subtitle: Text(
                          displayText,
                          style: const TextStyle(color: AppColor.textSecondary),
                        ),
                        trailing: PostMenuActions(post: post, controller: controller),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'post_new_post',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
        },
        backgroundColor: AppColor.primary,
        icon: const Icon(Icons.add, color: AppColor.textOnPrimary),
        label: Text('New Post'.tr, style: const TextStyle(color: AppColor.textOnPrimary)),
      ),
    );
  }
}