class Streamer {
  String display;
  String twitch;
  String profileUrl;
  String gameId;
  bool online;
  String game;
  int viewers;
  String title;

  Streamer(
      {required this.display,
      required this.twitch,
      required this.profileUrl,
      required this.gameId,
      required this.online,
      required this.game,
      required this.viewers,
      required this.title});

  factory Streamer.fromJson(Map<String, dynamic> json) {
    return Streamer(
      display: json["display"],
      game: json["game"],
      gameId: json["gameId"],
      online: json["online"],
      profileUrl: json["profileUrl"],
      title: json["title"],
      twitch: json["twitch"],
      viewers: json["viewers"],
    );
  }
}
