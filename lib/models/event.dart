import 'package:intl/intl.dart';

class EventUser {
  String display;
  String profileUrl;
  String url;

  EventUser(
      {required this.display, required this.profileUrl, required this.url});

  factory EventUser.fromJson(Map<String, dynamic> json) {
    String url = "";

    return EventUser(
        display: json["display"],
        profileUrl: json["profileUrl"],
        url: json["twitch"] != null
            ? "https://twitch.tv/${json["twitch"]}"
            : json["url"]);
  }
}

class EventModel {
  static String Function(DateTime date) getHours = DateFormat.Hm().format;

  DateTime start;
  DateTime end;
  String title;
  List<EventUser> participants;
  List<EventUser> organizers;

  EventModel(
      {required this.end,
      required this.organizers,
      required this.participants,
      required this.start,
      required this.title});

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      title: json["title"],
      end: DateTime.parse(json["end"]),
      start: DateTime.parse(json["start"]),
      organizers: List.from(json["organizers"] ?? [])
          .map((e) => EventUser.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      participants: List.from(json["participants"] ?? [])
          .map((e) => EventUser.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  String humanizeStartEnd() {
    return "${getHours(start)} - ${getHours(end)}";
  }

  String humanizeOrganizers() {
    return organizers.map((e) => e.display).join(", ");
  }
}
