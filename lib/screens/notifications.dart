import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zevent/screens/notifications_creator.dart';
import 'package:zevent/utils/ui.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsType {
  static const String online = "online";
  static const String game = "game";
  static const String gameStreamer = "game_streamer";
}

class NotificationData {
  String type; // NotificationsType
  String? game;
  String? streamer;

  NotificationData({required this.type, this.game, this.streamer});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
        type: json["type"], game: json["game"], streamer: json["streamer"]);
  }

  ListTile toListTile(BuildContext ctx) {
    return ListTile(
      title: Text("$type - $streamer - $game"),
      onLongPress: () async {
        await FirebaseFirestore.instance
            .collection("notifications")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "notifications": FieldValue.arrayRemove([toDoc()])
        });
        await FirebaseMessaging.instance.unsubscribeFromTopic(toString());
        Navigator.of(ctx).pop();
      },
    );
  }

  Map<String, dynamic> toDoc() {
    switch (type) {
      case NotificationsType.game:
        return {"type": NotificationsType.game, "game": game};
      case NotificationsType.online:
        return {"type": NotificationsType.online, "streamer": streamer};
      case NotificationsType.gameStreamer:
        return {
          "type": NotificationsType.game,
          "streamer": streamer,
          "game": game
        };
      default:
        return {};
    }
  }

  @override
  String toString() {
    switch (type) {
      case NotificationsType.game:
        return "${NotificationsType.game}.$game";
      case NotificationsType.online:
        return "${NotificationsType.online}.$streamer";
      case NotificationsType.gameStreamer:
        return "${NotificationsType.game}.$streamer.$game";
      default:
        return super.toString();
    }
  }
}

class NotificationsPageState extends State<NotificationsPage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection("notifications");

  late Future<List<NotificationData>> notifications;

  @override
  void initState() {
    super.initState();
    notifications = fetchNotifications();
    messaging
        .getToken(
            vapidKey:
                "BG0_rZVcqCrSGhSdc6Kye3265dwufMBsOACwA6mjrl8RRG-tlnfdpgaTVPDHOKKHT7wTYdUv69C7GYWOhvhwLnU")
        .then((r) => print(r));
  }

  Future<List<NotificationData>> fetchNotifications() async {
    var res = (await notificationsCollection.doc(auth.currentUser!.uid).get());

    if (!res.exists) {
      await notificationsCollection
          .doc(auth.currentUser!.uid)
          .set({"notifications": []});
      return [];
    }
    return (Map.from(res.data() as Map)["notifications"] as List)
        .map((e) => NotificationData.fromJson(e))
        .toList();
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
                  title:
                      Center(child: Text("Ajouter une nouvelle notification")),
                  children: [NotificationCreatorPage()],
                )),
      ),
      body: FutureBuilder(
        future: notifications,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text("An error occured: \n" + snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            return getPage(snapshot.data as List<NotificationData>);
          }
          return UI.getCenteredLoadingindicator();
        },
      ),
    );
  }

  Widget getPage(List<NotificationData> channels) {
    return ListView.separated(
      separatorBuilder: (ctx, i) => const Divider(),
      itemCount: channels.length,
      itemBuilder: (ctx, i) => channels[i].toListTile(ctx),
    );
  }
}
