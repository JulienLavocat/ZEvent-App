import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zevent/models/notifications_data.dart';
import 'package:zevent/models/streamers.dart';
import 'package:zevent/utils/firestore.dart';
import 'package:zevent/utils/realtime_database.dart';
import 'package:zevent/utils/ui.dart';
import 'package:zevent/widgets/notifications_manager/abstract_notification.dart';
import 'package:zevent/widgets/streamer_typeahead.dart';

class StreamerNotification extends AbstractNotification {
  final Future<List<Streamer>> streamers = RealtimeDatabase.getStreamers()
      .then((r) => r..sort((a, b) => a.display.compareTo(b.display)));

  Streamer? streamer;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: streamers,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return UI.getCenteredLoadingindicator();

          return Column(children: <Widget>[
            const Text("Soyez notifié dès que ce streamer lancera son stream."),
            StreamerTypeahead(
                onSelect: (selected) => {streamer = selected},
                streamers: (snapshot.data as List<Streamer>)),
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
                  // if (streamer == null) return;

                  var data = NotificationData(
                      type: NotificationsType.online,
                      streamer: streamer?.twitch,
                      streamerDisplayName: streamer?.display);
                  Firestore.addNotification(
                      FirebaseAuth.instance.currentUser!.uid, data);
                  await FirebaseMessaging.instance
                      .subscribeToTopic(data.toString());
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
              ),
            )
          ]);
        });
  }

  @override
  Widget? getType() {
    return null;
  }
}
