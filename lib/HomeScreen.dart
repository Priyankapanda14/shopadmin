import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopadmin/CatagoryScreen.dart';
import 'package:shopadmin/Inquiry.dart';
import 'package:shopadmin/NotificationPage.dart';
import 'package:shopadmin/ProductScreen.dart';
import 'package:shopadmin/StockOutProducts.dart';
import 'package:shopadmin/User.dart';
import 'package:shopadmin/ViewStock.dart';
//import 'package:circular_menu/circular_menu.dart';

import 'LoginPage.dart';
import 'constants/UrlHelper.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
   HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();

  }

class _HomeScreenState extends State<HomeScreen> {

  //>>>category
  Future<List>? allcategorydata;
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

  var categorycount = "0";
  void fetchCategories() async {
    List categoryList = await getcategory();
    print("Total categories: ${categoryList.length}");
    setState(() {
      categorycount = categoryList.length.toString();
      allcategorydata = Future.value(categoryList);
      print("categorycount = $categorycount");
    });
  }
  //>>>product
  Future<List>? allproductdata;
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
  var productcount = "0";
  void fetchProduct() async {
    List productList = await getproduct();
    print("Total products: ${productList.length}");
    setState(() {
      productcount = productList.length.toString();

      print("productcount = $productcount");
    });
  }
  //>>>inquiry
  Future<List>? allinquirydata;
  Future<List> getinquiry() async
  {
    Uri url = Uri.parse(UrlHelper.INQUIRY_VIEW);
    var response = await http.get(url);
    if (response.statusCode == 200)
    {
      var json = response.body.toString();
      return jsonDecode(json);
    }
    return [];
  }
  var inquirycount = "0";
  void fetchinquiry() async {
    List inquiryList = await getinquiry();
    print("Total inquiries: ${inquiryList.length}");
    setState(() {
      inquirycount = inquiryList.length.toString();

      print("inquirycount = $inquirycount");
    });
  }
  //>>>stockoutproducts

  Future<List>? allstockoutdata;
  Future<List> getstockoutproduct() async
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
  var stockoutcount = "0";
  void fetstockout() async {
    List stockoutList = await getstockoutproduct();
    print("Total stockoutproducts: ${stockoutList.length}");
    setState(() {
      stockoutcount = stockoutList.length.toString();

      print("stockoutcount = $stockoutcount");
    });
  }
  //>>>user
  Future<List>? alluserdata;

