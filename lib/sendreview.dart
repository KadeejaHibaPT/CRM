import 'dart:convert';
import 'dart:io';
import 'package:aicrm/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'home.dart';


void main() {
  runApp( sendreview(title: '',));
}

class sendreview extends StatefulWidget {
  const sendreview({super.key, required this.title});

  final String title;
  @override
  State<sendreview> createState() => _sendreviewState();

}
class _sendreviewState extends State<sendreview> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewtextController = TextEditingController();
  final TextEditingController _ratingtextController = TextEditingController();




  Future<void> _sendData() async {
    String review = _reviewtextController.text;
    String rating = _ratingtextController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? product_id = sh.getString('product_id');
    String? lid = sh.getString('lid');

    if (url == null) {
      Fluttertoast.showToast(msg: "Server URL not found.");
      return;
    }

    final uri = Uri.parse('$url/user_sendreview/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['product_id'] = product_id.toString();
    request.fields['lid'] = lid.toString();
    request.fields['review'] = review;
    request.fields['rating'] = rating;


    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(msg: "Submitted successfully.");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BankingDashboard()),
        );

      } else {
        Fluttertoast.showToast(msg: "Submission failed.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BankingDashboard()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                const SizedBox(height: 20),
                TextFormField(
                  controller: _reviewtextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Review',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Review is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ratingtextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Rating',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Rating is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _sendData();
                    } else {
                      Fluttertoast.showToast(msg: "Please fix errors in the form");
                    }
                  },
                  child: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

