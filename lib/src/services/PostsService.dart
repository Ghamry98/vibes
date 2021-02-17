import 'package:dio/dio.dart';
import 'package:vibes/src/models/CustomResponse.dart';
import 'package:vibes/src/models/Post.dart';
import 'package:vibes/config/SetupLocator.dart';

class PostsService {
  Dio dio = locator<Dio>();

  Future<List<Post>> getPosts({
    PostType postType,
    bool isTrending,
    String countryCode,
    PostsListSort sortBy,
    int offset,
    int limit,
    String search,
  }) async {
    try {
      Map<String, dynamic> params = {
        "sort": sortBy.toString().replaceAll("PostsListSort.", ""),
        "offset": offset,
        "limit": limit,
      };

      if (postType != null &&
          postType != PostType.all_mobile &&
          postType != PostType.trending_mobile) {
        params["type"] = postType.toString().replaceAll("PostType.", "");
      }

      if (isTrending != null && isTrending) {
        params["is_trending"] = 1;
      }

      if (countryCode != null) {
        params["country"] = countryCode;
      }

      if (search != null && search.isNotEmpty) {
        params["search"] = search;
      }

      Response response = await dio.get("/posts/", queryParameters: params);

      List<Post> _list = [];
      for (var item in response.data["data"]) {
        _list.add(Post.homeResponse(item));
      }

      return _list;
    } catch (e) {
      return null;
    }
  }

  Future<CustomResponse> addPost(Post post) async {
    try {
      Map<String, dynamic> data = post.toMap();

      Response response = await dio.post("/posts/", data: data);

      return CustomResponse.success(data: response.data["data"]);
    } catch (e) {
      // print(e);
      return CustomResponse.error();
    }
  }
}
