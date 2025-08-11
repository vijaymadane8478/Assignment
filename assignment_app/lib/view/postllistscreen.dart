import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/postcontroller.dart';
import '../model/postmodel.dart';
import 'postdetailsscreen.dart';

class PostsListPage extends StatefulWidget {
  const PostsListPage({super.key});

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  late final PostController postController;

  @override
  void initState() {
    super.initState();
    postController = Get.find<PostController>();
  }

  Future<void> _refreshPosts() async {
    await postController.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        elevation: 4,
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
      ),
      body: Obx(() {
        if (postController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (postController.posts.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refreshPosts,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 200),
                Center(
                  child: Text(
                    'No posts available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshPosts,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: postController.posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final post = postController.posts[index];

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Colors.black26,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Get.to(() => PostDetailsPage(post: post));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.body.length > 100
                              ? '${post.body.substring(0, 100)}...'
                              : post.body,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
