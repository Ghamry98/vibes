import 'package:flutter/cupertino.dart';
import 'package:vibes/config/ErrorHandler.dart';

class CustomResponse {
  // Attributes
  bool isSuccess;
  ErrorType error;
  dynamic data;

  // Constructors
  CustomResponse.success({this.error, this.data}) {
    this.isSuccess = true;
  }

  CustomResponse.error({this.error = ErrorType.basic, this.data}) {
    this.isSuccess = false;
  }

  CustomResponse(this.isSuccess, this.error, this.data);

  // Methods
  /// Returns a localized error messasge if exists, otherwise it will return an empty string.
  String getErrorMessage(BuildContext context) =>
      ErrorHandler.getErrorMessage(context, this.error);
}
