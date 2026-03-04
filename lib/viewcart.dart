// // import 'dart:convert';
// // import 'package:aicrm/payment.dart';
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:http/http.dart' as http;
// //
// // import 'home.dart';
// //
// // void main() {
// //   runApp(const ViewHouseApp());
// // }
// //
// // class ViewHouseApp extends StatelessWidget {
// //   const ViewHouseApp({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: viewcart(title: 'My Cart'),
// //     );
// //   }
// // }
// //
// // class viewcart extends StatefulWidget {
// //   const viewcart({super.key, required this.title});
// //   final String title;
// //
// //   @override
// //   State<viewcart> createState() => _viewcartState();
// // }
// //
// // class _viewcartState extends State<viewcart> {
// //   List<Map<String, dynamic>> cartItems = [];
// //   int totalAmount = 0;
// //   String sellerId = "";
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     loadCart();
// //   }
// //
// //   Future<void> loadCart() async {
// //     try {
// //       SharedPreferences sh = await SharedPreferences.getInstance();
// //       String url = sh.getString('url') ?? '';
// //       String lid = sh.getString('lid') ?? '';
// //       String img = sh.getString('img_url') ?? '';
// //
// //       var response = await http.post(
// //         Uri.parse('$url/user_viewcart_post/'),
// //         body: {'lid': lid},
// //       );
// //
// //       var jsonData = jsonDecode(response.body);
// //
// //       if (jsonData['status'] == 'ok') {
// //         int sum = 0;
// //         List<Map<String, dynamic>> temp = [];
// //
// //         for (var i in jsonData['data']) {
// //           int price = int.parse(i['price'].toString());
// //           int qty = int.parse(i['quantity'].toString());
// //           int seller=int.parse(i['sellerid'].toString());
// //           sum += price * qty;
// //
// //           temp.add({
// //             'id': i['id'],
// //             'name': i['name'],
// //             'photo': img + i['photo'],
// //             'description': i['description'],
// //             'price': price,
// //             'quantity': qty,
// //             'seller_id': i['sellerid'], // backend must send this
// //           });
// //
// //           setState(() {
// //             // sellerId=i['seller_id'].toString();
// //           });
// //           //
// //           sellerId = seller.toString();// assume same seller
// //         }
// //
// //         setState(() {
// //           cartItems = temp;
// //           totalAmount = sum;
// //         });
// //       }
// //     } catch (e) {
// //       debugPrint("Cart error: $e");
// //     }
// //   }
// //
// //   Future<void> checkout() async {
// //     SharedPreferences sh = await SharedPreferences.getInstance();
// //     String url = sh.getString('url')!;
// //     String lid = sh.getString('lid')!;
// //
// //     var response = await http.post(
// //       Uri.parse('$url/user_place_order_post/'),
// //       body: {
// //         'lid': lid,
// //         'seller_id': sellerId,
// //         'amount': totalAmount.toString(),
// //       },
// //     );
// //
// //     var data = jsonDecode(response.body);
// //
// //     if (data['status'] == 'ok') {
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => PayAmount(
// //             title: "Pay Now",
// //             vid: data['order_id'].toString(),
// //             amount: totalAmount.toString(),
// //           ),
// //         ),
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: () async {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => const BankingDashboard()),
// //         );
// //         return false;
// //       },
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: Text(widget.title),
// //           backgroundColor: Colors.blue,
// //         ),
// //         body: Column(
// //           children: [
// //             Expanded(
// //               child: ListView.builder(
// //                 itemCount: cartItems.length,
// //                 itemBuilder: (context, index) {
// //                   final item = cartItems[index];
// //                   return Card(
// //                     margin: const EdgeInsets.all(10),
// //                     elevation: 4,
// //                     child: ListTile(
// //                       leading: CircleAvatar(
// //                         backgroundImage: NetworkImage(item['photo']),
// //                         radius: 30,
// //                       ),
// //                       title: Text(item['name'],
// //                           style: const TextStyle(fontWeight: FontWeight.bold)),
// //                       subtitle: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(item['description']),
// //                           Text("Price: ₹${item['price']}"),
// //                           Text("Qty: ${item['quantity']}"),
// //                           Text("sellerid: ${sellerId}"),
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //
// //             /// TOTAL + CHECKOUT
// //             Container(
// //               padding: const EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 boxShadow: [
// //                   BoxShadow(color: Colors.black12, blurRadius: 5)
// //                 ],
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.stretch,
// //                 children: [
// //                   Text(
// //                     "Total: ₹$totalAmount",
// //                     style: const TextStyle(
// //                         fontSize: 18, fontWeight: FontWeight.bold),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   ElevatedButton(
// //                     onPressed: totalAmount > 0 ? checkout : null,
// //                     style: ElevatedButton.styleFrom(
// //                         padding: const EdgeInsets.all(15)),
// //                     child: const Text("Checkout & Pay"),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'dart:convert';
// import 'package:aicrm/viewproduct.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'payment.dart'; // PayAmount
// import 'home.dart';   // BankingDashboard
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: viewcart(),
//   ));
// }
//
// class viewcart extends StatefulWidget {
//   const viewcart({super.key});
//
//   @override
//   State<viewcart> createState() => _viewcartState();
// }
//
// class _viewcartState extends State<viewcart> {
//   List<Map<String, dynamic>> cartItems = [];
//   int totalAmount = 0;
//   String sellerId = "";
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadCart();
//   }
//
//   Future<void> loadCart() async {
//     setState(() => isLoading = true);
//
//     try {
//       final sh = await SharedPreferences.getInstance();
//       final baseUrl = sh.getString('url') ?? '';
//       final lid = sh.getString('lid') ?? '';
//       final imgBase = sh.getString('img_url') ?? '';
//
//       if (baseUrl.isEmpty || lid.isEmpty) {
//         Fluttertoast.showToast(msg: "Session error");
//         return;
//       }
//
//       final uri = Uri.parse('$baseUrl/user_viewcart_post/');
//
//       final response = await http.post(uri, body: {'lid': lid});
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//
//         if (jsonData['status'] == 'ok') {
//           int sum = 0;
//           List<Map<String, dynamic>> temp = [];
//
//           for (var item in jsonData['data']) {
//             final price = int.tryParse(item['price'].toString()) ?? 0;
//             final qty = int.tryParse(item['quantity'].toString()) ?? 1;
//             sum += price * qty;
//
//             temp.add({
//               'id': item['id'].toString(),
//               'name': item['name'] ?? 'No name',
//               'photo': imgBase + (item['photo'] ?? ''),
//               'description': item['description'] ?? '',
//               'price': price,
//               'quantity': qty,
//               'seller_id': item['sellerid']?.toString() ?? '',
//             });
//
//             // Assuming all items have same seller (common in single-seller cart)
//             sellerId = item['sellerid']?.toString() ?? sellerId;
//           }
//
//           setState(() {
//             cartItems = temp;
//             totalAmount = sum;
//           });
//         }
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error loading cart");
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> checkout() async {
//     if (totalAmount <= 0 || sellerId.isEmpty) {
//       Fluttertoast.showToast(msg: "Cart is empty or invalid");
//       return;
//     }
//
//     try {
//       final sh = await SharedPreferences.getInstance();
//       final baseUrl = sh.getString('url') ?? '';
//       final lid = sh.getString('lid') ?? '';
//
//       final uri = Uri.parse('$baseUrl/user_place_order_post/');
//
//       final response = await http.post(uri, body: {
//         'lid': lid,
//         'seller_id': sellerId,
//         'amount': totalAmount.toString(),
//       });
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         if (data['status'] == 'ok') {
//           final orderId = data['order_id']?.toString() ?? '';
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PayAmount(
//                 title: "Pay Now",
//                 vid: orderId,
//                 amount: totalAmount.toString(),
//               ),
//             ),
//           );
//         } else {
//           Fluttertoast.showToast(msg: data['message'] ?? "Order failed");
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Server error");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Connection error");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       appBar: AppBar(
//         title: const Text("My Cart"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF111827),
//         elevation: 0.6,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_rounded),
//           onPressed: () => Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const BankingDashboard()),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Cart Items List
//           Expanded(
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : cartItems.isEmpty
//                 ? _buildEmptyCart()
//                 : RefreshIndicator(
//               onRefresh: loadCart,
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 itemCount: cartItems.length,
//                 itemBuilder: (context, index) {
//                   final item = cartItems[index];
//                   return _buildCartItemCard(item);
//                 },
//               ),
//             ),
//           ),
//
//           // Sticky Bottom Bar - Total + Checkout
//           Container(
//             padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 12,
//                   offset: const Offset(0, -4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Total Amount",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF111827),
//                       ),
//                     ),
//                     Text(
//                       "₹ $totalAmount",
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF7C3AED),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   height: 56,
//                   child: FilledButton.icon(
//                     icon: const Icon(Icons.payment_rounded),
//                     label: const Text(
//                       "Checkout & Pay",
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     style: FilledButton.styleFrom(
//                       backgroundColor: const Color(0xFF7C3AED),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     onPressed: totalAmount > 0 && !isLoading ? checkout : null,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget _buildCartItemCard(Map<String, dynamic> item) {
//   //   return Card(
//   //     margin: const EdgeInsets.only(bottom: 16),
//   //     elevation: 1.5,
//   //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//   //     child: Padding(
//   //       padding: const EdgeInsets.all(12),
//   //       child: Row(
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           // Product Image
//   //           ClipRRect(
//   //             borderRadius: BorderRadius.circular(12),
//   //             child: SizedBox(
//   //               width: 100,
//   //               height: 100,
//   //               child: Image.network(
//   //                 item['photo'],
//   //                 fit: BoxFit.cover,
//   //                 errorBuilder: (context, error, stackTrace) {
//   //                   return Container(
//   //                     color: Colors.grey.shade200,
//   //                     child: const Icon(Icons.image_not_supported),
//   //                   );
//   //                 },
//   //               ),
//   //             ),
//   //           ),
//   //
//   //           const SizedBox(width: 16),
//   //
//   //           // Details
//   //           Expanded(
//   //             child: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 Text(
//   //                   item['name'],
//   //                   style: const TextStyle(
//   //                     fontSize: 17,
//   //                     fontWeight: FontWeight.w600,
//   //                     color: Color(0xFF111827),
//   //                   ),
//   //                   maxLines: 2,
//   //                   overflow: TextOverflow.ellipsis,
//   //                 ),
//   //                 const SizedBox(height: 6),
//   //                 Text(
//   //                   "₹ ${item['price']}",
//   //                   style: const TextStyle(
//   //                     fontSize: 18,
//   //                     fontWeight: FontWeight.bold,
//   //                     color: Color(0xFF7C3AED),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 4),
//   //                 Text(
//   //                   "Qty: ${item['quantity']}",
//   //                   style: TextStyle(
//   //                     fontSize: 15,
//   //                     color: Colors.grey.shade700,
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 4),
//   //                 Text(
//   //                   "Seller ID: ${item['seller_id']}",
//   //                   style: TextStyle(
//   //                     fontSize: 13,
//   //                     color: Colors.grey.shade600,
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget _buildCartItemCard(Map<String, dynamic> item) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 1.5,
//       color: const Color(0xFFFAFAFA), // Lighter background (soft off-white)
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: SizedBox(
//                 width: 100,
//                 height: 100,
//                 child: Image.network(
//                   item['photo'],
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       color: Colors.grey.shade200,
//                       child: const Icon(Icons.image_not_supported_rounded),
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//             const SizedBox(width: 16),
//
//             // Details + Controls
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item['name'],
//                     style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF111827),
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),
//
//                   Text(
//                     "₹ ${item['price']}",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF7C3AED),
//                     ),
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   // Quantity Controls
//                   Row(
//                     children: [
//                       _buildQuantityButton(
//                         icon: Icons.remove_rounded,
//                         onPressed: () => _updateQuantity(item, item['quantity'] - 1),
//                       ),
//                       const SizedBox(width: 12),
//                       Container(
//                         width: 60,
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "${item['quantity']}",
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       _buildQuantityButton(
//                         icon: Icons.add_rounded,
//                         onPressed: () => _updateQuantity(item, item['quantity'] + 1),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   // Delete Button + Seller Info
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Seller ID: ${item['seller_id']}",
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(
//                           Icons.delete_outline_rounded,
//                           color: Colors.redAccent,
//                           size: 22,
//                         ),
//                         tooltip: "Remove item",
//                         onPressed: () => _removeItem(item),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// // Helper: Small round button for quantity
//   Widget _buildQuantityButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF7C3AED),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: IconButton(
//         icon: Icon(icon, color: Colors.white, size: 20),
//         constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
//         padding: EdgeInsets.zero,
//         onPressed: onPressed,
//       ),
//     );
//   }
//
//   Widget _buildEmptyCart() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.shopping_cart_outlined,
//             size: 100,
//             color: Colors.grey.shade400,
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             "Your cart is empty",
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF111827),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             "Add some products to get started",
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           const SizedBox(height: 32),
//           OutlinedButton.icon(
//             icon: const Icon(Icons.shopping_bag_outlined),
//             label: const Text("Browse Products"),
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const viewproduct()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _removeItem {
// }



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'payment.dart'; // PayAmount
// import 'home.dart';   // BankingDashboard
// import 'viewproduct.dart'; // back to products
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: viewcart(),
//   ));
// }
//
// class viewcart extends StatefulWidget {
//   const viewcart({super.key});
//
//   @override
//   State<viewcart> createState() => _viewcartState();
// }
//
// class _viewcartState extends State<viewcart> {
//   List<Map<String, dynamic>> cartItems = [];
//   int totalAmount = 0;
//   String sellerId = "";
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadCart();
//   }
//
//   Future<void> loadCart() async {
//     setState(() => isLoading = true);
//
//     try {
//       final sh = await SharedPreferences.getInstance();
//       final baseUrl = sh.getString('url') ?? '';
//       final lid = sh.getString('lid') ?? '';
//       final imgBase = sh.getString('img_url') ?? '';
//
//       if (baseUrl.isEmpty || lid.isEmpty) {
//         Fluttertoast.showToast(msg: "Session error. Please login again.");
//         return;
//       }
//
//       final uri = Uri.parse('$baseUrl/user_viewcart_post/');
//
//       final response = await http.post(uri, body: {'lid': lid});
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//
//         if (jsonData['status'] == 'ok') {
//           int sum = 0;
//           List<Map<String, dynamic>> temp = [];
//
//           for (var item in jsonData['data']) {
//             final price = int.tryParse(item['price'].toString()) ?? 0;
//             final qty = int.tryParse(item['quantity'].toString()) ?? 1;
//             sum += price * qty;
//
//             temp.add({
//               'id': item['id'].toString(),
//               'name': item['name'] ?? 'No name',
//               'photo': imgBase + (item['photo'] ?? ''),
//               'description': item['description'] ?? '',
//               'price': price,
//               'quantity': qty,
//               'seller_id': item['sellerid']?.toString() ?? '',
//             });
//
//             // Assuming all items belong to the same seller
//             sellerId = item['sellerid']?.toString() ?? sellerId;
//           }
//
//           setState(() {
//             cartItems = temp;
//             totalAmount = sum;
//           });
//         } else {
//           Fluttertoast.showToast(msg: jsonData['message'] ?? 'No items in cart');
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Server error");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error loading cart");
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _updateQuantity(Map<String, dynamic> item, int newQty) async {
//     if (newQty < 1) {
//       Fluttertoast.showToast(msg: "Quantity cannot be less than 1");
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       final sh = await SharedPreferences.getInstance();
//       final baseUrl = sh.getString('url') ?? '';
//       final lid = sh.getString('lid') ?? '';
//
//       final uri = Uri.parse('$baseUrl/user_updatecartquantity_post/');
//
//       final response = await http.post(uri, body: {
//         'lid': lid,
//         'cart_id': item['id'].toString(),
//         'quantity': newQty.toString(),
//       });
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == 'ok') {
//           await loadCart(); // refresh entire cart
//           Fluttertoast.showToast(msg: "Quantity updated");
//         } else {
//           Fluttertoast.showToast(msg: data['message'] ?? "Update failed");
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Server error");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error updating quantity");
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _removeItem(Map<String, dynamic> item) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Remove Item"),
//         content: Text("Remove ${item['name']} from your cart?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text("Remove"),
//           ),
//         ],
//       ),
//     );
//
//     if (confirm != true) return;
//
//     setState(() => isLoading = true);
//
//     try {
//       final sh = await SharedPreferences.getInstance();
//       final baseUrl = sh.getString('url') ?? '';
//       final lid = sh.getString('lid') ?? '';
//
//       final uri = Uri.parse('$baseUrl/user_deletecart_post/');
//
//       final response = await http.post(uri, body: {
//       });
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == 'ok') {
//           Fluttertoast.showToast(msg: "Item removed successfully");
//           await loadCart();
//         } else {
//           Fluttertoast.showToast(msg: data['message'] ?? "Remove failed");
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Server error");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error removing item");
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> checkout() async {
//     if (totalAmount <= 0 || sellerId.isEmpty) {
//       Fluttertoast.showToast(msg: "Cart is empty or invalid");
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       final sh = await SharedPreferences.getInstance();
//       final baseUrl = sh.getString('url') ?? '';
//       final lid = sh.getString('lid') ?? '';
//
//       final uri = Uri.parse('$baseUrl/user_place_order_post/');
//
//       final response = await http.post(uri, body: {
//         'lid': lid,
//         'seller_id': sellerId,
//         'amount': totalAmount.toString(),
//       });
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         if (data['status'] == 'ok') {
//           final orderId = data['order_id']?.toString() ?? '';
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PayAmount(
//                 title: "Pay Now",
//                 vid: orderId,
//                 amount: totalAmount.toString(),
//               ),
//             ),
//           );
//         } else {
//           Fluttertoast.showToast(msg: data['message'] ?? "Order failed");
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Server error");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Connection error");
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFFFFF),
//       appBar: AppBar(
//         title: const Text("My Cart"),
//         centerTitle: true,
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: const Color(0xFFFFFFFF),
//         elevation: 0.6,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_rounded),
//           onPressed: () => Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const BankingDashboard()),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Cart Items
//           Expanded(
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : cartItems.isEmpty
//                 ? _buildEmptyCart()
//                 : RefreshIndicator(
//               onRefresh: loadCart,
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 itemCount: cartItems.length,
//                 itemBuilder: (context, index) {
//                   return _buildCartItemCard(cartItems[index]);
//                 },
//               ),
//             ),
//           ),
//
//           // Sticky Bottom Bar
//           Container(
//             padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 12,
//                   offset: const Offset(0, -4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Total Amount",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF111827),
//                       ),
//                     ),
//                     Text(
//                       "₹ $totalAmount",
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF7C3AED),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   height: 56,
//                   child: FilledButton.icon(
//                     icon: const Icon(Icons.payment_rounded),
//                     label: const Text(
//                       "Checkout & Pay",
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     style: FilledButton.styleFrom(
//                       backgroundColor: const Color(0xFF7C3AED),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     onPressed: totalAmount > 0 && !isLoading ? checkout : null,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCartItemCard(Map<String, dynamic> item) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 1.5,
//       color: const Color(0xFFFAFAFA), // light background
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: SizedBox(
//                 width: 100,
//                 height: 100,
//                 child: Image.network(
//                   item['photo'],
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       color: Colors.grey.shade200,
//                       child: const Icon(Icons.image_not_supported_rounded),
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//             const SizedBox(width: 16),
//
//             // Details + Controls
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item['name'],
//                     style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF111827),
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),
//
//                   Text(
//                     "₹ ${item['price']}",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF7C3AED),
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // Quantity Controls
//                   Row(
//                     children: [
//                       _buildQuantityButton(
//                         icon: Icons.remove_rounded,
//                         onPressed: () => _updateQuantity(item, item['quantity'] - 1),
//                       ),
//                       const SizedBox(width: 12),
//                       Container(
//                         width: 60,
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "${item['quantity']}",
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       _buildQuantityButton(
//                         icon: Icons.add_rounded,
//                         onPressed: () => _updateQuantity(item, item['quantity'] + 1),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // Seller Info + Delete
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Seller ID: ${item['seller_id']}",
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(
//                           Icons.delete_outline_rounded,
//                           color: Colors.redAccent,
//                           size: 24,
//                         ),
//                         tooltip: "Remove from cart",
//                         onPressed: () async {
//                           SharedPreferences sh=await SharedPreferences.getInstance();
//                           String url=sh.getString('url')??'';
//                           final urls=Uri.parse('$url/user_deletecart_post/');
//                           final response=await http.post(urls,body: {
//                             'id':item['id'].toString(),
//                           });
//                           if(response.statusCode==200){
//                             String status=jsonDecode(response.body)['status'];
//                             if(status=='ok'){
//                               Fluttertoast.showToast(msg: 'deleted succesfull');
//                               loadCart();
//
//                             }
//                           }
//                         },
//                       ),
//
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuantityButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return InkWell(
//       onTap: onPressed,
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: const Color(0xFF7C3AED),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(icon, color: Colors.white, size: 20),
//       ),
//     );
//   }
//
//   Widget _buildEmptyCart() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.shopping_cart_outlined,
//             size: 100,
//             color: Colors.deepPurple.shade400,
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             "Your cart is empty",
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF111827),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             "Add some products to get started",
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           const SizedBox(height: 32),
//           OutlinedButton.icon(
//             icon: const Icon(Icons.shopping_bag_outlined),
//             label: const Text("Browse Products"),
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const viewproduct()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'payment.dart'; // PayAmount
import 'home.dart';   // BankingDashboard
import 'viewproduct.dart'; // back to products

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: viewcart(),
  ));
}

class SellerGroup {
  final String sellerId;
  String sellerName;
  List<Map<String, dynamic>> items = [];
  int subtotal = 0;

  Map<String, dynamic>? offer;
  bool offerApplied = false;
  int discount = 0;

  SellerGroup({required this.sellerId, this.sellerName = "Seller"});

  int get payable => subtotal - discount;
}

class viewcart extends StatefulWidget {
  const viewcart({super.key});

  @override
  State<viewcart> createState() => _viewcartState();
}

class _viewcartState extends State<viewcart> {
  Map<String, SellerGroup> sellerGroups = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    setState(() => isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final lid = sh.getString('lid') ?? '';
      final imgBase = sh.getString('img_url') ?? '';

      if (baseUrl.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: "Session error. Please login again.");
        return;
      }

      final uri = Uri.parse('$baseUrl/user_viewcart_post/');
      final response = await http.post(uri, body: {'lid': lid});

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'ok') {
          Map<String, SellerGroup> groups = {};

          for (var item in jsonData['data']) {
            final sid = item['sellerid']?.toString() ?? 'unknown';
            final price = int.tryParse(item['price']?.toString() ?? '0') ?? 0;
            final qty = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;

            groups.putIfAbsent(
              sid,
                  () => SellerGroup(
                sellerId: sid,
                sellerName: item['seller_name']?.toString() ?? 'Seller $sid',
              ),
            );

            final group = groups[sid]!;
            group.items.add({
              'id': item['id']?.toString() ?? '',
              'name': item['name'] ?? 'No name',
              'photo': imgBase + (item['photo'] ?? ''),
              'description': item['description'] ?? '',
              'price': price,
              'quantity': qty,
            });

            group.subtotal += price * qty;
          }

          setState(() => sellerGroups = groups);

          await _loadOffersForEligibleSellers();
        } else {
          Fluttertoast.showToast(msg: jsonData['message'] ?? 'No items in cart');
        }
      } else {
        Fluttertoast.showToast(msg: "Server error");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading cart");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _loadOffersForEligibleSellers() async {
    for (final group in sellerGroups.values) {
      if (group.subtotal < 3000) continue;

      try {
        final sh = await SharedPreferences.getInstance();
        final baseUrl = sh.getString('url') ?? '';
        final lid = sh.getString('lid') ?? '';

        final uri = Uri.parse('$baseUrl/user_receiveoffers/');
        final res = await http.post(uri, body: {
          'lid': lid,
          'seller_id': group.sellerId,
          'amount': group.subtotal.toString(),
        });

        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          if (data['status'] == 'ok' && data['data'] != null) {
            setState(() {
              group.offer = data['data'] as Map<String, dynamic>;
              group.discount = 0; // not applied yet
              group.offerApplied = false;
            });
          }
        }
      } catch (e) {
        print("Offer load failed: $e");
      }
    }
  }

  void _showOfferDialog(SellerGroup group) {
    if (group.offer == null) return;

    final offer = group.offer!;
    final code = offer['couponcode']?.toString() ?? 'OFFER';
    final amount = int.tryParse(offer['amount']?.toString() ?? '0') ?? 0;
    final desc = offer['description']?.toString() ?? 'Special offer';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Grab Your Offer!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Coupon: $code", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Discount: ₹ $amount"),
            const SizedBox(height: 8),
            Text(desc),
            const SizedBox(height: 16),
            const Text("Do you want to apply this offer?"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                group.discount = 0;
                group.offerApplied = false;
              });
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Offer not applied");
            },
            child: const Text("No, Continue"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              setState(() {
                group.discount = amount.clamp(0, group.subtotal);
                group.offerApplied = true;
              });
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "₹$amount discount applied!");
            },
            child: const Text("Yes, Apply Offer"),
          ),
        ],
      ),
    );
  }

  Future<void> _updateQuantity(Map<String, dynamic> item, int delta) async {
    final newQty = (item['quantity'] as int) + delta;
    if (newQty < 1) return;

    setState(() => isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final lid = sh.getString('lid') ?? '';

      final uri = Uri.parse('$baseUrl/user_updatecartquantity_post/');
      final res = await http.post(uri, body: {
        'lid': lid,
        'cart_id': item['id'].toString(),
        'quantity': newQty.toString(),
      });

      if (res.statusCode == 200 && jsonDecode(res.body)['status'] == 'ok') {
        await loadCart();
        Fluttertoast.showToast(msg: "Quantity updated");
      } else {
        Fluttertoast.showToast(msg: "Update failed");
      }
    } catch (_) {
      Fluttertoast.showToast(msg: "Quantity update error");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _removeItem(Map<String, dynamic> item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remove Item"),
        content: Text("Remove ${item['name']}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final lid = sh.getString('lid') ?? '';

      final uri = Uri.parse('$baseUrl/user_deletecart_post/');
      final res = await http.post(uri, body: {
        'lid': lid,
        'id': item['id'].toString(),
      });

      if (res.statusCode == 200 && jsonDecode(res.body)['status'] == 'ok') {
        await loadCart();
        Fluttertoast.showToast(msg: "Item removed");
      } else {
        Fluttertoast.showToast(msg: "Remove failed");
      }
    } catch (_) {
      Fluttertoast.showToast(msg: "Remove error");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> checkout() async {
    final grandTotal = sellerGroups.values.fold(0, (sum, g) => sum + g.payable);

    if (grandTotal <= 0) {
      Fluttertoast.showToast(msg: "Nothing to pay");
      return;
    }

    setState(() => isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final lid = sh.getString('lid') ?? '';

      final uri = Uri.parse('$baseUrl/user_place_order_post/');

      // Find if any seller accepted an offer
      String? couponIdToSend;
      for (final group in sellerGroups.values) {
        if (group.offerApplied && group.offer != null) {
          couponIdToSend = group.offer!['id']?.toString() ?? '';
          break;
        }
      }

      final body = {
        'lid': lid,
        'seller_id': sellerGroups.keys.first, // first seller (change to jsonEncode if backend supports array)
        'amount': grandTotal.toString(),
      };

      // Pass coupon_id only if user accepted any offer
      if (couponIdToSend != null && couponIdToSend.isNotEmpty) {
        body['coupon_id'] = couponIdToSend;
      }

      final response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          final orderId = data['order_id']?.toString() ?? '';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PayAmount(
                title: "Pay Now",
                vid: orderId,
                amount: grandTotal.toString(),
              ),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? "Order failed");
        }
      } else {
        Fluttertoast.showToast(msg: "Server error");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Connection error");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final grandTotal = sellerGroups.values.fold(0, (sum, g) => sum + g.payable);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("My Cart"),
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
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : sellerGroups.isEmpty
                ? _buildEmptyCart()
                : RefreshIndicator(
              onRefresh: loadCart,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: sellerGroups.length,
                itemBuilder: (context, index) {
                  final group = sellerGroups.values.elementAt(index);
                  return _buildSellerSection(group);
                },
              ),
            ),
          ),

          // Bottom total & pay button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    Text("₹ $grandTotal", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.payment_rounded),
                    label: const Text("Checkout & Pay", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: grandTotal > 0 && !isLoading ? checkout : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerSection(SellerGroup group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.sellerName,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            ...group.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        item['photo'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported_rounded),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name'], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Text("₹ ${item['price']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildQuantityButton(Icons.remove_rounded, () => _updateQuantity(item, -1)),
                            const SizedBox(width: 12),
                            Container(
                              width: 60,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
                              child: Center(child: Text("${item['quantity']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                            ),
                            const SizedBox(width: 12),
                            _buildQuantityButton(Icons.add_rounded, () => _updateQuantity(item, 1)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    onPressed: () => _removeItem(item),
                  ),
                ],
              ),
            )),

            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Subtotal: ₹ ${group.subtotal}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                if (group.discount > 0) Text("- ₹ ${group.discount}", style: const TextStyle(color: Colors.green, fontSize: 16)),
              ],
            ),

            // "Tap to Grab Your Offer" only if eligible
            if (group.subtotal >= 3000 && group.offer != null)
              GestureDetector(
                onTap: () => _showOfferDialog(group),
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Tap to Grab Your Offer!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.deepPurple),
                    ],
                  ),
                ),
              ),

            if (group.discount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Payable:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹ ${group.payable}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.deepPurple.shade400),
          const SizedBox(height: 24),
          const Text("Your cart is empty", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text("Browse Products"),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const viewproduct())),
          ),
        ],
      ),
    );
  }
}