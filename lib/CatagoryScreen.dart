import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopadmin/ProductScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shopadmin/constants/UrlHelper.dart';

import 'AddCategoryScreen.dart';
import 'EditCategory.dart';

class CatagoryScreen extends StatefulWidget {
  const CatagoryScreen({super.key});

  @override
  State<CatagoryScreen> createState() => _CatagoryScreenState();
}

class _CatagoryScreenState extends State<CatagoryScreen> {

  Future<List>? alldata;


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
    setState(() {
      alldata = getcategory();
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Category',
          style: TextStyle(
            fontFamily: "Roboto_medium",
            fontSize: 24,
            color: Color(0XFF000000),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>AddCategoryScreen()));
                },
              ),
            ),
          ),
        ],
      ),
      body:
      FutureBuilder(
        future: alldata,
        builder: (context,snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No category found.'));
          }
          else
          {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context,index)
              {
                return  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>ProductScreen())
                      );
                    },

                      child: Column(
                        children: [
                          SizedBox(height: 10.0,),
                          Card(
                            child:
                            Padding(padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Image.network(snapshot.data![index]["category_image"].toString(),
                                    width: 89,height: 83,),
                                  SizedBox(width: 24.0,),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data![index]["category_name"].toString(), style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Roboto_medium",
                                          fontWeight: FontWeight.bold ),
                                      ),
                                      SizedBox(height: 15.0,),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 35,
                                            width: 100,

                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),onPressed: () async{

                                              var alert = AlertDialog(
                                                // backgroundColor: Colors.white,
                                                // shape: RoundedRectangleBorder(
                                                //   borderRadius: BorderRadius.zero,
                                                // ),
                                                actions: [
                                                  Container(
                                                    width: 300,
                                                    height: 140,
                                                    padding: EdgeInsets.all(20),
                                                    child:
                                                    Column(
                                                      children: [
                                                        Center(child: Text("Are You Sure To Delete This Product",style: TextStyle(fontFamily: "Roboto_medium",fontSize: 16),)),
                                                        Center(
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Colors.green,
                                                                      foregroundColor: Colors.white,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                    ),onPressed: (){

                                                                  Navigator.of(context).pop();

                                                                },

                                                                    child: Text("Cancel",style: TextStyle(fontSize: 16,fontFamily: "Roboto_medium"),)
                                                                ),
                                                              ),
                                                              SizedBox(width: 7,),
                                                              SizedBox(

                                                                child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Colors.red,
                                                                      foregroundColor: Colors.white,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                    ),onPressed: ()async{

                                                                  Uri url = Uri.parse(UrlHelper.DELETE_CATEGORY);
                                                                  var request = http.MultipartRequest('POST', url);

                                                                  request.fields['catid'] = snapshot.data![index]["category_id"].toString();

                                                                  var response = await request.send();
                                                                  final respStr = await response.stream.bytesToString();

                                                                  if (response.statusCode == 200) {
                                                                    setState(() {
                                                                      alldata = getcategory();
                                                                    });
                                                                  } else {
                                                                    print("Upload failed: ${response.statusCode}");
                                                                  }
                                                                },
                                                                    child: Text("Delete",style: TextStyle(fontSize: 16,fontFamily: "Roboto_medium"),)
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )

                                                ],
                                              );

                                              showDialog(context: context, builder: (context){
                                                return alert;
                                              });
                                            },
                                                child: Text("Delete",style: TextStyle(fontSize: 16,fontFamily: "Roboto_medium"),)),
                                          ),

                                          SizedBox(width: 9.0,),
                                          SizedBox(
                                            height: 35,
                                            width: 100,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder: (context)=>EditCategory(
                                                      id: snapshot.data![index]["category_id"].toString(),
                                                    ))
                                                );
                                              },
                                              child: Text("Edit", style: TextStyle(fontFamily: "Poppins_medium", fontSize: 16)),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),

                                ],
                              ),
                            ),
                            margin: EdgeInsets.only(left: 10.0, right: 10.0, ),
                          ),
                          SizedBox(height: 8.0,),
                        ],
                      ),

                );
              },
            );

          }
        },
      ),


    );
  }
}
