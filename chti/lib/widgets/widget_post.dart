import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeles/post.dart';
import '../modeles/membre.dart';
import '../modeles/formatage_date.dart';
import '../services_firebase/service_authentification.dart';
import '../services_firebase/service_firestore.dart';
import 'avatar.dart';

class WidgetPost extends StatelessWidget {
  final Post post;
  const WidgetPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ServiceFirestore().specificMember(post.nember),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const SizedBox();
        }

        final data = snapshot.data!;
        final Membre auteur = Membre(
          reference: data.reference,
          id: data.id,
          map: data.data() as Map<String, dynamic>,
        );

        return Card(
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Entête du post : Avatar (rayon 15), Nom de l'émetteur et Date
                Row(
                  children: [
                    Avatar(radius: 15, url: auteur.profilePicture),
                    const SizedBox(width: 10),
                    Text(
                      auteur.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(FormatageDate().formatted(post.date)),
                  ],
                ),
                const SizedBox(height: 10),
                
                // Si imageurl existe alors affichage Image.network sinon Container vide
                post.imageUrl.isNotEmpty
                    ? Image.network(
                        post.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Container(),
                const SizedBox(height: 10),
                
                // Texte du post
                Text(post.text),
                const Divider(),
                
                // Barre d'actions (Bouton Étoile/Likes et Commenter)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Action de Like (Étape 10)
                      },
                      icon: Icon(
                        Icons.star,
                        color: (post.likes.contains(ServiceAuthentification().myId!))
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text("${post.likes.length} Likes"),
                    IconButton(
                      onPressed: () {
                        // Action de Commentaire
                      },
                      icon: const Icon(Icons.messenger),
                    ),
                    const Text('Commenter'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}