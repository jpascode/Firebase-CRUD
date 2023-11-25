import 'dart:typed_data';

import 'package:firebase_crud/services/firebase_methods.dart';
import 'package:firebase_crud/services/show_dialog_and_snackbar.dart';
import 'package:firebase_crud/widgets/big_text.dart';
import 'package:firebase_crud/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({super.key});

  @override
  State<AddArticle> createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {

  final GlobalKey<FormState> _key = GlobalKey<FormState>();


  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

 Uint8List? image_data;

 bool pickingImage = false;

 bool _loading = false;

 addArticle()async{

   setState(() {
     _loading = true;
   });
   String res = await FirebaseMethods().addArticle(
       title: titleController.text,
       description: descriptionController.text,
       image_data: image_data!
   );

   setState(() {
     _loading = false;
   });

   if(res == 'success'){
     if(context.mounted){
       ShowDialogAndSnackBar().showSnackBar(context, "Article ajouté avec succès");
     }
   }else{
     print(res);
     if(context.mounted){
       ShowDialogAndSnackBar().showSnackBar(context, "Une erreur s'est produite");
     }
   }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const BigText(text: "Un nouveau article",color: Colors.white,size: 20,),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.withOpacity(0.2),
                    filled: true,
                    hintText: "Entrer le titre de l'article"
                  ),
                  validator: (value){
                    return value == null || value == "" ? "Veuillez rentrer le titre de l'article":null;
                  },
                ),
                const SizedBox(height: 15,),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                      fillColor: Colors.grey.withOpacity(0.2),
                      filled: true,
                      hintText: "Entrer la description de l'article"
                  ),
                  validator: (value){
                    return value == null || value == "" ? "Veuillez rentrer la description de l'article":null;
                  },
                ),
                const SizedBox(height: 15,),
                const SmallText(text: "Selectionnez une image"),
                const SizedBox(height: 10,),
                image_data!=null ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.memory(image_data!,height: 200,width: double.maxFinite,fit: BoxFit.cover,),
                    IconButton(onPressed: (){
                      pickImage();
                    }, icon: const Icon(Icons.change_circle_outlined,color: Colors.white,size: 45,))
                  ],
                ):Container(
                  height: 200,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: IconButton(
                    onPressed: (){
                      pickImage();
                    },
                    icon: const Icon(Icons.upload,color: Colors.white,size: 45,),),
                ),
                const SizedBox(height: 10,),

                pickingImage? const LinearProgressIndicator(color: Colors.deepOrange,): Container(),

                const SizedBox(height: 20,),

                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: (){
                      if(_key.currentState!.validate() && image_data!=null){
                        addArticle();
                      }else{
                        ShowDialogAndSnackBar().showSnackBar(context, "Veuillez renseignez tous les champs");
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.of(context).size.width*0.8,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child:_loading? const CircularProgressIndicator(color: Colors.white,): const BigText(text: "Ajouter",color: Colors.white,size: 20,),
                    ),
                  ),
                )
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  pickImage()async{

    setState(() {
      pickingImage = true;
    });

    ImagePicker _picker = ImagePicker();

    // selectionnez dans la galerie

     XFile? file = await _picker.pickImage(source: ImageSource.gallery);
     if(file!=null){

       var data = await file.readAsBytes();

       setState(() {
         image_data = data;
       });

       print(image_data);
     }

     setState(() {
       pickingImage = false;
     });
  }
}
