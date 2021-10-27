class DonationGoal {
  String id;
  String name;
  double amount;
  String streamerId;
  String nature;
  bool done;
  String? achievedAt;
  List<dynamic>? links;

  DonationGoal(
      {required this.id,
      required this.name,
      required this.amount,
      required this.streamerId,
      required this.nature,
      required this.done,
      this.links,
      this.achievedAt});

  factory DonationGoal.fromJson(Map<String, dynamic> json) {
    return DonationGoal(
        id: json["id"],
        name: json["name"],
        amount: json["amount"].toDouble(),
        streamerId: json["streamerId"],
        nature: json["nature"],
        done: json["done"],
        links: json["links"],
        achievedAt: json["achievedAt"]);
  }
}

class StreamerGoals {
  String displayName;
  String id;
  String twitch;
  String profileUrl;
  List<DonationGoal> donationGoals;

  StreamerGoals(
      {required this.displayName,
      required this.donationGoals,
      required this.twitch,
      required this.id,
      required this.profileUrl});

  factory StreamerGoals.fromJson(Map<String, dynamic> json) {
    return StreamerGoals(
        displayName: json["displayName"],
        donationGoals: ((json["donationGoals"] ?? []) as List<Object?>)
            .map((e) =>
                DonationGoal.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        twitch: json["twitch"],
        id: json["id"],
        profileUrl: json["profileUrl"]);
  }
}
