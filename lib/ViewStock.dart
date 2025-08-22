import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopadmin/AddStockScreen.dart';
import 'package:shopadmin/EditStock.dart';

import 'constants/UrlHelper.dart';

class Viewstock extends StatefulWidget {
  const Viewstock({super.key});

  @override
  State<Viewstock> createState() => _ViewstockState();
}

class _ViewstockState extends State<Viewstock> {
  Future<List>? alldata;
  Future<List> getstock() async
  {
    Uri url = Uri.parse(UrlHelper.STOCK_VIEW);
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
      alldata = getstock();
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
          'Stock',
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
                  var productid;
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>AddStockScreen(productid: productid)));
                },
              ),
            ),

          ),
          ],
      ),
      body: Expanded(
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
                itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  String type = snapshot.data![index]["type"].toString().toLowerCase();
              Color typeColor = type == "in" ? Colors.green : Colors.red;
                {
                  return
                    SingleChildScrollView(
                      child: Column(
                        children: [

                            Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),),
                              child:
                              Padding(padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                Image.network(snapshot.data![index]["img1"].toString(),
                                      width: 89,
                                      height: 83,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.broken_image, color: Colors.grey,size: 100,);
                                      },
                                    ),
                                    SizedBox(width: 40.0,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(snapshot.data![index]["title"].toString(), style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: "Roboto_medium",
                                              fontWeight: FontWeight.bold

                                          ),
                                          ),
                                          SizedBox(height: 5.0,),
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
                                          ),SizedBox(height: 5.0,),
                                          Row(
                                            children: [
                                              Text(snapshot.data![index]["noofitem"].toString(), style: TextStyle(
                                                fontSize: 12,color: typeColor,
                                                fontFamily: "Roboto_regular",

                                              ),
                                              ),SizedBox(width: 5.0,),
                                              Text(
                                                "${type.toUpperCase()} Stock",  // Shows "IN Stock" or "OUT Stock"
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "Roboto_regular",
                                                  fontWeight: FontWeight.bold,
                                                  color: typeColor,  // Green or Red
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.0,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 30,
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
                                                      MaterialPageRoute(builder: (context) =>EditStock(
                                                        stockid: snapshot.data![index]["stock_id"].toString(),
                                                      ) ,)
                                                  );
                                                },

                                                    child: Text("Edit",style: TextStyle(fontSize: 16,fontFamily: "Roboto_medium"),)),
                                              ),
                                              SizedBox(width: 3.0,),
                                              SizedBox(
                                                height: 30,
                                                width: 100,
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

                                                      title: Text("Are You Sure To Delete This Stock",style: TextStyle(fontFamily: "Roboto_medium"),),
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

                                                            Uri url = Uri.parse(UrlHelper.DELETE_STOCK);
                                                            var request = http.MultipartRequest('POST', url);

                                                            request.fields['stockid'] = snapshot.data![index]["stock_id"].toString();

                                                            var response = await request.send();
                                                            final respStr = await response.stream.bytesToString();

                                                            if (response.statusCode == 200) {
                                                              Navigator.of(context).pop();
                                                              setState(() {
                                                                alldata = getstock();
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

                          SizedBox(height: 8.0,),

                        ],
                      ),
                    );}
                },
              );
            }
          },
        ),
      ),
    );
  }
}
