import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zevent/models/notifications_data.dart';
import 'package:zevent/models/streamers.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsManager {
  static List<String> notifsNames = [
    "Streamer",
    "Jeu",
    "Streamer et jeu",
    "Statistiques"
  ];

  static getBuilder(String notif, BuildContext context) {
    switch (notif) {
      case "Streamer":
        return StreamerNotif().build(context);
      case "Jeu":
        return GameNotif().build(context);
      case "Streamer et jeu":
        return StreamerAndGameNotif().build(context);
      case "Statistiques":
        return StatsNotif().build(context);
      default:
    }
  }
}

class StreamerNotif extends INotification {
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

class GameNotif extends INotification {
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

class StreamerAndGameNotif extends INotification {
  final Future<List<Streamer>> streamers = Future.value([]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
            "Soyez notifiés dès que ce streamer lancera ou coupera sont stream sur un jeux en particulier."),
        TypeAheadField(
          textFieldConfiguration: const TextFieldConfiguration(
              autocorrect: false,
              autofocus: true,
              decoration: InputDecoration(hintText: "Nom du streamer")),
          suggestionsCallback: getSuggestions,
          itemBuilder: (ctx, value) => buildPropositionItem(value as Streamer),
          onSuggestionSelected: (suggestion) {},
        ),
        const TextField(
          autocorrect: false,
          autofocus: false,
          decoration: InputDecoration(hintText: "Nom du jeux"),
        )
      ],
    );
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

class StatsNotif extends INotification {
  List<String> suggestions = [
    "Dons",
    "Viewers",
    "Lives en cours",
    "Chaine la plus regardée",
    "Jeux le plus regardé"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
            "Soyez notifiés dès que une statistique dépasse ou atteint une valeur."),
        TypeAheadField(
          textFieldConfiguration: const TextFieldConfiguration(
              autocorrect: false,
              autofocus: true,
              decoration: InputDecoration(hintText: "Nom de la statistique")),
          suggestionsCallback: getSuggestions,
          itemBuilder: (ctx, value) => buildPropositionItem(value as String),
          onSuggestionSelected: (suggestion) {},
        ),
        const TextField(
          autocorrect: false,
          autofocus: false,
          decoration: InputDecoration(hintText: "Valeur de la statistique"),
        )
      ],
    );
  }

  List<String> getSuggestions(String pattern) {
    return suggestions
        .where((s) => s.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  Widget buildPropositionItem(String s) {
    return ListTile(
      title: Text(s),
      contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    );
  }

  @override
  Widget? getType() {
    return null;
  }
}

abstract class INotification {
  String name = "notif";

  Widget build(BuildContext context);
  Widget? getType();

  DropdownMenuItem getDropDown() {
    return DropdownMenuItem(
      child: Text(name),
    );
  }
}
