import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zevent/models/streamers.dart';
import 'package:zevent/utils/realtime_database.dart';
import 'package:zevent/utils/ui.dart';
import 'package:firebase_database/firebase_database.dart';

class StreamersPage extends StatefulWidget {
  const StreamersPage({Key? key}) : super(key: key);

  @override
  StreamersPageState createState() => StreamersPageState();
}

class StreamersPageState extends State<StreamersPage> {
  final FirebaseDatabase database = FirebaseDatabase.instance;

  late StreamSubscription<Event> _streamersSubscription;
  List<Streamer>? streamers;

  @override
  void initState() {
    super.initState();
    _streamersSubscription =
        RealtimeDatabase.subscribeToStreamers((streamers) => setState(() {
              this.streamers = streamers
                ..sort((a, b) => b.viewers.compareTo(a.viewers));
            }));
  }

  @override
  void dispose() {
    super.dispose();
    _streamersSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UI.getAppBar("Streamers en lignes"),
      drawer: UI.getDrawer(context),
      body: streamers != null
          ? buildPage(context)
          : UI.getCenteredLoadingindicator(),
    );
  }

  Widget buildPage(BuildContext ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: ListView.separated(
            itemCount: streamers!.length,
            separatorBuilder: (ctx, index) {
              return const Divider();
            },
            itemBuilder: (ctx, i) => streamerView(ctx, streamers![i])),
      );

  ListTile streamerView(BuildContext ctx, Streamer s) => ListTile(
      leading: Image.network(s.profileUrl),
      title: Text(
        s.display,
        style: s.online ? UI.onlineStreamer : UI.offlineStreamer,
      ),
      subtitle: Text(s.game),
      trailing: Text(
        NumberFormat.compact().format(s.viewers),
        style: UI.viewerCount,
      ),
      onTap: () => UI.streamLauncher(s.twitch));
}
