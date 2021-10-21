import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zevent/models/streamers.dart';
import 'package:zevent/utils/ui.dart';
import 'package:firebase_database/firebase_database.dart';

class GameDetails extends StatefulWidget {
  static const routeName = "/games";

  GameDetails({Key? key}) : super(key: key);

  @override
  GameDetailsState createState() => GameDetailsState();
}

class GameDetailsState extends State<GameDetails> {
  DatabaseReference ref =
      FirebaseDatabase.instance.reference().child("streamers");

  late StreamSubscription<Event> _subscription;
  List<Streamer>? streamers;

  @override
  void initState() {
    super.initState();

    _subscription = ref.onValue.listen((event) {
      setState(() {
        streamers = (event.snapshot.value as List<Object?>)
            .map((e) => Streamer.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final String gameName =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
        appBar: UI.getAppBar(gameName),
        body: streamers != null
            ? buildPage(context, gameName)
            : UI.getCenteredLoadingindicator());
  }

  Widget buildPage(BuildContext ctx, String game) {
    List<Streamer> filteredStreamers =
        streamers!.where((s) => s.game == game).toList();

    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: ListView.separated(
          separatorBuilder: (ctx, index) => const Divider(),
          itemCount: filteredStreamers.length,
          itemBuilder: (ctx, i) => getStreamerView(filteredStreamers[i]),
        ));
  }

  getStreamerView(Streamer s) {
    return ListTile(
      leading: Image.network(s.profileUrl),
      title: Text(
        s.display,
        style: s.online ? UI.onlineStreamer : UI.offlineStreamer,
      ),
      subtitle: Text(s.title),
      trailing: Text(
        NumberFormat.compact().format(s.viewers),
        style: UI.viewerCount,
      ),
      onTap: () => UI.streamLauncher(s.twitch),
    );
  }
}
