import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/model/game_result.dart';
import 'package:frenc_app/model/student.dart';

const String GAME_RESULT_COLLECTION = 'GameResults';
const String TUTOR_COLLECTION = 'Teachers';
const String STUDENT_COLLECTION = 'students';

class DatabaseRepository {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _tutorRef;
  late final CollectionReference _gameResultRef;
  late final CollectionReference _studentRef;

  DatabaseRepository() {
    _tutorRef = _firestore.collection(TUTOR_COLLECTION).withConverter<Tutor>(
        fromFirestore: (snapshots, _) => Tutor.fromJson(snapshots.data()!),
        toFirestore: (tutor, _) => tutor.toJson());
    _gameResultRef =
        _firestore.collection(GAME_RESULT_COLLECTION).withConverter<GameResult>(
              fromFirestore: (snapshots, _) =>
                  GameResult.fromJson(snapshots.data()!),
              toFirestore: (gameResult, _) => gameResult.toJson(),
            );
    _studentRef = _firestore
        .collection(STUDENT_COLLECTION)
        .withConverter<Student>(
            fromFirestore: (snapshots, _) =>
                Student.fromJson(snapshots.data()!),
            toFirestore: (student, _) => student.toJson());
  }

  Stream<QuerySnapshot> getTutors() {
    return _tutorRef.snapshots();
  }

  Future<bool> addTutor(Tutor tutor) async {
    try {
      await _tutorRef.add(tutor);
      return true;
    } catch (e) {
      return false;
    }
  }

  void deleteTutor(String id) async {
    _tutorRef.doc(id).delete();
  }

  Future<Tutor?> loginTutor(String email, String password) async {
    final tutor = await _tutorRef
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();
    if (tutor.docs.isNotEmpty) {
      return tutor.docs.first.data() as Tutor;
    }
    return null;
  }

  Future<String?> getTutorId(String email) async {
    final tutor = await _tutorRef.where('email', isEqualTo: email).get();
    if (tutor.docs.isNotEmpty) {
      return tutor.docs.first.id;
    }
    return null;
  }

  Future<int?> getStudentsCountByTutorId(String tutorId) async {
    final students = await _firestore
        .collection(STUDENT_COLLECTION)
        .where('tutorId', isEqualTo: tutorId)
        .get();
    return students.docs.length;
  }

  Future<List<Map<String, dynamic>>> getStudentsByTutorId(
      String tutorId) async {
    final students = await _firestore
        .collection(STUDENT_COLLECTION)
        .where('tutorId', isEqualTo: tutorId)
        .get();
    if (students.docs.isNotEmpty) {
      return students.docs.map((e) => {'id': e.id, 'data': e.data()}).toList();
    }
    return [];
  }

  Future<String?> getStudentIdByEmail(String name) async {
    final student = await _firestore
        .collection(STUDENT_COLLECTION)
        .where('name', isEqualTo: name)
        .get();
    if (student.docs.isNotEmpty) {
      return student.docs.first.id;
    }
    return null;
  }

  Future<Student?> getStudentById(String studentId) async {
    final student = await _studentRef.doc(studentId).get();
    if (student.exists) {
      return student.data() as Student;
    }
    return null;
  }

  Future<List<bool>> getGameCompletionStatusByCategory(
      String studentId, String category) async {
    final doc = await _gameResultRef.doc(studentId).get();
    if (doc.exists) {
      final gameResult = doc.data() as GameResult;
      switch (category) {
        case 'Nombres':
          return gameResult.nombresGameCompleted;
        case 'Voyelles':
          return gameResult.voyellesGameCompleted;
        case 'Famille':
          return gameResult.familleGameCompleted;
        default:
          throw Exception('Unknown category');
      }
    } else {
      return [false, false, false];
    }
  }

  Future<void> updateGameCompletionStatus(
      String studentId, String category, List<bool> newStatus) async {
    final doc = await _gameResultRef.doc(studentId).get();
    if (doc.exists) {
      final gameResult = doc.data() as GameResult;
      switch (category) {
        case 'Nombres':
          gameResult.nombresGameCompleted.setAll(0, newStatus);
          break;
        case 'Voyelles':
          gameResult.voyellesGameCompleted.setAll(0, newStatus);
          break;
        case 'Famille':
          gameResult.familleGameCompleted.setAll(0, newStatus);
          break;
        default:
          throw Exception('Unknown category');
      }
      await _gameResultRef.doc(studentId).set(gameResult);
    } else {
      final newGameResult = GameResult(
        studentId: studentId,
        nombresGameCompleted:
            category == 'Nombres' ? newStatus : [false, false, false],
        voyellesGameCompleted:
            category == 'Voyelles' ? newStatus : [false, false, false],
        familleGameCompleted:
            category == 'Famille' ? newStatus : [false, false, false],
      );
      await _gameResultRef.doc(studentId).set(newGameResult);
    }
  }
}
