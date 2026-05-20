import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../modeles/constantes.dart';
import 'service_storage.dart';
import 'package:chti/modeles/membre.dart';

class ServiceFirestore {
  // Acces a la BDD
  static final instance = FirebaseFirestore.instance;

  // Accès spécifique collection
  final firestoreMember = instance.collection(memberCollectionKey);
  final firestorePost = instance.collection(postCollectionKey);

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

  // 2. Ajoute cette méthode pour lire tous les posts triés par date décroissante
  allPosts() => firestorePost.orderBy(dateKey, descending: true).snapshots();

  // Lire les posts d'un utilisateur triés du plus récent au plus ancien
  postForMember(String id) => firestorePost.where(memberIdKey, isEqualTo: id).orderBy(dateKey, descending: true).snapshots();

  // Lire la liste de tous les membres
  allMembers() => firestoreMember.snapshots();

  createPost({
    required Membre member,
    required String text,
    required XFile? image,
  }) async {
    final date = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> map = {
      memberIdKey: member.id,
      likesKey: [],
      dateKey: date,
      textKey: text,
    };

    if (image != null) {
      final url = await ServiceStorage().addImage(
        xfile: image,
        folder: postCollectionKey,
        memberId: member.id,
        imageName: date.toString(),
      );
      map[postImageKey] = url;
      firestorePost.doc().set(map);
    } else {
      firestorePost.doc().set(map);
    }
  }
}