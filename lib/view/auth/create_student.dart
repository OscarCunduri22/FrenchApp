// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frenc_app/model/student.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class CreateStudentScreenHorizontal extends StatefulWidget {
  final String tutorId;

  CreateStudentScreenHorizontal({required this.tutorId});

  @override
  _CreateStudentScreenHorizontalState createState() =>
      _CreateStudentScreenHorizontalState();
}

class _CreateStudentScreenHorizontalState
    extends State<CreateStudentScreenHorizontal> {
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
    if (_nameController.text.isEmpty || _imageFile == null) {
      showSnackBar(
          context,
          'Error',
          'Please fill all the fields and select an image.',
          ContentType.failure);
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
      showSnackBar(
          context, 'Error', 'Failed to upload image.', ContentType.failure);
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

    showSnackBar(context, 'Success', 'Student created successfully.',
        ContentType.success);
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
  }

  void showSnackBar(
      BuildContext context, String title, String message, ContentType type) {
    final snackBar = SnackBar(
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/global/cloudsbg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/images/icons/hacia-atras.png',
                          width: 32,
                          height: 32,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const CustomTextWidget(
                          text: 'Agrega un estudiante',
                          type: TextType.Title,
                          fontSize: 34),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(height: 32),
                              _imageFile != null
                                  ? Image.file(
                                      File(_imageFile!.path),
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 150,
                                      height: 150,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image, size: 100),
                                    ),
                              const SizedBox(height: 32),
                              ElevatedButton(
                                onPressed: _pickImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF15E2F),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Selecciona tu foto',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CustomTextWidget(
                                text: "Ingresa el nombre del estudiante",
                                type: TextType.Subtitle,
                                fontSize: 24,
                                color: ColorType.Secondary,
                                shadow: false,
                              ),
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Ej: Pedro Perez',
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        'Inicial 1',
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontSize: 18,
                                            fontFamily: 'TitanOneFont'),
                                      ),
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
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        'Inicial 2',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 18,
                                          fontFamily: 'TitanOneFont',
                                        ),
                                      ),
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
                                  ),
                                ],
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _createStudent,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF016171),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Crear Estudiante',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
