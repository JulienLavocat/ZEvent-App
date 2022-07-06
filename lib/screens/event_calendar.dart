import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zevent/models/event.dart';
import 'package:zevent/screens/events_users_details.dart';
import 'package:zevent/utils/providers/dark_theme_provider.dart';
import 'package:zevent/utils/realtime_database.dart';
import 'package:zevent/utils/ui.dart';

class EventsCalendar extends StatefulWidget {
  const EventsCalendar({Key? key}) : super(key: key);

  @override
  _EventsCalendarState createState() => _EventsCalendarState();
}

class _EventsCalendarState extends State<EventsCalendar> {
  final Future<List<EventModel>> _events = RealtimeDatabase.getEvents();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UI.getAppBar("Calendrier des événements"),
      drawer: UI.getDrawer(context),
      body: FutureBuilder(
          future: _events,
          builder: (context, snapshot) => snapshot.hasData
              ? buildPage(context, snapshot.data as List<EventModel>)
              : UI.getCenteredLoadingindicator()),
    );
  }

  Widget buildPage(BuildContext context, List<EventModel> events) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final dates = <String>[
      "Jeudi\n28 Oct.",
      "Vendredi\n29 Oct.",
      "Samedi\n30 Oct.",
      "Dimanche\n31 Oct."
    ];
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: TabBar(
            tabs: dates
                .map(
                  (e) => Tab(
                    child: Text(
                      e,
                      textAlign: TextAlign.center,
                      style: !themeProvider.darkTheme
                          ? const TextStyle(color: Colors.black)
                          : null,
                    ),
                  ),
                )
                .toList(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(
              children: [
                getDayEvents(events, DateTime.utc(2021, 10, 28, 0, 0, 1),
                    DateTime.utc(2021, 10, 28, 23, 59)),
                getDayEvents(events, DateTime.utc(2021, 10, 29, 0, 0, 1),
                    DateTime.utc(2021, 10, 29, 23, 59)),
                getDayEvents(events, DateTime.utc(2021, 10, 30, 0, 0, 1),
                    DateTime.utc(2021, 10, 30, 23, 59)),
                getDayEvents(events, DateTime.utc(2021, 10, 31, 0, 0, 1),
                    DateTime.utc(2021, 10, 31, 23, 59)),
              ],
            ),
          ),
        ));
  }

  Widget getDayEvents(
          List<EventModel> events, DateTime after, DateTime before) =>
      ListView(
          children: events
              .where((element) =>
                  element.start.isAfter(after) &&
                  element.start.isBefore(before))
              .map((e) => renderEvent(e))
              .toList());

  Widget renderEvent(EventModel e) => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              subtitle:
                  Text("${e.humanizeStartEnd()}\n${e.humanizeOrganizers()}"),
              title: Text(e.title),
              isThreeLine: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(EventUsersDetails.routeName, arguments: e),
                    child: const Text("Participants")),
              ],
            )
          ],
        ),
      );
}
