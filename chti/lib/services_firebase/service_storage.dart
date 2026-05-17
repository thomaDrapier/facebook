import 'dart:io'; 
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart'; 

class ServiceStorage { 
  static final instance = FirebaseStorage.instance; 

  Reference get ref => instance.ref(); 

  Future<String> addImage({
    required XFile xfile, 
    required String folder, 
    required String memberId, 
    required String imageName,
  }) async {
    final reference = ref.child(folder).child(memberId).child(imageName);
    UploadTask task = reference.putFile(File(xfile.path)); 
    TaskSnapshot snapshot = await task.whenComplete(() => null);
    String imageUrl = await snapshot.ref.getDownloadURL(); 
    return imageUrl;
  }
}