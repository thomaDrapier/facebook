import 'package:firebase_auth/firebase_auth.dart';
import '../modeles/constantes.dart';
import '../services_firebase/service_firestore.dart';

class ServiceAuthentification {
  //Récupérer une instance de auth
  final instance = FirebaseAuth.instance;

// Connecter à Firebase
  Future<String?> signIn({required String email, required String password}) async {
    try {
      // Cette ligne effectue la vraie connexion auprès de Firebase
      await instance.signInWithEmailAndPassword(email: email, password: password);
      return null; // Renvoie null si la connexion est réussie
    } on FirebaseAuthException catch (e) {
      return e.message; // Renvoie le message d'erreur (ex: mauvais mot de passe)
    } catch (e) {
      return e.toString();
    }
}

// Créer un compte sur Firebase
  Future<String?> createAccount({
    required String email,
    required String password,
    required String surname,
    required String name
  }) async {
    try {
      // 1. Création de l'utilisateur dans Firebase Authentication
      UserCredential credential = await instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;

      if (user != null) {
        // 2. Préparation du dictionnaire (Map) avec les clés définies dans constantes.dart
        Map<String, dynamic> data = {
          memberIdKey: user.uid,
          nameKey: name,
          surnameKey: surname,
          profilePictureKey: "",
          coverPictureKey: "",
          descriptionKey: "",
        };

        // 3. Appel de la méthode addMember de ServiceFirestore
        ServiceFirestore().addMember(id: user.uid, data: data);
      }
      
      return null; // Retourne null si tout s'est bien passé (pas d'erreur)
    } on FirebaseAuthException catch (e) {
      return e.message; // Retourne le message d'erreur de Firebase en cas d'échec
    } catch (e) {
      return e.toString();
    }
  }

  // Déconnecter de Firebase
  Future<bool> signOut() async {
    bool result = false;
    return result;
  }

  // Récupérer l'id unique de l'utilisateur
  String? get myId => instance.currentUser?.uid;

  // Voir si vous etes l'utilisateur
  bool isMe(String profileId) {
    bool result = false;
    return result;
  }
}