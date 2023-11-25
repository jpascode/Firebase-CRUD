
import 'package:firebase_crud/screens/add_article.dart';
import 'package:firebase_crud/screens/login_page.dart';
import 'package:firebase_crud/services/firebase_methods.dart';
import 'package:firebase_crud/services/show_dialog_and_snackbar.dart';
import 'package:firebase_crud/widgets/big_text.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  logout()async{

    String res = await FirebaseMethods().logout();
    if(res == "success"){
      if(context.mounted){
        ShowDialogAndSnackBar().showSnackBar(context, "Déconnecté(e) avec succès");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        automaticallyImplyLeading: false,
        title: const BigText(text: "Mes Articles",color: Colors.white,size: 18,),
        actions: [
          IconButton(
              onPressed: (){
            // logout
                logout();
          },
              icon: const Icon(Icons.logout,color: Colors.white,size: 25,)
          )
        ],
      ),
      body: const Center(child: Text('Welcome'),),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddArticle()));
        },
        child: const Icon(Icons.add_circle_outline,color: Colors.white,size: 20,),
      ),
    );
  }
}
