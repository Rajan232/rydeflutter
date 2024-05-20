import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'colors.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

const appcolour = AppColors();

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<bool> _requestPermission(Permission permission) async {
  var status = await permission.status;

  if (status.isGranted) {
    // Permission is already granted
    return true;
  } else if (status.isDenied) {
    // Ask for permission
    if (await permission.request().isGranted) {
      // Permission granted after asking
      return true;
    } else {
      // Permission denied after asking
      return false;
    }
  } else if (status.isPermanentlyDenied) {
    // Permission permanently denied. Open app settings for the user to change.
    openAppSettings();
    return false;
  }

  // Handle other cases (e.g., restricted) if needed
  return false;
}


  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Navigate to the map view after successful login:
        Navigator.pushNamed(context, '/map'); 
      } on FirebaseAuthException catch (e) {
        print('Error logging in: ${e.message}');
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Navigate to the map view after successful login with Google:
        Navigator.pushNamed(context, '/map'); 
        return userCredential;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolour.darkGrey,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                SizedBox(width: 350, child: Text('Log In', style: TextStyle(fontSize: 65, fontFamily: 'Ubuntu', color: appcolour.accentGreen, fontWeight: FontWeight.w600), textAlign: TextAlign.left,),),
                // Login UI (similar to SignUpPage, but with login fields and button)
                const SizedBox(height: 40),
                SizedBox(width: 370, height: 60, child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),    
                  ), backgroundColor: Colors.white,
                  ),
                onPressed: _signInWithGoogle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/unnamed.png', height: 30),
                    const SizedBox(width: 20,),
                    const Text('Sign in using Google', style: TextStyle(fontFamily: 'RobotoMono', fontSize: 20, fontWeight: ui.FontWeight.w500, color: Color(0xFF222222)),),
                  ],
                ),
                ),), //Google Sign In Button
                
                const SizedBox(height: 30), 
                TextFormField(
                style: TextStyle(color: appcolour.accentGreen),
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder(),),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                ),
                const SizedBox(height: 30), 
                TextFormField(
                style: TextStyle(color: appcolour.accentGreen),
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(borderSide: BorderSide(color: appcolour.primaryGreen)),),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },// ... (password field)
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: 360,
                  child: Align(alignment: Alignment.centerLeft,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize:  const ui.Size(160, 60),
                      backgroundColor: appcolour.accentGreen,
                    ),
                  onPressed: () async{
                    if (await _requestPermission(Permission.location)) {
      // Permission granted. Proceed with location-related actions.
                      print('Location permission granted');

      // ... your location-related code ...
                    } else {
      // Permission denied. Handle this gracefully.
                           print('Location permission denied');
      // Show a dialog or message explaining why the permission is needed
                    }
                    _signInWithEmailAndPassword();
                  },
                  child: Text('Log In', style: TextStyle(fontSize: 21, color: appcolour.darkGrey),),
                ),),),
                const SizedBox(height: 30),
                const SizedBox(width: 335,
                child: Text('Don\'t have an account?', style: TextStyle(fontSize: 18, color: Colors.white),),),
                const SizedBox(height: 20),
                SizedBox(
                child: Align(alignment: Alignment.centerLeft,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const ui.Size(140, 50),
                    backgroundColor: appcolour.primaryGreen,
                  ),
                   onPressed: () async {
                    if (await _requestPermission(Permission.location)) {
      // Permission granted. Proceed with location-related actions.
      print('Location permission granted');

      // ... your location-related code ...
    } else {
      // Permission denied. Handle this gracefully.
      print('Location permission denied');
      // Show a dialog or message explaining why the permission is needed
    } 
                  Navigator.pushNamed(context, '/');// Navigate to the login page (implementation not shown)
                },
                child: Text('Sign Up', style: TextStyle(fontSize: 16, color: appcolour.darkGrey),),
                ),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}