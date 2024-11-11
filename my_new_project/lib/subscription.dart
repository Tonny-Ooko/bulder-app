import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final String paybillNumber = '4224574';
  final String callbackUrl = 'confirmation.techonwardfintech.com';
  final String consumerKey = 'GV4vURSNke8X9xLvNfayUoqxkUv3kQK3lr6UlqEcw2VAUlD4';
  final String consumerSecret = 'Xz23qQXE06lGXwnOFGL1aFrQDslR1Na6Ea2xAeiG3muGYJHRP09SOLXAwcdw992t';
  FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _subscriptionReminderTimer;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    checkSubscriptionExpiry();
  }

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTime = prefs.getInt('login_time') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - loginTime > 86400000) { // 24 hours in milliseconds
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> loginWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('login_time', DateTime.now().millisecondsSinceEpoch);
      Navigator.pushReplacementNamed(context, '/subscription');
    }
  }

  Future<String> getAccessToken() async {
    String auth = base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
    final response = await http.post(
      Uri.parse('https://api.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials'),
      headers: {
        'Authorization': 'Basic $auth',
        'Content-Type': 'application/json'
      },
    );
    final data = jsonDecode(response.body);
    return data['access_token'];
  }

  Future<void> initiateMpesaPayment(String amount, String phoneNumber) async {
    String accessToken = await getAccessToken();
    final response = await http.post(
      Uri.parse('https://api.safaricom.co.ke/mpesa/paybill/v1/paymentrequest'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "BusinessShortCode": paybillNumber,
        "Amount": amount,
        "PartyA": phoneNumber,
        "PartyB": paybillNumber,
        "PhoneNumber": phoneNumber,
        "CallBackURL": callbackUrl,
        "TransactionType": "CustomerPayBillOnline",
        "AccountReference": "YourAccountReference",
        "TransactionDesc": "Payment for service"
      }),
    );

    if (response.statusCode == 200) {
      print("Payment request sent successfully.");
    } else {
      print("Error initiating payment: ${response.body}");
    }
  }

  Future<void> initiateVisaPayment(double amount) async {
    // Implement Visa Payment API call
    print("Initiating Visa Payment for $amount");
  }

  Future<void> initiatePayPalPayment(double amount) async {
    // Implement PayPal Payment API call
    print("Initiating PayPal Payment for $amount");
  }

  void subscribe(double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => initiateMpesaPayment(amount.toString(), 'YOUR_PHONE_NUMBER'),
                child: Text('M-Pesa'),
              ),
              ElevatedButton(
                onPressed: () => initiateVisaPayment(amount),
                child: Text('Visa'),
              ),
              ElevatedButton(
                onPressed: () => initiatePayPalPayment(amount),
                child: Text('PayPal'),
              ),
            ],
          ),
        );
      },
    );
  }

  void checkSubscriptionExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    final subscriptionEnd = prefs.getInt('subscription_end') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime > subscriptionEnd) {
      // Subscription expired
      showReminder("Your subscription has expired. Renew now!");
    } else {
      // Start a timer to remind the user when subscription is about to expire
      final remainingTime = subscriptionEnd - currentTime;
      _subscriptionReminderTimer = Timer.periodic(Duration(days: 1), (timer) {
        final remainingDays = ((subscriptionEnd - DateTime.now().millisecondsSinceEpoch) / 86400000).ceil();
        if (remainingDays <= 3) {
          showReminder("Your subscription will expire in $remainingDays day(s). Please renew.");
        }
        if (remainingDays <= 0) {
          timer.cancel();
          showReminder("Your subscription has expired. Renew now!");
        }
      });
    }
  }

  void showReminder(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _subscriptionReminderTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subscription Plans')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select a subscription plan:'),
            ElevatedButton(onPressed: () => subscribe(1.0), child: Text('1 Day - \$1')),
            ElevatedButton(onPressed: () => subscribe(3.8), child: Text('1 Week - \$3.8')),
            ElevatedButton(onPressed: () => subscribe(15.5), child: Text('1 Month - \$15.5')),
            ElevatedButton(onPressed: () => subscribe(38.76), child: Text('3 Months - \$38.76')),
            ElevatedButton(onPressed: () => subscribe(155.8), child: Text('1 Year - \$155.8')),
          ],
        ),
      ),
    );
  }
}
