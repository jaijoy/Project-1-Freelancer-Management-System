
import 'dart:convert';
import 'package:creohive/chat.dart';
import 'package:creohive/homePage.dart';
import 'package:creohive/update_report.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FreelancerJobRequestStatus extends StatefulWidget {
  const FreelancerJobRequestStatus({super.key});

  @override
  State<FreelancerJobRequestStatus> createState() => _FreelancerJobRequestStatusState();
}

class _FreelancerJobRequestStatusState extends State<FreelancerJobRequestStatus> {
  List requests = [];
  bool isLoading = true;
  late String urls;
  late String imgurl;
  late String lid;

  // 🔹 Fetch job requests
  Future<void> fetchRequests() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      urls = sh.getString('url').toString();
      imgurl = sh.getString('imgurl').toString();
      lid = sh.getString('lid').toString();

      final response = await http.post(
        Uri.parse("$urls/myapp/freelancers_job_request_status_view/"),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'ok') {
          setState(() {
            requests = jsonData['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            requests = [];
          });
        }
      } else {
        throw Exception("Failed to load job status");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // 🔹 Get status color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }
  // child: IconButton(
  // onPressed: () {
  // // Navigator.pop(context);
  // Navigator.push(context,
  // MaterialPageRoute(
  // builder: (context) => FreelancerJobRequestStatus(),
  // ),
  //
  //
  // );
  // },
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color:Colors.white),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage() ),);
          },
        ),

        title: const Text(
          "My Job Requests",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),



        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 3,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const Center(
        child: Text(
          "No job requests yet",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchRequests,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: requests.length,
          itemBuilder: (context, index) {

            final req = requests[index];
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
                  // 🔹 Client Info
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
                            "$imgurl${req['client_photo']}",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                req['client_name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                req['client_email'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "📞 ${req['client_phone']}",
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

                  // 🔹 Job Details Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          req['job_title'],
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
                                child:
                                Text(req['job_discription'])),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.work_outline,
                                color: Colors.blueAccent, size: 18),
                            const SizedBox(width: 6),
                            Text(
                                "Experience: ${req['job_experience']}"),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                color: Colors.blueAccent, size: 18),
                            const SizedBox(width: 6),
                            Text(
                                "Posted Date: ${req['job_posted_date']}"),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.date_range_outlined,
                                color: Colors.blueAccent, size: 18),
                            const SizedBox(width: 6),
                            Text(
                                "Requested On: ${req['job_requested_date']}"),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // 🔹 Status + Update + Chat buttons in one row
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.info_outline,
                                    color: Colors.blueAccent,
                                    size: 18),
                                const SizedBox(width: 6),
                                const Text("Status: ",
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold)),
                                Chip(
                                  label: Text(
                                    req['job_request_status'],
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                  backgroundColor: getStatusColor(
                                      req['job_request_status']),
                                ),
                              ],
                            ),
