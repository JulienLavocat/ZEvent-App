import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zevent/models/notifications_data.dart';

class Firestore {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static StreamSubscription subscribeToNotifications(
      String userId, Function(List<NotificationData>) handler) {
    return firestore.collection("notifications").doc(userId).snapshots().listen(
        (event) => handler(
            (Map.from(event.data() as Map)["notifications"] as List)
                .map((e) => NotificationData.fromJson(e))
                .toList()));
  }

  static addNotification(String userId, NotificationData data) {
    FirebaseFirestore.instance.collection("notifications").doc(userId).update({
      "notifications": FieldValue.arrayUnion([data.toDoc()])
    });
  }
}
