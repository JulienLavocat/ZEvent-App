import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:zevent/models/streamers.dart';

class StreamerTypeahead extends StatefulWidget {
  final Function(Streamer) onSelect;
  final List<Streamer> streamers;

  const StreamerTypeahead(
      {Key? key, required this.onSelect, required this.streamers})
      : super(key: key);

  @override
  _StreamerTypeaheadState createState() =>
      _StreamerTypeaheadState(onSelect, streamers);
}

class _StreamerTypeaheadState extends State<StreamerTypeahead> {
  _StreamerTypeaheadState(this.onSelect, this.streamers);

  final Function(Streamer) onSelect;
  final List<Streamer> streamers;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<Streamer>(
      textFieldConfiguration: TextFieldConfiguration(
        autocorrect: false,
        autofocus: true,
        decoration:
            const InputDecoration(hintText: "Nom du streamer (vide = tous)"),
        controller: controller,
      ),
      suggestionsCallback: (pattern) => streamers
          .where((v) => v.display.toLowerCase().contains(pattern.toLowerCase()))
          .toList(),
      itemBuilder: (ctx, value) => ListTile(
        title: Text(value.display),
        contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      ),
      onSuggestionSelected: (value) {
        controller.text = value.display;
        onSelect(value);
      },
    );
  }
}
