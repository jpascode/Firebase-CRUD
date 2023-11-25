



import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/services/article_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseMethods{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Création de compte
   Future<String> registerUser({ required String email, required String password})async{
     String res = "Une erreur s'est produite";

     try {
       await _firebaseAuth.createUserWithEmailAndPassword(
           email: email,
           password: password
       );

       res = "success";
     } on FirebaseAuthException catch (e) {
       res = e.code;
     }

     return res;
   }

  // Connexion

  Future<String> login({required String email, required String password})async{
     String res = "Une erreur s'est produite" ;
     try {
       await _firebaseAuth.signInWithEmailAndPassword(
           email: email,
           password: password
       );

       res = "success";
     } on FirebaseAuthException catch (e) {
       res = e.code;
     }
     return res;
  }
  // la déconnexion

  Future<String> logout()async{
     String res = "Une erreur s'est produite";
     await _firebaseAuth.signOut().then((value){
       res = "success";
     }).onError((error, stackTrace) {
       res = error.toString();
     });

     return res;
  }

  // Récuperer UID uinique de l'utilisateur


  // add article

  addArticle({required String title, required  String description , required Uint8List image_data})async{

     String res = "Une erreur s'est produite";
     // upload to storage
    String url = await uploadImageToStorage(image_data);

    // add to cloud firestore

    Uuid uuid = Uuid();

    String id = uuid.v4();

    Article article = Article(
        id: id,
        title: title,
        description: description,
        image_url: url,
        create_at: DateTime.now(),
        update_at: DateTime.now(),
        user_id: _firebaseAuth.currentUser!.uid
    );

    await _firestore.collection("Articles").doc(id).set(article.toMap(article))
        .then((value){
          res = "success";
    }).onError((error, stackTrace) {
      res = error.toString();
    });

    return res;
  }


  Future<String> uploadImageToStorage(Uint8List image_data)async{
     String string = DateTime.now().toString();
     Reference ref = _storage.ref().child("ArticlesImages").child(string);

     UploadTask uploadTask = ref.putData(image_data);

     TaskSnapshot taskSnapshot = await uploadTask;

     String url = await taskSnapshot.ref.getDownloadURL();

     return url;
   }

}