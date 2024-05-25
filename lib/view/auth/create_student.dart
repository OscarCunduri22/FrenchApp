import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frenc_app/model/student.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateStudentScreen extends StatefulWidget {
  final String tutorId;

  CreateStudentScreen({required this.tutorId});

  @override
  _CreateStudentScreenState createState() => _CreateStudentScreenState();
}

class _CreateStudentScreenState extends State<CreateStudentScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedGroup;
  XFile? _imageFile;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<String?> _uploadImage(String studentId) async {
    if (_imageFile == null) return null;
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('students')
        .child('$studentId.jpg');
    await firebaseStorageRef.putFile(File(_imageFile!.path));
    return await firebaseStorageRef.getDownloadURL();
  }

  Future<void> _createStudent() async {
    if (_nameController.text.isEmpty ||
        _selectedGroup == null ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields and select an image.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String? imageUrl = await _uploadImage(_nameController.text);
    if (imageUrl == null) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to upload image.'),
        ),
      );
      return;
    }

    Student student = Student(
      name: _nameController.text,
      group: _selectedGroup!,
      tutorId: widget.tutorId,
      imageUrl: imageUrl,
    );

    await FirebaseFirestore.instance
        .collection('students')
        .add(student.toJson());

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nuevo Estudiante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                    ),
                    SizedBox(height: 16),
                    Text('Grupo'),
                    ListTile(
                      title: const Text('Inicial 1'),
                      leading: Radio<String>(
                        value: 'Inicial 1',
                        groupValue: _selectedGroup,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGroup = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Inicial 2'),
                      leading: Radio<String>(
                        value: 'Inicial 2',
                        groupValue: _selectedGroup,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGroup = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Seleccionar Imagen'),
                        ),
                        SizedBox(width: 16),
                        _imageFile != null
                            ? Image.file(
                                File(_imageFile!.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _createStudent,
                        child: Text('Crear Estudiante'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
