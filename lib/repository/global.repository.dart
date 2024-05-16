// ignore: constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void addTutor(Tutor tutor) async {
    _tutorRef.add(tutor);
  }

  void deleteTutor(String id) async {
    _tutorRef.doc(id).delete();
  }
}
