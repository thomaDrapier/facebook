import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../modeles/constantes.dart';
import 'service_storage.dart';

class ServiceFirestore {
  // Acces a la BDD
  static final instance = FirebaseFirestore.instance;

  // Accès spécifique collection
  final firestoreMember = instance.collection(memberCollectionKey);

  // Ajouter un membre
  addMember({required String id, required Map<String, dynamic> data}) {
    firestoreMember.doc(id).set(data);
  }

  // Mettre à jour un membre
  updateMember({required String id, required Map<String, dynamic> data}) {
    firestoreMember.doc(id).update(data);
  }

  // stockage et mise à jour d'une image
  updateImage({
    required File file,
    required String folder,
    required String memberId,
    required String imageName}) {
    
    ServiceStorage()
      .addImage(
      xfile: XFile(file.path), folder: folder, memberId: memberId, imageName: imageName).
      then((imageUrl) {
      updateMember(id: memberId, data: {imageName: imageUrl});
    });
  }
  // À ajouter dans la classe ServiceFirestore
  specificMember(String id) => firestoreMember.doc(id).snapshots();
}