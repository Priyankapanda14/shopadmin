import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants/UrlHelper.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  Future<List>? alldata;

  Future<List> getuser() async {
    Uri url = Uri.parse(UrlHelper.USER_VIEW);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
  Future<void> deleteuser(String userid) async {
    Uri url = Uri.parse(UrlHelper.DELETE_USER);
    var request = http.MultipartRequest('POST', url);
    request.fields['user_id'] = userid;

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
          alldata = getuser();
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
    alldata = getuser();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'All Users',
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
            return Center(child: Text("No user found."));
          } else {
            final userList = snapshot.data!;
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
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

                            Text("Userid : ${user['user_id']}", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Name : ${user['name']}"),
                            Text("Email : ${user['email']}"),
                            Text("Mobile number : ${user['mobile']}"),
                            Row(
                              children: [
                                Text("Password : ${user['password']}"),
                                SizedBox(width: 200,),
                                ElevatedButton(onPressed: () {
                                  deleteuser(user['user_id'].toString());

                                },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,foregroundColor: Colors.white),
                                    child: Text("Delete",)
                                ),
                              ],
                            ),

                            SizedBox(height: 8),

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
