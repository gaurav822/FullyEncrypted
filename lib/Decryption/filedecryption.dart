import 'dart:io';
import 'dart:typed_data';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FileDecryptionPage extends StatefulWidget {
  @override
  _FileDecryptionPageState createState() => _FileDecryptionPageState();
}

class _FileDecryptionPageState extends State<FileDecryptionPage> {
  TextEditingController keyController= TextEditingController();
  List<String> listofFiles= List();
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
          SizedBox(
            height: 40,
          ),
          _inputKey(),

        ],
      ),
    );
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

  _filePicker() async{

    ProgressDialog pr = ProgressDialog(context);
     pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
     pr.style(
       message: "Decrypting Please Wait..."
     );
     listofFiles=[];
     _createFolder("decrypted files");
     final mainDir= Directory("storage/emulated/0/decrypted files");
     listtoaddFiles(mainDir);
    var crypt = AesCrypt(keyController.text);
    
    File file=await FilePicker.getFile();
    String basename=p.basename(file.path);

    String outputfilename=basename.substring(0,basename.length-4);

    File newfile= File("storage/emulated/0/decrypted files/$outputfilename");
    if(listofFiles.contains(outputfilename)){
      Fluttertoast.showToast(msg: "Already Decrypted");
    }

    else{
    try{
      await pr.show();
      Uint8List decryptedData=crypt.decryptDataFromFileSync(file.path);
      newfile.writeAsBytesSync(decryptedData);
      await pr.hide();
      Fluttertoast.showToast(msg: "File Decrypted Successfully");
    }
    catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }

    }
  }

  listtoaddFiles(Directory directory){
    List<FileSystemEntity> fseList= directory.listSync();

    for(FileSystemEntity each in fseList){
      listofFiles.add(each.path);
      print(each.path);
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
}