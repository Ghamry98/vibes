import 'package:vibes/src/models/Feed.dart';
import 'package:vibes/src/models/Post.dart';
import 'package:vibes/src/providers/BaseProvider.dart';
import 'package:vibes/src/providers/PostsProvider.dart';
import 'package:vibes/src/providers/UserProvider.dart';
import 'package:vibes/src/services/BookmarksService.dart';
import 'package:vibes/config/SetupLocator.dart';

class BookmarksProvider extends BaseProvider {
  final BookmarksService _bookmarksService = locator<BookmarksService>();
  final PostsProvider _postsProvider = locator<PostsProvider>();
  final UserProvider _userProvider = locator<UserProvider>();

  static List<Post> _bookmarks;

  static int _limit = 10;
  int _offset = 0;

  Future<bool> fetchBookmarks() async {
    try {
      this._offset = 0;

      List<Post> list =
          await _bookmarksService.getBookmarks(offset: offset, limit: limit);

      if (list != null) {
        _bookmarks = list;

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

  Future<bool> loadMoreBookmarks() async {
    try {
      var temp = await _bookmarksService.getBookmarks(
        offset: offset,
        limit: limit,
      );
      if (temp != null) {
        if (temp.isNotEmpty) {
          incrementOffset();
        }
        if (_bookmarks != null) {
          _bookmarks += temp;
        } else {
          _bookmarks = temp;
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

  Future<bool> addToBookmarks(Post post) async {
    try {
      bool temp = post.isSaved;
      post.isSaved = true;
      notifyListeners();
      bool result = await _bookmarksService.addToBookmarks(postId: post.id);

      if (result) {
        _updatePostInLocalVariables(post, true);
      } else {
        post.isSaved = temp;
      }
      notifyListeners();

      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromBookmarks(Post post) async {
    try {
      bool temp = post.isSaved;
      post.isSaved = false;
      notifyListeners();
      bool result =
          await _bookmarksService.removeFromBookmarks(postId: post.id);

      if (result) {
        _updatePostInLocalVariables(post, false);
      } else {
        post.isSaved = temp;
      }
      notifyListeners();

      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAllBookmarks() async {
    try {
      bool result = await _bookmarksService.deleteAllBookmarks();

      if (result) {
        _deleteBookmarksInLocalPosts();
        notifyListeners();
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  void _updatePostInLocalVariables(Post post, bool value) {
    try {
      _updatePostInBookmarks(post, value);
      _updatePostInHomeFeeds(post, value);
      _updatePostInUserFeeds(post, value);
    } catch (e) {}
  }

  void _deleteBookmarksInLocalPosts() {
    try {
      if (_bookmarks != null) {
        for (var post in _bookmarks) {
          _updatePostInHomeFeeds(post, false);
          _updatePostInUserFeeds(post, false);
        }
        _bookmarks.clear();
      }
    } catch (e) {}
  }

  void _updatePostInBookmarks(Post post, bool value) {
    try {
      if (_bookmarks != null) {
        if (!value) {
          _bookmarks.removeWhere((element) => element.id == post.id);
        } else {
          for (var item in _bookmarks) {
            if (item.id == post.id) {
              item.isSaved = value;
              return;
            }
          }
          if (value) {
            post.showTranslation = false;
            _bookmarks.insert(0, post);
          }
        }
      }
    } catch (e) {}
  }

  void _updatePostInHomeFeeds(Post post, bool value) {
    try {
      _postsProvider.allCategories.forEach((key, list) {
        if (list != null) {
          for (var item in list) {
            if (item.id == post.id) {
              item.isSaved = value;
              break;
            }
          }
        }
      });
    } catch (e) {}
  }

  void _updatePostInUserFeeds(Post post, bool value) {
    try {
      if (_userProvider.user != null) {
        if (_userProvider.user.allFeeds != null) {
          for (var item in _userProvider.user.allFeeds) {
            if (item.type == FeedType.post) {
              if (item.data.id == post.id) {
                item.data.isSaved = value;
                break;
              }
            }
          }
        }

        if (_userProvider.user.posts != null) {
          for (var item in _userProvider.user.posts) {
            if (item.type == FeedType.post) {
              if (item.data.id == post.id) {
                item.data.isSaved = value;
                break;
              }
            }
          }
        }
      }
    } catch (e) {}
  }

  List<Post> get bookmarks => _bookmarks;

  void incrementOffset() {
    this._offset += limit;
  }

  int get limit => _limit;
  int get offset => _offset;

  static bool clearData() {
    try {
      if (_bookmarks != null) {
        _bookmarks.clear();
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
