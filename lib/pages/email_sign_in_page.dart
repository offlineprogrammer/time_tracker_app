import 'package:flutter/material.dart';
import 'package:time_tracker_app/widgets/email_sign_in_form_bloc.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInFormBloc.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
