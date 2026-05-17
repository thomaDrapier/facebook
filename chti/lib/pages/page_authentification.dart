import 'package:flutter/material.dart';
import '../services_firebase/service_authentification.dart'; // Import de ton service [cite: 365]

class PageAuthentification extends StatefulWidget {
  const PageAuthentification({super.key});

  @override
  State<PageAuthentification> createState() => _PageAuthentificationState();
}

class _PageAuthentificationState extends State<PageAuthentification> {
  // a) Les variables [cite: 332]
  bool accountExists = true; // Détermine si on se connecte ou si on crée un compte [cite: 334]
  late TextEditingController mailController; // [cite: 334]
  late TextEditingController passwordlController; // [cite: 335]
  late TextEditingController surnameController; // [cite: 336]
  late TextEditingController nameController; // [cite: 337]

  // b) Initialisation et libération [cite: 338]
  @override
  void initState() {
    super.initState();
    mailController = TextEditingController();
    passwordlController = TextEditingController();
    surnameController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    mailController.dispose();
    passwordlController.dispose();
    surnameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  // d) Fonction pour changer entre Connexion et Inscription [cite: 358]
  void _onSelectedChanged(Set<bool> newValue) {
    setState(() {
      accountExists = newValue.first; // 
    });
  }

  // e) Fonction pour gérer l'authentification [cite: 363]
  void _handleAuth() async {
    String? result;
    if (accountExists) {
      // Appel du service de connexion [cite: 363]
      result = await ServiceAuthentification().signIn(
        email: mailController.text,
        password: passwordlController.text,
      );
    } else {
      // Appel du service de création de compte [cite: 364]
      result = await ServiceAuthentification().createAccount(
        email: mailController.text,
        password: passwordlController.text,
        surname: surnameController.text,
        name: nameController.text,
      );
    }

    if (result != null && mounted) {
      // Afficher l'erreur si elle existe
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  // c) La méthode build [cite: 338]
  @override
  Widget build(BuildContext context) {
    return Scaffold( // [cite: 345]
      body: SafeArea( // 
        child: SingleChildScrollView( // 
          padding: const EdgeInsets.all(20),
          child: Column( // [cite: 348]
            children: [
              // Image (logo) [cite: 349]
              const FlutterLogo(size: 100), // Remplace par ton image plus tard
              const SizedBox(height: 20),
              
              Text(
                "T'in pour commincher", // Titre local [cite: 340]
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),

              // SegmentedButton [cite: 350]
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text("Se connecter")),
                  ButtonSegment(value: false, label: Text("Créer un compte")),
                ],
                selected: {accountExists},
                onSelectionChanged: _onSelectedChanged, // [cite: 358]
              ),
              const SizedBox(height: 20),

              // Formulaire dans une Card 
              Card(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column( // [cite: 353]
                    children: [
                      TextField( // [cite: 354]
                        controller: mailController,
                        decoration: const InputDecoration(labelText: "Adresse mail"),
                      ),
                      TextField( // [cite: 355]
                        controller: passwordlController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Mot de passe"),
                      ),
                      // Champs affichés seulement pour la création de compte
                      if (!accountExists) ...[
                        TextField( // [cite: 356]
                          controller: surnameController,
                          decoration: const InputDecoration(labelText: "Prénom"),
                        ),
                        TextField( // [cite: 357]
                          controller: nameController,
                          decoration: const InputDecoration(labelText: "Nom"),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bouton de validation [cite: 342]
              ElevatedButton(
                onPressed: _handleAuth,
                child: const Text("C'est parti"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}