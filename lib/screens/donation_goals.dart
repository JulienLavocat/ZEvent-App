import 'package:flutter/material.dart';
import 'package:zevent/models/streamer_goals.dart';
import 'package:zevent/screens/donations_details.dart';
import 'package:zevent/utils/realtime_database.dart';
import 'package:zevent/utils/ui.dart';

class DonationsGoals extends StatefulWidget {
  const DonationsGoals({Key? key}) : super(key: key);

  @override
  _DonationsGoalsState createState() => _DonationsGoalsState();
}

class _DonationsGoalsState extends State<DonationsGoals> {
  Future<List<StreamerGoals>> goals = RealtimeDatabase.getDonationGoals();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UI.getAppBar("Donation goals"),
      drawer: UI.getDrawer(context),
      body: FutureBuilder(
        future: goals,
        builder: (context, snapshot) => snapshot.hasData
            ? buildPage(context, snapshot.data as List<StreamerGoals>)
            : UI.getCenteredLoadingindicator(),
      ),
    );
  }

  Widget buildPage(BuildContext ctx, List<StreamerGoals> goals) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: ListView.separated(
            itemCount: goals.length,
            separatorBuilder: (ctx, index) {
              return const Divider();
            },
            itemBuilder: (ctx, i) => streamerView(ctx, goals[i])),
      );

  ListTile streamerView(BuildContext ctx, StreamerGoals s) => ListTile(
      leading: Image.network(s.profileUrl),
      title: Text(
        s.displayName,
      ),
      trailing: Text(
        s.completed.toString() + "/" + s.donationGoals.length.toString(),
        style: UI.viewerCount,
      ),
      onTap: () => Navigator.pushNamed(
            context,
            DonationsDetails.routeName,
            arguments: s,
          ));
}
