import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shopadmin/ProductScreen.dart';
import 'constants/UrlHelper.dart';

class EditProduct extends StatefulWidget {
  var productid;
  EditProduct({required this.productid});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
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
  String? img1;
  String? img2;
  String? img3;
  List categories = [];

  Future<void> getProductData() async {
    Uri url = Uri.parse(UrlHelper.PRODUCT_SINGLE_VIEW);
    final response = await http.post(url, body: {'productid': widget.productid});
    if (response.statusCode == 200) {
      var obj = jsonDecode(response.body);
      print(obj);
      setState(() {

        _title.text = obj['title'].toString();
        _sell.text = obj['sell_price'].toString();
        _retail.text = obj['retail_price'].toString();
        _video.text = obj['video_url'].toString();
        _description.text = obj['description'].toString();
        _specification.text = obj['specification'].toString();
        _isactive.text = obj['isactive'].toString();

        setState(() {
          // selectedCategoryId = obj['catid'].toString();
          img1 = obj['img1'].toString();
          img2 = obj['img2'].toString();
          img3 = obj['img3'].toString();
        });
      });
    }
  }

  Future<List> getproduct() async {
    Uri url = Uri.parse(UrlHelper.CATEGORY_VIEW); //
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    getProductData();
    getproduct().then((data) {
      setState(() {
        categories = data;
      });
    });
  }

