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
//       home: userreceivecoupons(title: 'View Users'),
//     );
//   }
// }
//
// class userreceivecoupons extends StatefulWidget {
//   const userreceivecoupons({super.key, required this.title});
//   final String title;
//
//   @override
//   State<userreceivecoupons> createState() => _userreceivecouponsState();
// }
//
// class _userreceivecouponsState extends State<userreceivecoupons> {
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
//       String lid = sh.getString('lid') ?? '';
//       String apiUrl = '$urls/user_receiveoffers/';
//
//       var response = await http.post(Uri.parse(apiUrl), body: {'lid':lid});
//       var jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         List<Map<String, dynamic>> tempList = [];
//         for (var item in jsonData['data']) {
//           tempList.add({
//             'id': item['id'].toString(),
//             'amount': item['amount'].toString(),
//             'couponcode': item['couponcode'].toString(),
//             'validateupto': item['validateupto'].toString(),
//             'seller_name': item['seller_name'].toString(),
//             'seller_email': item['seller_email'].toString(),
//             'seller_phone': item['seller_phone'].toString(),
//             'status':  item['status'].toString(),
//           });
//         }
//         setState(() {
//           users = tempList;
//           filteredUsers = tempList
//               .where((user) =>
//               user['date']
//                   .toString()
//                   .toLowerCase()
//                   .contains(searchValue.toLowerCase()))
//               .toList();
//           nameSuggestions = users.map((e) => e['date'].toString()).toSet().toList();
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
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("id: ${user['id']}"),
//                       Text("amount: ${user['amount']}"),
//                       Text("couponcode: ${user['couponcode']}"),
//                       Text("validateupto: ${user['validateupto']}"),
//                       Text("seller_name: ${user['seller_name']}"),
//                       Text("seller_email: ${user['seller_email']}"),
//                       Text("seller_phone: ${user['seller_phone']}"),
//                       Text("status: ${user['status']}"),
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
import 'package:aicrm/viewproduct.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart'; // BankingDashboard

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ReceiveOffersPage(),
  ));
}

class ReceiveOffersPage extends StatefulWidget {
  const ReceiveOffersPage({super.key});

  @override
  State<ReceiveOffersPage> createState() => _ReceiveOffersPageState();
}

class _ReceiveOffersPageState extends State<ReceiveOffersPage> {
  List<Map<String, dynamic>> coupons = [];
  List<Map<String, dynamic>> filteredCoupons = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCoupons();
    _searchController.addListener(_filterCoupons);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCoupons() async {
    setState(() => isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url')?.trim() ?? '';
      final lid = sh.getString('lid')?.trim() ?? '';

      if (baseUrl.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: "Session error. Please login again.");
        return;
      }

      final uri = Uri.parse('$baseUrl/user_receiveoffers/');

      final response = await http.post(uri, body: {'lid': lid});

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'ok') {
          final List<Map<String, dynamic>> temp = [];

          for (var item in jsonData['data']) {
            temp.add({
              'id': item['id']?.toString() ?? '—',
              'amount': item['amount']?.toString() ?? '0',
              'couponcode': item['couponcode']?.toString() ?? '—',
              'validateupto': item['validateupto']?.toString() ?? '—',
              'seller_name': item['seller_name']?.toString() ?? '—',
              'seller_email': item['seller_email']?.toString() ?? '—',
              'seller_phone': item['seller_phone']?.toString() ?? '—',
              'status': item['status']?.toString() ?? 'Active',
            });
          }

          setState(() {
            coupons = temp;
            filteredCoupons = temp;
          });
        } else {
          Fluttertoast.showToast(msg: jsonData['message'] ?? 'No offers found');
        }
      } else {
        Fluttertoast.showToast(msg: "Server error (${response.statusCode})");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading offers");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _filterCoupons() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredCoupons = List.from(coupons);
      } else {
        filteredCoupons = coupons.where((c) {
          final code = c['couponcode']?.toString().toLowerCase() ?? '';
          final seller = c['seller_name']?.toString().toLowerCase() ?? '';
          return code.contains(query) || seller.contains(query);
        }).toList();
      }
    });
  }

  Color _getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s == 'active') {
      return Colors.green.shade700;
    } else if (s == 'expired') {
      return Colors.red.shade700;
    } else if (s == 'used') {
      return Colors.grey.shade700;
    } else {
      return Colors.orange.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("My Offers & Coupons"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color(0xFFF9FAFB),
        elevation: 0.6,
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
                hintText: "Search by code or seller...",
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

          // Coupons List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredCoupons.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: _loadCoupons,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredCoupons.length,
                itemBuilder: (context, index) {
                  final coupon = filteredCoupons[index];
                  return _buildCouponCard(coupon);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(Map<String, dynamic> coupon) {
    final status = coupon['status'].toString().toLowerCase();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      color: const Color(0xFFFAFAFA),
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
                  "Coupon: ${coupon['couponcode']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    coupon['status'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "${coupon['amount']} % OFF",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Valid until: ${coupon['validateupto']}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              "From: ${coupon['seller_name']}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Contact: ${coupon['seller_phone']}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              "${coupon['seller_email']}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Color _getStatusColor(String status) {
  //   final s = status.toLowerCase();
  //   if (s == 'active') {
  //     return Colors.green.shade700;
  //   } else if (s == 'expired') {
  //     return Colors.red.shade700;
  //   } else if (s == 'used') {
  //     return Colors.grey.shade700;
  //   } else {
  //     return Colors.orange.shade700;
  //   }
  // }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 90,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          const Text(
            "No Offers Available",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Check back later for exciting deals!",
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
