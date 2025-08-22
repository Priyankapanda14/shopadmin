import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants/UrlHelper.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Future<List>? alldata;

  Future<List> getnotification() async {
    Uri url = Uri.parse(UrlHelper.NOTIFICATION_VIEW);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
  Future<void> deletenotification(String notid) async {
    Uri url = Uri.parse(UrlHelper.DELETE_NOTIFICATION);
    var request = http.MultipartRequest('POST', url);
    request.fields['notification_id'] = notid;

    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    print("Delete response: $respStr");

    if (response.statusCode == 200) {
      final json = jsonDecode(respStr);
      if (json['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Deleted successfully")),
        );
        setState(() {
          alldata = getnotification();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete")),
        );
      }
    } else {
      print("Upload failed: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    alldata = getnotification();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'All Notifications',
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
      FutureBuilder(
        future: alldata,
        builder: (context, snapshot) {



          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No Notification found."));
          } else {
            final notificationList = snapshot.data!;
            return ListView.builder(
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final notification = notificationList[index];


                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            Text(" ${notification['title']}"),
                            Text(" ${notification['msg']}"),
                            Text(" Date & Time: ${notification['date_and_time']}"),

                            Row(
                              children: [

                                ElevatedButton(onPressed: () {
                                  deletenotification(notification['notification_id'].toString());


                                },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,foregroundColor: Colors.white),
                                    child: Text("Delete",)
                                ),
                              ],
                            )



                          ],
                        ),
                      ),
                    ),


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
