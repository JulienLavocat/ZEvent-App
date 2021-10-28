import 'package:flutter/material.dart';
import 'package:zevent/models/event.dart';
import 'package:zevent/utils/realtime_database.dart';
import 'package:zevent/utils/ui.dart';
import 'package:intl/intl.dart';

class EventsCalendar extends StatefulWidget {
  const EventsCalendar({Key? key}) : super(key: key);

  @override
  _EventsCalendarState createState() => _EventsCalendarState();
}

class _EventsCalendarState extends State<EventsCalendar> {
  final Future<List<EventModel>> _events = RealtimeDatabase.getEvents();
  @override
  Widget build(BuildContext context) {
    // return buildPage(context, []);
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
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Vendredi\n29 Oct.",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                child: Text(
                  "Samedi\n30 Oct.",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                child: Text(
                  "Dimanche\n31 Oct.",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(
              children: [
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
                  Text(e.humanizeStartEnd() + "\n" + e.humanizeOrganizers()),
              title: Text(e.title),
              isThreeLine: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {}, child: const Text("Organisateurs")),
                const SizedBox(
                  height: 8,
                ),
                TextButton(onPressed: () {}, child: const Text("Participants")),
                const SizedBox(
                  height: 8,
                ),
              ],
            )
          ],
        ),
      );
}
