
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

class EncryptionPage extends StatefulWidget {
  
  
  @override
  _EncryptionPageState createState() => _EncryptionPageState();
}


class _EncryptionPageState extends State<EncryptionPage> {
   TextEditingController textEditingController = TextEditingController();
  TextEditingController passwordKey = TextEditingController();
  TextEditingController encryptedTextcontroller = TextEditingController();
  FToast fToast;
  String encrString="";

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
              controller: textEditingController,
              maxLines: null,
              decoration: InputDecoration(
               border: border,
               
              focusColor: Colors.red,
               hintText: "Enter Plain text to encrypt...",
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
              
            ),
            SizedBox(
              height: 50,
            ),
          
            MaterialButton(
              minWidth: Get.width,
              padding: EdgeInsets.all(10),
              child: Text("Generate Random key",style: TextStyle(color: Colors.white),),
              color: Colors.red,
              onPressed: (){
                _generateKey();
              },
            ),
            SizedBox(
              height: 50,
            ),
            MaterialButton(
              minWidth: Get.width,
              padding: EdgeInsets.all(10),
              child: Text("Encrypt",style: TextStyle(color: Colors.white),),
              color: Colors.red,
              onPressed: (){
                _encryption();
              },
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: encryptedTextcontroller,
              maxLines: null,
              decoration: InputDecoration(
               border: border,
               
              focusColor: Colors.red,
               hintText: "Encrypted text appears here",
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

  _encryption(){
    if(passwordKey.text.isEmpty || textEditingController.text.isEmpty){
      // Fluttertoast.showToast(msg: "Text or Key Cannot be Empty");
      _showToast("Text or Key cannot be empty");
    }

    else if(passwordKey.text.length!=16){
      _showToast("Key length must be equal to 16");
    }
    
    else{
    String encrypted=encryption(passwordKey.text,textEditingController.text);
    encryptedTextcontroller.text=encrypted;
    setState(() {
      
    });
    }
    
  }


 String encryption(String textkey, String text){
    final key= enc.Key.fromUtf8(textkey);

    final iv= enc.IV.fromLength(16);

    final encrypter= enc.Encrypter(enc.AES(key));

    final encrypted = encrypter.encrypt(text, iv: iv);
    // final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return encrypted.base16;
  }

  _generateKey(){
    String randkey=randomAlphaNumeric(16);
    passwordKey.text=randkey;
    setState(() {
      
    });
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