  Future<void> pickImage(ImageSource source, int imageNumber) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) selectedfile1 = File(pickedFile.path);
        if (imageNumber == 2) selectedfile2 = File(pickedFile.path);
        if (imageNumber == 3) selectedfile3 = File(pickedFile.path);
      });
    }
  }

  Widget imagePickerRow(String label, File? file, int imageNumber) {
    return Card(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: (selectedfile1==null)?
            (img1=="")?Image.network("https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg",width: 200,height: 200,)
                :Image.network(img1!,width: 150,height: 150):Image.file(selectedfile1!,width: 150,height: 150),

          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () => pickImage(ImageSource.camera, imageNumber),
                child: Text("Camera"),
              ),
              ElevatedButton(
                onPressed: () => pickImage(ImageSource.gallery, imageNumber),
                child: Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Edit Product",style: TextStyle(fontSize: 24,fontFamily: "Roboto_medium"),))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Category"),
            ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(borderRadius: BorderRadius.horizontal(left: Radius.circular(8),right: Radius.circular(8)),color: Colors.white),
            child: DropdownButton<String>(

              value: selectedCategoryId,
              isExpanded: true,
              hint: Text("Select Category"),
              items: categories.map((cat) {
                return DropdownMenuItem(
                  child: Text(cat['category_name']),
                  value: cat['category_id'].toString(),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedCategoryId = val),
            ),
          ),
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),),
            ),
            SizedBox(height: 10,),

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

            // Padding(
            //   padding:  EdgeInsets.all(8.0),
            //   child: Text("Video URL"),
            // ),
            // Padding(
            //   padding:  EdgeInsets.all(8.0),
            //   child: TextField(
            //     controller: _video,
            //
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            //     ),),
            // ),
            Padding(
              padding:  EdgeInsets.all(8.0),
              child: Text(" Description"),
            ),
            Padding(
              padding:  EdgeInsets.all(8.0),
              child: TextField(
                controller: _description,

                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),),
            ),
            Padding(
              padding:  EdgeInsets.all(8.0),
              child: Text("specification"),
            ),
            Padding(
              padding:  EdgeInsets.all(8.0),
              child: TextField(
                controller: _specification,

                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),),
            ),

            //TextField(controller: _title, decoration: InputDecoration(labelText: 'Title')),
            // TextField(controller: _retail, decoration: InputDecoration(labelText: 'Retail Price')),
            // TextField(controller: _sell, decoration: InputDecoration(labelText: 'Sell Price')),
            // TextField(controller: _video, decoration: InputDecoration(labelText: 'Video URL')),
            // TextField(controller: _description, decoration: InputDecoration(labelText: 'Description')),
            // TextField(controller: _specification, decoration: InputDecoration(labelText: 'specification')),
            // TextField(controller: _isactive, decoration: InputDecoration(labelText: 'Is Active')),

            SizedBox(height: 20),
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
                      (img1=="")?Image.network("https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg",width: 200,height: 200,)
                          :Image.network(img1!,width: 150,height: 150):Image.file(selectedfile1!,width: 150,height: 150),
                      SizedBox(width: 18,),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Image 1",style: TextStyle(
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
                      (img2=="")?Image.network("https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg",width: 200,height: 200,)
                          :Image.network(img2!,width: 150,height: 150):Image.file(selectedfile2!,width: 150,height: 150),
                      SizedBox(width: 18,),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Image 2",style: TextStyle(
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
                                      selectedfile2 = imagefile;
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
                      (img3=="")?Image.network("https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg",width: 200,height: 200,)
                          :Image.network(img3!,width: 150,height: 150):Image.file(selectedfile3!,width: 150,height: 150),
                      SizedBox(width: 18,),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Image 3",style: TextStyle(
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
                                      selectedfile3 = imagefile;
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
            // Card(
            //   child: Row(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(10.0),
            //         child: (selectedfile1==null)?
            //         (img1=="")?Image.network("https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg",width: 200,height: 200,)
            //             :Image.network(img1!,width: 200,height: 200):Image.file(selectedfile1!,width: 200,height: 200),
            //
            //       ),
            //       Column(
            //         children: [
            //           ElevatedButton(onPressed: () async{
            //
            //             ImagePicker picker = ImagePicker();
            //             final XFile? photo = await picker.pickImage(source: ImageSource.camera);
            //             File imagefile = File(photo!.path);
            //             setState(() {
            //               selectedfile1 = imagefile;
            //             });
            //
            //           }, child: Text("Camera")),
            //           ElevatedButton(onPressed: () async{
            //             ImagePicker picker = ImagePicker();
            //             final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
            //             File imagefile = File(photo!.path);
            //             setState(() {
            //               selectedfile1 = imagefile;
            //             });
            //
            //           }, child: Text("Gallery")),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            // Card(
            //   child: Row(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(10.0),
            //         child: (selectedfile2==null)?
            //         (img2=="")?Image.network("https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg",width: 200,height: 200,)
            //             :Image.network(img2!,width: 200,height: 200):Image.file(selectedfile2!,width: 200,height: 200),
            //
            //       ),
            //       Column(
            //         children: [
            //           ElevatedButton(onPressed: () async{
            //
            //             ImagePicker picker = ImagePicker();
            //             final XFile? photo = await picker.pickImage(source: ImageSource.camera);
            //             File imagefile = File(photo!.path);
            //             setState(() {
            //               selectedfile2 = imagefile;
            //             });
            //
            //           }, child: Text("Camera")),
            //           ElevatedButton(onPressed: () async{
            //             ImagePicker picker = ImagePicker();
            //             final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
            //             File imagefile = File(photo!.path);
            //             setState(() {
            //               selectedfile2 = imagefile;
            //             });
            //
            //           }, child: Text("Gallery")),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            // Card(
            //   child: Row(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(10.0),
            //         child: (selectedfile3==null)?
            //         (img3=="")?Image.network("https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg",width: 200,height: 200,)
            //             :Image.network(img3!,width: 200,height: 200):Image.file(selectedfile3!,width: 200,height: 200),
            //
            //       ),
            //       Column(
            //         children: [
            //           ElevatedButton(onPressed: () async{
            //
            //             ImagePicker picker = ImagePicker();
            //             final XFile? photo = await picker.pickImage(source: ImageSource.camera);
            //             File imagefile = File(photo!.path);
            //             setState(() {
            //               selectedfile3 = imagefile;
            //             });
            //
            //           }, child: Text("Camera")),
            //           ElevatedButton(onPressed: () async{
            //             ImagePicker picker = ImagePicker();
            //             final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
            //             File imagefile = File(photo!.path);
            //             setState(() {
            //               selectedfile3 = imagefile;
            //             });
            //
            //           }, child: Text("Gallery")),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
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
                  onPressed: () async {
                    Uri url = Uri.parse(UrlHelper.UPDATE_PRODUCT);
                    var request = http.MultipartRequest('POST', url);

                    request.fields['productid'] = widget.productid;
                    request.fields['title'] = _title.text;
                    request.fields['retail_price'] = _retail.text;
                    request.fields['sell_price'] = _sell.text;
                    request.fields['video_url'] = _video.text;
                    request.fields['description'] = _description.text;
                    request.fields['specification'] = _specification.text;
                    request.fields['isactive'] = _isactive.text;
                    request.fields['catid'] = selectedCategoryId ?? '';

                    if (selectedfile1 != null)
                      request.files.add(await http.MultipartFile.fromPath('img1', selectedfile1!.path));
                    if (selectedfile2 != null)
                      request.files.add(await http.MultipartFile.fromPath('img2', selectedfile2!.path));
                    if (selectedfile3 != null)
                      request.files.add(await http.MultipartFile.fromPath('img3', selectedfile3!.path));

                    var response = await request.send();
                    if (response.statusCode == 200) {
                      final respStr = await response.stream.bytesToString();
                      print(respStr);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to update product")));
                    }
                  },
                  child: Text("Update",style: TextStyle(
                      fontFamily: "Poppins_medium",fontSize: 18
                  ),)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
