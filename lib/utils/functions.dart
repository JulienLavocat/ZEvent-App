import 'package:cloud_functions/cloud_functions.dart';
import 'package:zevent/models/game_data.dart';

class Functions {
  static FirebaseFunctions functions = FirebaseFunctions.instance;

  static Future<List<GameData>> search(String query) async {
    final results = await functions.httpsCallable("searchGames").call(query);
    return (results.data as List)
        .map((e) => GameData.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
