import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PayAmount extends StatefulWidget {
  final String title;
  final String vid;
  final String amount;

  const PayAmount({
    super.key,
    required this.title,
    required this.vid,
    required this.amount,
  });

  @override
  State<PayAmount> createState() => _PayAmountState();
}

class _PayAmountState extends State<PayAmount> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Auto-open payment when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openCheckout();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_HKCAwYtLt0rwQe', // replace with your Razorpay key
      'amount': int.parse(widget.amount) * 100,
      'name': 'Traffic Fine Payment',
      'description': 'Fine ID: ${widget.vid}',
      'prefill': {'contact': '9747360170', 'email': 'test@gmail.com'},
      'external': {'wallets': ['paytm']}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await _sendData(response.paymentId ?? "");
    Fluttertoast.showToast(msg: "Payment Successful");
    Navigator.pop(context, true); // return back to fines page
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed: ${response.message}");
    Navigator.pop(context, false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External Wallet Selected: ${response.walletName}");
  }

  Future<void> _sendData(String paymentId) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";
    String lid = sh.getString('lid') ?? "";

    final uri = Uri.parse('$url/makepayment/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['vid'] = widget.vid;
    request.fields['amount'] = widget.amount;
    request.fields['lid'] = lid;
    request.fields['payment_id'] = paymentId;

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (!(response.statusCode == 200 && data['status'] == 'ok')) {
        Fluttertoast.showToast(msg: "Server rejected payment");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text("Processing Payment...", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
