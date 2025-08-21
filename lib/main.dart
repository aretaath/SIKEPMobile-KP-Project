import 'package:flutter/material.dart';
import 'package:sikep/screens/login.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(SikepApp());
}

class SikepApp extends StatelessWidget {
  const SikepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIKEP',
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
