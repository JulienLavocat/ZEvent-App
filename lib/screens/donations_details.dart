import 'package:flutter/material.dart';
import 'package:zevent/main.dart';
import 'package:zevent/models/streamer_goals.dart';
import 'package:zevent/utils/ui.dart';
import 'package:intl/intl.dart';

class DonationsDetails extends StatefulWidget {
  static const routeName = "/donations";

  const DonationsDetails({Key? key}) : super(key: key);

  @override
  _DonationsDetailsState createState() => _DonationsDetailsState();
}

class _DonationsDetailsState extends State<DonationsDetails> {
  @override
  Widget build(BuildContext context) {
    final StreamerGoals goals =
        ModalRoute.of(context)!.settings.arguments as StreamerGoals;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text(goals.displayName),
              centerTitle: true,
              bottom: const TabBar(tabs: [
                Tab(text: "Simples"),
                Tab(text: "Récurents"),
              ]),
            ),
            body: TabBarView(children: [
              getDonationsList(
                  goals,
                  goals.donationGoals
                      .where((element) => element.nature == "simple")
                      .toList()),
              getDonationsList(
                  goals,
                  goals.donationGoals
                      .where((element) => element.nature == "recurent")
                      .toList()),
            ])));
  }

  getDonationsList(StreamerGoals goals, List<DonationGoal> donationGoals) =>
      Padding(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
          ),
          child: ListView.separated(
            separatorBuilder: (ctx, index) => const Divider(),
            itemCount: donationGoals.length,
            itemBuilder: (ctx, i) => getDonationView(goals, donationGoals[i]),
          ));

  getDonationView(StreamerGoals g, DonationGoal s) {
    return ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            s.nature == "simple"
                ? Icon(s.done ? Icons.check_box : Icons.check_box_outline_blank)
                : Text("Tous les\n${UI.formatCurrency(s.amount)}"),
          ],
        ),
        title: Text(
          s.name,
        ),
        subtitle: s.nature == "simple"
            ? Text(
                UI.formatCurrency(s.amount),
              )
            : null);
  }
}
