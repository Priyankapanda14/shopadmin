import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopadmin/AddProductScreen.dart';
import 'package:shopadmin/ProductInformation.dart';
import 'package:shopadmin/constants/UrlHelper.dart';
import 'EditProduct.dart';

const Duration fakeAPIDuration = Duration(seconds: 1);

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ToyScreenState();
}

class _ToyScreenState extends State<ProductScreen> {

  TextEditingController search = TextEditingController();

  List<dynamic> _allProducts = [];
  List<dynamic> _filteredProducts = [];
  Future<List>? alldata;
  Future<List> getproduct() async
  {
    Uri url = Uri.parse(UrlHelper.PRODUCT_VIEW);
    var response = await http.get(url);
    if(response.statusCode==200)
    {
      var json = response.body.toString();
      // return jsonDecode(json);
      setState(() {
        _allProducts = jsonDecode(json);
        _filteredProducts = _allProducts;
      });
      return _filteredProducts;
    }
    return [];
  }
  void _filterSearch(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((item) =>
          item["title"]
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
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
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Product',
            style: TextStyle(
              color: Colors.black,
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
                        MaterialPageRoute(builder: (context)=>AddProductScreen()));
                  },
                ),
              ),

            ),

             ],
        ),
      body:

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: search,
                  onChanged: _filterSearch,
                    decoration: InputDecoration(
                      label: Icon(Icons.search_outlined,color: Colors.grey,),

                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                ),
              ),
              SizedBox(height: 8),

              Expanded(
                child: FutureBuilder(
                        future: alldata!,
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
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context,index)
                    {
                      return
                        SingleChildScrollView(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context)=>Productinformation(
                                      id: _filteredProducts[index]["product_id"].toString(),
                                    ))
                                );
                              },
                              child:
                              Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),),
                                child:
                                Padding(padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        _filteredProducts[index]["img1"].toString(),
                                        width: 89,
                                        height: 83,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.broken_image, color: Colors.grey,size: 100,);
                                        },
                                      ),
                                      // Image.network(snapshot.data![index]["img1"].toString(),
                                      //   width: 89,height: 83,),
                                      SizedBox(width: 40.0,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(_filteredProducts[index]["title"].toString(), style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Roboto_medium",
                                                fontWeight: FontWeight.bold

                                            ),
                                            ),
                                            SizedBox(height: 10.0,),
                                            Text(_filteredProducts[index]["category_name"].toString(), style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Roboto_regular",
                                                fontWeight: FontWeight.bold

                                            ),
                                            ),
                                            SizedBox(height: 10.0,),
                                            Row(
                                              children: [
                                                Text("₹"+snapshot.data![index]["sell_price"].toString(), style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "Roboto_regular",

                                                ),
                                                ),
                                                SizedBox(width: 10.0,),
                                                Text("₹"+snapshot.data![index]["retail_price"].toString(), style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "Roboto_regular",
                                                  color: Colors.black54,
                                                  decoration: TextDecoration.lineThrough,)
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.0,),
                                            Row(
                                              children: [
                                                Text("Stock : "+_filteredProducts[index]["totalstock"].toString(), style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Roboto_regular",
                                                    color: Colors.red
                                                ),),
                                                SizedBox(width: 135.0,),
                                                SizedBox(
                                                  width: 100,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.blue,
                                                        foregroundColor: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                      ),onPressed: (){
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(builder: (context) =>EditProduct(
                                                          productid: _filteredProducts[index]["product_id"].toString(),
                                                        ) ,)
                                                    );
                                                  },

                                                      child: Text("Edit",style: TextStyle(fontSize: 16,fontFamily: "Roboto_medium"),)),
                                                ),
                                                SizedBox(width: 3.0,),
                                                SizedBox(

                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                        foregroundColor: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                      ),onPressed: () async{

                                                    var alert = Expanded(
                                                      child: AlertDialog(backgroundColor: Colors.white,

                                                        title: Text("Are You Sure To Delete This Product",style: TextStyle(fontFamily: "Roboto_medium"),),
                                                        actions: [
                                                          ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.green,
                                                                foregroundColor: Colors.white,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                              ),onPressed: (){

                                                            Navigator.of(context).pop();

                                                          },

                                                        child: Text("Cancel",style: TextStyle(fontSize: 16,fontFamily: "Roboto_medium"),)),
                                                          SizedBox(

                                                            child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Colors.red,
                                                                  foregroundColor: Colors.white,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                ),onPressed: ()async{

                                                              Uri url = Uri.parse(UrlHelper.DELETE_PRODUCT);
                                                              var request = http.MultipartRequest('POST', url);

                                                              request.fields['proid'] = _filteredProducts[index]["product_id"].toString();

                                                              var response = await request.send();
                                                              final respStr = await response.stream.bytesToString();

                                                              if (response.statusCode == 200) {
                                                                Navigator.of(context).pop();
                                                                setState(() {
                                                                  alldata = getproduct();
                                                                });

                                                              } else {
                                                                print("Upload failed: ${response.statusCode}");
                                                              }
                                                            },
                                                                child: Text("Delete",style: TextStyle(fontSize: 16,fontFamily: "Roboto_medium"),)),
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                    showDialog(context: context, builder: (context){
                                                      return alert;
                                                    });





                                                  },

                                                      child: Text("Delete",style: TextStyle(fontSize: 16,fontFamily: "Roboto_medium"),)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.0,),

                                            ],
                                        ),
                                      )
                                    ],
                                  ),),
                                margin: EdgeInsets.only(left: 10.0, right: 10.0, ),
                              ),
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
              ),
            ],
          )
      ,

    );
  }
}




