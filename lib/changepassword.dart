// import 'dart:convert';
// import 'dart:io';
// import 'package:aicrm/login.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'home.dart';
//
//
// void main() {
//   runApp( userchangepassword(title: '',));
// }
//
// class userchangepassword extends StatefulWidget {
//   const userchangepassword({super.key, required this.title});
//
//   final String title;
//   @override
//   State<userchangepassword> createState() => _userchangepasswordState();
//
// }
// class _userchangepasswordState extends State<userchangepassword> {
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _currentpasswordtextController = TextEditingController();
//   final TextEditingController _newpasswordtextController = TextEditingController();
//   final TextEditingController _confirmpasswordtextController = TextEditingController();
//
//
//
//   Future<void> _sendData() async {
//     String ucurrentpassword = _currentpasswordtextController.text;
//     String unewpassword = _newpasswordtextController.text;
//     String uconfirmpassword = _confirmpasswordtextController.text;
//
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//     String? lid = sh.getString('lid');
//
//     if (url == null) {
//       Fluttertoast.showToast(msg: "Server URL not found.");
//       return;
//     }
//
//     final uri = Uri.parse('$url/user_changepassword_post/');
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['lid'] = lid.toString();
//     request.fields['Currentpassword'] = ucurrentpassword;
//     request.fields['NewPassword'] = unewpassword;
//     request.fields['ConfirmPassword'] = uconfirmpassword;
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
//           MaterialPageRoute(builder: (context) => const MyLoginPage(title: '')),
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
//           MaterialPageRoute(builder: (context) => const BankingDashboard()),
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
//                   controller: _currentpasswordtextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your Current Password',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Current Password is required';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _newpasswordtextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your New Password',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'New Password is required';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _confirmpasswordtextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your Confirm Password',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Confirm Password is required';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 const SizedBox(height: 20),
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
//
//


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';      // BankingDashboard
import 'login.dart';     // MyLoginPage

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChangePasswordPage(),
  ));
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(
        msg: "New password and confirm password do not match",
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final lid = sh.getString('lid') ?? '';

      if (baseUrl.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: "Session error. Please login again.");
        return;
      }

      final uri = Uri.parse('$baseUrl/user_changepassword_post/');

      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'lid': lid,
        'Currentpassword': _currentPasswordController.text,
        'NewPassword': _newPasswordController.text,
        'ConfirmPassword': _confirmPasswordController.text,
      });

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: "Password changed successfully",
            backgroundColor: Colors.green.shade700,
          );

          // Common practice: logout and redirect to login after password change
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MyLoginPage(title: '')),
          );
        } else {
          Fluttertoast.showToast(
            msg: data['message'] ?? "Failed to change password",
          );
        }
      } else {
        Fluttertoast.showToast(msg: "Server error (${response.statusCode})");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Connection error");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color(0xFFFFFFFF),
        elevation: 0.8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BankingDashboard()),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Icon + Title
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        size: 68,
                        color: Color(0xFF7C3AED),
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      "Change Your Password",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      "Enter your current password and set a new one",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // Current Password
                    _buildPasswordField(
                      controller: _currentPasswordController,
                      label: "Current Password",
                      obscure: _obscureCurrent,
                      onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    ),

                    const SizedBox(height: 20),

                    // New Password
                    _buildPasswordField(
                      controller: _newPasswordController,
                      label: "New Password",
                      obscure: _obscureNew,
                      onToggle: () => setState(() => _obscureNew = !_obscureNew),
                    ),

                    const SizedBox(height: 20),

                    // Confirm Password
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      label: "Confirm New Password",
                      obscure: _obscureConfirm,
                      onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),

                    const SizedBox(height: 48),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        icon: _isLoading
                            ? const SizedBox.shrink()
                            : const Icon(Icons.lock_reset_rounded),
                        label: _isLoading
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.8,
                          ),
                        )
                            : const Text(
                          "Update Password",
                          style: TextStyle(
                            fontSize: 16,
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
                        onPressed: _isLoading ? null : _changePassword,
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade700),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF7C3AED),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.deepPurple.shade600,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
          borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        if (label.contains("New") && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}