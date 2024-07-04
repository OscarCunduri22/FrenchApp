// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final Tutor tutor;

  EditProfileScreen({required this.tutor});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final DatabaseRepository _databaseRepository = DatabaseRepository();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tutor.name);
    _usernameController = TextEditingController(text: widget.tutor.username);
    _emailController = TextEditingController(text: widget.tutor.email);
    _passwordController = TextEditingController(text: widget.tutor.password);
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      Tutor updatedTutor = Tutor(
        name: _nameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        code: widget.tutor.code,
      );

      await _databaseRepository.updateTutor(updatedTutor);
      Provider.of<UserProvider>(context, listen: false)
          .setCurrentUser(updatedTutor);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre de usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo electrónico';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
