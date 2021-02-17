import 'package:dio/dio.dart';
import 'package:vibes/src/models/Post.dart';
import 'package:vibes/config/SetupLocator.dart';

class PostService {
  Dio dio = locator<Dio>();

  Future<Post> getPost(int postId) async {
    try {
      Response response = await dio.get("/posts/" + postId.toString() + "/");

      return Post.detailed(response.data["data"]);
    } catch (e) {
      return null;
    }
  }

  Future<bool> confirmPost(int postId) async {
    try {
      await dio.post("/post/" + postId.toString() + "/Confirm/");

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> challengePost(int postId) async {
    try {
      await dio.post("/post/" + postId.toString() + "/Challenge/");

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addComment(int postId, String message) async {
    try {
      await dio.post(
        "/post/" + postId.toString() + "/comment",
        data: {"message": message},
      );

      return true;
    } catch (e) {
      // print(e);
      return false;
    }
  }

  Future<bool> reportComment(int commentId) async {
    try {
      await dio.post("/comment/" + commentId.toString() + "/report");

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePost(int postId) async {
    try {
      await dio.put("/posts/" + postId.toString() + "/");

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hidePost(int postId) async {
    try {
      await dio.post("/post/" + postId.toString() + "/hide");

      return true;
    } catch (e) {
      // print(e);
      return false;
    }
  }

  Future<bool> reportPost(int postId) async {
    try {
      await dio.post("/post/" + postId.toString() + "/report");

      return true;
    } catch (e) {
      // print(e);
      return false;
    }
  }
}
