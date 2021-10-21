import 'package:flutter/material.dart';
import 'package:zevent/widgets/notifications_manager/abstract_notification.dart';

class GameNotifications extends AbstractNotification {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
            "Soyez notifiés dès que quelqu'un lance un stream sur ce jeux."),
        TextField(
          autocorrect: false,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Nom du jeux"),
          onSubmitted: createNotif,
        ),
      ],
    );
  }

  createNotif(String obj) {}

  @override
  Widget? getType() {
    return null;
  }
}
