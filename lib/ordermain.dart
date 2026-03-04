import 'dart:convert';

import 'package:aicrm/addtocart.dart';
import 'package:aicrm/ordersub.dart';
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
      home: ordermain(title: 'View Users'),
    );
  }
}

class ordermain extends StatefulWidget {
  const ordermain({super.key, required this.title});
  final String title;

  @override
  State<ordermain> createState() => _ordermainState();
}

class _ordermainState extends State<ordermain> {
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
      String lid = sh.getString('lid').toString();
      String apiUrl = '$urls/user_viewordermain/';

      var response = await http.post(Uri.parse(apiUrl), body: {
        'lid':lid
      });
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<Map<String, dynamic>> tempList = [];
        for (var item in jsonData['data']) {
          tempList.add({
            'id': item['id'],
            'date': item['date'],
            'amount':item['amount'],
            'status': item['status'],
            'seller_name':  item['seller_name'],
            // 'seller_email':item['seller_email'],
            // 'seller_phone':item['seller_phone'],
          });
        }
        setState(() {
          users = tempList;
          filteredUsers = tempList
              .where((user) =>
              user['seller_name']
                  .toString()
                  .toLowerCase()
                  .contains(searchValue.toLowerCase()))
              .toList();
          nameSuggestions = users.map((e) => e['seller_name'].toString()).toSet().toList();
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
                  title: Text(user['seller_name'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("date: ${user['date']}"),
                      Text("amount: ${user['amount']}"),
                      Text("status: ${user['status']}"),
                      ElevatedButton(onPressed: () async {
                        SharedPreferences sh = await SharedPreferences.getInstance();
                        sh.setString('mid', user['id'].toString());
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ordersub(title: '')));
                      }, child: Text('ordersub')),

                      // ElevatedButton(onPressed: () async {
                      //   SharedPreferences sh = await SharedPreferences.getInstance();
                      //   sh.setString('pid', user['id'].toString());
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
