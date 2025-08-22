import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopadmin/AddStockByProduct.dart';
import 'package:shopadmin/AddStockScreen.dart';
import 'package:shopadmin/HomeScreen.dart';
import 'package:shopadmin/ProductInformation.dart';
import 'package:shopadmin/constants/UrlHelper.dart';
import 'EditProduct.dart';

class StockOutProducts extends StatefulWidget {


  @override
  State<StockOutProducts> createState() => _StockOutProductsState();
}

class _StockOutProductsState extends State<StockOutProducts> {
  Future<List>? alldata;
  TextEditingController _type = TextEditingController();
  TextEditingController _noofitem = TextEditingController();
  String? selectedProductId;

  Future<List> getproduct() async
  {
    Uri url = Uri.parse(UrlHelper.STOCK_OUT_PRODUCT);
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
      alldata = getproduct();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,
          title: Text("Stockout Products",style: TextStyle(fontSize: 24,fontFamily: "Roboto_medium"),),
        ),
        body:

          FutureBuilder(
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
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context,index)
                  {
                    return  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),),
                        child:
                        Padding(padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Image.network(snapshot.data![index]["img1"].toString(),
                                width: 100.0,),
                              SizedBox(width: 40.0,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data![index]["title"].toString(), style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Roboto_medium"

                                    ),
                                    ),
                                    SizedBox(height: 10.0,),
                                    Text(snapshot.data![index]["sell_price"].toString(), style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Roboto_medium"

                                    ),
                                    ),
                                    SizedBox(height: 5.0,),
                                    Row(
                                      children: [
                                        Text("Stock : "+snapshot.data![index]["totalstock"].toString(), style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Roboto_medium",
                                            color: Color(0XFFFF0A0A)
                                        ),),
                                        SizedBox(width: 20.0,),

                                        SizedBox(
                                          height: 30,
                                          width: 145,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0XFFF15A29),
                                                foregroundColor: Colors.white, // Text ka color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () async{
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder: (context)=>AddStockByProduct(
                                                      title: snapshot.data![index]["title"].toString(),
                                                      pid: snapshot.data![index]["product_id"].toString(),
                                                    ))
                                                );
                                               },
                                              child: Text("Add Stock",style: TextStyle(
                                                  fontFamily: "Poppins_medium",fontSize: 18
                                              ),)
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Text(snapshot.data![index]["category_name"].toString(), style: TextStyle(
                                    //     fontSize: 20,
                                    //     fontWeight: FontWeight.bold
                                    //
                                    // ),
                                    // ),


                                    // ElevatedButton(
                                    //     onPressed: () async {
                                    //       Navigator.of(context).push(
                                    //           MaterialPageRoute(builder: (context)=>AddStockByProduct(
                                    //             title: snapshot.data![index]["title"].toString(),
                                    //             pid: snapshot.data![index]["product_id"].toString(),
                                    //           ))
                                    //       );
                                    //     },
                                    //     child: Text("Add Stock", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                                    // ),
                                  ],
                                ),
                              )
                            ],
                          ),),
                        margin: EdgeInsets.only(left: 10.0, right: 10.0, ),
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