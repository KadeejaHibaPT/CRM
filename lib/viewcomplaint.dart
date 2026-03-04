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
//       home: usersviewcomplaint(title: 'View Users'),
//     );
//   }
// }
//
// class usersviewcomplaint extends StatefulWidget {
//   const usersviewcomplaint({super.key, required this.title});
//   final String title;
//
//   @override
//   State<usersviewcomplaint> createState() => _usersviewcomplaintState();
// }
//
// class _usersviewcomplaintState extends State<usersviewcomplaint> {
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
//       String apiUrl = '$urls/user_viewcomplaint/';
//
//       var response = await http.post(Uri.parse(apiUrl), body: {'lid':lid});
//       var jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         List<Map<String, dynamic>> tempList = [];
//         for (var item in jsonData['data']) {
//           tempList.add({
//             'date': item['date'],
//             'complaint': item['complaint'],
//             'reply': item['reply'],
//             'status':  item['status'],
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
//                   title: Text(user['status'], style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("complaint: ${user['complaint']}"),
//                       Text("date: ${user['date']}"),
//                       Text("reply: ${user['reply']}"),
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
import 'package:aicrm/sendcomplaint.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart'; // BankingDashboard

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ViewComplaintsPage(),
  ));
}

class ViewComplaintsPage extends StatefulWidget {
  const ViewComplaintsPage({super.key});

  @override
  State<ViewComplaintsPage> createState() => _ViewComplaintsPageState();
}

class _ViewComplaintsPageState extends State<ViewComplaintsPage> {
  List<Map<String, dynamic>> complaints = [];
  List<Map<String, dynamic>> filteredComplaints = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadComplaints();
    _searchController.addListener(_filterComplaints);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadComplaints() async {
    setState(() => isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url')?.trim() ?? '';
      final lid = sh.getString('lid')?.trim() ?? '';

      if (baseUrl.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: "Session error. Please login again.");
        return;
      }

      final uri = Uri.parse('$baseUrl/user_viewcomplaint/');

      final response = await http.post(uri, body: {'lid': lid});

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'ok') {
          final List<Map<String, dynamic>> temp = [];

          for (var item in jsonData['data']) {
            temp.add({
              'date': item['date']?.toString() ?? '—',
              'complaint': item['complaint']?.toString() ?? '',
              'reply': item['reply']?.toString() ?? 'No reply yet',
              'status': item['status']?.toString() ?? 'Pending',
            });
          }

          setState(() {
            complaints = temp;
            filteredComplaints = temp;
          });
        } else {
          Fluttertoast.showToast(msg: jsonData['message'] ?? 'No complaints found');
        }
      } else {
        Fluttertoast.showToast(msg: "Server error (${response.statusCode})");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading complaints");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _filterComplaints() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredComplaints = List.from(complaints);
      } else {
        filteredComplaints = complaints.where((c) {
          final date = c['date']?.toString().toLowerCase() ?? '';
          final complaintText = c['complaint']?.toString().toLowerCase() ?? '';
          return date.contains(query) || complaintText.contains(query);
        }).toList();
      }
    });
  }

  Color _getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s == 'replied' || s == 'resolved' || s == 'closed') {
      return Colors.green.shade700;
    } else if (s == 'pending') {
      return Colors.orange.shade700;
    } else {
      return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("My Complaints"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color(0xFFFFFFFF),
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
                hintText: "Search by date or complaint...",
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

          // Complaints List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredComplaints.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: _loadComplaints,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredComplaints.length,
                itemBuilder: (context, index) {
                  final complaint = filteredComplaints[index];
                  return _buildComplaintCard(complaint);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(Map<String, dynamic> complaint) {
    final status = complaint['status'].toString().toLowerCase();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      color: const Color(0xFFFFFFFF), // light modern background
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
                  "Date: ${complaint['date']}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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
                    complaint['status'],
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
              complaint['complaint'],
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
            if (complaint['reply'] != null && complaint['reply'].toString().isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                "Reply from Admin:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                complaint['reply'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Color _getStatusColor(String status) {
  //   final s = status.toLowerCase();
  //   if (s == 'replied' || s == 'resolved' || s == 'closed') {
  //     return Colors.green.shade700;
  //   } else if (s == 'pending') {
  //     return Colors.orange.shade700;
  //   } else {
  //     return Colors.grey.shade700;
  //   }
  // }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.announcement_outlined,
            size: 90,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          const Text(
            "No Complaints Yet",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Your submitted complaints will appear here",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: const Text("Submit a Complaint"),
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
                MaterialPageRoute(builder: (_) => const SendComplaintPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}