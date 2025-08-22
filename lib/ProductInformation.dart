
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'EditProduct.dart';
import 'Inquiry.dart';
import 'constants/UrlHelper.dart';

class Productinformation extends StatefulWidget {
  var id;
  Productinformation({this.id});

  @override
  State<Productinformation> createState() => _ProductinformationState();
}

class _ProductinformationState extends State<Productinformation> {
  TextEditingController product_id =TextEditingController();
  TextEditingController quantity =TextEditingController();
  TextEditingController buyer_name =TextEditingController();
  TextEditingController message =TextEditingController();

  var single;
  var selectedimage="";



  Future<void>getdata() async {
    Uri url = Uri.parse(UrlHelper.SINGLE_PRODUCT);
    final map = <String, dynamic>{};
    map['id'] = widget.id.toString();
    var response = await http.post(url, body: map);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());

      setState(() {
        single = json;
        selectedimage = single["img1"];
      });
    }
  }


  @override
  void initState() {
    super.initState();
    getdata();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(single == null ? "Loading..." : single["title"]),
        actions: [
          PopupMenuButton(color:Colors.white,
          itemBuilder: (context) =>[
            PopupMenuItem(
                child: Column(
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>EditProduct(
                            productid: single["product_id"].toString(),
                          ) ,)
                      );
                    },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,foregroundColor: Colors.white,),
                        child: Text("Edit")),
                    SizedBox(height: 3.0,),
                    // ElevatedButton(onPressed: () async{
                    //
                    //   Uri url = Uri.parse(UrlHelper.DELETE_PRODUCT);
                    //   var request = http.MultipartRequest('POST', url);
                    //
                    //   request.fields['proid'] = single["product_id"].toString();
                    //
                    //   var response = await request.send();
                    //   final respStr = await response.stream.bytesToString();
                    //
                    //   if (response.statusCode == 200) {
                    //     Navigator.of(context).pop();
                    //   } else {
                    //     print("Upload failed: ${response.statusCode}");
                    //   }
                    //
                    // },
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.red,foregroundColor: Colors.white),
                    //     child: Text("Delete")),
                    SizedBox(

                      child: ElevatedButton(onPressed: () async{

                        var alert = Expanded(
                          child: AlertDialog(backgroundColor: Colors.white,

                            title: Text("Are You Sure To Delete This Product",style: TextStyle(fontFamily: "Roboto_medium"),),
                            actions: [
                              ElevatedButton(onPressed: (){

                                Navigator.of(context).pop();

                              },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,foregroundColor: Colors.white),
                                  child: Text("Cancel",style: TextStyle(fontSize: 16,fontFamily: "Roboto_medium"),)),
                              SizedBox(

                                child: ElevatedButton(onPressed: ()async{

                                  Uri url = Uri.parse(UrlHelper.DELETE_PRODUCT);
                                  var request = http.MultipartRequest('POST', url);

                                  request.fields['proid'] = single["product_id"].toString();

                                  var response = await request.send();
                                  final respStr = await response.stream.bytesToString();

                                  if (response.statusCode == 200) {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      //alldata = getproduct();
                                    });

                                  } else {
                                    print("Upload failed: ${response.statusCode}");
                                  }
                                },style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,foregroundColor: Colors.white),
                                    child: Text("Delete",style: TextStyle(fontSize: 16,fontFamily: "Roboto_medium"),)),
                              ),
                            ],
                          ),
                        );

                        showDialog(context: context, builder: (context){
                          return alert;
                        });





                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,foregroundColor: Colors.white),
                          child: Text("Delete",style: TextStyle(fontSize: 16,fontFamily: "Roboto_medium"),)),
                    ),
                  ],
                ) )
          ])
        ],
      ),
      body:
      single == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 267,
              width: 400,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(selectedimage,
                  ),

                ),
              ),),
            SizedBox(height: 24,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedimage = single["img1"];
                    });
                  },
                  child: Card(
                    elevation: 5,
                    child: Image.network(single["img1"],
                      height: 114,
                      width: 121,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedimage = single["img2"];
                    });
                  },
                  child: Card(
                    elevation: 5,
                    child: Image.network(single["img2"],
                      height: 114,
                      width: 121,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedimage = single["img3"];
                    });
                  },
                  child: Card(
                    elevation: 5,
                    child: Image.network(single["img3"],
                      height: 114,
                      width: 121,
                    ),
                  ),
                ),
              ],
            ),


            SizedBox(height: 40),
            Text("Title : " + single["title"],
              style: TextStyle(fontSize: 20, fontFamily:"Roboto_semibold" ),
            ),
            SizedBox(height: 10),
            Text(
                "Category : toys",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
                "" + single["sell_price"],
                style: TextStyle(fontSize: 18,color:Color(0XFF000000),
                    fontFamily: "Roboto_regular")),
            SizedBox(height: 10),
            Text(
              "Description : "+ single["description"],
              style: TextStyle(fontSize: 12, fontFamily: "Poppins_semibold"),
            ),
            SizedBox(height: 30),

          ],

        ),
      ),
    );
  }
}


