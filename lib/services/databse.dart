import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Podcastin/services/auth.dart';

class DBService {
  const DBService();

  createUserDoc(String email, String name, String uid) {
    Firestore.instance
        .collection('users')
        .document(uid)
        .setData({'email': email, 'name': name, 'uid': uid});
  }

  Stream getUserDoc(uid) {
    return Firestore.instance.collection('users').document(uid).snapshots();
  }

  Future updateUserDoc({image}) async {
    final user = await AuthService().currentUser();
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData({
      'image': image,
    });
  }
}
