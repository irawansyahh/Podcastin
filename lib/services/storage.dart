import 'package:Podcastin/services/auth.dart';
import 'package:Podcastin/services/databse.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class StorageService {
  const StorageService();

  Future uploadFile(image) async {
    final user = await AuthService().currentUser();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('images/${user.uid}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    uploadTask.events.listen((event) {
      print(event.type);
    });
    await uploadTask.onComplete;
    final url = await storageReference.getDownloadURL();
    DBService().updateUserDoc(image: url);
  }
}
