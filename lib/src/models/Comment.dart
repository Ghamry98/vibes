import 'package:flutter/cupertino.dart';
import 'package:vibes/src/models/Post.dart';
import 'package:vibes/src/models/User.dart';
import 'package:vibes/utils/Helpers.dart';

class Comment {
  // Attributes
  int id;
  String text;
  DateTime creationDate;
  User user;
  Post post;

  // Constructor
  Comment(this.text, this.user, this.creationDate);

  // Mapping
  Comment.fromJSON(Map<String, dynamic> data) {
    this.id = data["id"] as int;
    this.text = data["text"];
    this.user = User.basic(data["author"]);
    this.creationDate = DateTime.tryParse(data["created_at"]);

    this.post = data["post"] != null ? Post.homeResponse(data["post"]) : null;
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "user_id": this.user.id,
      "text": this.text,
    };
    return map;
  }

  // Methods
  /// Returns a formatted localized datetime string that indicates the comment elapsed time.
  String elapsedTime(BuildContext context, {bool isLongFormat = true}) {
    return Helpers.getElapsedTime(creationDate, context, isLongFormat);
  }
}
