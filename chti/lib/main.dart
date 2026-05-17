import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chti/pages/page_authentification.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:chti/pages/page_navigation.dart'; 

Future<void> main() async {
  // d) Cette ligne permet de s'assurer que les services Flutter sont bien prêts  
  WidgetsFlutterBinding.ensureInitialized();

  // e) Cette ligne initialise Firebase avec les options spécifiques à ta plateforme IOS
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            // Si Firebase détecte un utilisateur actif, il affiche le menu global
            return const PageNavigation(); 
          } else {
            // Si personne n'est connecté, il affiche le formulaire de connexion
            return const PageAuthentification();
          }
        },
      ),
    );
  }
}
