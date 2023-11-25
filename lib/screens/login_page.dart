import 'package:firebase_crud/home_page.dart';
import 'package:firebase_crud/screens/register_page.dart';
import 'package:firebase_crud/services/firebase_methods.dart';
import 'package:firebase_crud/services/show_dialog_and_snackbar.dart';
import 'package:firebase_crud/widgets/big_text.dart';
import 'package:flutter/material.dart';

import '../widgets/small_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isObscure = true;
  bool _loading = false;

  login()async{
    setState(() {
      _loading = true;
    });
    String res = await FirebaseMethods().login(
        email: _emailController.text,
        password: _passwordController.text
    );
    setState(() {
      _loading = false;
    });
    if(res=="success"){
     if(context.mounted){
       // show snackar
       ShowDialogAndSnackBar().showSnackBar(context, "Connecté(e) avec succès");

       // Navigate to HomePage
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage()));
     }
    }
    else if(res == "invalid-email"){
      if(context.mounted){
        ShowDialogAndSnackBar().showAlertDialog(context,
            "Connexion",
            'Veuillez rentrer un email valide'
        );
      }
    }
    else if(res=="user-not-found"){
      if(context.mounted){
        ShowDialogAndSnackBar().showAlertDialog(context,
            "Connexion",
            'Aucun compte n\'est relie à cet email'
        );
      }
    }
    else if(res=="wrong-password"){
      if(context.mounted){
        ShowDialogAndSnackBar().showAlertDialog(context,
            "Connexion",
            'Mot de passe incorrecte'
        );
      }
    }
    else{
      print(res);
    }
  }


  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                const SmallText(text: "Veuillez renseigner vos informations afin de vous cnnecter !!!",isCenter: true,size: 18,),
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
                    //login
                    login();

                  }else{
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
                  child:_loading?const CircularProgressIndicator(color: Colors.white,):const BigText(text: "Se connecter",size: 20,color: Colors.white,),
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BigText(text: "N'avez-vous pas un compte"),
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
                      },
                      child: const BigText(text: "S'inscire",color: Colors.deepOrange,size: 15,underline: true,)),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
