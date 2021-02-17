import 'package:dio/dio.dart';
import 'package:vibes/src/models/Message.dart';
import 'package:vibes/config/SetupLocator.dart';

class NotificationsService {
  Dio dio = locator<Dio>();

  Future<List<Message>> getNotifications({
    int offset,
    int limit,
  }) async {
    try {
      // Map<String, dynamic> params = {
      //   "offset": offset,
      //   "limit": limit,
      // };

      Response response = await dio.get(
        "/notifications",
        // queryParameters: params,
      );

      List<Message> _list = [];
      for (var item in response.data) {
        _list.add(Message.fromJSON(item));
      }

      return _list;
    } catch (e) {
      // print(e);
      return null;
    }
  }
}
