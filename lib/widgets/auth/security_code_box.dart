// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/user_provider.dart';

class SecurityCodeDialog extends StatelessWidget {
  final Function onSuccess;

  SecurityCodeDialog({required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Security Code'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Please enter the 4-digit security code to proceed.'),
          const SizedBox(height: 16),
          SecurityCodeInput(onSuccess: onSuccess),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class SecurityCodeInput extends StatefulWidget {
  final Function onSuccess;

  SecurityCodeInput({super.key, required this.onSuccess});

  @override
  _SecurityCodeInputState createState() => _SecurityCodeInputState();
}

class _SecurityCodeInputState extends State<SecurityCodeInput> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  void _validateCode(String value) {
    final code = int.tryParse(value);
    if (code != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.currentUser?.code == code) {
        Navigator.of(context).pop();
        widget.onSuccess();
      } else {
        setState(() {
          _errorMessage = 'Invalid code. Please try again.';
        });
        _controller.clear();
      }
    } else {
      setState(() {
        _errorMessage = 'Please enter a valid 4-digit code.';
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PinCodeTextField(
          appContext: context,
          length: 4,
          controller: _controller,
          onChanged: (value) {},
          onCompleted: _validateCode,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}
