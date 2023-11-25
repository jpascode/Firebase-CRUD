import 'package:firebase_crud/home_page.dart';
import 'package:firebase_crud/screens/login_page.dart';
import 'package:firebase_crud/services/firebase_methods.dart';
import 'package:firebase_crud/services/show_dialog_and_snackbar.dart';
import 'package:firebase_crud/widgets/big_text.dart';
import 'package:flutter/material.dart';

import '../widgets/small_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isObscure = true;
  bool _loading = false;


  // methode de creation de compte
  register()async{
    setState(() {
      _loading = true;
    });
    String res = await FirebaseMethods().registerUser(
        email: _emailController.text,
        password: _passwordController.text
    );

    setState(() {
      _loading = false;
    });

    if(res=="success"){
      // afficher snackbar
      if(context.mounted){
        ShowDialogAndSnackBar().showSnackBar(context, "Votre compte est créé avec success");
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    }else if(res=="invalid-email"){
      if(context.mounted){
        ShowDialogAndSnackBar().showAlertDialog(
            context,
            "Erreur",
            "Veuillez rentrer un email valide"
        );
      }
    }else if( res=="weak-password"){
      if(context.mounted){
        ShowDialogAndSnackBar().showAlertDialog(
            context,
            "Erreur",
            "Mot de passe trop faible"
        );
      }
    }else if(res=="email-already-in-use") {
      if (context.mounted) {
        ShowDialogAndSnackBar().showAlertDialog(
            context,
            "Erreur",
            "Un autre compte est déja relié à cet email"
        );
      }
    }
    else{
      print(res);
    }

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("images/firebase.png",width: 250,height: 250,),
                const SizedBox(height: 10,),
                const BigText(text: "FIREBASE CRUD !",size: 20,),
                const SizedBox(height: 10,),
                const SmallText(text: "Veuillez renseigner vos informations afin de créer un compte !!!",isCenter: true,size: 18,),
                const SizedBox(height: 20,),


                // Form

                Form(
                    key: formKey,
                    child: Column(
                      children: [

                        // email
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                              hintText: "Entrer votre email"
                          ),
                          validator: (value){
                            return value==null ||value==""?"Veuillez rentrer votre email":null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        // password
                        TextFormField(
                          obscureText: isObscure,
                          controller: _passwordController,
                          decoration: InputDecoration(
                              hintText: "Entrer votre mot de passe",
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                icon: Icon(isObscure?Icons.visibility:Icons.visibility_off_outlined,color: Colors.deepOrange,size: 25,),
                              )
                          ),
                          validator: (value){
                            return value==null ||value==""?"Veuillez rentrer votre mot de passe":null;
                          },
                        ),
                      ],)),
                const SizedBox(height: 20,),

                InkWell(
                  onTap: (){
                    if(formKey.currentState!.validate()){

                     register();

                    }

                    else{
                      print("Non validé");
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width*0.8,
                    decoration:BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child:_loading? const CircularProgressIndicator(color: Colors.white,): const BigText(text: "S'Inscrire",size: 20,color: Colors.white,),
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(text: "Avez-vous déja un compte"),
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                        },
                        child: BigText(text: "Se connecter",color: Colors.deepOrange,size: 15,underline: true,)),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}
