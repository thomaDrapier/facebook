import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../modeles/membre.dart';
import '../services_firebase/service_firestore.dart';

class PageEcrirePost extends StatefulWidget {
  final Membre member;
  final Function(int) newselection;

  const PageEcrirePost({
    super.key, 
    required this.member, 
    required this.newselection,
  });

  @override
  State<PageEcrirePost> createState() => _PageEcrirePostState();
}

class _PageEcrirePostState extends State<PageEcrirePost> {
  // a) Les variables
  late TextEditingController textController;
  XFile? xFile;

  // b) Initialisation du contrôleur
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  // b) Libération de la mémoire
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // d) Fonction d'envoi du post
  void _sendPost() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (xFile == null && textController.text.isEmpty) return;

    await ServiceFirestore().createPost(
      member: widget.member,
      text: textController.text,
      image: xFile,
    );

    // Retour automatique à la page d'accueil (index 0)
    widget.newselection(0);
  }

  // e) Fonction de capture ou sélection d'image
  void _takePic(ImageSource source) async {
    XFile? newFile = await ImagePicker().pickImage(source: source, maxWidth: 500);
    setState(() {
      xFile = newFile;
    });
  }

  // c) La méthode build (Design de la page)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.border_color),
                        SizedBox(width: 10),
                        Text(
                          "Écrire un post",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const Divider(),
                    TextField(
                      controller: textController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "Quoi de neuf dans les Hauts-de-France ?",
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Affichage de la miniature si une image est sélectionnée
                    if (xFile != null)
                      Container(
                        height: 200,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Image.file(File(xFile!.path), fit: BoxFit.cover),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.photo_library, color: Colors.blue),
                          onPressed: () => _takePic(ImageSource.gallery),
                        ),
                        IconButton(
                          icon: const Icon(Icons.photo_camera, color: Colors.green),
                          onPressed: () => _takePic(ImageSource.camera),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendPost,
              child: const Text("Envoyer"),
            ),
          ],
        ),
      ),
    );
  }
}