// import 'dart:convert';
//
// import 'package:aicrm/addtocart.dart';
// import 'package:aicrm/viewseller.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'home.dart';
//
// void main() {
//   runApp(const ViewHouseApp());
// }
//
// class ViewHouseApp extends StatelessWidget {
//   const ViewHouseApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: viewpaymenthistory(title: 'View Users'),
//     );
//   }
// }
//
// class viewpaymenthistory extends StatefulWidget {
//   const viewpaymenthistory({super.key, required this.title});
//   final String title;
//
//   @override
//   State<viewpaymenthistory> createState() => _viewpaymenthistoryState();
// }
//
// class _viewpaymenthistoryState extends State<viewpaymenthistory> {
//   List<Map<String, dynamic>> users = [];
//   List<Map<String, dynamic>> filteredUsers = [];
//   List<String> nameSuggestions = [];
//
//   @override
//   void initState() {
//     super.initState();
//     viewUsers("");
//   }
//
//   Future<void> viewUsers(String searchValue) async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url') ?? '';
//       String img = sh.getString('img_url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//       String apiUrl = '$urls/user_vieworderhistory/';
//
//       var response = await http.post(Uri.parse(apiUrl), body: {'lid':lid});
//       var jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         List<Map<String, dynamic>> tempList = [];
//         for (var item in jsonData['data']) {
//           tempList.add({
//             'id': item['id'],
//             'date': item['date'],
//             'status':item['status'],
//             'amount': item['amount'],
//           });
//         }
//         setState(() {
//           users = tempList;
//           filteredUsers = tempList
//               .where((user) =>
//               user['id']
//                   .toString()
//                   .toLowerCase()
//                   .contains(searchValue.toLowerCase()))
//               .toList();
//           nameSuggestions = users.map((e) => e['id'].toString()).toSet().toList();
//         });
//       }
//     } catch (e) {
//       print("Error fetching users: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const BankingDashboard()),
//           );
//           return false; // Prevent default pop
//         },
//         child:Scaffold(
//           // appBar: EasySearchBar(
//           //   backgroundColor: Color.fromARGB(255, 232, 177, 61),
//           //   title: Text('Search by name'),
//           //   suggestions: nameSuggestions,
//           //   onSearch: (value) {
//           //     setState(() {
//           //       filteredUsers = users
//           //           .where((user) => user['name']
//           //           .toString()
//           //           .toLowerCase()
//           //           .contains(value.toLowerCase()))
//           //           .toList();
//           //     });
//           //   },
//           // ),
//           body: ListView.builder(
//             shrinkWrap: true,
//             physics: BouncingScrollPhysics(),
//             itemCount: filteredUsers.length,
//             itemBuilder: (context, index) {
//               final user = filteredUsers[index];
//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 elevation: 5,
//                 child: ListTile(
//                   // leading: CircleAvatar(
//                   //   backgroundImage: NetworkImage(user['photo']),
//                   //   radius: 30,
//                   // ),
//                   title: Text(user['status'], style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("id: ${user['id']}"),
//                       Text("date: ${user['date']}"),
//                       Text("status: ${user['status']}"),
//                       Text("amount: ${user['amount']}"),
//                       // ElevatedButton(onPressed: () async {
//                       //   SharedPreferences sh = await SharedPreferences.getInstance();
//                       //   sh.setString('pid', user['id'].toString());
//                       //   Navigator.push(context, MaterialPageRoute(builder: (context)=>viewseller(title: '')));
//                       // }, child: Text('viewseller')),
//                       //
//                       // ElevatedButton(onPressed: () async {
//                       //   SharedPreferences sh = await SharedPreferences.getInstance();
//                       //   sh.setString('pid', user['id'].toString());
//                       //   Navigator.push(context, MaterialPageRoute(builder: (context)=>addtocart(title: '')));
//                       // }, child: Text('cart'))
//
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ));
//   }
// }


import 'dart:convert';
import 'package:aicrm/sendreview.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';      // BankingDashboard
import 'viewproduct.dart'; // browse products fallback

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PaymentHistoryPage(),
  ));
}

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> filteredOrders = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrderHistory();
    _searchController.addListener(_filterOrders);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOrderHistory() async {
    setState(() => isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url')?.trim() ?? '';
      final lid = sh.getString('lid')?.trim() ?? '';

      if (baseUrl.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: "Session error. Please login again.");
        return;
      }

      final uri = Uri.parse('$baseUrl/user_viewpaymenthistory_post/');

      final response = await http.post(uri, body: {'lid': lid});

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'ok') {
          final List<Map<String, dynamic>> temp = [];

          for (var item in jsonData['data']) {
            temp.add({
              'id': item['id']?.toString() ?? '—',        // Force string
              'date': item['date'] ?? '—',
              'amount': item['amount']?.toString() ?? '0',
            });
          }

          setState(() {
            orders = temp;
            filteredOrders = temp;
          });
        } else {
          Fluttertoast.showToast(msg: jsonData['message'] ?? 'No order history found');
        }
      } else {
        Fluttertoast.showToast(msg: "Server error (${response.statusCode})");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading history: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _filterOrders() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredOrders = List.from(orders);
      } else {
        filteredOrders = orders.where((order) {
          // Safely convert ID to string and search
          final orderId = order['id']?.toString().toLowerCase() ?? '';
          return orderId.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("Order History"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color(0xFFFFFFFF),
        elevation: 0.4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BankingDashboard()),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by Order ID...",
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF7C3AED)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
                ),
              ),
            ),
          ),

          // Order List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredOrders.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: _loadOrderHistory,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return _buildOrderCard(order);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.2,
      color: const Color(0xFFFAFAFA), // light background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${order['id']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  "₹ ${order['amount']}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Date: ${order['date']}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
            ElevatedButton(onPressed: () async {
              SharedPreferences sh =await  SharedPreferences.getInstance();

              // sh.setString(('id'), )
              // sh.setString(key,user.toString()
              Navigator.push(context, MaterialPageRoute(builder: (context)=>sendreview(title: '',)));
            }, child: Text('sendreview'))
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 90,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          const Text(
            "No Orders Found",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Your order history will appear here",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text("Browse Products"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(
                color: Color(0xFFD1D5DB),
                width: 1.5,
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const viewproduct()),
              );
            },
          ),
        ],
      ),
    );
  }
}