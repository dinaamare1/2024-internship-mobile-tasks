
import 'package:ecommerce_app_ui/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Addpage extends StatefulWidget {
  const Addpage({super.key});

  @override
  State<Addpage> createState() => _AddpageState();
}

class _AddpageState extends State<Addpage> {
  //handles the upload sections
  File? _image;

  Future<void> _pickImage() async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission denied to access gallery")),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                  ),
                  SizedBox(width: 100),
                  const Text(
                    "Add Products",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: Container(
                  width: 366,
                  height: 190,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.white),
                  ),
                  child: _image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: [
                          const SizedBox(height: 10),
                          Icon(
                            Icons.image_outlined,
                            color: Colors.grey[800],
                          ),
                          Text(
                            "Upload Image",
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        ],
                      )
                    : Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(                        
                        fillColor: Colors.grey[200],
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Category:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.grey[200],
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Price:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        fillColor: Colors.grey[200],
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder:  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'descrption:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 140,
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.grey[200],
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                         enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder:  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      maxLines: 5,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                          return const RootPage();
                        }));
                      },
                      style: ElevatedButton.styleFrom(
                      minimumSize: Size(152, 50), 
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      child: const Text("ADD",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500)),
                    ),
                    
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                      minimumSize:const Size(152, 50), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                          ),
                        side: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                        ),
                      child: const Text("DELETE",style: TextStyle(color: Colors.red,fontSize: 14,fontWeight: FontWeight.w500),),
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
