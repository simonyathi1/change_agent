import 'dart:convert';

import 'package:change_agent/reources/strings_resource.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import 'package:flutter/cupertino.dart';

class WFTONotification {
  static final Client client = Client();

  static const String serverKey = StringsResource.fcmServerKey;
  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'submissions');

  static Future<Response> sendToTopic(
      {@required String title,
        @required String body,
        @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}