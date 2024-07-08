import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/auth/login_tutor_screen.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/dialog_manager.dart';
import 'dart:ui';
import 'package:frenc_app/view/auth/create_student.dart'; // Importar la pantalla de creación de usuario
import 'package:frenc_app/widgets/auth/student_card.dart'; // Importar el widget StudentCard
import 'package:frenc_app/model/student.dart'; // Importar el modelo Student
import 'package:frenc_app/view/auth/edit_profile.dart'; // Importar la pantalla de edición de perfil
import 'package:frenc_app/view/auth/student_detail_screen.dart'; // Importar la pantalla de detalles del estudiante
import 'package:frenc_app/widgets/auth/common_button_styles.dart'; // Importar estilos de botones comunes

class TutorDashboardScreen extends StatefulWidget {
  final String tutorName;

  const TutorDashboardScreen({super.key, required this.tutorName});

  @override
  _TutorDashboardScreenState createState() => _TutorDashboardScreenState();
}

class _TutorDashboardScreenState extends State<TutorDashboardScreen> {
  final DatabaseRepository _databaseRepository = DatabaseRepository();
  bool showDeleteButtons = false;
  int studentCount = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _loadStudentCount();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> _loadStudentCount() async {
    Tutor? currentUser =
        Provider.of<UserProvider>(context, listen: false).currentUser;
    if (currentUser != null) {
      String? tutorId = await _databaseRepository.getTutorId(currentUser.email);
      if (tutorId != null) {
        int? count =
            await _databaseRepository.getStudentsCountByTutorId(tutorId);
        setState(() {
          studentCount = count!;
        });
      }
    }
  }

  void toggleDeleteButtons() {
    setState(() {
      showDeleteButtons = !showDeleteButtons;
    });
  }

  Future<void> deleteStudent(String studentId) async {
    await _databaseRepository.deleteStudentById(studentId);
    _loadStudentCount();
    setState(() {});
  }

  Future<void> confirmDeleteStudent(
      String studentId, String studentName) async {
    bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Alumno'),
          content: Text('¿Deseas eliminar al alumno $studentName?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancelar
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Aceptar
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await deleteStudent(studentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    Tutor? currentUser = Provider.of<UserProvider>(context).currentUser;
    String? tutorId = Provider.of<UserProvider>(context).currentUserId;
    if (currentUser == null) {
      return Scaffold(
        body: Center(
            child: Container(
          color: Colors.white,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        )),
      );
    }

    return WillPopScope(
        onWillPop: () async {
          DialogManager.showExitConfirmationDialog(context);
          return false;
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/fondo_tutor_dashboard.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    const CustomTextWidget(
                      text: 'Tutor',
                      type: TextType.Subtitle,
                      color: ColorType.Primary,
                      fontSize: 44,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 1.0,
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/gallo.png'),
                                  radius: 40,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentUser.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Estudiantes: $studentCount',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 77.6,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileScreen(
                                                  tutor: currentUser),
                                        ),
                                      );
                                    },
                                    style:
                                        CommonButtonStyles.primaryButtonStyle,
                                    child: const Text(
                                      'Editar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: CustomTextWidget(
                        text: 'Alumnos',
                        type: TextType.Subtitle,
                        color: ColorType.Primary,
                        fontSize: 44,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateStudentScreenHorizontal(
                                        tutorId: tutorId!),
                              ),
                            );
                            _loadStudentCount();
                          },
                          style: CommonButtonStyles.primaryButtonStyle,
                          child: const Text(
                            'Crear Alumno',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: toggleDeleteButtons,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Eliminar Alumno',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future:
                            _databaseRepository.getStudentsByTutorId(tutorId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error al cargar alumnos'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No hay alumnos registrados'));
                          }

                          final alumnos = snapshot.data!;
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Número de columnas
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: alumnos.length,
                            itemBuilder: (context, index) {
                              final studentData = alumnos[index]['data'];
                              final studentId = alumnos[index]['id'];
                              final student = Student.fromJson(studentData);
                              return Stack(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: GestureDetector(
                                      child: StudentCard(
                                        student: student,
                                        studentId: studentId,
                                        onTap: (id) {
                                          Provider.of<UserProvider>(context, listen: false).clearStudent();
                                          Provider.of<UserProvider>(context, listen: false).setCurrentStudent(studentId, student);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentDetailScreen(
                                                      student: student,
                                                      studentId: studentId),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  if (showDeleteButtons)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: IconButton(
                                        icon: Image.asset(
                                          'assets/images/icons/exit.png',
                                          width: 32,
                                          height: 32,
                                        ),
                                        onPressed: () {
                                          confirmDeleteStudent(
                                              studentId, student.name);
                                        },
                                      ),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<UserProvider>(context, listen: false).clearUser();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TutorLoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
