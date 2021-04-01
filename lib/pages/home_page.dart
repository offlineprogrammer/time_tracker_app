import 'package:flutter/material.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:time_tracker_app/widgets/show_alart_dialog.dart';

class HomePage extends StatelessWidget {
  final AuthBase auth;

  const HomePage({Key? key, required this.auth}) : super(key: key);

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    try {
      final didRequestSignOut = await showAlertDialog(context,
          title: 'Logout',
          content: 'Are you sure you want to logout',
          defaultActionText: 'Logout',
          cancelActionText: 'Cancel');

      if (didRequestSignOut == true) {
        _signOut();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
