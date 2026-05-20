import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_authentification.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/membre.dart';
import '../modeles/constantes.dart';
import '../widgets/avatar.dart';
import '../widgets/bouton_camera.dart';
import 'page_modifier_profil.dart';
import '../widgets/widget_post.dart';
import '../modeles/post.dart';

class PageProfil extends StatefulWidget {
  final Membre member;
  const PageProfil({super.key, required this.member});

  @override
  State<PageProfil> createState() => _PageProfilState();
}

class _PageProfilState extends State<PageProfil> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ServiceFirestore().postForMember(widget.member.id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data;
        final docs = data?.docs;
        final length = docs?.length ?? 0;
        final isMe = ServiceAuthentification().isMe(widget.member.id);
        final indexToAdd = 1;

        return ListView.builder(
          itemCount: length + indexToAdd,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  Container(
                    // Augmentation de la hauteur à 280 pour accueillir l'avatar de 75 de rayon
                    height: 280, 
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                widget.member.coverPicture.isNotEmpty
                                    ? Image.network(
                                        widget.member.coverPicture,
                                        height: 200,
                                        width: MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 200,
                                        width: MediaQuery.of(context).size.width,
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                      ),
                                if (isMe)
                                  BoutonCamera(
                                    type: coverPictureKey,
                                    id: widget.member.id,
                                  ),
                              ],
                            ),
                            // Espace ajusté pour laisser passer le grand cercle de l'avatar
                            const SizedBox(height: 60), 
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              // Étape 6.5 : Appel du widget Avatar avec radius: 75
                              Avatar(
                                radius: 75,
                                url: widget.member.profilePicture,
                              ),
                              // Étape 6.6 : Bouton caméra profil juxtaposé (Syntaxe ternaire conforme au PDF)
                              (isMe)
                                  ? BoutonCamera(
                                      type: profilePictureKey,
                                      id: widget.member.id,
                                    )
                                  : const Center(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.member.fullName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  if (isMe)
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PageModifierProfil(member: widget.member),
                          ),
                        );
                      },
                      child: const Text('Modifier le profil'),
                    ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      widget.member.description.isNotEmpty
                          ? widget.member.description
                          : "Aucune description renseignée pour le moment.",
                      style: const TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }
            final current = docs![index - indexToAdd]; 
            final Post post = Post(
              reference: current.reference,
              id: current.id,
              map: current.data() as Map<String, dynamic>,
            );

            return WidgetPost(post: post);
          },
        );
      },
    );
  }
}