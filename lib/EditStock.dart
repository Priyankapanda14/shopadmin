import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants/UrlHelper.dart';
import 'ViewStock.dart';

class EditStock extends StatefulWidget {
  final String stockid;
  EditStock({required this.stockid});

  @override
  State<EditStock> createState() => _EditStockState();
}

class _EditStockState extends State<EditStock> {
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
      return jsonDecode(json);
    }
    return [];
  }
  @override
  void initState() {
    super.initState();
    getstock();
    getproduct();
  }


  Future<void> getstock() async {
    Uri url = Uri.parse(UrlHelper.STOCK_SINGLE_VIEW);
    var response = await http.post(url, body: {
      'stock_id': widget.stockid,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> stock = jsonDecode(response.body);

      if (!stock.containsKey('error')) {
        setState(() {
          _type.text = stock['type'].toString();
          _noofitem.text = stock['noofitem'].toString();
        });
      } else {
        print("Error: ${stock['error']}");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Stock")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder(
              future: getproduct(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("No products found");
                }

                final productList = snapshot.data!;

                return DropdownButton<String>(
                  hint: Text("Select Product"),
                  value: selectedProductId,
                  onChanged: (newValue) {
                    setState(() {
                      selectedProductId = newValue!;
                    });
                  },
                  items: productList.map<DropdownMenuItem<String>>((product) {
                    return DropdownMenuItem<String>(
                      value: product['product_id'].toString(),
                      child: Text(product['title']),
                    );
                  }).toList(),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _type,
                decoration: InputDecoration(
                  labelText: "Type",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _noofitem,
                decoration: InputDecoration(
                  labelText: "Number of Items",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20.0,),
             Center(
               child: ElevatedButton(
                    onPressed: () async {
                      var type = _type.text.toString();
                      var numberofitem = _noofitem.text.toString();



                      Uri url = Uri.parse(UrlHelper.UPDATE_STOCK);
                      var request = http.MultipartRequest('POST', url);

                      request.fields['stock_id'] = widget.stockid;
                      request.fields['proid'] = selectedProductId.toString();
                      request.fields['type'] = type;
                      request.fields['noofitem'] = numberofitem;

                      var response = await request.send();
                      var respStr = await response.stream.bytesToString();
                      print("Response: $respStr");

                      if (response.statusCode == 200) {
                        final jsonResponse = jsonDecode(respStr);
                        if (jsonResponse["status"] == "success") {
                          print(response);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => Viewstock()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(jsonResponse["message"] ?? "Update failed")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to update product")),
                        );
                      }
                    },
                    child: Text("Update", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
             ),
            ],
        ),
      ),
    );
  }
}
