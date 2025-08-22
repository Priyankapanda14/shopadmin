import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopadmin/EditStock.dart';

import 'HomeScreen.dart';
import 'constants/UrlHelper.dart';

class AddStockScreen extends StatefulWidget {
  const AddStockScreen({super.key, required String productid});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  Future<List>? alldata;

  TextEditingController _type = TextEditingController();
  TextEditingController _noofitem = TextEditingController();
  String? selectedProductId;

  Future<List> getproduct() async
  {
    Uri url = Uri.parse(UrlHelper.PRODUCT_VIEW);
    var response = await http.get(url);

    if(response.statusCode==200)
    {
      var json = response.body.toString();
      print("PRODUCT API RESPONSE: $json");
      return jsonDecode(json);
    }
    return [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      alldata = getproduct();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Add Stock",style: TextStyle(fontFamily: "Roboto_medium"),),
      ),
      body:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: alldata,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No product found');
                }

                final product = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Product",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedProductId,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProductId = newValue!;
                      });
                    },
                    items: product.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['product_id'].toString(),
                        child: Text(category['title']),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Type"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _type,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Number Of Item :"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _noofitem,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                    onPressed: () async{var type = _type.text.toString();
                      var noofitem = _noofitem.text.toString();

                      Uri url = Uri.parse(UrlHelper.ADD_STOCK);
                      var request = http.MultipartRequest('POST', url);

                      request.fields['proid'] = selectedProductId.toString();
                      request.fields['type'] = type;
                      request.fields['noofitem'] = noofitem;

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
                      child:  Text("Add Stock",style: TextStyle(
                        fontFamily: "Poppins_medium",fontSize: 18
                    ),)
                ),
              ),
            ),
      // Padding(
      //   padding: const EdgeInsets.only(left: 200.0),
      //   child: ElevatedButton(
      //     onPressed: () async {
      //       var type = _type.text.toString();
      //       var noofitem = _noofitem.text.toString();
      //
      //       Uri url = Uri.parse(UrlHelper.ADD_STOCK);
      //       var request = http.MultipartRequest('POST', url);
      //
      //       request.fields['proid'] = selectedProductId.toString();
      //       request.fields['type'] = type;
      //       request.fields['noofitem'] = noofitem;
      //
      //       var response = await request.send();
      //       final respStr = await response.stream.bytesToString();
      //
      //       if (response.statusCode == 200) {
      //         print("Server Response: $respStr");
      //         Navigator.pop(context);
      //         Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      //       } else {
      //         print("Upload failed: ${response.statusCode}");
      //       }
      //     },
      //       child: Text("Add", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      // ),
      SizedBox(width: 30.0,),



          ],
          
        ),
      ),

    );
  }
}
