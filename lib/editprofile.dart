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
//   runApp( editprofile(title: '',));
// }
//
// class editprofile extends StatefulWidget {
//   const editprofile({super.key, required this.title});
//
//   final String title;
//   @override
//   State<editprofile> createState() => _editprofileState();
//
// }
// class _editprofileState extends State<editprofile> {
//
//   _editprofileState(){
//     _get_data();
//   }
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
//   String photo_="";
//
//   void _get_data() async{
//
//
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//     String img=sh.getString('img_url').toString();
//
//
//     final urls = Uri.parse('$url/user_viewprofile_post/');
//     try {
//       final response = await http.post(urls, body: {
//         'lid':lid
//
//
//
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status=='ok') {
//           String name=jsonDecode(response.body)['name'];
//           String dob=jsonDecode(response.body)['dob'];
//           String gender=jsonDecode(response.body)['gender'];
//           String email=jsonDecode(response.body)['email'];
//           String phone=jsonDecode(response.body)['phone'];
//           String place=jsonDecode(response.body)['place'];
//           String pin=jsonDecode(response.body)['pin'];
//           String district=jsonDecode(response.body)['district'];
//           String photo=img+jsonDecode(response.body)['photo'];
//
//           setState(() {
//
//             _nametextController.text= name;
//             _dobtextController.text= dob;
//             _gendertextController.text= gender;
//             _emailtextController.text= email;
//             _phonenotextController.text= phone;
//             _placetextController.text= place;
//             _pintextController.text= pin;
//             _districttextController.text= district;
//             photo_= photo;
//           });
//
//
//
//
//
//         }else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       }
//       else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     }
//     catch (e){
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
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
//     final uri = Uri.parse('$url/user_editprofile_post/');
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['uname'] = uname;
//     request.fields['uemail'] = uemail;
//     request.fields['uphoneno'] = uphone;
//     request.fields['udob'] = udob;
//     request.fields['ugender'] = ugender;
//     request.fields['uplace'] = uplace;
//     request.fields['udistrict'] = udistrict;
//     request.fields['upin'] = upin;
//     request.fields['lid'] = lid!;
//
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
//           MaterialPageRoute(builder: (context) => const BankingDashboard()),
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
//                 _selectedImage != null
//                     ? Image.file(_selectedImage!, height: 150)
//                     : Image(image: NetworkImage(photo_),height: 80,width: 130,),
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






import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'home.dart'; // BankingDashboard

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: editprofile(),
  ));
}

class editprofile extends StatefulWidget {
  const editprofile({super.key});

  @override
  State<editprofile> createState() => _editprofileState();
}

class _editprofileState extends State<editprofile>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _placeController = TextEditingController();
  final _districtController = TextEditingController();
  final _pinController = TextEditingController();

  File? _selectedImage;
  String _currentPhotoUrl = '';
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

    _loadCurrentProfile();
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
    super.dispose();
  }

  Future<void> _loadCurrentProfile() async {
    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final imgBase = sh.getString('img_url') ?? '';
      final lid = sh.getString('lid') ?? '';

      if (baseUrl.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: "Session error. Please login again.");
        return;
      }

      final uri = Uri.parse('$baseUrl/user_viewprofile_post/');
      final response = await http.post(uri, body: {'lid': lid});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            _nameController.text = data['name'] ?? '';
            _dobController.text = data['dob'] ?? '';
            _genderController.text = data['gender'] ?? '';
            _emailController.text = data['email'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _placeController.text = data['place'] ?? '';
            _districtController.text = data['district'] ?? '';
            _pinController.text = data['pin'] ?? '';
            _currentPhotoUrl = imgBase + (data['photo'] ?? '');
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to load profile');
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null && mounted) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (_) {
      Fluttertoast.showToast(msg: "Couldn't pick image");
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final lid = sh.getString('lid') ?? '';

      if (baseUrl.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: "Session error");
        return;
      }

      final uri = Uri.parse('$baseUrl/user_editprofile_post/');

      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'lid': lid,
        'uname': _nameController.text.trim(),
        'uemail': _emailController.text.trim(),
        'uphoneno': _phoneController.text.trim(),
        'udob': _dobController.text.trim(),
        'ugender': _genderController.text.trim(),
        'uplace': _placeController.text.trim(),
        'udistrict': _districtController.text.trim(),
        'upin': _pinController.text.trim(),
      });

      if (_selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'photo',
          _selectedImage!.path,
        ));
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: "Profile updated successfully",
            backgroundColor: Colors.green.shade700,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BankingDashboard()),
          );
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? "Update failed");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),

                    // Profile Picture
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                              image: DecorationImage(
                                image: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : (_currentPhotoUrl.isNotEmpty
                                    ? NetworkImage(_currentPhotoUrl)
                                    : const AssetImage('assets/placeholder.png') as ImageProvider),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
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

                    const SizedBox(height: 12),
                    Text(
                      "Tap to change profile picture",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Form Fields
                    _buildTextField(
                      controller: _nameController,
                      label: "Full Name",
                      icon: Icons.person_outline_rounded,
                    ),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _dobController,
                            label: "Date of Birth",
                            icon: Icons.calendar_today_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _genderController,
                            label: "Gender",
                            icon: Icons.wc_outlined,
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
                        const SizedBox(width: 16),
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

                    const SizedBox(height: 48),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        icon: _isLoading
                            ? const SizedBox.shrink()
                            : const Icon(Icons.save_rounded),
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
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _isLoading ? null : _updateProfile,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.black,              // <--- text color is black
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: const TextStyle(
            color: Color(0xFF7C3AED),
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.deepPurple.shade600,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }
}