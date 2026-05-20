import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/membre.dart';
import '../widgets/widget_vide.dart';
import 'page_profil.dart';

class PageMembres extends StatefulWidget {
  const PageMembres({super.key});

  @override
  State<PageMembres> createState() => _PageMembresState();
}

class _PageMembresState extends State<PageMembres> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ServiceFirestore().allMembers(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final data = docs[index];
              
              // Transformation des données brutes Firestore en objet de notre modèle Membre
              final Membre membre = Membre(
                reference: data.reference,
                id: data.id,
                map: data.data() as Map<String, dynamic>,
              );

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(membre.fullName),
                subtitle: Text(membre.description.isNotEmpty 
                  ? membre.description 
                  : "Pas de description"),
                onTap: () {
                  // 7.3 Clic sur un membre -> Redirection vers son profil
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PageProfil(member: membre),
                    ),
                  );
                },
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