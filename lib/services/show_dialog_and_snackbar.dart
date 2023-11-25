

import 'package:flutter/material.dart';

import '../widgets/big_text.dart';
import '../widgets/small_text.dart';

class ShowDialogAndSnackBar{


  // show alert

  showAlertDialog(BuildContext context, String title, String message){

    return showDialog(context: context,
        builder: (context){
      return AlertDialog(
        title: BigText(text: title,size: 18,isCenter: true,),
        content: SmallText(text: message,size: 18,isCenter: true,),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange
            ),
              onPressed: (){
            Navigator.pop(context);
          }, child: const BigText(text: "OK",color: Colors.white,))
        ],
      );
        });
  }

  // showsnackbar

  showSnackBar(BuildContext context, String message){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: SmallText(text: message,size: 18,color: Colors.white,))
    );
  }


}