  Future<List> getuser() async {
    Uri url = Uri.parse(UrlHelper.USER_VIEW);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
  var usercount = "0";
  void fetchuser() async {
    List userList = await getuser();
    print("Total usercount: ${userList.length}");
    setState(() {
      usercount = userList.length.toString();

      print("usercount = $usercount");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategories();
    fetchProduct();
    fetchinquiry();
    fetstockout();
    fetchuser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Center(child: Text("Homepage"),),
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
                icon: Icon(Icons.notification_add, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>NotificationPage()));
                },
              ),
            ),
          ),
        ],


      ),

      drawer: Drawer(
          child: Container(
            color: Color(0xFF2B2B2B),
            child: ListView(
                children: [
                  // Header
                  Container(
                    color: Colors.deepOrange,
                    padding: EdgeInsets.symmetric( vertical: 18),
                    child: ListTile(
                      trailing: Icon(Icons.login,size: 43,),
                    ),
                    ),
                  SizedBox(height: 29.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 29.0),
                  child: ListTile(
                    title: Text("Catagory",style: TextStyle(color: Colors.white,fontFamily: "Poppins_semibold",fontSize: 18.0),),
                    leading: Icon(Icons.dashboard_customize_rounded,color: Colors.white,size: 20),
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>CatagoryScreen())
                      );
                    },
                  ),
                ),
                SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.only(left: 29.0),
                  child: ListTile(
                    title: Text("Products",style: TextStyle(color: Colors.white,fontFamily: "Poppins_semibold",fontSize: 18.0),),
                    leading: Icon(Icons.local_parking_rounded,color: Colors.white,size: 20),
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>ProductScreen())
                      );
                    },
                  ),
                ),
                SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.only(left: 29.0),
                  child: ListTile(
                    title: Text("Stocks",style: TextStyle(color: Colors.white,fontFamily: "Poppins_semibold",fontSize: 18.0),),
                    leading: Icon(Icons.dashboard_outlined,color: Colors.white,size: 20),
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>Viewstock())
                      );
                    },
                  ),
                ),
                SizedBox(height: 24,),

                Padding(
                  padding: const EdgeInsets.only(left: 29.0),
                  child: ListTile(
                    title: Text("Stock Out Products",style: TextStyle(color: Colors.white,fontFamily: "Poppins_semibold",fontSize: 18.0),),
                    leading: Icon(Icons.outbox_sharp,color: Colors.white,size: 20),
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>StockOutProducts())
                      );
                    },
                  ),
                ),

                SizedBox(height: 24,),
                  Padding(
                    padding: const EdgeInsets.only(left: 29.0),
                    child: ListTile(
                      title: Text("Today Order",style: TextStyle(color: Colors.white,fontFamily: "Poppins_semibold",fontSize: 18.0),),
                      leading: Icon(Icons.notifications,color: Colors.white,size: 20),
                      onTap: (){},
                    ),
                  ),

                  SizedBox(height: 24,),
                  Padding(
                    padding: const EdgeInsets.only(left: 29.0),
                    child: ListTile(
                      title: Text("Inquiry",style: TextStyle(color: Colors.white,fontFamily: "Poppins_semibold",fontSize: 18.0),),
                      leading: Icon(Icons.live_help_outlined,color: Colors.white,size: 20),
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>Inquiry())
                        );
                      }
                         ),
                  ),
                  SizedBox(height: 24,),
                  Padding(
                    padding: const EdgeInsets.only(left: 29.0),
                    child: ListTile(
                      title: Text("User",style: TextStyle(color: Colors.white,fontFamily: "Poppins_semibold",fontSize: 18.0),),
                      leading: Icon(Icons.supervised_user_circle,color: Colors.white,size: 20),
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>User())
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 24,),
                  Padding(
                    padding: const EdgeInsets.only(left: 29.0),
                    child: ListTile(
                      title: Text("Report",style: TextStyle(color: Colors.white,fontFamily: "Poppins_semibold",fontSize: 18.0),),
                      leading: Icon(Icons.report_gmailerrorred_sharp,color: Colors.white,size: 20),
                      onTap: (){},
                    ),
                  ),

                  SizedBox(height: 24,),
                 Padding(
                  padding: const EdgeInsets.only(left: 29.0),
                  child: ListTile(
                    title: Text("Logout",style: TextStyle(color: Colors.white,fontFamily: "Poppins_semibold",fontSize: 18.0),),
                    leading: Icon(Icons.logout,color: Colors.white,size: 20),
                    onTap: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>LoginPage())
                      );

                    },
                  ),
                ),

              ]
          ),
        )
      ),
      body:Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount: 2,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>CatagoryScreen())
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(categorycount,
                          style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontFamily: "Poppins_bold",
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 42),
                        Text("Category",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: "Roboto_bold",
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),

                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>ProductScreen())
                  );
                },
                child:
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(productcount,
                          style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontFamily: "Poppins_bold",
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 42),
                        Text("Product",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Roboto_bold",
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),

                ),

              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>Inquiry())
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(inquirycount,
                          style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontFamily: "Poppins_bold",
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 42),
                        Text("Inquiry",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Roboto_bold",
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),

                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("5",
                        style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontFamily: "Poppins_bold",
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 42),
                      Text("Today order",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Roboto_bold",
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),

              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>StockOutProducts())
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(stockoutcount,
                          style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontFamily: "Poppins_bold",
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 42),
                        Text("Out Of Stock",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Roboto_bold",
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),

                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>User())
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(usercount,
                          style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontFamily: "Poppins_bold",
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 42),
                        Text("User",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: "Roboto_bold",
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),

                ),
              )




            ],
        ),
      )
    );

  }
}
