import 'package:flutter/foundation.dart';

/// Represents the state of the view.
enum ViewState { idle, busy }

/// Responsible for notifing the view when its setState method is called.
class BaseProvider with ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
