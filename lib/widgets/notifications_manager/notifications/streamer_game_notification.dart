import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zevent/models/game_data.dart';
import 'package:zevent/models/notifications_data.dart';
import 'package:zevent/models/streamers.dart';
import 'package:zevent/utils/firestore.dart';
import 'package:zevent/utils/realtime_database.dart';
import 'package:zevent/utils/ui.dart';
import 'package:zevent/widgets/games_typeahead.dart';
import 'package:zevent/widgets/notifications_manager/abstract_notification.dart';
import 'package:zevent/widgets/streamer_typeahead.dart';

class StreamerAndGameNotification extends AbstractNotification {
  final Future<List<Streamer>> streamers = RealtimeDatabase.getStreamers();

  Streamer? streamer;
  GameData? game;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: streamers,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return UI.getCenteredLoadingindicator();

          return Column(
            children: <Widget>[
              const Text(
                  "Soyez notifiés dès que ce streamer lancera ou coupera sont stream sur un jeux en particulier."),
              StreamerTypeahead(
                  onSelect: (streamer) => this.streamer = streamer,
                  streamers: snapshot.data as List<Streamer>),
              GameTypeahead(onSelect: (game) => this.game = game),
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
                        type: NotificationsType.gameStreamer,
                        game: game?.id,
                        gameDisplayName: game?.name,
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
            ],
          );
        });
  }

  @override
  Widget? getType() {
    return null;
  }

  Future<List<Streamer>> getSuggestions(String pattern) async {
    final values = await streamers;
    return values
        .where((v) => v.twitch.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  Widget buildPropositionItem(Streamer s) {
    return ListTile(
      title: Text(s.display),
      contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    );
  }
}
