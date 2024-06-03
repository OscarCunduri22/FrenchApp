// ignore: constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frenc_app/model/student.dart';
import 'package:frenc_app/model/tutor.dart';

const String TUTOR_COLLECTION = 'Teachers';

class DatabaseRepository {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _tutorRef;

  DatabaseRepository() {
    _tutorRef = _firestore.collection(TUTOR_COLLECTION).withConverter<Tutor>(
        fromFirestore: (snapshots, _) => Tutor.fromJson(snapshots.data()!),
        toFirestore: (tutor, _) => tutor.toJson());
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
        .collection('students')
        .where('tutorId', isEqualTo: tutorId)
        .get();
    return students.docs.length;
  }

  Future<List<Student>?> getStudentsByTutorId(String tutorId) async {
    final students = await _firestore
        .collection('students')
        .where('tutorId', isEqualTo: tutorId)
        .get();
    if (students.docs.isNotEmpty) {
      return students.docs.map((e) => Student.fromJson(e.data())).toList();
    }
    return null;
  }
}
