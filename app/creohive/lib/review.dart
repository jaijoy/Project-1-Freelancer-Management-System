import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FreelancerReviewsPage extends StatefulWidget {
  const FreelancerReviewsPage({super.key});

  @override
  State<FreelancerReviewsPage> createState() => _FreelancerReviewsPageState();
}

class _FreelancerReviewsPageState extends State<FreelancerReviewsPage> {
  List reviews = [];
  bool isLoading = true;
  String? urls;
  String? lid;
  String? imgurl;

  // 🔹 Fetch reviews from Django API
  Future<void> fetchReviews() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      urls = sh.getString('url');
      lid = sh.getString('lid');
      imgurl = sh.getString('imgurl');

      if (urls == null || lid == null) {
        throw Exception("URL or LID not found in SharedPreferences");
      }

      final response = await http.post(
        Uri.parse("$urls/myapp/freelancer_review/"),
        body: {'lid': lid!},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'ok') {
          setState(() {
            reviews = jsonData['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            reviews = [];
          });
        }
      } else {
        throw Exception("Failed to load reviews");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // 🔹 Display star rating
  Widget buildRatingStars(String rating) {
    int rate = int.tryParse(rating) ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
            (index) => Icon(
          index < rate ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 22,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Client Reviews",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 3,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reviews.isEmpty
          ? const Center(
        child: Text(
          "No reviews yet",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchReviews,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final rev = reviews[index];
            // 🔹 Get image URL safely
            final img = rev['client_image']?.toString() ?? '';
            final imageUrl = imgurl != null
                ? "$imgurl$img"
                : img; // prepend base URL if needed

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Client Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                          Colors.blueAccent.withOpacity(0.2),
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null,
                          child: imageUrl.isEmpty
                              ? const Icon(Icons.person,
                              color: Colors.grey, size: 30)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                rev['client_name'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                rev['client_email'] ?? '',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 🔹 Review Text
                    Text(
                      rev['review'] ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 🔹 Rating Stars
                    Center(
                      child: buildRatingStars(
                        rev['rating'].toString(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
