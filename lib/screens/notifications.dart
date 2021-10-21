import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zevent/models/notifications_data.dart';
import 'package:zevent/utils/firestore.dart';
import 'package:zevent/utils/ui.dart';
import 'package:zevent/widgets/dialogs/notifications_creator.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  late StreamSubscription _subscription;
  List<NotificationData>? _notifications;

  @override
  void initState() {
    super.initState();

    _subscription = Firestore.subscribeToNotifications(
        FirebaseAuth.instance.currentUser!.uid,
        (notifs) => setState(() {
              _notifications = notifs;
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
        appBar: UI.getAppBar("Notifications"),
        drawer: UI.getDrawer(context),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showDialog(
              context: context,
              builder: (ctx) => const SimpleDialog(
                    title: Center(
                        child: Text("Ajouter une nouvelle notification")),
                    children: [NotificationCreatorPage()],
                  )),
        ),
        body: _notifications != null
            ? getPage()
            : UI.getCenteredLoadingindicator());
  }

  Widget getPage() {
    return ListView.separated(
      separatorBuilder: (ctx, i) => const Divider(),
      itemCount: _notifications!.length,
      itemBuilder: (ctx, i) => _notifications![i].toListTile(ctx),
    );
  }
}
