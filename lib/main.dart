import 'package:flutter/material.dart';
import 'package:sikep/screens/login.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

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
