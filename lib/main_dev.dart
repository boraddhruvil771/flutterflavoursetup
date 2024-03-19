import 'package:firebase_core/firebase_core.dart';
import 'package:flavoursetup/firebase/firebaseapi.dart';
import 'package:flavoursetup/ui/myapp.dart';
import 'package:flutter/material.dart';

import 'env.dart';

Future<void> main() async {
  AppEnvironment.setUpEnv(Environment.dev);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  runApp(const MyApp());
}
