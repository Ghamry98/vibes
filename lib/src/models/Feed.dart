import 'package:vibes/src/models/Comment.dart';
import 'package:vibes/src/models/Interaction.dart';
import 'package:vibes/src/models/Post.dart';

enum FeedType { post, comment, interaction }

class Feed {
  // Attributes
  FeedType type;
  dynamic data;

  // Constructor
  Feed(this.type, this.data);

  // Mapping
  Feed.fromJSON(Map<String, dynamic> data) {
    this.type = data["type"] != null ? _getType(data["type"]) : null;
    this.data = data["data"] != null ? _getData(data["data"]) : null;
  }

  // Methods
  static FeedType _getType(String data) {
    try {
      switch (data.toLowerCase()) {
        case "post":
          return FeedType.post;
        case "comment":
          return FeedType.comment;
        case "interaction":
          return FeedType.interaction;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  dynamic _getData(Map<String, dynamic> data) {
    try {
      switch (this.type) {
        case FeedType.post:
          return Post.homeResponse(data);
        case FeedType.comment:
          return Comment.fromJSON(data);
        case FeedType.interaction:
          return Interaction.fromJSON(data);
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }
}
