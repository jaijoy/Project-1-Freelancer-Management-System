import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FreelancersJobView extends StatefulWidget {
  const FreelancersJobView({super.key});

  @override
  State<FreelancersJobView> createState() => _FreelancersJobViewState();
}

class _FreelancersJobViewState extends State<FreelancersJobView> {
  List jobs = [];
  bool isLoading = true;
  late String urls;
  late String lid;
  late String imgurl;

  // 🔹 Fetch all jobs
  Future<void> fetchJobs() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      urls = sh.getString('url').toString();
      imgurl = sh.getString('imgurl').toString();
      lid = sh.getString('lid').toString();

      final response = await http.post(
        Uri.parse("$urls/myapp/freelancers_job_view/"),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'ok') {
          setState(() {
            jobs = jsonData['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            jobs = [];
          });
        }
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // 🔹 Send Job Request
  Future<void> sendRequest(String jobId) async {
    try {
      final response = await http.post(
        Uri.parse("$urls/myapp/freelancers_job_requests_POST/"),
        body: {
          'lid': lid, // freelancer LOGIN id
          'job_id': jobId, // job id
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'].toString().toLowerCase() == 'ok') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Request sent successfully!")),
          );
        } else if (jsonData['status'] == 'exists') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("You already sent a request for this job.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${jsonData['status']}")),
          );
        }
      } else {
        throw Exception('Failed to send request');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Available Jobs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 3,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
          ? const Center(
        child: Text(
          "No jobs available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchJobs,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // 🔹 Top Section - Client Info
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            "$imgurl${job['c_photo']}",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                job['c_name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                job['c_email'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "📞 ${job['c_phone']}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔹 Job Details
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.description_outlined,
                                color: Colors.blueAccent, size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                                child: Text(job['discription'])),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.work_outline,
                                color: Colors.blueAccent, size: 18),
                            const SizedBox(width: 6),
                            Text(
                                "Experience: ${job['experience']}"),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                color: Colors.blueAccent, size: 18),
                            const SizedBox(width: 6),
                            Text("Date: ${job['date']}"),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.info_outline,
                                color: Colors.blueAccent, size: 18),
                            const SizedBox(width: 6),
                            Text("Status: ${job['status']}"),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              sendRequest(job['id'].toString());
                            },
                            icon: const Icon(Icons.send_rounded),
                            label: const Text(
                              "Send Request",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}



