import 'package:flutter/material.dart';
import 'package:zevent/models/streamers.dart';
import 'package:zevent/widgets/notifications_manager/abstract_notification.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class StreamerAndGameNotification extends AbstractNotification {
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
