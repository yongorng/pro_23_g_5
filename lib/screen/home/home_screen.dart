import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/post_controller.dart';
import '../../theme/app_color.dart';
import '../custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final PageController _pageController = PageController(
    viewportFraction: 1.0,
  );

  int _currentSlideIndex = 0;
  Timer? _timer;


  final List<Map<String, String>> _sliderData = [
    {'image': 'https://picsum.photos/800/400?random=1', 'title': 'Welcome', 'subtitle': 'Banner in the carousel'},
    {'image': 'https://picsum.photos/800/400?random=2', 'title': 'Latest posts', 'subtitle': 'Second banner'},
    {'image': 'https://picsum.photos/800/400?random=3', 'title': 'Community', 'subtitle': 'Join us now'},
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentSlideIndex < _sliderData.length - 1) {
        _currentSlideIndex++;
      } else {
        _currentSlideIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentSlideIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PostController controller = Get.find<PostController>();

    return Scaffold(
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Home'.tr),
            centerTitle: true,
            floating: true,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,

                    itemCount: _sliderData.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentSlideIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = _sliderData[index];


                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(item['image']!, fit: BoxFit.cover),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.9)],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                      const SizedBox(height: 4),
                                      Text(item['subtitle']!, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_sliderData.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentSlideIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentSlideIndex == index ? AppColor.primary : Colors.grey.shade300,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // Latest Posts Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Latest_Posts'.tr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.textPrimary)),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Posts List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: Obx(() {
              if (controller.isLoading.value) return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              final posts = controller.posts;
              if (posts.isEmpty) return SliverFillRemaining(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.article_outlined, size: 64, color: AppColor.textSecondary), const SizedBox(height: 16), Text('No posts available', style: TextStyle(color: AppColor.textSecondary))])));

              return SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                final post = posts[index];
                return Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(
                  leading: CircleAvatar(backgroundColor: AppColor.primary, child: post.imageUrl != null && post.imageUrl!.isNotEmpty ? ClipOval(child: Image.network(post.imageUrl!, fit: BoxFit.cover, width: 40, height: 40, errorBuilder: (_, _, _) => const Icon(Icons.article, color: AppColor.textOnPrimary))) : const Icon(Icons.article, color: AppColor.textOnPrimary)),
                  title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.textPrimary)),
                  subtitle: Text(post.description.isNotEmpty ? (post.description.length > 50 ? '${post.description.substring(0, 50)}...' : post.description) : 'No description', style: const TextStyle(color: AppColor.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                  isThreeLine: true,
                ));
              }, childCount: posts.length));
            }),
          ),
        ],
      ),
    );
  }
}