import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'HomeScreen.dart';
import 'constants/UrlHelper.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {


  TextEditingController _title = TextEditingController();
  TextEditingController _sell = TextEditingController();
  TextEditingController _retail = TextEditingController();
  TextEditingController _video = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _specification = TextEditingController();
  TextEditingController _isactive = TextEditingController();

  File? selectedfile1;
  File? selectedfile2;
  File? selectedfile3;
  String? selectedCategoryId;


  Future<List> getcategory() async
  {
    Uri url = Uri.parse(UrlHelper.CATEGORY_VIEW);
    var response = await http.get(url);
    if(response.statusCode==200)
    {
      var json = response.body.toString();
      return jsonDecode(json);
    }
    return [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Add Product",style: TextStyle(fontSize: 24,fontFamily: "Roboto_medium"),)),
      ),
      body:


      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Category"),
              ),
          FutureBuilder(

            future: getcategory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No categories found');
              }

              final categories = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(borderRadius: BorderRadius.horizontal(left: Radius.circular(8),right: Radius.circular(8)),color: Colors.white),
                  child: DropdownButton<String>(

                    hint: Text("Select Category"),
                    value: selectedCategoryId,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategoryId = newValue!;
                      });
                    },
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(

                        value: category['category_id'].toString(),
                        child: Text(category['category_name']),

                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),


              Padding(
                padding:  EdgeInsets.all(8.0),
                child: Text("Product Name"),
              ),
              Padding(
                padding:  EdgeInsets.all(8.0),
                child: TextField(
                  controller: _title,

                  decoration: InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),),
              ),

              Padding(
                padding:  EdgeInsets.only(left: 8.0),
                child: Text("Product Images"),
              ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (selectedfile1==null)?
                          Image.asset("assets/img/image.png",width: 100,height: 100,)
                              :Image.file(selectedfile1!,width: 200,height: 200),
                          SizedBox(width: 18,),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Upload Image 1",style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Roboto_regular"
                                ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        ImagePicker picker = ImagePicker();
                                        final XFile? photo = await picker.pickImage(source: ImageSource.camera);

                                        if (photo != null) {
                                          File imagefile = File(photo.path);
                                          setState(() {
                                            selectedfile1 = imagefile;
                                          });
                                        }
                                      },
                                      child:Image.asset("assets/img/camera.png"),

                                    ),
                                    SizedBox(width: 16,),
                                    GestureDetector(
                                      onTap: () async{
                                        ImagePicker picker = ImagePicker();
                                        final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
                                        File imagefile = File(photo!.path);
                                        setState(() {
                                          selectedfile1 = imagefile;
                                        });
                                      },
                                      child:Image.asset("assets/img/gallery.png"),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 10.0, ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (selectedfile2==null)?
                        Image.asset("assets/img/image.png",width: 100,height: 100,)
                            :Image.file(selectedfile2!,width: 200,height: 200),
                        SizedBox(width: 18,),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Upload Image 2",style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Roboto_regular"
                              ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      ImagePicker picker = ImagePicker();
                                      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

                                      if (photo != null) {
                                        File imagefile = File(photo.path);
                                        setState(() {
                                          selectedfile2 = imagefile;
                                        });
                                      }
                                    },
                                    child:Image.asset("assets/img/camera.png"),

                                  ),
                                  SizedBox(width: 16,),
                                  GestureDetector(
                                    onTap: () async{
                                      ImagePicker picker = ImagePicker();
                                      final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
                                      File imagefile = File(photo!.path);
                                      setState(() {
                                        selectedfile1 = imagefile;
                                      });
                                    },
                                    child:Image.asset("assets/img/gallery.png"),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0, ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (selectedfile3==null)?
                        Image.asset("assets/img/image.png",width: 100,height: 100,)
                            :Image.file(selectedfile3!,width: 200,height: 200),
                        SizedBox(width: 18,),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Upload Image 3",style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Roboto_regular"
                              ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      ImagePicker picker = ImagePicker();
                                      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

                                      if (photo != null) {
                                        File imagefile = File(photo.path);
                                        setState(() {
                                          selectedfile3 = imagefile;
                                        });
                                      }
                                    },
                                    child:Image.asset("assets/img/camera.png"),

                                  ),
                                  SizedBox(width: 16,),
                                  GestureDetector(
                                    onTap: () async{
                                      ImagePicker picker = ImagePicker();
                                      final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
                                      File imagefile = File(photo!.path);
                                      setState(() {
                                        selectedfile1 = imagefile;
                                      });
                                    },
                                    child:Image.asset("assets/img/gallery.png"),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0, ),
              Padding(
                padding:  EdgeInsets.all(8.0),
                child: Row(
                  children: [


                      Expanded(
                        child:
                        TextField(
                          controller: _sell,
                          decoration: InputDecoration(
                            labelText: "Sell Price",
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          ),
                        ),
                      ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _retail,
                        decoration: InputDecoration(
                          labelText: "Retail Price",
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Description"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _description,
                  maxLines: 20,
                  decoration: InputDecoration(
                    labelText: "Add Description",
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                            var title = _title.text.toString();
                            var retail = _retail.text.toString();
                            var sell = _sell.text.toString();
                            var video = _video.text.toString();
                            var description = _description.text.toString();
                            var specification = _specification.text.toString();
                            var isactive = _isactive.text.toString();

                            Uri url = Uri.parse(UrlHelper.ADD_PRODUCT);
                            var request = http.MultipartRequest('POST', url);

                            request.files.add(await http.MultipartFile.fromPath('img1', selectedfile1!.path));
                            request.files.add(await http.MultipartFile.fromPath('img2', selectedfile2!.path));
                            request.files.add(await http.MultipartFile.fromPath('img3', selectedfile3!.path));
                            request.fields['title'] = title;
                            request.fields['retail'] = retail;
                            request.fields['sell'] = sell;
                            request.fields['video'] = video;
                            request.fields['description'] = description;
                            request.fields['specification'] = specification;
                            request.fields['isactive'] = isactive;
                            request.fields['catid'] = selectedCategoryId.toString();


                            var response = await request.send();
                            final respStr = await response.stream.bytesToString();

                            if (response.statusCode == 200) {
                              print("Server Response: $respStr");
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                            } else {
                              print("Upload failed: ${response.statusCode}");
                            }
                      },
                         child: Text("Add",style: TextStyle(
                      fontFamily: "Poppins_medium",fontSize: 18
                  ),)
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.only(left: 200.0),
              //   child: ElevatedButton
              //     (onPressed: () async{
              //
              //     var title = _title.text.toString();
              //     var retail = _retail.text.toString();
              //     var sell = _sell.text.toString();
              //     var video = _video.text.toString();
              //     var description = _description.text.toString();
              //     var specification = _specification.text.toString();
              //     var isactive = _isactive.text.toString();
              //
              //     Uri url = Uri.parse(UrlHelper.ADD_PRODUCT);
              //     var request = http.MultipartRequest('POST', url);
              //
              //     request.files.add(await http.MultipartFile.fromPath('img1', selectedfile1!.path));
              //     request.files.add(await http.MultipartFile.fromPath('img2', selectedfile2!.path));
              //     request.files.add(await http.MultipartFile.fromPath('img3', selectedfile3!.path));
              //     request.fields['title'] = title;
              //     request.fields['retail'] = retail;
              //     request.fields['sell'] = sell;
              //     request.fields['video'] = video;
              //     request.fields['description'] = description;
              //     request.fields['specification'] = specification;
              //     request.fields['isactive'] = isactive;
              //     request.fields['catid'] = selectedCategoryId.toString();
              //
              //
              //     var response = await request.send();
              //     final respStr = await response.stream.bytesToString();
              //
              //     if (response.statusCode == 200) {
              //       print("Server Response: $respStr");
              //       Navigator.pop(context);
              //       Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
              //     } else {
              //       print("Upload failed: ${response.statusCode}");
              //     }
              //
              //     // final map = <String, dynamic>{};
              //     // map['title'] = title;
              //     // map['retail'] = retail;
              //     // map['sell'] = sell;
              //     // map['video'] = video;
              //     // map['description'] = description;
              //     // map['specialization'] = specialization;
              //     // map['isactive'] = isactive;
              //     //
              //     // var response = await http.post(url,body: map);
              //     // if(response.statusCode==200)
              //     // {
              //     //   var json = response.body.toString();
              //     //   print(json);
              //     // }
              //
              //   }, child: Text("Add", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
              // ),
              SizedBox(height: 30.0, ),
            ],
          ),
        ),
      ),
    );
  }
}
