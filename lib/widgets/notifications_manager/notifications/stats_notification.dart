import 'package:flutter/material.dart';
import 'package:zevent/widgets/notifications_manager/abstract_notification.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class StatsNotification extends AbstractNotification {
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
