import 'package:flutter/material.dart';
import 'package:time_tracker_app/widgets/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    required String text,
    required VoidCallback? onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          height: 44.0,
          color: Colors.indigo,
          onPressed: onPressed,
        );
}
