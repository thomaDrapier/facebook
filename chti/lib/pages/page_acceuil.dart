import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/constantes.dart';
import '../widgets/widget_vide.dart';

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ServiceFirestore().allPosts(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final doc = snapshot.data!.docs;
          
          return ListView.builder(
            itemCount: doc.length,
            itemBuilder: (context, index) {
              // Récupération des données brutes du post sous forme de Map
              final postMap = doc[index].data() as Map<String, dynamic>;
              
              // Affichage temporaire en attendant les étapes 6 et 9 du projet
              return ListTile(
                leading: const Icon(Icons.turned_in_not),
                title: Text(postMap[textKey] ?? 'Message vide'),
              );
            },
          );
        } else {
          return const EmptyBody();
        }
      },
    );
  }
}