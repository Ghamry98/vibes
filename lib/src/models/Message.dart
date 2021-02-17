import 'package:flutter/material.dart';
import 'package:vibes/utils/Helpers.dart';

enum MessageType { newsletter, like, comment, follow_request, follow }

class Message {
  // Attributes
  int id;
  String title;
  String body;
  DateTime creationDate;
  MessageType type;
  bool isSeen;

  // Constructor
  Message(
    this.id,
    this.title,
    this.creationDate,
    this.type,
    this.isSeen,
  );

  // Mapping
  Message.fromJSON(Map<String, dynamic> data) {
    this.id = data["id"] as int;
    this.title = data["title"] != null ? data["title"] : null;
    this.body = data["body"] != null ? data["body"] : null;
    this.creationDate = DateTime.tryParse(data["creation_date"]);
    this.type = data["type"] != null
        ? _getNotificationType(data["type"])
        : MessageType.newsletter;
    this.isSeen = data["is_seen"] != null ? data["is_seen"] as bool : true;
  }

  Message.fromFCM(Map<String, dynamic> data) {
    if (data["notification"]["title"] != null) {
      this.title = data["notification"]["title"];
    }
    if (data["notification"]["body"] != null) {
      this.body = data["notification"]["body"];
    }

    if (this.title != null &&
        data["data"] != null &&
        data["data"]["type"] != null) {
      this.type = _getNotificationType(data["data"]["type"]);
    } else {
      this.type = MessageType.newsletter;
    }
  }

  /// Returns a formatted localized datetime string that indicates the notification elapsed time.
  String elapsedTime(BuildContext context, {bool isLongFormat = true}) {
    return Helpers.getElapsedTime(creationDate, context, isLongFormat);
  }

  static MessageType _getNotificationType(String type) {
    switch (type.toLowerCase()) {
      case "newsletter":
        return MessageType.newsletter;
      case "like":
        return MessageType.like;
      case "comment":
        return MessageType.comment;
      case "follow_request":
        return MessageType.follow_request;
      case "follow":
        return MessageType.follow;
      default:
        return MessageType.newsletter;
    }
  }
}
