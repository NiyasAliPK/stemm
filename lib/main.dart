import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/app/modules/home/views/home_view.dart';
import 'package:firebase_chat/app/modules/login/views/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBnj1K-cIBt_2ExCXr-jNcizdJvELxuC9E',
          appId: '1:185708009305:android:2303f347e3c09011389e48',
          messagingSenderId: '185708009305',
          projectId: 'stemmchat',
          databaseURL: 'https://stemmchat-default-rtdb.firebaseio.com',
          storageBucket: 'stemmchat.appspot.com'));
  // FACED SOME ISSUES WITH FIREBASE CLI HENCE USED MANUAL ASSIGNMENT
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return HomeView();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return LoginView();
          }
        },
      ),
    );
  }
}
