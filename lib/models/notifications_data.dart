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
  String type;
  String? game;
  String? streamer;
  String? streamerDisplayName;
  String? gameDisplayName;

  NotificationData(
      {required this.type,
      this.game,
      this.streamer,
      this.streamerDisplayName,
      this.gameDisplayName});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
        type: json["type"],
        game: json["game"],
        streamer: json["streamer"],
        streamerDisplayName: json["streamerDisplayName"],
        gameDisplayName: json["gameDisplayName"]);
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
    return {
      "type": type,
      "game": game,
      "streamer": streamer,
      "streamerDisplayName": streamerDisplayName,
      "gameDisplayName": gameDisplayName
    };
  }

  String humanize() {
    switch (type) {
      case NotificationsType.game:
        return game != null
            ? "[Nom] joue à $gameDisplayName"
            : "[Nom] joue à [Jeu]";
      case NotificationsType.online:
        return streamer != null
            ? "$streamerDisplayName a lancé son live"
            : "[Nom] à lancé son live";
      case NotificationsType.gameStreamer:
        return "$streamerDisplayName joue a $gameDisplayName";
      default:
        return super.toString();
    }
  }

  @override
  String toString() {
    switch (type) {
      case NotificationsType.game:
        return game != null
            ? "${NotificationsType.game}.$game"
            : NotificationsType.game;
      case NotificationsType.online:
        return streamer != null
            ? "${NotificationsType.online}.$streamer"
            : NotificationsType.online;
      case NotificationsType.gameStreamer:
        return "${NotificationsType.game}.$streamer.$game";
      default:
        return super.toString();
    }
  }
}
