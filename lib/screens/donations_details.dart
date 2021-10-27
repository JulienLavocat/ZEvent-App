import 'package:flutter/material.dart';
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

    return Scaffold(
        appBar: UI.getAppBar(goals.displayName),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ListView.separated(
              separatorBuilder: (ctx, index) => const Divider(),
              itemCount: goals.donationGoals.length,
              itemBuilder: (ctx, i) =>
                  getDonationView(goals, goals.donationGoals[i]),
            )));
  }

  getDonationView(StreamerGoals g, DonationGoal s) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(s.done ? Icons.check_box : Icons.check_box_outline_blank),
        ],
      ),
      title: Text(
        s.name,
      ),
      subtitle: Text(UI.formatCurrency(s.amount)),
    );
  }
}
