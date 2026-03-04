// import 'package:aicrm/changepassword.dart';
// import 'package:aicrm/editprofile.dart';
// import 'package:aicrm/home.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(const ViewProfile());
// }
//
// class ViewProfile extends StatelessWidget {
//   const ViewProfile({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'View Profile',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const ViewProfilePage(title: 'View Profile'),
//     );
//   }
// }
//
// class ViewProfilePage extends StatefulWidget {
//   const ViewProfilePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<ViewProfilePage> createState() => _ViewProfilePageState();
// }
//
// class _ViewProfilePageState extends State<ViewProfilePage> {
//
//   _ViewProfilePageState()
//   {
//     _send_data();
//   }
//   @override
//   Widget build(BuildContext context) {
//
//
//
//     return WillPopScope(
//       onWillPop: () async{ return true; },
//       child: Scaffold(
//         appBar: AppBar(
//           leading:IconButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>BankingDashboard()));
//           }, icon: Icon(Icons.arrow_back)),
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           title: Text(widget.title),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//
//
//               Column(
//                 children: [
//                   Image(image: NetworkImage(photo_),height: 200,width: 200,),
//                   Padding(
//                     padding: EdgeInsets.all(5),
//                   child: Text(name_),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Text(dob_),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Text(gender_),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Text(email_),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Text(phone_),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Text(place_),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Text(pin_),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Text(district_),
//                   ),
//
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => editprofile(title: "Edit Profile"),));
//                 },
//                 child: Text("Edit Profile"),
//               ),
//
//
//               ElevatedButton(onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(
//                   builder: (context) => userchangepassword(title: "Edit Profile"),));
//               }, child: Text('change password'))
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   String name_="";
//   String dob_="";
//   String gender_="";
//   String email_="";
//   String phone_="";
//   String place_="";
//   String pin_="";
//   String district_="";
//   String photo_="";
//
//   void _send_data() async{
//
//
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String img=sh.getString('img_url').toString();
//     String lid = sh.getString('lid').toString();
//
//     final urls = Uri.parse('$url/user_viewprofile_post/');
//     try {
//       final response = await http.post(urls, body: {
//       'lid':lid
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
//             name_= name;
//             dob_= dob;
//             gender_= gender;
//             email_= email;
//             phone_= phone;
//             place_= place;
//             pin_= pin;
//             district_= district;
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
// }
//
//
//
//
//



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'changepassword.dart';
import 'editprofile.dart';

// Replace with your actual imports
// import 'package:aicrm/editprofile.dart';
// import 'package:aicrm/changepassword.dart';
// import 'package:aicrm/home.dart';

void main() {
  runApp(const ViewProfileApp());
}

class ViewProfileApp extends StatelessWidget {
  const ViewProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'View Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
        ),
      ),
      home: const ViewProfilePage(title: 'My Profile'),
    );
  }
}

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key, required this.title});
  final String title;

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  bool _isLoading = true;

  String name = '';
  String dob = '';
  String gender = '';
  String email = '';
  String phone = '';
  String place = '';
  String pin = '';
  String district = '';
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final imgBase = sh.getString('img_url') ?? '';
      final lid = sh.getString('lid') ?? '';

      if (baseUrl.isEmpty || lid.isEmpty) {
        Fluttertoast.showToast(msg: "Session error. Please login again.");
        setState(() => _isLoading = false);
        return;
      }

      final uri = Uri.parse('$baseUrl/user_viewprofile_post/');

      final response = await http.post(uri, body: {'lid': lid});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          setState(() {
            name = data['name'] ?? 'Not set';
            dob = data['dob'] ?? '-';
            gender = data['gender'] ?? '-';
            email = data['email'] ?? '-';
            phone = data['phone'] ?? '-';
            place = data['place'] ?? '-';
            pin = data['pin'] ?? '-';
            district = data['district'] ?? '-';
            photoUrl = imgBase + (data['photo'] ?? '');

            _isLoading = false;
          });
        } else {
          Fluttertoast.showToast(msg: 'Profile not found');
          setState(() => _isLoading = false);
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF7C3AED), size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0x6F070607),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F5FF),
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          backgroundColor: const Color(0xFF7C3AED),
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Replace with your actual dashboard
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BankingDashboard()));
              Navigator.pop(context);
            },
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _fetchProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                // Profile header
                Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            // color: const Color(0xFF7C3AED).withOpacity(0.4),
                            color: const Color(0xFF070607).withOpacity(0.4),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                          photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                          child: photoUrl.isEmpty
                              ? const Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.grey,
                          )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        name.isEmpty ? 'User' : name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        email.isEmpty ? 'No email' : email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // // Info card
                // Card(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                //     child: Column(
                //       children: [
                //         _infoTile("Date of Birth", dob, Icons.cake_outlined),
                //         const Divider(height: 1, indent: 16, endIndent: 16),
                //         _infoTile("Gender", gender, Icons.wc_outlined),
                //         const Divider(height: 1, indent: 16, endIndent: 16),
                //         _infoTile("Phone", phone, Icons.phone_outlined),
                //         const Divider(height: 1, indent: 16, endIndent: 16),
                //         _infoTile("Place", place, Icons.location_on_outlined),
                //         const Divider(height: 1, indent: 16, endIndent: 16),
                //         _infoTile("PIN Code", pin, Icons.pin_outlined),
                //         const Divider(height: 1, indent: 16, endIndent: 16),
                //         _infoTile("District", district, Icons.map_outlined),
                //       ],
                //     ),
                //   ),
                // ),

                Card(
                  color: const Color(0xFFF8FFFB),   // very light gray - clean & premium
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Column(
                      children: [
                        _infoTile("Date of Birth", dob, Icons.cake_outlined),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _infoTile("Gender", gender, Icons.wc_outlined),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _infoTile("Phone", phone, Icons.phone_outlined),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _infoTile("Place", place, Icons.location_on_outlined),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _infoTile("PIN Code", pin, Icons.pin_outlined),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _infoTile("District", district, Icons.map_outlined),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text("Edit Profile"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => editprofile(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.lock_reset_outlined),
                        label: const Text("Change Password"),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangePasswordPage(),
                            ),
                          );
                        },
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
}