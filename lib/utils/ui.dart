// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zevent/screens/donation_goals.dart';
import 'package:zevent/screens/event_calendar.dart';
import 'package:zevent/screens/games.dart';
import 'package:zevent/screens/notifications.dart';
import 'package:zevent/screens/streamers.dart';
import 'package:zevent/screens/zevent_page.dart';
import 'package:intl/intl.dart';
import 'package:zevent/utils/providers/dark_theme_provider.dart';
import 'package:zevent/utils/user_preferences.dart';

class PageEntry {
  String name;
  Widget Function(BuildContext context) builder;

  PageEntry(this.name, this.builder);
}

class UI {
  static TextStyle onlineStreamer = const TextStyle(color: Colors.green);
  static TextStyle offlineStreamer = const TextStyle(color: Colors.red);
  static TextStyle viewerCount = TextStyle(color: Colors.grey[700]);
  static TextStyle gamesViewersCount = const TextStyle(fontSize: 14);
  static TextStyle gamesTitle = TextStyle(color: Colors.grey[700]);

  static List<PageEntry> pages = <PageEntry>[
    PageEntry("Statistiques globales", ((context) => const ZEventPage())),
    PageEntry("Streameurs", ((context) => const StreamersPage())),
    PageEntry("Jeux streamés", ((context) => const GamesPage())),
    PageEntry("Donation goals", ((context) => const DonationsGoals())),
    PageEntry(
        "Calendrier des événements", ((context) => const EventsCalendar())),
    PageEntry("Notifications", ((context) => const NotificationsPage())),
  ];

  static SafeArea getDrawer(BuildContext ctx) {
    final themeChange = Provider.of<DarkThemeProvider>(ctx);

    return SafeArea(
      child: Drawer(
        child: Column(
          children: <Widget>[
            Image.asset("assets/images/drawer_header_2022.png"),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    PageEntry page = pages[index];
                    ListTile tile = ListTile(
                      title: Text(page.name),
                      onTap: () {
                        Navigator.of(ctx).pop();
                        if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
                        Navigator.of(ctx)
                            .push(MaterialPageRoute(builder: page.builder));
                      },
                    );
                    return index == 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: tile,
                          )
                        : tile;
                  },
                  separatorBuilder: (ctx, i) => const Divider(),
                  itemCount: pages.length),
            ),
            const Divider(),
            IconButton(
              onPressed: () {
                themeChange.darkTheme = !themeChange.darkTheme;
              },
              icon: Icon(
                  !themeChange.darkTheme ? Icons.brightness_2 : Icons.wb_sunny),
            )
          ],
        ),
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
      child: Text("Une erreur est survenue pendant le chargement.\n$error"),
    );
  }

  static streamLauncher(String channel) async {
    final url = "https://twitch.tv/$channel";
    return handleLaunchUrl(url);
  }

  static handleLaunchUrl(String url) async {
    // ignore: avoid_print
    print("Launching url :>> $url");
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  static formatCurrency(dynamic value) {
    return NumberFormat.currency(decimalDigits: 2, locale: "fr_FR", symbol: "€")
        .format(value);
  }
}
