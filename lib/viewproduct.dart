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
//       home: viewproduct(title: 'View Users'),
//     );
//   }
// }
//
// class viewproduct extends StatefulWidget {
//   const viewproduct({super.key, required this.title});
//   final String title;
//
//   @override
//   State<viewproduct> createState() => _viewproductState();
// }
//
// class _viewproductState extends State<viewproduct> {
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
//       String apiUrl = '$urls/user_viewproduct_post/';
//
//       var response = await http.post(Uri.parse(apiUrl), body: {});
//       var jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         List<Map<String, dynamic>> tempList = [];
//         for (var item in jsonData['data']) {
//           tempList.add({
//             'id': item['id'],
//             'name': item['name'],
//             'photo':img+item['photo'],
//             'description': item['description'],
//             'price':  item['price'],
//             'sid':item['sid'],
//           });
//         }
//         setState(() {
//           users = tempList;
//           filteredUsers = tempList
//               .where((user) =>
//               user['name']
//                   .toString()
//                   .toLowerCase()
//                   .contains(searchValue.toLowerCase()))
//               .toList();
//           nameSuggestions = users.map((e) => e['name'].toString()).toSet().toList();
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
//                   leading: CircleAvatar(
//                     backgroundImage: NetworkImage(user['photo']),
//                     radius: 30,
//                   ),
//                   title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Description: ${user['description']}"),
//                       Text("Price: ${user['price']}"),
//                       ElevatedButton(onPressed: () async {
//                         SharedPreferences sh = await SharedPreferences.getInstance();
//                         sh.setString('pid', user['id'].toString());
//                         Navigator.push(context, MaterialPageRoute(builder: (context)=>viewseller(title: '')));
//                       }, child: Text('viewseller')),
//
//                       ElevatedButton(onPressed: () async {
//                         SharedPreferences sh = await SharedPreferences.getInstance();
//                         sh.setString('pid', user['id'].toString());
//                         Navigator.push(context, MaterialPageRoute(builder: (context)=>addtocart(title: '')));
//                       }, child: Text('cart'))
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

