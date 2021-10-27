import 'package:flutter/material.dart';
import 'package:zevent/models/streamer_goals.dart';
import 'package:zevent/utils/realtime_database.dart';
import 'package:zevent/utils/ui.dart';
import 'package:intl/intl.dart';

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
      appBar: UI.getAppBar("Streamers en lignes"),
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
        // style: s.online ? UI.onlineStreamer : UI.offlineStreamer,
      ),
      // subtitle: Text(s.),
      trailing: Text(
        NumberFormat.compact().format(s.donationGoals.length),
        style: UI.viewerCount,
      ),
      onTap: () => UI.streamLauncher(s.twitch));
}
