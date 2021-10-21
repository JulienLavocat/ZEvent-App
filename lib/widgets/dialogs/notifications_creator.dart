import 'package:flutter/material.dart';
import 'package:zevent/widgets/notifications_manager/notifications_manager.dart';

class NotificationCreatorPage extends StatefulWidget {
  const NotificationCreatorPage({Key? key}) : super(key: key);

  @override
  NotificationCreatorState createState() => NotificationCreatorState();
}

class NotificationCreatorState extends State<NotificationCreatorPage> {
  String? current;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5), child: getPage());
    // return Scaffold(
    //   appBar: UI.getAppBar("Ajouter une notification"),
    //   body:
    //       Padding(padding: EdgeInsets.fromLTRB(10, 5, 10, 5), child: getPage()),
    // );
  }

  Widget getPage() => Column(children: <Widget>[getDropdown(), getSpecific()]);

  Widget getDropdown() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Type: "),
          DropdownButton<String>(
            hint: const Text("Type"),
            value: current,
            onChanged: (n) {
              setState(() {
                current = n!;
              });
            },
            items: NotificationsManager.notifsNames.map(getDropDown).toList(),
          )
        ]);
  }

  Widget getSpecific() {
    if (current != null) {
      return NotificationsManager.getBuilder(current!, context);
    } else {
      return const Text("Pour commencer, séléctionnez un type de notification");
    }
  }

  DropdownMenuItem<String> getDropDown(String n) {
    return DropdownMenuItem<String>(
      child: Text(n),
      value: n,
    );
  }
}
