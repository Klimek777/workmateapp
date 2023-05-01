import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

class FirebaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  final String USER_COLLECTION = 'users';
  final String WORK_COLLECTION = 'work';
  Map? currentUser;

  FirebaseService();

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String _userId = _userCredential.user!.uid;
      await _db.collection(USER_COLLECTION).doc(_userId).set({
        "name": name,
        "email": email,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_userCredential.user != null) {
        currentUser = await getUserData(uid: _userCredential.user!.uid);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot? _doc =
        await _db.collection(USER_COLLECTION).doc(uid).get();
    return _doc.data() as Map;
  }

  Future<bool> postWork(
    String name,
    String phone,
    String address,
    String city,
    String time,
    String date,
    String? product,
    String? notes,
    String sum,
    String status,
  ) async {
    try {
      String _userId = _auth.currentUser!.uid;
      DocumentReference documentReference =
          await _db.collection(WORK_COLLECTION).add({
        "userId": _userId,
        "name": name,
        "phone": phone,
        "address": address,
        "city": city,
        "time": time,
        "date": date,
        "product": product,
        "notes": notes,
        "sum": sum,
        "status": status,
      });
      String documentId = documentReference
          .id; // get the documentId of the newly created document
      setDocumentId(documentId); // set the documentId to be used later
      return true;

      return true;
    } catch (e) {
      return false;
    }
  }

  String? _documentId;

  void setDocumentId(String documentId) {
    _documentId = documentId;
  }

  String? getDocumentId() {
    return _documentId;
  }

  Stream<QuerySnapshot> getWorkForUser(String date) {
    String _userId = _auth.currentUser!.uid;

    return _db
        .collection(WORK_COLLECTION)
        .where('userId', isEqualTo: _userId)
        .where('date', isEqualTo: date)
        .snapshots();
  }

  Future<bool> deleteWork(String documentId) async {
    try {
      await _db.collection(WORK_COLLECTION).doc(documentId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateStatus(String documentId, String newStatus) async {
    try {
      await _db
          .collection(WORK_COLLECTION)
          .doc(documentId)
          .update({'status': newStatus});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
