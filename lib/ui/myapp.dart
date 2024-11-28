import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flavoursetup/otpverification/OptVerfication.dart';
import 'package:flutter/material.dart';

import '../env.dart';
import '../firedatabase/RealtimeDatabaseDemo.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppEnvironment.title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: AppEnvironment.primaryColors),
        useMaterial3: true,
      ),
      home: MyHomePage(title: AppEnvironment.title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _signInAnonymously() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in: ${user.uid}');
      }
    });

/*
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      debugPrint("Signed in as: ${userCredential.user?.uid}");
    } catch (e) {
      debugPrint("Error signing in anonymously: $e");
    }
*/
  }

  void _incrementCounter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RealtimeDatabaseDemo(),
      ),
    );
  }

  void _redurectToOtpVerficationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Optverfication(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(AppEnvironment.baseApiUrl),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            InkWell(
              onTap: () {
                FirebaseCrashlytics.instance.crash();
              },
              child: SizedBox(
                height: 200,
                width: 200,
                child: Image(image: NetworkImage(AppEnvironment.imageUrl)),
              ),
            ),
            ElevatedButton(
              onPressed: _signInAnonymously,
              child: const Text("Sign in Anonymously"),
            ),
          ],
        ),
      ),
      floatingActionButton:
          Column(crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment:MainAxisAlignment.end,children: [
        FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: _redurectToOtpVerficationScreen,
          tooltip: 'OTP verfication',
          child: const Icon(Icons.mobile_friendly),
        ),
      ]),
    );
  }
}