//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'addtocart.dart';
// import 'viewseller.dart';
// import 'home.dart'; // BankingDashboard
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: viewproduct(),
//   ));
// }
//
// class viewproduct extends StatefulWidget {
//   const viewproduct({super.key});
//
//   @override
//   State<viewproduct> createState() => _viewproductState();
// }
//
// class _viewproductState extends State<viewproduct> {
//   List<Map<String, dynamic>> products = [];
//   List<Map<String, dynamic>> filteredProducts = [];
//   bool isLoading = true;
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//     _searchController.addListener(_filterProducts);
//   }
//
//   @override
//   void dispose() {
//     _searchController.removeListener(_filterProducts);
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadProducts() async {
//     setState(() => isLoading = true);
//
//     try {
//       final sh = await SharedPreferences.getInstance();
//       final baseUrl = sh.getString('url') ?? '';
//       final imgBase = sh.getString('img_url') ?? '';
//
//       if (baseUrl.isEmpty) {
//         Fluttertoast.showToast(msg: "Server not configured");
//         return;
//       }
//
//       final uri = Uri.parse('$baseUrl/user_viewproduct_post/');
//
//       final response = await http.post(uri);
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//
//         if (jsonData['status'] == 'ok') {
//           final List<Map<String, dynamic>> temp = [];
//
//           for (var item in jsonData['data']) {
//             temp.add({
//               'id': item['id'].toString(),
//               'name': item['name'] ?? 'No name',
//               'photo': imgBase + (item['photo'] ?? ''),
//               'description': item['description'] ?? '',
//               'price': item['price'] ?? '0',
//               'sid': item['sid']?.toString() ?? '',
//             });
//           }
//
//           setState(() {
//             products = temp;
//             filteredProducts = temp;
//           });
//         }
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error loading products");
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }
//
//   void _filterProducts() {
//     final query = _searchController.text.toLowerCase().trim();
//
//     setState(() {
//       if (query.isEmpty) {
//         filteredProducts = List.from(products);
//       } else {
//         filteredProducts = products
//             .where((p) => p['name'].toLowerCase().contains(query))
//             .toList();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       appBar: AppBar(
//         title: const Text("Products"),
//         centerTitle: true,
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         elevation: 0.6,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_rounded),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const BankingDashboard()),
//             );
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           // Search bar
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: "Search products...",
//                 prefixIcon: const Icon(Icons.search_rounded),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: BorderSide.none,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: BorderSide(color: Colors.deepPurple.shade300),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
//                 ),
//               ),
//             ),
//           ),
//
//           // Main content
//           Expanded(
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : RefreshIndicator(
//               onRefresh: _loadProducts,
//               child: filteredProducts.isEmpty
//                   ? _emptyState()
//                   : ListView.builder(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 itemCount: filteredProducts.length,
//                 itemBuilder: (context, index) {
//                   final product = filteredProducts[index];
//                   return _buildProductCard(product);
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildProductCard(Map<String, dynamic> product) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       color: const Color(0xFFF9FAFB), // ← Light modern background (very light gray/off-white)
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: () {
//           // Optional: open product detail page
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             AspectRatio(
//               aspectRatio: 16 / 9,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   image: DecorationImage(
//                     image: NetworkImage(product['photo']),
//                     fit: BoxFit.cover,
//                     onError: (exception, stackTrace) => const Icon(Icons.broken_image),
//                   ),
//                 ),
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product['name'],
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF111827),
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//
//                   const SizedBox(height: 4),
//
//                   Text(
//                     product['description'],
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade700,
//                       height: 1.4,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "₹ ${product['price']}",
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF7C3AED),
//                         ),
//                       ),
//
//                       Row(
//                         children: [
//                           OutlinedButton.icon(
//                             icon: const Icon(Icons.store_outlined, size: 18),
//                             label: const Text("Seller"),
//                             style: OutlinedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 14,
//                                 vertical: 8,
//                               ),
//                               side: BorderSide(color: Colors.deepPurple.shade400),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             onPressed: () async {
//                               final sh = await SharedPreferences.getInstance();
//                               sh.setString('pid', product['id']);
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => ViewSellerPage(),
//                                 ),
//                               );
//                             },
//                           ),
//                           const SizedBox(width: 12),
//                           ElevatedButton.icon(
//                             icon: const Icon(Icons.shopping_cart_outlined, size: 18),
//                             label: const Text("Cart"),
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 14,
//                                 vertical: 8,
//                               ),
//                               backgroundColor: const Color(0xFF7C3AED),
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             onPressed: () async {
//                               final sh = await SharedPreferences.getInstance();
//                               sh.setString('pid', product['id'].toString());
//                               sh.setString('product_name', product['name']);
//                               sh.setString('product_price', product['price'].toString());
//                               sh.setString('product_image', product['photo']);
//
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (_) => const addtocart()),
//                               );
//                             },
//                           ),
//                         ],
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
//   Widget _emptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.inventory_2_outlined,
//             size: 80,
//             color: Colors.grey.shade400,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "No products found",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "Try changing your search term",
//             style: TextStyle(color: Colors.grey.shade600),
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

import 'addtocart.dart';
import 'viewseller.dart';
import 'home.dart'; // BankingDashboard

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: viewproduct(),
  ));
}

class viewproduct extends StatefulWidget {
  const viewproduct({super.key});

  @override
  State<viewproduct> createState() => _viewproductState();
}

