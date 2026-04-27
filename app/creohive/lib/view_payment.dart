import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({Key? key}) : super(key: key);

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  List<dynamic> payments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String url = prefs.getString("url") ?? '';
      String lid = prefs.getString("lid") ?? '';

      final response = await http.post(
        Uri.parse('$url/myapp/freelancer_view_payment_details/'),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'ok') {
          setState(() {
            payments = jsonData['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            payments = [];
            _isLoading = false;
          });
        }
      } else {
        throw Exception("Server error");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Details"),
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            onPressed: _fetchPayments,
            icon: const Icon(Icons.refresh),
            tooltip: "Reload",
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : payments.isEmpty
          ? const Center(
        child: Text(
          "No payment details available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          var p = payments[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: const Icon(Icons.payment, color: Colors.blue),
              ),
              title: Text(
                p['job'] ?? "Unknown Job",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text("Freelancer: ${p['client_name'] ?? ''}",
                      style: const TextStyle(color: Colors.black87)),
                  Text("Amount: ₹${p['amount'] ?? ''}",
                      style: const TextStyle(color: Colors.green)),
                  Text("Date: ${p['date'] ?? ''}",
                      style: const TextStyle(color: Colors.black54)),
                  Text("Status: ${p['status'] ?? ''}",
                      style: TextStyle(
                        color: (p['status'] == 'Completed')
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
