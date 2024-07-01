import 'package:flutter/material.dart';

class ExitAndLogoutDialog extends StatelessWidget {
  final VoidCallback onExitConfirmed;
  final VoidCallback onLogoutAndExitConfirmed;

  const ExitAndLogoutDialog({
    required this.onExitConfirmed,
    required this.onLogoutAndExitConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmación de Salida'),
      content: const Text('¿Deseas salir o salir y cerrar sesión?'),
      actions: [
        TextButton(
          onPressed: onExitConfirmed,
          child: const Text('Salir'),
        ),
        TextButton(
          onPressed: onLogoutAndExitConfirmed,
          child: const Text('Salir y Cerrar Sesión'),
        ),
      ],
    );
  }
}
