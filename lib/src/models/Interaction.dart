import 'package:flutter/material.dart';
import 'package:vibes/src/models/Comment.dart';
import 'package:vibes/src/models/Post.dart';
import 'package:vibes/src/models/User.dart';
import 'package:vibes/utils/Helpers.dart';

enum InteractionType { like, comment, follow_request, follow }

class Interaction {
  // Attributes
  int id;
  InteractionType type;
  DateTime creationDate;
  User user;
  Post post;
  Comment comment;

  // Constructor
  Interaction(
    this.id,
    this.type,
    this.creationDate,
    this.user,
    this.post,
    this.comment,
  );

  // Mapping
  Interaction.fromJSON(Map<String, dynamic> data) {
    this.id = data["id"] as int;
    this.type = _getInteractionType(data["action"]);
    this.user = User.basic(data["user"]);
    this.post = Post.simple(data["post"]);
    this.comment =
        data["comment"] != null ? Comment.fromJSON(data["comment"]) : null;
  }

  // Methods
  /// Returns a formatted localized datetime string that indicates the interaction elapsed time.
  String elapsedTime(BuildContext context, {bool isLongFormat = false}) {
    return Helpers.getElapsedTime(creationDate, context, isLongFormat);
  }

  static InteractionType _getInteractionType(String type) {
    switch (type.toLowerCase()) {
      case "like":
        return InteractionType.like;
      case "comment":
        return InteractionType.comment;
      case "follow_request":
        return InteractionType.follow_request;
      case "follow":
        return InteractionType.follow;
      default:
        return null;
    }
  }
}
