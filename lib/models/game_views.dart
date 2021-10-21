class GameViews {
  String name;
  String id;
  int viewers;

  GameViews({required this.name, required this.viewers, required this.id});

  factory GameViews.fromJson(String id, Map<String, dynamic> json) {
    return GameViews(name: json["name"], id: id, viewers: json["viewers"]);
  }
}
