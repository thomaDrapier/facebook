import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import nécessaire pour le StreamBuilder

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil Firebase'),
        backgroundColor: Colors.deepPurple[100],
      ),
      // C'est ici que tu insères le code StreamBuilder qui t'a été fourni
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          // On vérifie si l'utilisateur est connecté
          if (snapshot.hasData) {
            return const Center(child: Text("Connecté"));
          } else {
            return const Center(child: Text("Non connecté"));
          }
        },
      ),
    );
  }
}