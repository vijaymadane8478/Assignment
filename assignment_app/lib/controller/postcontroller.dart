import 'package:assignment_app/model/postmodel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Flutter app)', // spoof a common user agent
          'Accept': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);
        print('Number of posts fetched: ${jsonData.length}');
        posts.assignAll(jsonData.map((json) => Post.fromJson(json)).toList());
      } else {
        print('Failed to load posts with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching posts: $e');
    } finally {
      isLoading(false);
    }
  }
}
