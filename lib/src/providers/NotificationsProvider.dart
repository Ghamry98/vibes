import 'package:vibes/src/blocs/IconsBloc.dart';
import 'package:vibes/src/models/Message.dart';
import 'package:vibes/src/models/Option.dart';
import 'package:vibes/src/providers/BaseProvider.dart';
import 'package:vibes/src/services/NotificationsService.dart';
import 'package:vibes/config/SetupLocator.dart';

class NotificationsProvider extends BaseProvider {
  final NotificationsService _notificationsService =
      locator<NotificationsService>();

  final IconsBloc _iconsBloc = locator<IconsBloc>();

  static List<Message> _notifications;
  static List<Option> _options;

  static int _limit = 10;
  int _offset = 0;

  Future<bool> fetchNotifications() async {
    try {
      this._offset = 0;

      _notifications = await _notificationsService.getNotifications(
          offset: offset, limit: limit);
      _iconsBloc.notifyNotifications(false);
      if (_notifications != null) {
        if (_notifications.isNotEmpty) {
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

  Future<bool> loadMoreNotifications() async {
    try {
      var temp = await _notificationsService.getNotifications(
        offset: offset,
        limit: limit,
      );
      if (temp != null) {
        if (temp.isNotEmpty) {
          incrementOffset();
        }
        if (_notifications != null) {
          _notifications += temp;
        } else {
          _notifications = temp;
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

  List<Message> get notifications => _notifications;
  List<Option> get options => _options;

  void incrementOffset() {
    this._offset += limit;
  }

  int get limit => _limit;
  int get offset => _offset;

  static bool clearData() {
    try {
      if (_notifications != null) {
        _notifications.clear();
      }
      if (_options != null) {
        _options.clear();
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
