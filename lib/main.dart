import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zevent/screens/donations_details.dart';
import 'package:zevent/screens/game_details.dart';
import 'package:zevent/screens/zevent_page.dart';
import 'package:zevent/utils/UI.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = performInitialization();

  static Future<FirebaseApp> performInitialization() async {
    FirebaseApp firebase = await Firebase.initializeApp();

    await FirebaseAuth.instance.signInAnonymously();

    FirebaseMessaging.instance.getToken().then((r) => print(r));

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage((m) => _handleMessage(m));

    return firebase;
  }

  static _handleMessage(RemoteMessage message) {
    if (message.data["twitch"] != null) {
      UI.streamLauncher(message.data["twitch"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error while loading Firebase, " +
                    snapshot.error.toString()),
              ),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return const ZEventPage();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return UI.getCenteredLoadingindicator();
        },
      ),
      routes: {
        GameDetails.routeName: (context) => const GameDetails(),
        DonationsDetails.routeName: (context) => const DonationsDetails()
      },
    );
  }
}
