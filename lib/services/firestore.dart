import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sikep/models/user.dart';
import 'package:sikep/models/perdin.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //user
  Future<void> addUser(UserModel user) async {
    await _db.collection('users').doc(user.nip).set(user.toMap());
  }

  Future<UserModel?> getUserByNip(String nip) async {
    final doc = await _db.collection('users').doc(nip).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  //perdin
  Future<void> addPerdin(PerdinModel perdin) async {
    await _db
        .collection('perjalanan_dinas')
        .doc(perdin.noSpd)
        .set(perdin.toMap());
  }

  Future<List<PerdinModel>> getAllPerdin() async {
    final snapshot = await _db.collection('perjalanan_dinas').get();
    return snapshot.docs.map((doc) => PerdinModel.fromMap(doc.data())).toList();
  }
}
