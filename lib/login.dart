//
//
//
// import 'dart:convert';
// import 'package:aicrm/signup.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'home.dart';
// import 'main.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: MyLoginPage(title: 'Login'),
//   ));
// }
//
// class MyLoginPage extends StatefulWidget {
//   const MyLoginPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyLoginPage> createState() => _MyLoginPageState();
// }
//
// class _MyLoginPageState extends State<MyLoginPage> {
//   final TextEditingController _usernametextController = TextEditingController();
//   final TextEditingController _passwordtextController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const IpSetupPage(title: '',)),
//       );
//       return false; // Prevent default pop
//     },
//     child:Scaffold(
//       backgroundColor: const Color(0xFFEFF3FF), // Light blue background
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Top Shape and Logo
//             Stack(
//               children: [
//                 Container(
//                   height: 180,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFF0047AB),
//                     borderRadius:
//                     BorderRadius.only(bottomLeft: Radius.circular(80)),
//                   ),
//                 ),
//                 const Positioned(
//                   top: 100,
//                   left: 20,
//                   child: Text(
//                     'Smart Billing',
//                     style: TextStyle(
//                         fontSize: 32,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 40),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Email id",
//                       style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _usernametextController,
//                     decoration: InputDecoration(
//                       hintText: "Enter your email",
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide.none),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text("Password",
//                       style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _passwordtextController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintText: "••••••••",
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide.none),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//
//                   // Login Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _send_data,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         backgroundColor: Colors.orange,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                       ),
//                       child: const Text("Login",
//                           style: TextStyle(color: Colors.white, fontSize: 16)),
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {},
//                       child: const Text("Forgot Password ?",
//                           style: TextStyle(color: Colors.black87)),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//
//                   // Divider
//                   Row(children: const <Widget>[
//                     Expanded(child: Divider()),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8),
//                       child: Text("or"),
//                     ),
//                     Expanded(child: Divider()),
//                   ]),
//                   const SizedBox(height: 20),
//
//                   // Facebook Button
//                   // SizedBox(
//                   //   width: double.infinity,
//                   //   child: ElevatedButton.icon(
//                   //     onPressed: () {},
//                   //     icon: const Icon(Icons.facebook, color: Colors.white),
//                   //     label: const Text("Log in with Facebook"),
//                   //     style: ElevatedButton.styleFrom(
//                   //         backgroundColor: const Color(0xFF1877F2),
//                   //         padding: const EdgeInsets.symmetric(vertical: 14),
//                   //         shape: RoundedRectangleBorder(
//                   //             borderRadius: BorderRadius.circular(8))),
//                   //   ),
//                   // ),
//                   const SizedBox(height: 30),
//
//                   // Register Prompt
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children:  [
//                       Text("Don't have an account? ",
//                           style: TextStyle(color: Colors.black87)),
//                       TextButton(onPressed:(){
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => usersignup(title: '',)),
//                         );
//                       },child: Text("Register",
//
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.orange))),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     ));
//   }
//
//   void _send_data() async {
//     String uname = _usernametextController.text;
//     String password = _passwordtextController.text;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//
//     final urls = Uri.parse('$url/app_login_post/');
//     try {
//       final response = await http.post(urls, body: {
//         'Username': uname,
//         'Password': password,
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status == 'ok') {
//           String lid = jsonDecode(response.body)['lid'];
//           sh.setString("lid", lid);
//
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => BankingDashboard()),
//           );
//         } else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
// }


// ────────────────────────────────────────────────
//  Modern Login – Light Purple Theme
// ────────────────────────────────────────────────

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'forgotpassword.dart';
import 'signup.dart';     // usersignup
import 'home.dart';       // BankingDashboard
import 'main.dart';       // IpSetupPage

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});
  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';

      if (baseUrl.isEmpty) {
        Fluttertoast.showToast(msg: "Server URL not configured");
        return;
      }

      final uri = Uri.parse('$baseUrl/app_login_post/');

      final res = await http.post(uri, body: {
        'Username': _emailController.text.trim(),
        'Password': _passwordController.text,
      });

      if (!mounted) return;

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == 'ok') {
          await sh.setString('lid', data['lid'].toString());
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BankingDashboard()),
          );
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? 'Login failed');
        }
      } else {
        Fluttertoast.showToast(msg: 'Server error ${res.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const IpSetupPage(title: '')),
        );
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF5F0FF),
                Color(0xFFEDE7FF),
                Color(0xFFF8F5FF),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),

                        // Logo / Brand
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C3AED).withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.inventory_2_rounded,
                                  size: 64,
                                  color: Color(0xFF6B21A8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Smart Billing",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4C1D95),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Login to continue",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Email field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (!v.contains('@')) return 'Invalid email';
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (_) => _login(),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                        ),

                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordPage()));
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(color: Color(0xFF7C3AED)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login button
                        FilledButton(
                          onPressed: _isLoading ? null : _login,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF7C3AED),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SignupPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Create account",
                                style: TextStyle(
                                  color: Color(0xFF7C3AED),
                                  fontWeight: FontWeight.w600,
                                ),
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
            ),
          ),
        ),
      ),
    );
  }

}