import 'package:flutter/material.dart';
import 'package:zevent/models/event.dart';
import 'package:zevent/utils/ui.dart';

class EventUsersDetails extends StatefulWidget {
  static const routeName = "/events";

  const EventUsersDetails({Key? key}) : super(key: key);

  @override
  _EventUsersDetailsState createState() => _EventUsersDetailsState();
}

class _EventUsersDetailsState extends State<EventUsersDetails> {
  @override
  Widget build(BuildContext context) {
    EventModel event = ModalRoute.of(context)!.settings.arguments as EventModel;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text(event.title),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: "Organisateurs",
                  ),
                  Tab(
                    text: "Participants",
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: [
                getUsersView(event.organizers),
                getUsersView(event.participants)
              ],
            )));
  }

  getUsersView(List<EventUser> users) => Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: ListView.separated(
            itemBuilder: (ctx, i) {
              final s = users[i];
              return ListTile(
                leading: Image.network(s.profileUrl),
                title: Text(
                  s.display,
                ),
                onTap: () => UI.handleLaunchUrl(s.url),
              );
            },
            separatorBuilder: (e, i) => const Divider(),
            itemCount: users.length),
      );
}
