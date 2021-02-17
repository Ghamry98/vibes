import 'package:dio/dio.dart';
import 'package:vibes/src/models/Post.dart';
import 'package:vibes/config/SetupLocator.dart';

class BookmarksService {
  Dio _dio = locator<Dio>();

  Future<List<Post>> getBookmarks({
    int offset,
    int limit,
  }) async {
    try {
      Map<String, dynamic> params = {
        "offset": offset,
        "limit": limit,
      };

      Response response =
          await _dio.get("/bookmarks/", queryParameters: params);

      List<Post> _list = [];
      for (var item in response.data["data"]) {
        _list.add(Post.homeResponse(item));
      }

      return _list;
    } catch (e) {
      // print(e);
      return null;
    }
  }

  Future<bool> addToBookmarks({int postId}) async {
    try {
      await _dio.post("/bookmarks/", data: {"post_id": postId});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromBookmarks({int postId}) async {
    try {
      await _dio.delete("/bookmarks/" + postId.toString());

      return true;
    } catch (e) {
      // print(e);
      return false;
    }
  }

  Future<bool> deleteAllBookmarks() async {
    try {
      await _dio.delete("/bookmarks/");

      return true;
    } catch (e) {
      return false;
    }
  }
}
