import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frenc_app/firebase_options.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/family/game3/drag_family.dart';
import 'package:frenc_app/view/auth/student_login.view.dart';
import 'package:frenc_app/view/numbers/game1/game_screen.dart';
import 'package:frenc_app/view/numbers/game2/game_screen.dart';
import 'package:frenc_app/view/numbers/game3/game_screen.dart';
import 'package:frenc_app/view/start_screen.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/view/family/game1/family_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LudoFrench',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: MemoryNumbersGame());
  }
}


/* Checked */