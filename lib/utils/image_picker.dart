import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

Future<void> pickImage(
    ImagePicker picker, void Function(XFile?) setImageFile) async {
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
  setImageFile(pickedFile);
}

Future<String?> uploadImage(String studentId, XFile? imageFile) async {
  if (imageFile == null) return null;
  final firebaseStorageRef =
      FirebaseStorage.instance.ref().child('students').child('$studentId.jpg');
  await firebaseStorageRef.putFile(File(imageFile.path));
  return await firebaseStorageRef.getDownloadURL();
}

void showSnackBar(BuildContext context, String title, String message,
    ContentType contentType) {
  final snackBar = SnackBar(
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
