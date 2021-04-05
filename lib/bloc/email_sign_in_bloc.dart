import 'dart:async';

import 'package:time_tracker_app/models/email_sign_in_model.dart';
import 'package:time_tracker_app/services/auth.dart';

class EmailSignInBloc {
  final AuthBase auth;

  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  EmailSignInBloc({required this.auth});

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    updateWith(
        submitted: false,
        email: '',
        password: '',
        isLoading: false,
        formType: _model.formType == EmailSignInFormType.signIn
            ? EmailSignInFormType.register
            : EmailSignInFormType.signIn);
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );

    _modelController.add(_model);
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);

    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        final user = await auth.signInWithEmailAndPassword(
            _model.email, _model.password);
      } else {
        final user = await auth.registerWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
