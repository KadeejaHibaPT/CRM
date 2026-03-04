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
//   runApp( usersignup(title: '',));
// }
//
// class usersignup extends StatefulWidget {
//   const usersignup({super.key, required this.title});
//
//   final String title;
//   @override
//   State<usersignup> createState() => _usersignupState();
//
// }
// class _usersignupState extends State<usersignup> {
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _nametextController = TextEditingController();
//   final TextEditingController _emailtextController = TextEditingController();
//   final TextEditingController _phonenotextController = TextEditingController();
//   final TextEditingController _dobtextController = TextEditingController();
//   final TextEditingController _placetextController = TextEditingController();
//   final TextEditingController _gendertextController = TextEditingController();
//   final TextEditingController _pintextController = TextEditingController();
//   final TextEditingController _districttextController = TextEditingController();
//   final TextEditingController _passwordtextController = TextEditingController();
//   final TextEditingController _confirmpasswordtextController = TextEditingController();
//
//   File? _selectedImage;
//   Future<void> _chooseImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//     else {
//       Fluttertoast.showToast(msg: "No image selected");
//     }
//   }
//
//   Future<void> _sendData() async {
//     String uname = _nametextController.text;
//     String uemail = _emailtextController.text;
//     String uphone = _phonenotextController.text;
//     String udob = _dobtextController.text;
//     String ugender = _gendertextController.text;
//     String uplace = _placetextController.text;
//     String udistrict = _districttextController.text;
//     String upin = _pintextController.text;
//     String upassword = _passwordtextController.text;
//     String uconfirmpassword = _confirmpasswordtextController.text;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//
//     if (url == null) {
//       Fluttertoast.showToast(msg: "Server URL not found.");
//       return;
//     }
//
//     final uri = Uri.parse('$url/user_signup_post/');
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['uname'] = uname;
//     request.fields['uemail'] = uemail;
//     request.fields['uphoneno'] = uphone;
//     request.fields['udob'] = udob;
//     request.fields['ugender'] = ugender;
//     request.fields['uplace'] = uplace;
//     request.fields['udistrict'] = udistrict;
//     request.fields['upin'] = upin;
//     request.fields['upassword'] = upassword;
//
//     if (_selectedImage != null) {
//       request.files.add(await http.MultipartFile.fromPath('photo', _selectedImage!.path));
//     }
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
//           MaterialPageRoute(builder: (context) => const MyLoginPage(title: '')),
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
//                 _selectedImage != null
//                     ? Image.file(_selectedImage!, height: 150)
//                     : const Text("No Image Selected"),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _chooseImage,
//                   child: const Text("Choose Image"),
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _nametextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your Name',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Name is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _dobtextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your DOB',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'DOB is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _gendertextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your Gender',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Gender is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   controller: _emailtextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your Email',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Email is required';
//                     }
//                     if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
//                       return 'Enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   controller: _phonenotextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your Phone Number',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Phone number is required';
//                     }
//                     if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//                       return 'Enter a valid 10-digit phone number';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _placetextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your Place',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Place is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _districttextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your District',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'District is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _pintextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your Pincode',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Pincode is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _passwordtextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your Password',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Password is required';
//                     }
//                     if (value.length<6){
//                       return "password must contain atleast 6 characters";
//                     }
//
//                     return null;
//                   },
//                 ),
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
//                     if(value!=_passwordtextController.text){
//                       return "password doesn't match";
//                     }
//                     return null;
//                   },
//                 ),
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



import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'login.dart'; // MyLoginPage

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignupPage(),
  ));
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _placeController = TextEditingController();
  final _districtController = TextEditingController();
  final _pinController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  File? _selectedImage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _placeController.dispose();
    _districtController.dispose();
    _pinController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked != null && mounted) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Couldn't pick image");
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';

      if (baseUrl.isEmpty) {
        Fluttertoast.showToast(msg: "Server URL not configured");
        return;
      }

      final uri = Uri.parse('$baseUrl/user_signup_post/');

      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'uname': _nameController.text.trim(),
        'uemail': _emailController.text.trim(),
        'uphoneno': _phoneController.text.trim(),
        'udob': _dobController.text.trim(),
        'ugender': _genderController.text.trim(),
        'uplace': _placeController.text.trim(),
        'udistrict': _districtController.text.trim(),
        'upin': _pinController.text.trim(),
        'upassword': _passwordController.text,
      });

      if (_selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'photo',
          _selectedImage!.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: "Account created successfully",
            backgroundColor: Colors.green.shade700,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MyLoginPage(title: '')),
          );
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? "Registration failed");
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F0FF),
              Color(0xFFEBE5FF),
              Color(0xFFE6DEFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Profile photo + picker
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade200,
                                  image: _selectedImage != null
                                      ? DecorationImage(
                                    image: FileImage(_selectedImage!),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: _selectedImage == null
                                    ? const Icon(
                                  Icons.person_outline_rounded,
                                  size: 60,
                                  color: Colors.grey,
                                )
                                    : null,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF7C3AED),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4C1D95),
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          "Join Smart Billing today",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // ─── Form fields ──────────────────────────────────────

                        _buildTextField(
                          controller: _nameController,
                          label: "Full Name",
                          icon: Icons.person_outline,
                          validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                        ),

                        _buildTextField(
                          controller: _emailController,
                          label: "Email",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v?.trim().isEmpty ?? true) return 'Required';
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v!)) return 'Invalid email';
                            return null;
                          },
                        ),

                        _buildTextField(
                          controller: _phoneController,
                          label: "Phone Number",
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            if (v?.trim().isEmpty ?? true) return 'Required';
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(v!)) return '10 digits required';
                            return null;
                          },
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _dobController,
                                label: "Date of Birth",
                                icon: Icons.calendar_today_outlined,
                                validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller: _genderController,
                                label: "Gender",
                                icon: Icons.wc_outlined,
                                validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),

                        _buildTextField(
                          controller: _placeController,
                          label: "Place",
                          icon: Icons.location_on_outlined,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _districtController,
                                label: "District",
                                icon: Icons.map_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller: _pinController,
                                label: "PIN Code",
                                icon: Icons.pin_outlined,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),

                        _buildPasswordField(
                          controller: _passwordController,
                          label: "Password",
                          obscure: _obscurePassword,
                          onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                          validator: (v) {
                            if (v?.isEmpty ?? true) return 'Required';
                            if (v!.length < 6) return 'At least 6 characters';
                            return null;
                          },
                        ),

                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          label: "Confirm Password",
                          obscure: _obscureConfirmPassword,
                          onToggle: () =>
                              setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          validator: (v) {
                            if (v != _passwordController.text) return "Passwords don't match";
                            return null;
                          },
                        ),

                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton.icon(
                            icon: _isLoading
                                ? const SizedBox.shrink()
                                : const Icon(Icons.arrow_forward_rounded),
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
                              "Create Account",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF7C3AED),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: _isLoading ? null : _submit,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const MyLoginPage(title: '')),
                                );
                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  color: Color(0xFF7C3AED),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade600) : null,
          filled: true,
          fillColor: Colors.white,
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
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.grey.shade600,
            ),
            onPressed: onToggle,
          ),
          filled: true,
          fillColor: Colors.white,
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
        validator: validator,
      ),
    );
  }
}