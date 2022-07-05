import 'package:firebase_database/firebase_database.dart';
import 'package:zevent/models/event.dart';
import 'package:zevent/models/game_views.dart';
import 'package:zevent/models/stats.dart';
import 'package:zevent/models/streamer_goals.dart';
import 'package:zevent/models/streamers.dart';

class RealtimeDatabase {
  static DatabaseReference database = FirebaseDatabase.instance.ref();

  static subscribeToStats(Function(StatsModel) handler) {
    return database.child("stats").onValue.listen((event) => handler(
        StatsModel.fromJson(
            Map<String, dynamic>.from(event.snapshot.value as Map))));
  }

  static subscribeToGames(Function(List<GameViews>) handler) {
    return database.child("games").onValue.listen((event) => handler(
        Map<String, Object?>.from(event.snapshot.value as Map)
            .entries
            .map((e) => GameViews.fromJson(
                e.key, Map<String, dynamic>.from(e.value as Map)))
            .toList()));
  }

  static subscribeToStreamers(Function(List<Streamer>) handler) {
    return database.child("streamers").onValue.listen((event) => handler(
        (event.snapshot.value as List<Object?>)
            .map((e) => Streamer.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList()));
  }

  static Future<List<Streamer>> getStreamers() {
    return database.child("streamers").once().then((event) =>
        (event.snapshot.value as List<Object?>)
            .map((e) => Streamer.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList());
  }

  static Future<List<StreamerGoals>> getDonationGoals() {
    return database.child("goals").once().then((event) => (event.snapshot.value
            as List<Object?>)
        .map((e) => StreamerGoals.fromJson(Map<String, dynamic>.from(e as Map)))
        .where((element) => element.donationGoals.isNotEmpty)
        .toList());
  }

  static Future<List<EventModel>> getEvents() {
    return database.child("events").once().then((event) => (event.snapshot.value
            as List<Object?>)
        .map((e) => EventModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList());
  }
}
