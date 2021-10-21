import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zevent/models/notifications_data.dart';
import 'package:zevent/screens/notifications_creator.dart';
import 'package:zevent/utils/ui.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection("notifications");

  late StreamSubscription _subscription;

  List<NotificationData>? _notifications;

  @override
  void initState() {
    super.initState();

    _subscription = notificationsCollection
        .doc(auth.currentUser!.uid)
        .snapshots()
        .listen((event) => setState(() {
              _notifications = event.exists
                  ? (Map.from(event.data() as Map)["notifications"] as List)
                      .map((e) => NotificationData.fromJson(e))
                      .toList()
                  : null;
            }));

    messaging
        .getToken(
            vapidKey:
                "BG0_rZVcqCrSGhSdc6Kye3265dwufMBsOACwA6mjrl8RRG-tlnfdpgaTVPDHOKKHT7wTYdUv69C7GYWOhvhwLnU")
        .then((r) => print(r));
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
