import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shopadmin/HomeScreen.dart';
import 'package:shopadmin/constants/UrlHelper.dart';
class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {

  TextEditingController _name = TextEditingController();
  
  File? selectedfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Add Category",style: TextStyle(
          fontFamily: "Roboto_medium",  fontSize: 24,
          color: Color(0XFF000000),
        ),)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Text("Category Image",
                 style: TextStyle(
                     fontSize: 16,
                     fontFamily: "Roboto_regular"
                 ),),

           SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (selectedfile==null)?
                    Image.asset("assets/img/image.png",width: 99,height: 99,)
                        :Image.file(selectedfile!,width: 99,height: 99),
                    SizedBox(width: 18.0,),
                    Column(
                      children: [
                        Text("upload image",style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Roboto_regular"
                          ),
                        ),
                        SizedBox(height: 14,),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                ImagePicker picker = ImagePicker();
                                final XFile? photo = await picker.pickImage(source: ImageSource.camera);

                                if (photo != null) {
                                  File imagefile = File(photo.path);
                                  setState(() {
                                    selectedfile = imagefile;
                                  });
                                }
                              },
                              child:Image.asset("assets/img/camera.png"),

                            ),
                            SizedBox(width: 16.0,),
                            GestureDetector(
                              onTap: () async{
                                ImagePicker picker = ImagePicker();
                                final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
                                File imagefile = File(photo!.path);
                                setState(() {
                                  selectedfile = imagefile;
                                });
                              },
                              child:Image.asset("assets/img/gallery.png"),

                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 16),


                  ],
                )
              ),

              SizedBox(height: 35.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Category Name ",style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Roboto_regular"
                ),),
              ),
                Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _name,
            decoration: InputDecoration(
              hintText: "Category Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),),
                ),
                SizedBox(height: 34,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(height: 50,
                    width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFFF15A29),
                      foregroundColor: Colors.white, // Text ka color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      var cname = _name.text.toString();

                      Uri url = Uri.parse(UrlHelper.ADD_CATEGORY);
                      var request = http.MultipartRequest('POST', url);
                      request.headers.addAll({
                        "Content-Type": "multipart/form-data",
                        "Accept": "application/json"
                      });
                      request.files.add(await http.MultipartFile.fromPath('catimage', selectedfile!.path));
                      request.fields['catname'] = cname;

                      var response = await request.send();

                      if (response.statusCode == 200) {
                        final respStr = await response.stream.bytesToString();
                        print("Response: $respStr");
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                      } else {
                        print("Upload failed: ${response.statusCode}");
                      }
                    },
                    child: Text("Add Category",style: TextStyle(
                        fontFamily: "Poppins_medium",fontSize: 18
                    ),),
                  ),),
                ),


              ],
          ),
        ),
      ),
    );
  }
}
