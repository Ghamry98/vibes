import 'dart:io';
import 'package:vibes/utils/Helpers.dart';
import 'package:vibes/utils/Validators.dart';

enum MediaSource { gallery, camera }
enum MediaType { image, video }

class Media {
  // Attributes
  String url;
  MediaType type;

  // Extras
  File localFile;
  bool uploadFailed;

  // Constructors
  Media.basic(this.localFile);
  Media.localFile(this.localFile, this.type);
  Media.image(this.url) {
    this.type = MediaType.image;
  }
  Media.video(this.url) {
    this.type = MediaType.video;
  }
  Media(this.url, this.type);

  // Mapping
  Media.fromJSON(Map<String, dynamic> data) {
    this.url = data["media_path"];
    this.type = data["media_type"] != null
        ? _getMediaType(data["media_type"])
        : MediaType.image;
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "media_path": this.url,
      "media_type": this.type,
    };
    return map;
  }

  // Methods
  String get fileName => Helpers.getFileName(this.localFile);
  String get fileExtension => Helpers.getFileExtension(this.fileName);

  int get fileSize => Helpers.getFileSize(this.localFile);
  String get formattedFileSize => Helpers.formatFileSize(fileSize);

  bool get isImage => type != null && type == MediaType.image;
  bool get isVideo => type != null && type == MediaType.video;

  bool get isUploading => isFileValid && this.url == null;
  bool get uploadedSuccessfully => this.localFile != null && this.url != null;

  bool get isFileSizeValid => Validators.validateFileSize(fileSize);
  bool get isFileExtensionValid =>
      Validators.validateFileExtension(fileExtension);

  bool get isFileValid {
    return isFileSizeValid &&
        isFileExtensionValid &&
        !(uploadFailed != null && uploadFailed);
  }

  void updateType() {
    if (fileExtension != null) {
      if (Validators.validateImageExtension(fileExtension)) {
        type = MediaType.image;
      } else if (Validators.validateVideoExtension(fileExtension)) {
        type = MediaType.video;
      }
    }
  }

  static MediaType _getMediaType(String type) {
    try {
      switch (type.toLowerCase()) {
        case "image":
          return MediaType.image;
        case "video":
          return MediaType.video;
        default:
          return MediaType.image;
      }
    } catch (e) {
      return MediaType.image;
    }
  }
}
