import 'dart:io';
import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';



class FileEncryptionPage extends StatefulWidget {
  @override
  _FileEncryptionPageState createState() => _FileEncryptionPageState();
}

class _FileEncryptionPageState extends State<FileEncryptionPage> {
  TextEditingController keyController= TextEditingController();
  List<String> listofFiles= List();
  String selectedFileName="";
  String fpath="";
  File myfile;
  @override
  Widget build(BuildContext context) {

   
    return Scaffold(
      backgroundColor: Colors.brown,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          _chooseFileButton(),

          Text(selectedFileName),
          SizedBox(
            height: 40,
          ),
          _inputKey(),

          SizedBox(
            height: 20,
          ),
          _encryptButton(),

        ],
      ),
    );
  }

  Widget _encryptButton(){

    return MaterialButton(
      onPressed: (){
        _encryptFile();
      },
      child: Text("ENCRYPT"),
      color: Colors.red.shade300,
    );
  }

  _encryptFile() async{
     listofFiles=[];
     _createFolder("encrypted files");
     final mainDir= Directory("storage/emulated/0/encrypted files");
     listtoaddFiles(mainDir);
     ProgressDialog pr = ProgressDialog(context);
     pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
     pr.style(
       message: "Encrypting Please Wait..."
     );
    if(selectedFileName.isEmpty){
      Fluttertoast.showToast(msg: "Please Choose a file to Encrypt");
    }

    else if(keyController.text.isEmpty){
      Fluttertoast.showToast(msg: "Password Key Cannot be null");
    }

    else{
       if(listofFiles.contains(selectedFileName)){
       print("File already Encrypted");
       Fluttertoast.showToast(msg: "File Already Encrypted");
       }

       else{
      try{
      var crypt= AesCrypt(keyController.text);
      Uint8List uint8list=myfile.readAsBytesSync();
    
      await pr.show();
      await crypt.encryptDataToFile(uint8list, fpath).then((value) async {
      await pr.hide();
      Fluttertoast.showToast(msg: "Encrypted Sucessfully");
    // listFiles(directory);
      });
  
    }
    catch(e){
      print(e);
    }

       }
    }
  }


  Widget _chooseFileButton(){

    return MaterialButton(
      color: Colors.grey,
      onPressed: (){
        _filePicker();
      },
      child: Text("Choose file"),
      minWidth: 150,
    );
  }

  _filePicker()async{
    try{
    File file = await FilePicker.getFile();
    String basename= p.basename(file.path); 
    String filePath="storage/emulated/0/encrypted files"+"/"+basename+".aes";
    selectedFileName=basename;
    fpath=filePath;
    myfile=file;
    setState(() {

    });

    }

    on FileSystemException catch(e){
      Fluttertoast.showToast(msg: e.toString());
      print("hello");
    }  
}

  Future<String> _createFolder(String cow) async {
  final folderName = cow;
  final path = Directory("storage/emulated/0/$folderName");
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if ((await path.exists())) {
    return path.path;
  } else {
    path.create();
    return path.path;
  }
}

  listtoaddFiles(Directory directory){
    List<FileSystemEntity> fseList= directory.listSync();

    for(FileSystemEntity each in fseList){
      listofFiles.add(each.path);
    }
  }

  Widget _inputKey(){
    OutlineInputBorder border= OutlineInputBorder(

            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
                controller: keyController,
                obscureText: true,
                decoration: InputDecoration(
                 border: border,
                 
                focusColor: Colors.red,
                 hintText: "Enter Password...",
                 hintStyle: TextStyle(color: Colors.black),
                 focusedBorder: border,
                 enabled: true,
                 fillColor: Colors.white38,
                 filled: true,
                
                
                ),
      ),
    );
  }

}