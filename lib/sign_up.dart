import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'colors.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

const appcolour = AppColors();

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushNamed(context, '/map'); 
      } on FirebaseAuthException catch (e) {
        print('Error creating account: ${e.message}');
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 350,
                child: Text('Sign Up', style: TextStyle(fontSize: 65, color: appcolour.accentGreen, fontFamily: 'Ubuntu', fontWeight: FontWeight.w600,),textAlign: TextAlign.left,)
              ),
              Flexible(child: SizedBox(height: 40)),
              SizedBox(
                width: 350,
                height: 60,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),    
                  ), backgroundColor: appcolour.lightGrey,
                  ),
                onPressed: _signInWithGoogle,
                child: const Text('Sign in using Google', style: TextStyle(fontSize: 20, color: Color(0xFF222222)),),
              ),),
              const SizedBox(height: 30),
              TextFormField(
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
              const SizedBox(height: 20),
              TextFormField(
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
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder(),),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              Flexible(flex: 2,child: SizedBox(height: 35),),
              SizedBox(
                width: 360,                
                child: Align(alignment: Alignment.centerLeft,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const ui.Size(160, 60),
                    backgroundColor: appcolour.accentGreen,
                  ),
                onPressed: _signUp,
                child: Text('Sign Up', style: TextStyle(fontSize: 21, color: appcolour.darkGrey),),
              ),)),
              Flexible(child: SizedBox(height: 20,),),
              const SizedBox(
                width: 335,
                child:Text('Already Signed Up?', style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'Ubuntu', fontWeight: FontWeight.w400,),textAlign: TextAlign.left,))
              ,
              Flexible(child: SizedBox(height: 20,),),
              SizedBox(
                child: Align(alignment: Alignment.centerLeft,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const ui.Size(140, 50),
                    backgroundColor: appcolour.primaryGreen,
                  ),
                   onPressed: () { 
                  // Navigate to the login page (implementation not shown)
                },
                child: Text('Log In', style: TextStyle(fontSize: 16, color: appcolour.darkGrey),),
                ),),
                )
              
            ],
          ),
        ),
      ),
    );
  }
}

