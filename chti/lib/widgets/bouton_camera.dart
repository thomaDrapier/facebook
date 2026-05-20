import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/constantes.dart';

class BoutonCamera extends StatelessWidget {
  final String type;
  final String id;

  const BoutonCamera({super.key, required this.type, required this.id});

  void _takePicture(BuildContext context, ImageSource source, String type) async {
    final XFile? xFile = await ImagePicker().pickImage(source: source, maxWidth: 500);
    if (xFile == null) return;
    
    ServiceFirestore().updateImage(
      file: File(xFile.path),
      folder: memberCollectionKey,
      memberId: id,
      imageName: type,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera_alt, color: Colors.white),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galerie'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _takePicture(context, ImageSource.gallery, type);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Appareil photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _takePicture(context, ImageSource.camera, type);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}