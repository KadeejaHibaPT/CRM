// import 'dart:convert';
// import 'dart:io';
// import 'package:aicrm/login.dart';
// import 'package:aicrm/viewproduct.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'home.dart';
//
//
// void main() {
//   runApp( addtocart(title: '',));
// }
//
// class addtocart extends StatefulWidget {
//   const addtocart({super.key, required this.title});
//
//   final String title;
//   @override
//   State<addtocart> createState() => _addtocartState();
//
// }
// class _addtocartState extends State<addtocart> {
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _quantitytextController = TextEditingController();
//
//
//   Future<void> _sendData() async {
//     String quantity = _quantitytextController.text;
//
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//     String? lid = sh.getString('lid');
//     String? pid = sh.getString('pid');
//
//     if (url == null) {
//       Fluttertoast.showToast(msg: "Server URL not found.");
//       return;
//     }
//
//     final uri = Uri.parse('$url/user_addproductcart_post/');
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['lid'] = lid.toString();
//     request.fields['pid'] = pid.toString();
//     request.fields['quantity'] = quantity;
//
//
//
//     try {
//       var response = await request.send();
//       var respStr = await response.stream.bytesToString();
//       var data = jsonDecode(respStr);
//
//       if (response.statusCode == 200 && data['status'] == 'ok') {
//         Fluttertoast.showToast(msg: "Submitted successfully.");
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const viewproduct()),
//         );
//
//       } else {
//         Fluttertoast.showToast(msg: "Submission failed.");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const viewproduct()),
//         );
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//           centerTitle: true,
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           foregroundColor: Colors.white,
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _quantitytextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your quantity',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'quantity is required';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       _sendData();
//                     } else {
//                       Fluttertoast.showToast(msg: "Please fix errors in the form");
//                     }
//                   },
//                   child: const Text("Submit"),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size.fromHeight(50),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'viewproduct.dart'; // back to product list

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: addtocart(),
  ));
}

class addtocart extends StatefulWidget {
  const addtocart({super.key});

  @override
  State<addtocart> createState() => _addtocartState();
}

class _addtocartState extends State<addtocart>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '1');

  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // Product preview data
  String productName = "Loading...";
  String productPrice = "₹ 0.00";
  String productImage = "";

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();

    _loadProductDetails();
  }

  double unitPrice = 0.0;   // single item price
  double totalPrice = 0.0;  // quantity * price


  Future<void> _loadProductDetails() async {
    final sh = await SharedPreferences.getInstance();

    setState(() {
      productName = sh.getString('product_name') ?? "Selected Product";

      unitPrice = double.tryParse(
          sh.getString('product_price') ?? '0') ??
          0.0;

      totalPrice = unitPrice; // qty = 1 initially
      productImage = sh.getString('product_image') ?? "";
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _addToCart() async {
    if (!_formKey.currentState!.validate()) return;

    final qty = int.tryParse(_quantityController.text) ?? 1;
    if (qty < 1) {
      Fluttertoast.showToast(msg: "Quantity must be at least 1");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final lid = sh.getString('lid') ?? '';
      final pid = sh.getString('pid') ?? '';

      if (baseUrl.isEmpty || lid.isEmpty || pid.isEmpty) {
        Fluttertoast.showToast(msg: "Session error. Please try again.");
        return;
      }

      final uri = Uri.parse('$baseUrl/user_addproductcart_post/');

      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll({
        'lid': lid,
        'pid': pid,
        'quantity': qty.toString(),
      });

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: "Added to cart successfully",
            backgroundColor: Colors.green.shade700,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const viewproduct()),
          );
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? "Failed to add");
        }
      } else {
        Fluttertoast.showToast(msg: "Server error");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Connection error");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _increment() {
    int current = int.tryParse(_quantityController.text) ?? 1;
    current++;
    _quantityController.text = current.toString();

    setState(() {
      totalPrice = unitPrice * current;
    });
  }

  void _decrement() {
    int current = int.tryParse(_quantityController.text) ?? 1;
    if (current > 1) {
      current--;
      _quantityController.text = current.toString();

      setState(() {
        totalPrice = unitPrice * current;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("Add to Cart"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color(0xFFFFFFFF),
        elevation: 0.6,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const viewproduct()),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Product Image + Info
                    Container(
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
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: SizedBox(
                              height: 220,
                              width: double.infinity,
                              child: productImage.isNotEmpty
                                  ? Image.network(
                                productImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported_rounded,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                                  : Container(
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image_outlined,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "₹ ${totalPrice.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7C3AED),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Quantity Selector
                    const Text(
                      "Select Quantity",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildQuantityButton(
                          icon: Icons.remove_rounded,
                          onPressed: _decrement,
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 90,
                          child: TextFormField(
                            controller: _quantityController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFF7C3AED),
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              final qty = int.tryParse(value);
                              if (qty == null || qty < 1) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        _buildQuantityButton(
                          icon: Icons.add_rounded,
                          onPressed: _increment,
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        icon: _isLoading
                            ? const SizedBox.shrink()
                            : const Icon(Icons.shopping_cart_checkout_rounded),
                        label: _isLoading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.8,
                          ),
                        )
                            : const Text(
                          "Add to Cart",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _isLoading ? null : _addToCart,
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      ),
    );
  }
}