import 'package:firebase_database/firebase_database.dart';
import 'package:zevent/models/game_views.dart';
import 'package:zevent/models/stats.dart';
import 'package:zevent/models/streamers.dart';

class RealtimeDatabase {
  static DatabaseReference database = FirebaseDatabase.instance.reference();

  static subscribeToStats(Function(StatsModel) handler) {
    return database.child("stats").onValue.listen((event) => handler(
        StatsModel.fromJson(Map<String, dynamic>.from(event.snapshot.value))));
  }

  static subscribeToGames(Function(List<GameViews>) handler) {
    return database.child("games").onValue.listen((event) => handler(
        Map<String, Object?>.from(event.snapshot.value)
            .entries
            .map((e) => GameViews.fromJson(
                e.key, Map<String, dynamic>.from(e.value as Map)))
            .toList()));
  }

  static subscribeToStreamers(Function(List<Streamer>) handler) {
    return database.reference().child("streamers").onValue.listen((event) =>
        handler((event.snapshot.value as List<Object?>)
            .map((e) => Streamer.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList()));
  }
}
