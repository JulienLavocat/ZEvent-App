import 'package:flutter/material.dart';
import 'package:zevent/models/streamers.dart';
import 'package:zevent/widgets/notifications_manager/abstract_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zevent/models/notifications_data.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreamerNotification extends AbstractNotification {
  final Future<List<Streamer>> streamers = FirebaseDatabase.instance
      .reference()
      .child("streamers")
      .once()
      .then((snapshot) => (snapshot.value as List<Object?>)
          .map((e) => Streamer.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList());

  final TextEditingController streamer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text("Soyez notifié dès que ce streamer lancera son stream."),
        FutureBuilder(
          future: streamers,
          builder: (context, snapshot) => snapshot.hasData
              ? TypeAheadField<Streamer>(
                  textFieldConfiguration: TextFieldConfiguration(
                    autocorrect: false,
                    autofocus: true,
                    decoration:
                        const InputDecoration(hintText: "Nom du streamer"),
                    controller: streamer,
                  ),
                  suggestionsCallback: getSuggestions,
                  itemBuilder: (ctx, value) => buildPropositionItem(value),
                  onSuggestionSelected: (suggestion) {
                    streamer.text = suggestion.twitch;
                  },
                )
              : TypeAheadField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    enabled: false,
                    autocorrect: false,
                    autofocus: true,
                    decoration:
                        const InputDecoration(hintText: "Nom du streamer"),
                    controller: streamer,
                  ),
                  suggestionsCallback: (pattern) => [],
                  itemBuilder: (ctx, value) => const ListTile(),
                  onSuggestionSelected: (suggestion) {},
                ),
        ),
        ElevatedButton.icon(
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: const Text(
            "Ajouter la notification",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            if (streamer.text.length < 3) return;

            FirebaseFirestore.instance
                .collection("notifications")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              "notifications": FieldValue.arrayUnion([
                NotificationData(
                        type: NotificationsType.online, streamer: streamer.text)
                    .toDoc()
              ])
            });
            await FirebaseMessaging.instance
                .subscribeToTopic("online.${streamer.text}");
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Future<List<Streamer>> getSuggestions(String pattern) async {
    final values = await streamers;
    return values
        .where((v) => v.display.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  Widget buildPropositionItem(Streamer s) {
    return ListTile(
      title: Text(s.display),
      contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    );
  }

  @override
  Widget? getType() {
    return null;
  }
}
