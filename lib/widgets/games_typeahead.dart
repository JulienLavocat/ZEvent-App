import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:zevent/models/game_data.dart';
import 'package:zevent/utils/functions.dart';

class GameTypeahead extends StatefulWidget {
  final Function(GameData) onSelect;

  const GameTypeahead({Key? key, required this.onSelect}) : super(key: key);

  @override
  _GameTypeaheadState createState() => _GameTypeaheadState(onSelect);
}

class _GameTypeaheadState extends State<GameTypeahead> {
  _GameTypeaheadState(this.onSelect);

  final Function(GameData) onSelect;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<GameData>(
      textFieldConfiguration: TextFieldConfiguration(
        autocorrect: false,
        autofocus: true,
        decoration: const InputDecoration(hintText: "Nom du streamer"),
        controller: controller,
      ),
      suggestionsCallback: (pattern) => Functions.search(pattern),
      debounceDuration: const Duration(milliseconds: 500),
      itemBuilder: (ctx, value) => ListTile(
        title: Text(value.name),
        contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      ),
      onSuggestionSelected: (value) {
        controller.text = value.name;
        onSelect(value);
      },
    );
  }
}
