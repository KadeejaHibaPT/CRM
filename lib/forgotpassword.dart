// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'login.dart';
//
// void main() {
//   runApp(const forgotpassword());
// }
//
// class forgotpassword extends StatelessWidget {
//   const forgotpassword({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Forgot Password',
//       home: forgot_password(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class forgot_password extends StatefulWidget {
//   const forgot_password({super.key});
//
//   @override
//   State<forgot_password> createState() => _forgot_passwordState();
// }
//
// class _forgot_passwordState extends State<forgot_password> {
//   final TextEditingController email = TextEditingController();
//
//   Future<void> sendData() async {
//     String femail = email.text.trim();
//     if (femail.isEmpty || !femail.contains('@')) {
//       Fluttertoast.showToast(msg: 'Enter a valid email');
//       return;
//     }
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? '';
//     final urls = Uri.parse('$url/android_forget_password_post/');
//
//     try {
//       final response = await http.post(urls, body: {
//         'email': femail,
//       });
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         String status = data['status'];
//
//         if (status == 'ok') {
//           Fluttertoast.showToast(msg: 'Password sent to email');
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const MyLoginPage(title: '',)),
//           );
//         } else {
//           Fluttertoast.showToast(msg: 'Email not found');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Server error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Forgot Password'),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Enter your registered email address',
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: email,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 prefixIcon: Icon(Icons.email),
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: sendData,
//                 child: const Text('Send Password'),
//               ),
//             ),
//           ],
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

import 'login.dart'; // MyLoginPage

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ForgotPasswordPage(),
  ));
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetRequest() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid email address',
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';

      if (baseUrl.isEmpty) {
        Fluttertoast.showToast(msg: 'Server not configured');
        return;
      }

      final uri = Uri.parse('$baseUrl/android_forget_password_post/');

      final response = await http.post(uri, body: {'email': email});

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'] as String?;

        if (status == 'ok') {
          Fluttertoast.showToast(
            msg: 'Password reset link sent to your email',
            backgroundColor: Colors.green.shade700,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MyLoginPage(title: '')),
          );
        } else {
          Fluttertoast.showToast(msg: 'Email not found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Server error (${response.statusCode})');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Connection error');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F0FF), // very light lavender
              Color(0xFFEBE5FF),
              Color(0xFFE6DEFF),
              Color(0xFFF8F5FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),

                        // Icon + Title
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_reset_rounded,
                            size: 72,
                            color: Color(0xFF6B21A8),
                          ),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4C1D95),
                            letterSpacing: -0.4,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Enter your registered email and we'll\nsend you a reset link.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 48),

                        // Email field
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _sendResetRequest(),
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'example@domain.com',
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Colors.white,
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
                              borderSide: const BorderSide(
                                color: Color(0xFF7C3AED),
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Send button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton.icon(
                            icon: _isLoading
                                ? const SizedBox.shrink()
                                : const Icon(Icons.send_rounded, size: 20),
                            label: _isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.6,
                              ),
                            )
                                : const Text(
                              "Send Reset Link",
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
                              elevation: 0,
                            ),
                            onPressed: _isLoading ? null : _sendResetRequest,
                          ),
                        ),

                        const SizedBox(height: 32),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MyLoginPage(title: ''),
                              ),
                            );
                          },
                          child: const Text(
                            "Back to Login",
                            style: TextStyle(
                              color: Color(0xFF7C3AED),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
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
        ),
      ),
    );
  }
}
