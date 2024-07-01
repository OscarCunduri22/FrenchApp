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
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/auth/security_code.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Código de seguridad',
                style: TextStyle(
                  fontFamily: "TitanOneFont",
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ingresa tu código de acceso al área de tutores.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              SecurityCodeInput(onSuccess: onSuccess),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
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
          _errorMessage = 'Código inválido. Por favor, inténtelo de nuevo.';
        });
        _controller.clear();
      }
    } else {
      setState(() {
        _errorMessage = 'Ingresa un código de 4 dígitos válido.';
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        PinCodeTextField(
          appContext: context,
          length: 4,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          controller: _controller,
          keyboardType: TextInputType.number,
          onChanged: (value) {},
          onCompleted: _validateCode,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
            selectedFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            activeColor: Colors.white,
            selectedColor: Colors.orange,
            inactiveColor: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          textStyle: const TextStyle(color: Colors.black),
          cursorColor: Colors.black,
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.error, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
