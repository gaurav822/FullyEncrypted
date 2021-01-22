import 'package:FullyEncrypted/Decryption/decryption.dart';
import 'package:FullyEncrypted/Decryption/filedecryption.dart';
import 'package:FullyEncrypted/Encryption/encryption.dart';
import 'package:FullyEncrypted/Encryption/fileencryption.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("FULLY ENCRYPTED",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          
          Icon(Icons.security,color: Colors.red,),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    
      body: _body(context),
    );
  }

  Widget _body(BuildContext context){

    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
        runSpacing: 20,
        spacing: 20,
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
       
        children: [
           GestureDetector(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>EncryptionPage()));
             },
             child: _eachContainer(image: Icon(Icons.lock,size: 50,color: Colors.yellow),name: "Text Encryption")
             ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>DecryptionPage()));
            },
            child: _eachContainer(image: Icon(Icons.lock_open,size: 50,color: Colors.yellow),name: "Text Decryption")),
          GestureDetector(
            onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>FileEncryptionPage()));

            },
            child: _eachContainer( image: Image.asset("assets/encrypt.png", height: 60,color: Colors.red,),name: "File Encryption")),

           GestureDetector(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>FileDecryptionPage()));
             },
             child: _eachContainer(image: Image.asset("assets/decrypt.png", height: 70,color: Colors.greenAccent,),name: "File Decryption")),
          
        ],
      ),

    );
  }

  Widget _eachContainer({Widget image, String name}){
     TextStyle style=TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 17 );
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
            height: Get.height*.4,
            width: Get.width*.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blue
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(),
                image,
                SizedBox(
                  height: 20,
                ),
                Text(name, style: style,)
              ],
            ),
          ),
    );
  }
}