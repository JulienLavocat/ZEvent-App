// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zevent/screens/games.dart';
import 'package:zevent/screens/notifications.dart';
import 'package:zevent/screens/streamers.dart';
import 'package:zevent/screens/zevent_page.dart';

class UI {
  static TextStyle onlineStreamer = const TextStyle(color: Colors.green);
  static TextStyle offlineStreamer = const TextStyle(color: Colors.red);
  static TextStyle viewerCount = TextStyle(color: Colors.grey[700]);
  static TextStyle gamesViewersCount = const TextStyle(fontSize: 14);
  static TextStyle gamesTitle = TextStyle(color: Colors.grey[700]);

  static Drawer getDrawer(BuildContext ctx) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Image.asset("assets/images/drawer_header.png"),
          ListTile(
            title: const Text("Statistiques globales"),
            onTap: () {
              Navigator.of(ctx).pop();
              if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
              Navigator.of(ctx).push(
                  MaterialPageRoute(builder: (ctx) => const ZEventPage()));
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Streameurs"),
            onTap: () {
              Navigator.of(ctx).pop();
              if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
              Navigator.of(ctx).push(
                  MaterialPageRoute(builder: (ctx) => const StreamersPage()));
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Jeux streamés"),
            onTap: () {
              Navigator.of(ctx).pop();
              if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
              Navigator.of(ctx)
                  .push(MaterialPageRoute(builder: (ctx) => GamesPage()));
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Notifications"),
            onTap: () {
              Navigator.of(ctx).pop();
              if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
              Navigator.of(ctx).push(MaterialPageRoute(
                  builder: (ctx) => const NotificationsPage()));
            },
          ),
          // const Divider(),
          // ListTile(
          //   title: const Text("Faire un don"),
          //   onTap: () {
          //     Navigator.of(ctx).pop();
          //     if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
          //     Navigator.of(ctx)
          //         .push(MaterialPageRoute(builder: (ctx) => NYIPage()));
          //   },
          // )
        ],
      ),
    );
  }

  static AppBar getAppBar(String title) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
    );
  }

  static Widget getCenteredLoadingindicator() {
    return const Center(child: CircularProgressIndicator());
  }

  static void displaySnackbarAction(
      BuildContext ctx, String content, String action, Function onPressed) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(content),
      action: SnackBarAction(
        label: action,
        onPressed: () => onPressed(),
      ),
    ));
  }

  static void displaySnackbar(BuildContext ctx, String content) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(content),
    ));
  }

  static Widget getError(BuildContext ctx, Object error) {
    // ignore: avoid_print
    print(error);
    return Center(
      child: Text("Une erreur est survenue pendant le chargement.\n" +
          error.toString()),
    );
  }

  static streamLauncher(String channel) async {
    final url = "https://twitch.tv/" + channel;
    // ignore: avoid_print
    print("Launching stream :>> " + url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
