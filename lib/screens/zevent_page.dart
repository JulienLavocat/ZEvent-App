import 'dart:async';

import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import 'package:zevent/models/stats.dart';
import 'package:zevent/utils/realtime_database.dart';
import 'package:zevent/utils/ui.dart';
import 'package:firebase_database/firebase_database.dart';

class ZEventPage extends StatefulWidget {
  const ZEventPage({Key? key}) : super(key: key);

  @override
  ZEventPageState createState() => ZEventPageState();
}

class ZEventPageState extends State<ZEventPage> {
  late StreamSubscription<Event> _statsSubscription;
  StatsModel? stats;

  @override
  void initState() {
    super.initState();

    _statsSubscription =
        RealtimeDatabase.subscribeToStats((stats) => setState(() {
              this.stats = stats;
            }));
  }

  @override
  void dispose() {
    super.dispose();
    _statsSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UI.getAppBar("ZEvent 2021"),
        drawer: UI.getDrawer(context),
        body: stats != null
            ? renderStats(context)
            : UI.getCenteredLoadingindicator());
  }

  Widget renderStats(BuildContext ctx) {
    const divider = Divider(
      height: 10,
    );

    var compact = NumberFormat.compact(locale: "fr_FR");

    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text("Total des dons"),
              subtitle: Text(NumberFormat.currency(
                      decimalDigits: 2, locale: "fr_FR", symbol: "€")
                  .format(stats!.donations)),
            ),
            divider,
            ListTile(
              title: const Text("Viewers totaux"),
              subtitle: Text(compact.format(stats!.viewersCount)),
            ),
            divider,
            ListTile(
              title: const Text("Lives en cours"),
              subtitle: Text(stats!.onlineStreams.toString()),
            ),
            divider,
            ListTile(
              title: const Text("Chaine la plus regardée"),
              subtitle: Text(
                  "${stats!.mostWatchedChannel.name} (${compact.format(stats!.mostWatchedChannel.viewers)})"),
            ),
            divider,
            ListTile(
              title: const Text("Jeux le plus regardé"),
              subtitle: Text(
                  "${stats!.mostWatchedGame.name} (${compact.format(stats!.mostWatchedGame.viewers)})"),
            ),
          ],
        ));
  }
}
