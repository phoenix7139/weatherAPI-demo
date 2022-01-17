import 'package:demo_app/pages/auth_page.dart';
import 'package:demo_app/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   primaryColor: Colors.black,
      //   textTheme: Theme.of(context).textTheme.apply(
      //         bodyColor: Colors.white.withOpacity(0.7),
      //         displayColor: Colors.white.withOpacity(0.7),
      //       ),
      // ),
      home: AuthPage(),
    );
  }
}
