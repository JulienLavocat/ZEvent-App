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
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: const Text(
              "Ajouter la notification",
              style: TextStyle(color: Colors.white),
            ),
            // onPressed: () async {
            //   Navigator.of(context).pop();
            // },
            onPressed: null,
          ),
        )
      ],
    );
  }

  createNotif(String obj) {}

  @override
  Widget? getType() {
    return null;
  }
}
