import 'package:translator/translator.dart';
import 'package:vibes/src/models/Post.dart';
import 'package:vibes/src/providers/BaseProvider.dart';
import 'package:vibes/src/services/PostService.dart';
import 'package:vibes/config/SetupLocator.dart';

class PostProvider extends BaseProvider {
  final PostService _postService = locator<PostService>();
  final GoogleTranslator _translator = locator<GoogleTranslator>();

  Post post;

  Future<bool> fetchPost(int postId) async {
    try {
      var p = await _postService.getPost(postId);

      if (p != null) {
        p.showTranslation = false;
        post = p;

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> translatePost(String languageCode) async {
    try {
      if (this.post.title != null && this.post.title.trim().isNotEmpty) {
        this.post.showTranslation = true;

        setState(ViewState.busy);

        List<Future<String>> translations = [
          _translator
              .translate(
                this.post.title,
                to: languageCode,
              )
              .then((value) => value.text),
        ];

        if (this.post.description != null && this.post.description.isNotEmpty) {
          translations.add(_translator
              .translate(
                this.post.description,
                to: languageCode,
              )
              .then((value) => value.text));
        }

        List<String> result = await Future.wait(translations);

        if (result != null) {
          if (result.length > 0) {
            post.translatedTitle = result[0];
          }
          if (result.length > 1) {
            post.translatedDescription = result[1];
            post.translatedMarkedText =
                Post.markText(post.translatedDescription);
          }
        }

        setState(ViewState.idle);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  Future<bool> translateTitle(Post p, String languageCode) async {
    try {
      if (p.title != null && p.title.trim().isNotEmpty) {
        p.showTranslation = true;
        setState(ViewState.busy);

        String result = await _translator
            .translate(
              p.title,
              to: languageCode,
            )
            .then((value) => value.text);

        if (result != null) {
          p.translatedTitle = result;
        }

        setState(ViewState.idle);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  Future<bool> confirmPost() async {
    try {
      bool temp = post.isLiked;

      post.isLiked = true;
      // post.numberOfConfirms++;
      // post.numberOfInteractions++;

      notifyListeners();
      bool result = await _postService.confirmPost(post.id);

      if (!result) {
        post.isLiked = temp;
        // if (post.numberOfInteractions > 0) {
        //   post.numberOfInteractions--;
        // }
        // if (post.numberOfConfirms > 0) {
        //   post.numberOfConfirms--;
        // }
        notifyListeners();
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> challengePost() async {
    try {
      bool temp = post.isLiked;
      post.isLiked = false;

      // post.numberOfInteractions++;
      // post.numberOfChallenges++;

      notifyListeners();
      bool result = await _postService.challengePost(post.id);

      if (!result) {
        post.isLiked = temp;

        // if (post.numberOfInteractions > 0) {
        //   post.numberOfInteractions--;
        // }
        // if (post.numberOfChallenges > 0) {
        //   post.numberOfChallenges--;
        // }
        notifyListeners();
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addComment(String message) async {
    try {
      bool result = await _postService.addComment(post.id, message);

      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> reportComment(int commentId) async {
    try {
      bool result = await _postService.reportComment(commentId);

      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hidePost() async {
    try {
      bool result = await _postService.hidePost(post.id);

      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> reportPost() async {
    try {
      bool result = await _postService.reportPost(post.id);

      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePost() async {
    try {
      bool result = await _postService.deletePost(post.id);

      return result;
    } catch (e) {
      return false;
    }
  }
}
