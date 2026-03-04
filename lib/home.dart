// import 'package:aicrm/chatbot.dart';
// import 'package:aicrm/receiveoffers.dart';
// import 'package:aicrm/sendcomplaint.dart';
// import 'package:aicrm/viewcart.dart';
// import 'package:aicrm/viewcomplaint.dart';
// import 'package:aicrm/viewpaymenthistory.dart';
// import 'package:aicrm/viewproduct.dart';
// import 'package:aicrm/viewprofile.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: BankingDashboard(),
//   ));
// }
//
// class BankingDashboard extends StatefulWidget {
//   const BankingDashboard({super.key});
//
//   @override
//   State<BankingDashboard> createState() => _BankingDashboardState();
// }
//
// class _BankingDashboardState extends State<BankingDashboard> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // drawer: const Drawer(
//       //   child: DrawerContent(),
//       // ),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black87),
//         // actions: const [
//         //   Icon(Icons.notifications_none),
//         //   SizedBox(width: 16),
//         // ],
//       ),
//       backgroundColor: const Color(0xFFF5F6FA),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: AssetImage('assets/user.jpg'),
//                   radius: 25,
//                 ),
//                 SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Hi Admin,',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       'What do you want to do today?',
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(''),
//                       SizedBox(height: 6),
//                       Text(
//                         '',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(''),
//                       SizedBox(height: 6),
//                       Text(
//                         '',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 25),
//             const Text(
//               'Quick Actions',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 15),
//             Expanded(
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 15,
//                 mainAxisSpacing: 15,
//                 children: [
//                   ActionCard(
//                     title: 'Profile',
//                     color: Colors.pinkAccent,
//                     icon: Icons.verified_user,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ViewProfilePage(title: '')),
//                       );
//                     },
//                   ),
//                   ActionCard(
//                     title: 'Products',
//                     color: Colors.pinkAccent,
//                     icon: Icons.verified_user,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => viewproduct()),
//                       );
//                     },
//                   ),
//                   ActionCard(
//                     title: 'Cart',
//                     color: Colors.pinkAccent,
//                     icon: Icons.verified_user,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => viewcart()),
//                       );
//                     },
//                   ),
//
//                   ActionCard(
//                     title: 'Payment History',
//                     color: Colors.pinkAccent,
//                     icon: Icons.verified_user,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => PaymentHistoryPage()),
//                       );
//                     },
//                   ),
//
//                   ActionCard(
//                     title: 'chatbot',
//                     color: Colors.pinkAccent,
//                     icon: Icons.verified_user,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ChatScreen()),
//                       );
//                     },
//                   ),
//
//
//                   ActionCard(
//                     title: 'send complaint',
//                     color: Colors.pinkAccent,
//                     icon: Icons.verified_user,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => SendComplaintPage()),
//                       );
//                     },
//                   ),
//
//
//
//                   ActionCard(
//                     title: 'view complaint',
//                     color: Colors.pinkAccent,
//                     icon: Icons.verified_user,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ViewComplaintsPage()),
//                       );
//                     },
//                   ),
//                   ActionCard(
//                     title: 'view coupons',
//                     color: Colors.pinkAccent,
//                     icon: Icons.verified_user,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ReceiveOffersPage()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ActionCard extends StatelessWidget {
//   final String title;
//   final Color color;
//   final IconData icon;
//   final VoidCallback? onTap; // ADD this
//
//   const ActionCard({
//     super.key,
//     required this.title,
//     required this.color,
//     required this.icon,
//     this.onTap, // ADD this
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap, // USE this
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               backgroundColor: color,
//               child: Icon(icon, color: Colors.white),
//             ),
//             const SizedBox(height: 10),
//             Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // class DrawerContent extends StatefulWidget {
// //   const DrawerContent({super.key});
// //
// //   @override
// //   State<DrawerContent> createState() => _DrawerContentState();
// // }
//
// // class _DrawerContentState extends State<DrawerContent> {
// //   void showDrawerMessage(String message) {
// //     Navigator.pop(context); // Close drawer
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(message)),
// //     );
// //   }
// //
// //   // @override
// //   // Widget build(BuildContext context) {
// //   //   return ListView(
// //   //     padding: EdgeInsets.zero,
// //   //     children: [
// //   //       const DrawerHeader(
// //   //         decoration: BoxDecoration(color: Colors.blue),
// //   //         child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
// //   //       ),
// //   //       ListTile(
// //   //         leading: const Icon(Icons.dashboard),
// //   //         title: const Text('Dashboard'),
// //   //         onTap: () => showDrawerMessage('Dashboard selected'),
// //   //       ),
// //   //       ListTile(
// //   //         leading: const Icon(Icons.receipt),
// //   //         title: const Text('Add User'),
// //   //         onTap: () => showDrawerMessage('Bills selected'),
// //   //       ),
// //   //       ListTile(
// //   //         leading: const Icon(Icons.send),
// //   //         title: const Text('Transfers'),
// //   //         onTap: () => showDrawerMessage('Transfers selected'),
// //   //       ),
// //   //       ListTile(
// //   //         leading: const Icon(Icons.settings),
// //   //         title: const Text('Settings'),
// //   //         onTap: () => showDrawerMessage('Settings selected'),
// //   //       ),
// //   //     ],
// //   //   );
// //   // }
// // }


