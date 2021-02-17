import 'package:vibes/src/models/CustomResponse.dart';
import 'package:vibes/src/models/Post.dart';
import 'package:vibes/src/providers/BaseProvider.dart';
import 'package:vibes/src/services/PostsService.dart';
import 'package:vibes/config/SetupLocator.dart';

class PostsProvider extends BaseProvider {
  final PostsService _postsService = locator<PostsService>();

  static Map<PostType, List<Post>> _allCategories = {};

  static PostsListSort _sortBy = PostsListSort.date;
  static String _searchText = "";

  static int _limit = 10;
  int _offset = 0;

  PostType _currentTab = PostType.all_mobile;

  static const Duration hold = const Duration(milliseconds: 400);

  Future<bool> fetchPosts(
      {PostType postType, bool isTrending, String countryCode}) async {
    try {
      this._offset = 0;

      List<Post> list = await _postsService.getPosts(
        postType: postType,
        isTrending: isTrending,
        sortBy: sortBy,
        offset: offset,
        limit: limit,
        countryCode: countryCode,
        search: _searchText,
      );

      if (list != null) {
        _allCategories[postType] = list;

        if (list.isNotEmpty) {
          incrementOffset();
        }
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> loadMorePosts(
      {PostType postType, bool isTrending, String countryCode}) async {
    try {
      var temp = await _postsService.getPosts(
        postType: postType,
        isTrending: isTrending,
        sortBy: sortBy,
        offset: offset,
        limit: limit,
        countryCode: countryCode,
        search: _searchText,
      );
      if (temp != null) {
        if (temp.isNotEmpty) {
          incrementOffset();
        }
        if (_allCategories[postType] != null) {
          _allCategories[postType] += temp;
        } else {
          _allCategories[postType] = temp;
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> addPost(Post post) async {
    try {
      setState(ViewState.busy);
      CustomResponse result = await _postsService.addPost(post);

      if (result.isSuccess) {
        post.id = result.data as int;
        if (_allCategories[PostType.all_mobile] != null) {
          _allCategories[PostType.all_mobile].insert(0, post);
        }
        if (_allCategories[post.type] != null) {
          _allCategories[post.type].insert(0, post);
        }
      }

      setState(ViewState.idle);

      return result.isSuccess;
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  Map<PostType, List<Post>> get allCategories => _allCategories;

  List<Post> posts(PostType postType) {
    if (_allCategories != null && _allCategories[postType] != null) {
      return _allCategories[postType];
    }
    return null;
  }

  void search(String text) {
    try {
      if (_searchText != text) {
        _searchText = text;
        notifyListeners();

        fetchPosts(postType: _currentTab);
      }
    } catch (e) {}
  }

  void incrementOffset() {
    this._offset += limit;
  }

  void updateSort(PostsListSort newSort) {
    _sortBy = newSort;
    notifyListeners();
  }

  void updateCurrentTab(PostType postType) {
    _currentTab = postType;
    notifyListeners();
  }

  void resetSort() {
    _sortBy = PostsListSort.date;
    notifyListeners();
  }

  String get searchText => _searchText;
  PostsListSort get sortBy => _sortBy;
  int get limit => _limit;
  int get offset => _offset;

  static bool clearData() {
    try {
      if (_allCategories != null) {
        _allCategories.clear();
      }
      _sortBy = PostsListSort.date;
      _searchText = "";

      return true;
    } catch (e) {
      return false;
    }
  }
}
