import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:random_string/random_string.dart';

class DecryptionPage extends StatefulWidget {
  @override
  _DecryptionPageState createState() => _DecryptionPageState();
}

class _DecryptionPageState extends State<DecryptionPage> {
TextEditingController ciphertextController = TextEditingController();
  TextEditingController passwordKey = TextEditingController();
  TextEditingController plaintextController = TextEditingController();

FToast fToast;
  String cipherString="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

 @override
  Widget build(BuildContext context) {
    OutlineInputBorder border= OutlineInputBorder(

            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white));
    return Scaffold(
      
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.brown,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            TextField(
              controller: ciphertextController,
              maxLines: null,
              decoration: InputDecoration(
               border: border,
               
              focusColor: Colors.red,
               hintText: "Enter Cipher text to decrypt...",
               hintStyle: TextStyle(color: Colors.black),
               focusedBorder: border,
               enabled: true,
               fillColor: Colors.white38,
               filled: true,
              
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: passwordKey,
              
              decoration: InputDecoration(
                fillColor: Colors.white38,
               filled: true,
               border: border,
               focusedBorder: border,
               hintText: "Enter Security Key...",
               hintStyle: TextStyle(color: Colors.black),
              ),
              obscureText: false,
              
            ),
            
            SizedBox(
              height: 50,
            ),
            MaterialButton(
              minWidth: Get.width,
              padding: EdgeInsets.all(10),
              child: Text("Decrypt",style: TextStyle(color: Colors.white),),
              color: Colors.red,
              onPressed: (){
                _decryption();
              },
            ),
            SizedBox(
              height: 40,
            ),
            
            TextField(
              controller: plaintextController,
              maxLines: null,
              decoration: InputDecoration(
               border: border,
               
              focusColor: Colors.red,
               hintText: "Plain text appears here",
               hintStyle: TextStyle(color: Colors.black),
               focusedBorder: border,
               enabled: true,
               fillColor: Colors.white38,
               filled: true,
              
              ),
            ),
          ],
        ),
      ),
    );
  }

  

  _decryption(){
    if(passwordKey.text.isEmpty || ciphertextController.text.isEmpty){
      // Fluttertoast.showToast(msg: "Text or Key Cannot be Empty");
      _showToast("Text or Key cannot be empty");
    }

    else if(passwordKey.text.length!=16){
      _showToast("Key length must be equal to 16");
    }
    else{
    String decrypted=decryption(passwordKey.text,ciphertextController.text);
    plaintextController.text=decrypted;
    setState(() { 
    });
    }
    
  }


  String decryption(String textkey, String text){

    enc.Encrypted base16encoded= enc.Encrypted.fromBase16(text);
    final key= enc.Key.fromUtf8(textkey);

    final iv= enc.IV.fromLength(16);

    final encrypter= enc.Encrypter(enc.AES(key));
    try{
    final decrypted = encrypter.decrypt(base16encoded, iv: iv);
     return decrypted;
    }
    catch(e){
      print(e);
      _showToast("Incorrect Password");
    }
  
  }

  _showToast(String message) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
        ),
        child: Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
                  child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
              Icon(Icons.privacy_tip),
              SizedBox(
              width: 12.0,
              ),
              Text(message),
          ],
          ),
        ),
    );


    fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
    );
    
    // Custom Toast Position
    // fToast.showToast(
    //     child: toast,
    //     toastDuration: Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         child: child,
    //         top: 16.0,
    //         left: 16.0,
    //       );
    //     });
}


}