import 'dart:convert';
import 'package:aicrm/appchatbot.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'ordermain.dart';
import 'viewprofile.dart';
import 'viewproduct.dart';
import 'viewcart.dart';
import 'viewpaymenthistory.dart';
import 'chatbot.dart';
import 'sendcomplaint.dart';
import 'viewcomplaint.dart';
import 'receiveoffers.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BankingDashboard(),
  ));
}

class BankingDashboard extends StatefulWidget {
  const BankingDashboard({super.key});

  @override
  State<BankingDashboard> createState() => _BankingDashboardState();
}

class _BankingDashboardState extends State<BankingDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  String userName = "User";

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();

    _loadUserName();
    _fetchProfile();
  }

  String name='';
  String photoUrl='';
  String points='';


  Future<void> _fetchProfile() async {
    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final imgBase = sh.getString('img_url') ?? '';
      final lid = sh.getString('lid') ?? '';

      if (baseUrl.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: "Session error. Please login again.");
        return;
      }

      final uri = Uri.parse('$baseUrl/viewprofilehomepage/');

      final response = await http.post(uri, body: {'lid': lid});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          setState(() {
            name = data['name'].toString();
            points = data['points'].toString();
            photoUrl = imgBase + (data['photo'] ?? '');

          });
        } else {
          Fluttertoast.showToast(msg: 'Profile not found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> _loadUserName() async {
    final sh = await SharedPreferences.getInstance();
    setState(() {
      userName = sh.getString('name') ?? "User";
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      // appBar: AppBar(
      //   backgroundColor: Colors.deepPurple,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: const Text(
      //     "Dashboard",
      //     style: TextStyle(
      //       color: Color(0xFFF8F9FC),
      //       fontWeight: FontWeight.w600,
      //       fontSize: 20,
      //     ),
      //   ),
      //   actions: [
      //     Stack(
      //       children: [
      //         if (true) // Replace with actual unread count logic
      //           Positioned(
      //             right: 8,
      //             top: 8,
      //             child: Container(
      //               padding: const EdgeInsets.all(4),
      //               decoration: const BoxDecoration(
      //                 color: Colors.redAccent,
      //                 shape: BoxShape.circle,
      //               ),
      //               child: const Text(
      //                 '3',
      //                 style: TextStyle(color: Colors.white, fontSize: 10),
      //               ),
      //             ),
      //           ),
      //       ],
      //     ),
      //     const SizedBox(width: 8),
      //   ],
      // ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(photoUrl),
                    ),

                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi $name,",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Your Loyalty Points $points",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Quick Actions Grid
                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 20),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.05,
                  children: [
                    _buildActionCard(
                      title: "Profile",
                      icon: Icons.person_outline_rounded,
                      color: const Color(0xFF7C3AED),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ViewProfilePage(title: "",)),
                      ),
                    ),
                    _buildActionCard(
                      title: "Products",
                      icon: Icons.inventory_2_outlined,
                      color: const Color(0xFF4CAF50),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const viewproduct()),
                      ),
                    ),
                    _buildActionCard(
                      title: "Cart",
                      icon: Icons.shopping_cart_outlined,
                      color: const Color(0xFFFF9800),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const viewcart()),
                      ),
                    ),
                    _buildActionCard(
                      title: "Payments",
                      icon: Icons.receipt_long_outlined,
                      color: const Color(0xFF2196F3),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PaymentHistoryPage()),
                      ),
                    ),
                    _buildActionCard(
                      title: "Chatbot",
                      icon: Icons.chat_bubble_outline_rounded,
                      color: const Color(0xFF9C27B0),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChatScreen()),
                      ),
                    ),
                    _buildActionCard(
                      title: "Send Complaint",
                      icon: Icons.report_problem_outlined,
                      color: const Color(0xFFE91E63),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SendComplaintPage()),
                      ),
                    ),
                    _buildActionCard(
                      title: "My Complaints",
                      icon: Icons.list_alt_outlined,
                      color: const Color(0xFF00BCD4),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ViewComplaintsPage()),
                      ),
                    ),
                    _buildActionCard(
                      title: "Coupons",
                      icon: Icons.local_offer_outlined,
                      color: const Color(0xFFFFC107),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ReceiveOffersPage()),
                      ),
                    ), _buildActionCard(
                      title: "Orders",
                      icon: Icons.local_offer_outlined,
                      color: const Color(0xFFFFC107),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ordermain(title: '',)),
                      ),
                    ),
                    _buildActionCard(
                      title: "App Chat bot",
                      icon: Icons.exit_to_app,
                      color: const Color(0xFFEDA2EF),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Appchatbot(title: "",)),
                      ),
                    ),_buildActionCard(
                      title: "LogOut",
                      icon: Icons.exit_to_app,
                      color: const Color(0xFFEDA2EF),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyLoginPage(title: "",)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}