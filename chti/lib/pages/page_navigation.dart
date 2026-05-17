import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_authentification.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/membre.dart';
import '../widgets/widget_vide.dart';

class PageNavigation extends StatefulWidget {
  const PageNavigation({super.key});

  @override
  State<PageNavigation> createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  // a) La variable d'index pour l'affichage des pages
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final memberId = ServiceAuthentification().myId;
    
    if (memberId == null) {
      return const EmptyScaffold();
    }

    // b) StreamBuilder pour récupérer les infos du membre connecté
    return StreamBuilder<DocumentSnapshot>(
      stream: ServiceFirestore().specificMember(memberId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final Membre member = Membre(
            reference: data.reference,
            id: data.id,
            map: data.data() as Map<String, dynamic>,
          );

          // Liste des pages à afficher selon l'onglet sélectionné
          List<Widget> bodies = [
            const Center(child: Text("Accueil")),
            const Center(child: Text("Membres")),
            const Center(child: Text("Ecrire un post")),
            const Center(child: Text("Notifications")),
            const Center(child: Text("Profil")),
          ];

          return Scaffold(
            appBar: AppBar(
              title: Text(member.fullName),
            ),
            bottomNavigationBar: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: index,
              onDestinationSelected: (int newValue) {
                setState(() {
                  index = newValue;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: "Accueil",
                ),
                NavigationDestination(
                  icon: Icon(Icons.group),
                  label: "Membres",
                ),
                NavigationDestination(
                  icon: Icon(Icons.border_color),
                  label: "Ecrire",
                ),
                NavigationDestination(
                  icon: Icon(Icons.notifications),
                  label: "Notification",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: "Profil",
                ),
              ],
            ),
            body: bodies[index],
          );
        } else {
          return const EmptyScaffold();
        }
      },
    );
  }
}