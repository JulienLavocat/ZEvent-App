import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zevent/screens/game_details.dart';
import 'package:zevent/utils/ui.dart';
import 'package:firebase_database/firebase_database.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  GamesPageState createState() => GamesPageState();
}

class GameViews {
  String name;
  String id;
  int viewers;

  GameViews({required this.name, required this.viewers, required this.id});

  factory GameViews.fromJson(String id, Map<String, dynamic> json) {
    return GameViews(name: json["name"], id: id, viewers: json["viewers"]);
  }
}

class GamesPageState extends State<GamesPage> {
  final DatabaseReference ref =
      FirebaseDatabase.instance.reference().child("games");

  late StreamSubscription<Event> _subscription;
  List<GameViews>? games;

  @override
  void initState() {
    super.initState();

    _subscription = ref.onValue.listen((event) => setState(() {
          games = Map<String, Object?>.from(event.snapshot.value)
              .entries
              .map((e) => GameViews.fromJson(
                  e.key, Map<String, dynamic>.from(e.value as Map)))
              .toList()
            ..sort((a, b) => b.viewers.compareTo(a.viewers));
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
                      child: GestureDetector(
                        child: Image.network(
                            "https://static-cdn.jtvnw.net/ttv-boxart/" +
                                g.name +
                                "-285x380.jpg"),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            GameDetails.routeName,
                            arguments: g.name,
                          );
                        },
                      ),
                      fit: FlexFit.loose,
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
