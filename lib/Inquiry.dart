import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'constants/UrlHelper.dart';

class Inquiry extends StatefulWidget {
  const Inquiry({super.key});

  @override
  State<Inquiry> createState() => _InquiryState();
}

class _InquiryState extends State<Inquiry> {


  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

var tokendata = "";
  void initFCM() async {
    String? token = await _fcm.getToken();
    if (token != null) {
      print("token = ${token}");
      setState(() {
        tokendata = token;
        print("token data = ${tokendata}");
      });
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 2,
          channelKey: 'basic_channel',
          title: message.notification?.title,
          body: message.notification?.body,
        ),
      );
    });
  }


  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? pickedDate1 = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate1 != null) {
      setState(() {
        _dateController1.text = DateFormat('yyyy-MM-dd').format(pickedDate1);
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? pickedDate2 = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate2 != null) {
      setState(() {
        _dateController2.text = DateFormat('yyyy-MM-dd').format(pickedDate2);
      });
    }
  }


  List filteredList = [];
  Future<List>? alldata;
  Future<List> getinquiry() async {
    Uri url = Uri.parse(UrlHelper.INQUIRY_VIEW);
    //Uri url = Uri.parse("https://cataloge.infinityfreeapp.com/shopping/getinquiry.php");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // return jsonDecode(response.body);
      print("json = ${jsonDecode(response.body)}");
      return jsonDecode(response.body);
    }
    return [];
  }
  
  // Future<void> deleteinquiry(String id) async {
  //   Uri url = Uri.parse(UrlHelper.DELETE_INQUIRY);
  //   var request = http.MultipartRequest('POST', url);
  //   request.fields['inquiry_id'] = id;
  //
  //   var response = await request.send();
  //   final respStr = await response.stream.bytesToString();
  //   print("Delete response: $respStr");
  //
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(respStr);
  //     if (json['status'] == 'success') {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Deleted successfully")),
  //       );
  //       setState(() {
  //         alldata = getinquiry();
  //       });
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Failed to delete")),
  //       );
  //     }
  //   } else {
  //     print("Upload failed: ${response.statusCode}");
  //   }
  // }

  @override
  void initState() {
    super.initState();

    alldata = getinquiry().then((data) {
      setState(() {
        filteredList = data;
      });
      return data;
    });
  }
  // Future<void> _selectDate1(BuildContext context) async {
  //   final DateTime? pickedDate1 = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (pickedDate1 != null) {
  //     setState(() {
  //       _dateController1.text = DateFormat('yyyy-MM-dd').format(pickedDate1);
  //     });
  //   }
  // }
  //
  // Future<void> _selectDate2(BuildContext context) async {
  //   final DateTime? pickedDate2 = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (pickedDate2 != null) {
  //     setState(() {
  //       _dateController2.text = DateFormat('yyyy-MM-dd').format(pickedDate2);
  //     });
  //   }
  // }
  void filterByDate() async {
    if (_dateController1.text.isEmpty || _dateController2.text.isEmpty) return;

    DateTime startDate = DateTime.parse(_dateController1.text);
    DateTime endDate = DateTime.parse(_dateController2.text);

    var fullData = await alldata;

    setState(() {
      filteredList = fullData!.where((inquiry) {
        DateTime inquiryDate = DateTime.parse(inquiry['inquiry_datetime']);
        return inquiryDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            inquiryDate.isBefore(endDate.add(Duration(days: 1)));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    initFCM();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Inquiry',
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

      ),

      body:

      Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _dateController1,
                      readOnly: true,
                      onTap: () => _selectDate1(context),
                      decoration: InputDecoration(
                        labelText: "Start Date",
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      ),
                    ),
                  ),
                ),


                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _dateController2,
                        onTap: () => _selectDate2(context),
                        decoration: InputDecoration(
                          label: Text("End date"),
                          suffixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Flexible(
                    child: SizedBox(
                      width: 175,
                        height: 55,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0XFFF15A29),
                              foregroundColor: Colors.white, // Text ka color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),onPressed: filterByDate, child: Text("Search")))
                  ),
              ]
              ),
            ),),

          Expanded(
            child: alldata == null
                ? Center(child: CircularProgressIndicator())
                : filteredList.isEmpty
                ? Center(child: Text("No inquiry found."))
                : ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final inquiry = filteredList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Inquiry ID: ${inquiry['inquiry_id']}"),
                          Text("Product ID: ${inquiry['product_id']}"),
                          Text("Quantity: ${inquiry['quantity']}"),
                          Text("User Name: ${inquiry['buyer_name']}"),
                          Text("Message: ${inquiry['message']}"),
                          Text("Inquiry Date & Time: ${inquiry['inquiry_datetime']}"),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),


         // Text(tokendata)

          // Expanded(
          //   child: FutureBuilder(
          //     future: alldata,
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return Center(child: CircularProgressIndicator());
          //       } else if (snapshot.hasError) {
          //         return Center(child: Text("Error: ${snapshot.error}"));
          //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //         return Center(child: Text("No inquiry found."));
          //       } else {
          //         final inquiryList = snapshot.data!;
          //         return ListView.builder(
          //           itemCount: inquiryList.length,
          //           itemBuilder: (context, index) {
          //             final inquiry = inquiryList[index];
          //             return Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Card(
          //                 margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          //                 child: Padding(
          //                   padding: const EdgeInsets.all(10.0),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //
          //                       Text("Inquiry ID: ${inquiry['inquiry_id']}", style: TextStyle(fontWeight: FontWeight.bold)),
          //                       Text("Product ID: ${inquiry['product_id']}"),
          //                       Text("Quantity: ${inquiry['quantity']}"),
          //                       Text("User Name: ${inquiry['buyer_name']}"),
          //                       Text("Message: ${inquiry['message']}"),
          //                       Text("Inquiry Date & Time: ${inquiry['inquiry_datetime']}"),
          //
          //                       SizedBox(height: 8),
          //                       Center(
          //                         child: ElevatedButton(
          //                             style: ElevatedButton.styleFrom(
          //                               backgroundColor: Color(0XFFF15A29),
          //                               foregroundColor: Colors.white, // Text ka color
          //                               shape: RoundedRectangleBorder(
          //                                 borderRadius: BorderRadius.circular(8),
          //                               ),
          //                             ),onPressed: () {
          //                           // deleteinquiry(inquiry['inquiry_id'].toString());
          //
          //                         },
          //                             child: Text("Delete",)
          //                         ),
          //                       ),
          //
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             );
          //           },
          //         );
          //       }
          //     },
          //   ),
          // ),
        ],
      )
      ,
    );
    
  }


}

