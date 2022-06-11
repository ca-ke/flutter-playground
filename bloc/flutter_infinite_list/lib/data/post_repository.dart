import 'package:flutter_infinite_list/model/post.dart';

abstract class IPostRepository {
  Future<List<Post>> getPosts();
}

class PostRepository extends IPostRepository {
  @override
  Future<List<Post>> getPosts() async {
    return Future.delayed(const Duration(seconds: 1)).then((value) => [
          Post(id: 1, title: "Oi", body: "Oi"),
          Post(id: 1, title: "Oi", body: "Oi"),
          Post(id: 1, title: "Oi", body: "Oi"),
          Post(id: 1, title: "Oi", body: "Oi")
        ]);
  }
}
