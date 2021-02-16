import 'package:rxdart/rxdart.dart';

class IconsBloc {
  /// PublishSubjects that provides a stream for in-app notifications.
  PublishSubject<bool> _publishSubjectNotifications =
      new PublishSubject<bool>();

  /// Updates the home page bottombar notification icon.
  ///
  /// If the given value is true, a dot appears over the notification icon, otherwise it will hide the dot.
  void notifyNotifications(bool value) {
    _publishSubjectNotifications.sink.add(value);
  }

  /// Returns the IconsBloc instance to its initial state.
  void clearData() {
    notifyNotifications(false);
  }

  /// A stream for the notification.
  Stream<bool> get notificationsStream => _publishSubjectNotifications.stream;

  /// Closes the notification in-app stream.
  dispose() {
    _publishSubjectNotifications.close();
  }
}
