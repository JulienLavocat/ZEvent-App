import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zevent/models/game_views.dart';
import 'package:zevent/screens/game_details.dart';
import 'package:zevent/utils/realtime_database.dart';
import 'package:zevent/utils/ui.dart';
import 'package:firebase_database/firebase_database.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  GamesPageState createState() => GamesPageState();
}

class GamesPageState extends State<GamesPage> {
  late StreamSubscription<DatabaseEvent> _subscription;
  List<GameViews>? games;

  @override
  void initState() {
    super.initState();

    _subscription =
        RealtimeDatabase.subscribeToGames((gameViews) => setState(() {
              games = gameViews..sort((a, b) => b.viewers.compareTo(a.viewers));
            }));
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UI.getAppBar("Jeux streamés"),
      drawer: UI.getDrawer(context),
      body: games != null
          ? getPageBody(context)
          : UI.getCenteredLoadingindicator(),
    );
  }

  Widget getPageBody(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 0,
          children: buildView(),
        ));
  }

  List<Widget> buildView() {
    return games!
        .map((g) => Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.loose,
                      child: GestureDetector(
                        child: Image.network(
                            "https://static-cdn.jtvnw.net/ttv-boxart/${g.name}-285x380.jpg"),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            GameDetails.routeName,
                            arguments: g.name,
                          );
                        },
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(g.name,
                                    style: UI.gamesTitle,
                                    overflow: TextOverflow.ellipsis),
                                Text(
                                  NumberFormat.compact().format(g.viewers) +
                                      " viewers",
                                  style: UI.gamesViewersCount,
                                )
                              ]),
                        ))
                  ],
                ),
              ),
            ))
        .toList();
  }
}
