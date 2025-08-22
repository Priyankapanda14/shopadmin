import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shopadmin/CatagoryScreen.dart';
import 'package:shopadmin/constants/UrlHelper.dart';

class EditCategory extends StatefulWidget {
  var id;
  EditCategory({this.id});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {

  TextEditingController _name = TextEditingController();
  File? selectedfile;
  String? catimage="";


  getdata() async
  {
    Uri url = Uri.parse(UrlHelper.CATEGORY_SINGLE_VIEW);
    final map = <String, dynamic>{};
    map['id'] = widget.id;
    var response = await http.post(url,body: map);
    if(response.statusCode==200)
    {
      var json = response.body.toString();
      var obj = jsonDecode(json);
      _name.text = obj["category_name"].toString();
      setState(() {
        catimage = obj["category_image"].toString();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Category"),
        ),
        body:
        (catimage=="")?Center(child: CircularProgressIndicator(),):
            SingleChildScrollView(
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
                                      (catimage=="")?Image.network("https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg",width: 99,height: 99,)
                                        :Image.network(catimage!,width: 99,height: 99,):Image.file(selectedfile!,width: 99,height: 99,),


                            // Image.asset("assets/img/image.png",width: 99,height: 99,)
                            //     :Image.file(selectedfile!,width: 99,height: 99),
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
                              child: Text("Category Name : "),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _name,
                                decoration: InputDecoration(
                                  hint: Text("add category"),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),),
                            ),
                            SizedBox(height: 30.0,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0XFFF15A29),
                                      foregroundColor: Colors.white, // Text ka color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () async{

                                  var cname = _name.text.toString();

                                  Uri url = Uri.parse(UrlHelper.UPDATE_CATEGORY);
                                  var request = http.MultipartRequest('POST', url);
                                  request.headers.addAll({
                                    "Content-Type": "multipart/form-data",
                                    "Accept": "application/json"
                                  });
                                  if(selectedfile!=null)
                                    {
                                      request.files.add(await http.MultipartFile.fromPath('catimage', selectedfile!.path));
                                    }

                                  request.fields['catname'] = cname;
                                  request.fields['catid'] = widget.id;
                                  var response = await request.send();

                                  if (response.statusCode == 200) {
                                    final respStr = await response.stream.bytesToString();
                                    print(respStr);

                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();

                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context)=>CatagoryScreen())
                                    );


                                  } else {
                                    print("Upload failed: ${response.statusCode}");
                                  }
                                }, child: Text("Update Category",style: TextStyle(
                                    fontFamily: "Poppins_medium",fontSize: 18
                                ),)),
                              ),
                            ),
                  ],
                ),
              ),
            )

    );
  }
}
