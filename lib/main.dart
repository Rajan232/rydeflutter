import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rydeflutter/log_in.dart';
import 'firebase_options.dart'; 
import 'sign_up.dart'; 
import 'map_view_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'You App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>( // Use StreamBuilder for real-time updates
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator
          } else {
            if (snapshot.hasData) {
              return MapViewMain();
            } else {
              return LoginPage();
            }
          }
        },
      ),
      initialRoute: '/',
      routes: {
        '/signUp': (context) => SignUpPage(),
        '/map': (context) => MapViewMain(),
        '/login': (context) => LoginPage(), 
      },
    );
  }
}