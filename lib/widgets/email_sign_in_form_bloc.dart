import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/bloc/email_sign_in_bloc.dart';
import 'package:time_tracker_app/models/email_sign_in_model.dart';
import 'package:time_tracker_app/models/form_submit_button.dart';
import 'package:time_tracker_app/services/auth.dart';

import 'package:time_tracker_app/widgets/show_exception_alert_dialog.dart';

class EmailSignInFormBloc extends StatefulWidget {
  final EmailSignInBloc bloc;

  EmailSignInFormBloc({Key? key, required this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBloc(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocState createState() => _EmailSignInFormBlocState();
}

class _EmailSignInFormBlocState extends State<EmailSignInFormBloc> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  void _emailEditingComplete(EmailSignInModel model) {
    if (model.emailValidator.isValid(model.email))
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    else
      FocusScope.of(context).requestFocus(_emailFocusNode);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign In failed',
        exception: e,
      );
    }

    print(_emailController.text);
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();

    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(model),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        onPressed: model.submitEnabled ? _submit : null,
        text: model.primaryButtonText,
      ),
      SizedBox(
        height: 8.0,
      ),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryButtonText),
      )
    ];
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      decoration: InputDecoration(
        enabled: model.isLoading == false,
        labelText: 'Password',
        errorText: model.passwordErrorText,
      ),
      obscureText: true,
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: widget.bloc.updatePassword,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      decoration: InputDecoration(
        enabled: model.isLoading == false,
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
      ),
      controller: _emailController,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: widget.bloc.updateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model),
            ),
          );
        });
  }
}
