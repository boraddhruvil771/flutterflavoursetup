import 'package:firebase_core/firebase_core.dart';
import 'package:flavoursetup/ui/myapp.dart';
import 'package:flutter/material.dart';

import 'env.dart';

void main() async {
  AppEnvironment.setUpEnv(Environment.staging);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