// ---------------------------------------------------------------------------------------------------------------
                            if (req['job_request_status']
                                .toLowerCase() ==
                                'completed')
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      SharedPreferences sh = await SharedPreferences.getInstance();
                                      await sh.setString("clid", req['client_id'].toString());
                                      // print(req['client_id']);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const MyChatApp(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "Chat",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                ],
                              ),

      // --------------------------------------------------------------------------------------------------------

                            if (req['job_request_status'].toLowerCase() == 'approved' ||
                                req['job_request_status'].toLowerCase() == 'incompleted')
                              Column(
                                children: [
                                  // 🔹 Chat Button
                                  ElevatedButton(
                                    onPressed: () async {
                                      SharedPreferences sh = await SharedPreferences.getInstance();
                                      await sh.setString("clid", req['client_id'].toString());
                                      // print(req['client_id']);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const MyChatApp(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "Chat",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // 🔹 Update Button
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateReportPage(
                                            jobId: req['job_id'],
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "Update",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),


                          ],
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




//
// import 'dart:convert';
// import 'package:creohive/update_report.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class FreelancerJobRequestStatus extends StatefulWidget {
//   const FreelancerJobRequestStatus({super.key});
//
//   @override
//   State<FreelancerJobRequestStatus> createState() => _FreelancerJobRequestStatusState();
// }
//
// class _FreelancerJobRequestStatusState extends State<FreelancerJobRequestStatus> {
//   List requests = [];
//   bool isLoading = true;
//   late String urls;
//   late String imgurl;
//   late String lid;
//
//   // 🔹 Fetch job requests
//   Future<void> fetchRequests() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       urls = sh.getString('url').toString();
//       imgurl = sh.getString('imgurl').toString();
//       lid = sh.getString('lid').toString();
//
//       final response = await http.post(
//         Uri.parse("$urls/myapp/freelancers_job_request_status_view/"),
//         body: {'lid': lid},
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         if (jsonData['status'] == 'ok') {
//           setState(() {
//             requests = jsonData['data'];
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//             requests = [];
//           });
//         }
//       } else {
//         throw Exception("Failed to load job requests");
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }
//
//   // 🔹 Get status color
//   Color getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Colors.orange;
//       case 'approved':
//         return Colors.green;
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRequests();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text(
//           "My Job Requests",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//         elevation: 3,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : requests.isEmpty
//           ? const Center(
//         child: Text(
//           "No job requests yet",
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       )
//           : RefreshIndicator(
//         onRefresh: fetchRequests,
//         child: ListView.builder(
//           padding: const EdgeInsets.all(12),
//           itemCount: requests.length,
//           itemBuilder: (context, index) {
//             final req = requests[index];
//             return Container(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 6,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//                 color: Colors.white,
//               ),
//               child: Column(
//                 children: [
//                   // 🔹 Client Info
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.blueAccent,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16),
//                       ),
//                     ),
//                     padding: const EdgeInsets.all(16),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         CircleAvatar(
//                           radius: 32,
//                           backgroundColor: Colors.white,
//                           backgroundImage: NetworkImage(
//                             "$imgurl${req['client_photo']}",
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 req['client_name'],
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 req['client_email'],
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 "📞 ${req['client_phone']}",
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // 🔹 Job Details Section
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           req['job_title'],
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             const Icon(Icons.description_outlined,
//                                 color: Colors.blueAccent, size: 18),
//                             const SizedBox(width: 6),
//                             Expanded(
//                                 child:
//                                 Text(req['job_discription'])),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             const Icon(Icons.work_outline,
//                                 color: Colors.blueAccent, size: 18),
//                             const SizedBox(width: 6),
//                             Text(
//                                 "Experience: ${req['job_experience']}"),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             const Icon(Icons.calendar_today_outlined,
//                                 color: Colors.blueAccent, size: 18),
//                             const SizedBox(width: 6),
//                             Text(
//                                 "Posted Date: ${req['job_posted_date']}"),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             const Icon(Icons.date_range_outlined,
//                                 color: Colors.blueAccent, size: 18),
//                             const SizedBox(width: 6),
//                             Text(
//                                 "Requested On: ${req['job_requested_date']}"),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//
//                         // 🔹 Status + Update button in one row
//                         Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 const Icon(Icons.info_outline,
//                                     color: Colors.blueAccent,
//                                     size: 18),
//                                 const SizedBox(width: 6),
//                                 const Text("Status: ",
//                                     style: TextStyle(
//                                         fontWeight:
//                                         FontWeight.bold)),
//                                 Chip(
//                                   label: Text(
//                                     req['job_request_status'],
//                                     style: const TextStyle(
//                                         color: Colors.white),
//                                   ),
//                                   backgroundColor: getStatusColor(
//                                       req['job_request_status']),
//                                 ),
//                               ],
//                             ),
//
//                             // 🔹 Update button (only if approved)
//                             if (req['job_request_status']
//                                 .toLowerCase() ==
//                                 'approved')
//                               ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => UpdateReportPage(jobId: req['job_id'],),
//                                     ),
//                                   );
//                                 },
//
//
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 8),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                     BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   "Update",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


//before putting update button
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class FreelancerJobRequestStatus extends StatefulWidget {
//   const FreelancerJobRequestStatus({super.key});
//
//   @override
//   State<FreelancerJobRequestStatus> createState() => _FreelancerJobRequestStatusState();
// }
//
// class _FreelancerJobRequestStatusState extends State<FreelancerJobRequestStatus> {
//   List requests = [];
//   bool isLoading = true;
//   late String urls;
//   late String imgurl;
//   late String lid;
//
//   // 🔹 Fetch job requests
//   Future<void> fetchRequests() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       urls = sh.getString('url').toString();
//       imgurl = sh.getString('imgurl').toString();
//       lid = sh.getString('lid').toString();
//
//       final response = await http.post(
//         Uri.parse("$urls/myapp/freelancers_job_request_status_view/"),
//         body: {'lid': lid},
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         if (jsonData['status'] == 'ok') {
//           setState(() {
//             requests = jsonData['data'];
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//             requests = [];
//           });
//         }
//       } else {
//         throw Exception("Failed to load job requests");
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }
//
//   // 🔹 Get status color
//   Color getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Colors.orange;
//       case 'approved':
//         return Colors.green;
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRequests();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text(
//           "My Job Requests",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//         elevation: 3,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : requests.isEmpty
//           ? const Center(
//         child: Text(
//           "No job requests yet",
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       )
//           : RefreshIndicator(
//         onRefresh: fetchRequests,
//         child: ListView.builder(
//           padding: const EdgeInsets.all(12),
//           itemCount: requests.length,
//           itemBuilder: (context, index) {
//             final req = requests[index];
//             return Container(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 6,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//                 color: Colors.white,
//               ),
//               child: Column(
//                 children: [
//                   // 🔹 Client Info
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.blueAccent,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16),
//                       ),
//                     ),
//                     padding: const EdgeInsets.all(16),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         CircleAvatar(
//                           radius: 32,
//                           backgroundColor: Colors.white,
//                           backgroundImage: NetworkImage(
//                             "$imgurl${req['client_photo']}",
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 req['client_name'],
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 req['client_email'],
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 "📞 ${req['client_phone']}",
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // 🔹 Job Details Section
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           req['job_title'],
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             const Icon(Icons.description_outlined,
//                                 color: Colors.blueAccent, size: 18),
//                             const SizedBox(width: 6),
//                             Expanded(child: Text(req['job_discription'])),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             const Icon(Icons.work_outline,
//                                 color: Colors.blueAccent, size: 18),
//                             const SizedBox(width: 6),
//                             Text("Experience: ${req['job_experience']}"),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             const Icon(Icons.calendar_today_outlined,
//                                 color: Colors.blueAccent, size: 18),
//                             const SizedBox(width: 6),
//                             Text("Posted Date: ${req['job_posted_date']}"),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             const Icon(Icons.date_range_outlined,
//                                 color: Colors.blueAccent, size: 18),
//                             const SizedBox(width: 6),
//                             Text("Requested On: ${req['job_requested_date']}"),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             const Icon(Icons.info_outline,
//                                 color: Colors.blueAccent, size: 18),
//                             const SizedBox(width: 6),
//                             Text("Status: ",
//                                 style: const TextStyle(fontWeight: FontWeight.bold)),
//                             Chip(
//                               label: Text(
//                                 req['job_request_status'],
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                               backgroundColor:
//                               getStatusColor(req['job_request_status']),
//                             ),
//                           ],
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
