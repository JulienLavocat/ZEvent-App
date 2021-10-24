class GameData {
  String name;
  String id;
  String boxArtUrl;

  GameData({required this.name, required this.boxArtUrl, required this.id});

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
        name: json["name"], id: json["id"], boxArtUrl: json["boxArtUrl"]);
  }
}
