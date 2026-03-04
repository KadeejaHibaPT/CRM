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
//       home: const viewseller(title: 'View Profile'),
//     );
//   }
// }
//
// class viewseller extends StatefulWidget {
//   const viewseller({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<viewseller> createState() => _viewsellerState();
// }
//
// class _viewsellerState extends State<viewseller> {
//
//   _viewsellerState()
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
//           leading: BackButton( ),
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
//                   Image(image: NetworkImage(logo_),height: 200,width: 200,),
//                   Padding(
//                     padding: EdgeInsets.all(5),
//                   child: Text(name_),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Text(since_),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Text(license_),
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
//
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
//   String since_="";
//   String license_="";
//   String email_="";
//   String phone_="";
//   String place_="";
//   String pin_="";
//   String district_="";
//   String logo_="";
//
//   void _send_data() async{
//
//
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String img_url = sh.getString('img_url').toString();
//     String id = sh.getString('pid').toString();
//
//     final urls = Uri.parse('$url/user_viewsellerinformation_post/');
//     try {
//       final response = await http.post(urls, body: {
//       'id':id.toString(),
//
//
//
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status=='ok') {
//           String name=jsonDecode(response.body)['name'];
//           String since=jsonDecode(response.body)['since'];
//           String license=jsonDecode(response.body)['license'];
//           String email=jsonDecode(response.body)['email'];
//           String phone=jsonDecode(response.body)['phone'];
//           String place=jsonDecode(response.body)['place'];
//           String pin=jsonDecode(response.body)['pin'];
//           String district=jsonDecode(response.body)['district'];
//           String logo=img_url+jsonDecode(response.body)['logo'];
//
//           setState(() {
//
//             name_= name;
//             since_= since;
//             license_= license;
//             email_= email;
//             phone_= phone;
//             place_= place;
//             pin_= pin;
//             district_= district;
//             logo_= logo;
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



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart'; // BankingDashboard (back button destination)

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ViewSellerPage(),
  ));
}

class ViewSellerPage extends StatefulWidget {
  const ViewSellerPage({super.key});

  @override
  State<ViewSellerPage> createState() => _ViewSellerPageState();
}

class _ViewSellerPageState extends State<ViewSellerPage> {
  bool isLoading = true;

  String name = '';
  String since = '';
  String license = '';
  String email = '';
  String phone = '';
  String place = '';
  String pin = '';
  String district = '';
  String logoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadSellerInfo();
  }

  Future<void> _loadSellerInfo() async {
    setState(() => isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      final baseUrl = sh.getString('url') ?? '';
      final imgBase = sh.getString('img_url') ?? '';
      final pid = sh.getString('pid') ?? '';

      if (baseUrl.isEmpty || pid.isEmpty) {
        Fluttertoast.showToast(msg: "Session error. Please try again.");
        return;
      }

      final uri = Uri.parse('$baseUrl/user_viewsellerinformation_post/');

      final response = await http.post(uri, body: {'id': pid});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          setState(() {
            name = data['name'] ?? '—';
            since = data['since'] ?? '—';
            license = data['license'] ?? '—';
            email = data['email'] ?? '—';
            phone = data['phone'] ?? '—';
            place = data['place'] ?? '—';
            pin = data['pin'] ?? '—';
            district = data['district'] ?? '—';
            logoUrl = imgBase + (data['logo'] ?? '');
            isLoading = false;
          });
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? 'Seller not found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 26,
          ),
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
                  value.isEmpty ? '—' : value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF070607),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("Seller Profile"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color(0xFFF8FFFB),
        elevation: 0.6,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BankingDashboard()),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadSellerInfo,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Seller Logo / Avatar
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: const Color(0xFFF3F4F6),
                        backgroundImage:
                        logoUrl.isNotEmpty ? NetworkImage(logoUrl) : null,
                        child: logoUrl.isEmpty
                            ? const Icon(
                          Icons.store_rounded,
                          size: 70,
                          color: Color(0xFF9CA3AF),
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF070607),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Info Card
              // Card(
              //   elevation: 2,
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 15),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10),
              //     child: Column(
              //       children: [
              //         _infoRow("Business Since", since, Icons.calendar_today_outlined),
              //         const Divider(height: 1, indent: 56, endIndent: 24),
              //         _infoRow("License Number", license, Icons.verified_outlined),
              //         const Divider(height: 1, indent: 56, endIndent: 24),
              //         _infoRow("Phone", phone, Icons.phone_outlined),
              //         const Divider(height: 1, indent: 56, endIndent: 24),
              //         _infoRow("Place", place, Icons.location_on_outlined),
              //         const Divider(height: 1, indent: 56, endIndent: 24),
              //         _infoRow("PIN Code", pin, Icons.pin_outlined),
              //         const Divider(height: 1, indent: 56, endIndent: 24),
              //         _infoRow("District", district, Icons.map_outlined),
              //       ],
              //     ),
              //   ),
              //   ),
              // ),

              Card(
                elevation: 2,
                color: const Color(0xFFFAFAFA), // very light gray / soft off-white
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        _infoRow("Business Since", since, Icons.calendar_today_outlined),
                        const Divider(height: 1, indent: 56, endIndent: 24),
                        _infoRow("License Number", license, Icons.verified_outlined),
                        const Divider(height: 1, indent: 56, endIndent: 24),
                        _infoRow("Phone", phone, Icons.phone_outlined),
                        const Divider(height: 1, indent: 56, endIndent: 24),
                        _infoRow("Place", place, Icons.location_on_outlined),
                        const Divider(height: 1, indent: 56, endIndent: 24),
                        _infoRow("PIN Code", pin, Icons.pin_outlined),
                        const Divider(height: 1, indent: 56, endIndent: 24),
                        _infoRow("District", district, Icons.map_outlined),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}





