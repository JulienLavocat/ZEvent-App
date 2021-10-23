import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      title: Text(humanize()),
      onLongPress: () async {
        await FirebaseFirestore.instance
            .collection("notifications")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "notifications": FieldValue.arrayRemove([toDoc()])
        });
        await FirebaseMessaging.instance.unsubscribeFromTopic(toString());
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

  String humanize() {
    switch (type) {
      case NotificationsType.game:
        return "Un streamer joue a $game";
      case NotificationsType.online:
        return "$streamer a lancé son live";
      case NotificationsType.gameStreamer:
        return "$streamer joue a $game";
      default:
        return super.toString();
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
