import 'package:flutter/material.dart';
import 'package:zevent/models/game_data.dart';
import 'package:zevent/models/notifications_data.dart';
import 'package:zevent/utils/firestore.dart';
import 'package:zevent/widgets/games_typeahead.dart';
import 'package:zevent/widgets/notifications_manager/abstract_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class GameNotifications extends AbstractNotification {
  GameData? game;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
            "Soyez notifiés dès que quelqu'un lance un stream sur ce jeux."),
        GameTypeahead(onSelect: (game) {
          print("Selected game: ${game.name}");
          this.game = game;
        }),
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
            onPressed: () async {
              var data = NotificationData(
                  type: NotificationsType.game,
                  game: game?.id,
                  gameDisplayName: game?.name);
              Firestore.addNotification(
                  FirebaseAuth.instance.currentUser!.uid, data);
              await FirebaseMessaging.instance
                  .subscribeToTopic(data.toString());

              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
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
