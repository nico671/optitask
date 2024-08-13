import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:optitask/ui/loginscreen/loginscreen.dart';

import '../ui/basescreen.dart';

import '../ui/onboarding/onboarding.dart';

class CheckOnboarding extends StatefulWidget {
  const CheckOnboarding({Key? key}) : super(key: key);

  @override
  CheckOnboardingState createState() => CheckOnboardingState();
}

class CheckOnboardingState extends State<CheckOnboarding>
    with AfterLayoutMixin<CheckOnboarding> {
  late StreamSubscription<User?> user;

  Future checkFirstSeen() async {
    final user = FirebaseAuth.instance.currentUser;
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');

    log('user: $user');
    if (user == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      DataSnapshot data =
          await ref.child(FirebaseAuth.instance.currentUser!.uid).get();
      bool seen = data.exists;
      if (seen) {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Basescreen()));
        }
      } else {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const OnboardingUI()));
        }
      }
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