class _viewproductState extends State<viewproduct> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  // Category filter
  String? _selectedCategory;
  final List<String> _categories = [
    'UI/UX Design',
    'Website Maintenance & Support',
    'SEO Services',
    'Digital Marketing',
    'Content Writing & Copywriting',
    'Brand Identity Design',
    'E-commerce Setup',
    'Landing Page Design',
    'Social Media Management',
    'Website Optimization',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProducts);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final imgBase = sh.getString('img_url') ?? '';

      if (baseUrl.isEmpty) {
        Fluttertoast.showToast(msg: "Server not configured");
        return;
      }

      final uri = Uri.parse('$baseUrl/user_viewproduct_post/');

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'ok') {
          final List<Map<String, dynamic>> temp = [];

          for (var item in jsonData['data']) {
            temp.add({
              'id': item['id'].toString(),
              'name': item['name'] ?? 'No name',
              'photo': imgBase + (item['photo'] ?? ''),
              'description': item['description'] ?? '',
              'price': item['price'] ?? '0',
              'sid': item['sid']?.toString() ?? '',
              'category': item['category'] ?? 'Uncategorized', // Add category field
            });
          }

          setState(() {
            products = temp;
            filteredProducts = temp;
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading products");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      filteredProducts = products.where((product) {
        // Search filter
        final matchesSearch = query.isEmpty ||
            product['name'].toLowerCase().contains(query);

        // Category filter
        final matchesCategory = _selectedCategory == null ||
            _selectedCategory!.isEmpty ||
            product['category'] == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _clearCategoryFilter() {
    setState(() {
      _selectedCategory = null;
      _filterProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0.6,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BankingDashboard()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Search bar and Category dropdown
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                // Category dropdown with horizontal scroll
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // "All Categories" chip
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedCategory == null,
                        onSelected: (selected) {
                          _clearCategoryFilter();
                        },
                        backgroundColor: Colors.white,
                        selectedColor: Colors.deepPurple.shade100,
                        checkmarkColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                          color: _selectedCategory == null
                              ? Colors.deepPurple
                              : Colors.black87,
                          fontWeight: _selectedCategory == null
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: _selectedCategory == null
                              ? Colors.deepPurple
                              : Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Category chips
                      ..._categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? category : null;
                                _filterProducts();
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: Colors.deepPurple.shade100,
                            checkmarkColor: Colors.deepPurple,
                            labelStyle: TextStyle(
                              color: _selectedCategory == category
                                  ? Colors.deepPurple
                                  : Colors.black87,
                              fontWeight: _selectedCategory == category
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            side: BorderSide(
                              color: _selectedCategory == category
                                  ? Colors.deepPurple
                                  : Colors.grey.shade300,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                // Search field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.deepPurple.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _loadProducts,
              child: filteredProducts.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return _buildProductCard(product);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: const Color(0xFFF9FAFB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Optional: open product detail page
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  image: DecorationImage(
                    image: NetworkImage(product['photo']),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) => const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip (optional - shows which category the product belongs to)
                  if (product['category'] != null && product['category'] != 'Uncategorized')
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.deepPurple.shade200),
                      ),
                      child: Text(
                        product['category'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.deepPurple.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    product['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                    maxLines: 3, // Increased to show more description
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹ ${product['price']}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7C3AED),
                        ),
                      ),

                      Row(
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.store_outlined, size: 18),
                            label: const Text("Seller"),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              side: BorderSide(color: Colors.deepPurple.shade400),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final sh = await SharedPreferences.getInstance();
                              sh.setString('pid', product['id']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewSellerPage(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                            label: const Text("Cart"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              backgroundColor: const Color(0xFF7C3AED),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final sh = await SharedPreferences.getInstance();
                              sh.setString('pid', product['id'].toString());
                              sh.setString('product_name', product['name']);
                              sh.setString('product_price', product['price'].toString());
                              sh.setString('product_image', product['photo']);

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const addtocart()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "No products found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedCategory != null
                ? "Try selecting a different category"
                : "Try changing your search term",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          if (_selectedCategory != null)
            TextButton.icon(
              onPressed: _clearCategoryFilter,
              icon: const Icon(Icons.clear),
              label: const Text("Clear category filter"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple,
              ),
            ),
        ],
      ),
    );
  }
}