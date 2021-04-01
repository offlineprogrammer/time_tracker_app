import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/pages/home_page.dart';
import 'package:time_tracker_app/pages/sign_in_page.dart';
import 'package:time_tracker_app/services/auth.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;

          if (user == null) {
            return SignInPage();
          }
          return HomePage();
        }
        return Scaffold(
          body: CircularProgressIndicator(),
        );
      },
    );
  }
}
