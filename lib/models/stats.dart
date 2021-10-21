class StatsModel {
  double donations;
  int viewersCount;
  int onlineStreams;
  MostWatchedModel mostWatchedGame;
  MostWatchedModel mostWatchedChannel;

  StatsModel(
      {required this.donations,
      required this.viewersCount,
      required this.onlineStreams,
      required this.mostWatchedGame,
      required this.mostWatchedChannel});

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
        donations: json["donations"].toDouble(),
        viewersCount: json["viewersCount"],
        onlineStreams: json["onlineStreams"],
        mostWatchedGame: MostWatchedModel.fromJson(
            Map<String, dynamic>.from(json["mostWatchedGame"])),
        mostWatchedChannel: MostWatchedModel.fromJson(
            Map<String, dynamic>.from(json["mostWatchedChannel"])));
  }
}

class MostWatchedModel {
  String name;
  int viewers;

  MostWatchedModel({required this.name, required this.viewers});

  factory MostWatchedModel.fromJson(Map<String, dynamic> json) {
    return MostWatchedModel(name: json["name"], viewers: json["viewers"]);
  }
}
