import 'package:flutter/material.dart';

abstract class AbstractNotification {
  String name = "notif";

  Widget build(BuildContext context);
  Widget? getType();

  DropdownMenuItem getDropDown() {
    return DropdownMenuItem(
      child: Text(name),
    );
  }
}
