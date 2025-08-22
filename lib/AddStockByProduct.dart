import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'HomeScreen.dart';
import 'constants/UrlHelper.dart';
import 'ViewStock.dart';

class AddStockByProduct extends StatefulWidget {
  final String title,pid;
  AddStockByProduct({required this.title,required this.pid});

  @override
  State<AddStockByProduct> createState() => _AddStockByProductState();
}

class _AddStockByProductState extends State<AddStockByProduct> {
  TextEditingController _type = TextEditingController();
  TextEditingController _noofitem = TextEditingController();
  String? selectedProductId;





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Stock")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.title),
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
                    var noofitem = _noofitem.text.toString();

                    Uri url = Uri.parse(UrlHelper.ADD_STOCK);
                    var request = http.MultipartRequest('POST', url);

                    request.fields['proid'] = widget.pid.toString();
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
                  child: Text("Add", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
            ),
          ],
        ),
      ),
    );
  }
}