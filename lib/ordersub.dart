import 'dart:convert';

import 'package:aicrm/addtocart.dart';
import 'package:aicrm/sendreview.dart';
import 'package:aicrm/viewseller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

void main() {
  runApp(const ViewHouseApp());
}

class ViewHouseApp extends StatelessWidget {
  const ViewHouseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ordersub(title: 'View Users'),
    );
  }
}

class ordersub extends StatefulWidget {
  const ordersub({super.key, required this.title});
  final String title;

  @override
  State<ordersub> createState() => _ordersubState();
}

class _ordersubState extends State<ordersub> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  List<String> nameSuggestions = [];

  @override
  void initState() {
    super.initState();
    viewUsers("");
  }

  Future<void> viewUsers(String searchValue) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String img = sh.getString('img_url') ?? '';
      String mid = sh.getString('mid').toString();
      String apiUrl = '$urls/user_viewordersub/';

      var response = await http.post(Uri.parse(apiUrl), body: {
        'mid':mid
      });
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<Map<String, dynamic>> tempList = [];
        for (var item in jsonData['data']) {
          tempList.add({
            'id': item['id'],
            'quantity': item['quantity'],
            'product_name':item['product_name'],
            'product_id':item['product_id'],
          });
        }
        setState(() {
          users = tempList;
          filteredUsers = tempList
              .where((user) =>
              user['product_name']
                  .toString()
                  .toLowerCase()
                  .contains(searchValue.toLowerCase()))
              .toList();
          nameSuggestions = users.map((e) => e['product_name'].toString()).toSet().toList();
        });
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BankingDashboard()),
          );
          return false; // Prevent default pop
        },
        child:Scaffold(
          // appBar: EasySearchBar(
          //   backgroundColor: Color.fromARGB(255, 232, 177, 61),
          //   title: Text('Search by name'),
          //   suggestions: nameSuggestions,
          //   onSearch: (value) {
          //     setState(() {
          //       filteredUsers = users
          //           .where((user) => user['name']
          //           .toString()
          //           .toLowerCase()
          //           .contains(value.toLowerCase()))
          //           .toList();
          //     });
          //   },
          // ),
          body: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: ListTile(
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(user['photo']),
                  //   radius: 30,
                  // ),
                  title: Text(user['product_name'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("quantity: ${user['quantity']}"),
                      Text("product_id: ${user['product_id']}"),
                      ElevatedButton(onPressed: () async {
                        SharedPreferences sh = await SharedPreferences.getInstance();
                        sh.setString('product_id', user['product_id'].toString());
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>sendreview(title: '')));
                      }, child: Text('sendreview')),

                      // ElevatedButton(onPressed: () async {
                      //   SharedPreferences sh = await SharedPreferences.getInstance();
                      //   sh.setString('pid', user['pid'].toString());
                      //   Navigator.push(context, MaterialPageRoute(builder: (context)=>addtocart()));
                      // }, child: Text('cart'))

                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
