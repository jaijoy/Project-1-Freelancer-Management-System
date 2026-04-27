import 'dart:convert';
import 'package:creohive/complaint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class FreelancersComplaintView extends StatefulWidget {
  const FreelancersComplaintView({super.key});

  @override
  State<FreelancersComplaintView> createState() =>
      _FreelancersComplaintViewState();
}

class _FreelancersComplaintViewState extends State<FreelancersComplaintView> {
  List complaints = [];
  bool isLoading = true;

  // 🔹 Fetch complaint data from Django
  Future<void> fetchComplaints() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();

      final response = await http.post(
        Uri.parse("$urls/myapp/freelancers_complaint_view/"),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'ok') {
          setState(() {
            complaints = jsonData['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            complaints = [];
          });
        }
      } else {
        throw Exception('Failed to load complaints');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Complaints"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : complaints.isEmpty
          ? const Center(child: Text("No complaints found"))
          : RefreshIndicator(
        onRefresh: fetchComplaints,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: complaints.length,
          itemBuilder: (context, index) {
            final item = complaints[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date: ${item['date']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Complaint:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(item['complaint']),
                    const SizedBox(height: 10),
                    const Text(
                      "Reply:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      item['reply'].isNotEmpty
                          ? item['reply']
                          : "No reply yet",
                      style: TextStyle(
                        color: item['reply'].isNotEmpty
                            ? Colors.black
                            : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Go to Add Complaint Page
          bool? added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ComplaintForm()),
          );

          if (added == true) {
            fetchComplaints(); // refresh list when a new complaint is added
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}
