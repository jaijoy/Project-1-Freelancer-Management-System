// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
//
// class UpdateReportPage extends StatefulWidget {
//   final String jobId;
//
//   const UpdateReportPage({super.key, required this.jobId});
//
//   @override
//   State<UpdateReportPage> createState() => _UpdateReportPageState();
// }
//
// class _UpdateReportPageState extends State<UpdateReportPage> {
//   final TextEditingController reportController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//   String? selectedStatus;
//   bool isLoading = false;
//   Map<String, dynamic>? reportData; // store fetched report details
//
//   // 🔹 Automatically fetch report when the page opens
//   @override
//   void initState() {
//     super.initState();
//     viewReport(); // 👈 load the report when screen opens
//   }
//
//   // --------------------------------------------------------------------------
//   Future<void> submitReport() async {
//     final report = reportController.text.trim();
//     final amount = amountController.text.trim();
//
//     if (report.isEmpty || selectedStatus == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill in all fields")),
//       );
//       return;
//     }
//
//     if (selectedStatus == "Completed" && amount.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter amount for completed jobs")),
//       );
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String urls = sh.getString('url').toString();
//
//     final response = await http.post(
//       Uri.parse("$urls/myapp/freelancer_job_report/"),
//       body: {
//         'job_id': widget.jobId.toString(),
//         'report': report,
//         'amount': selectedStatus == "Completed" ? amount : "0",
//         'status': selectedStatus!,
//       },
//     );
//
//     final jsonData = jsonDecode(response.body);
//     print("Response: $jsonData");
//
//     if (jsonData['status'].toString().toLowerCase() == 'ok') {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Report submitted successfully ✅")),
//       );
//       reportController.clear();
//       amountController.clear();
//       setState(() => selectedStatus = null);
//
//
//       viewReport();
//     } else if (jsonData['status'].toString().toLowerCase() == 'not ok') {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Error: work already completed")),
//       );
//     }
//
//     setState(() => isLoading = false);
//   }
//
//   // --------------------------------------------------------------------------
//   Future<void> viewReport() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String urls = sh.getString('url').toString();
//
//     final response = await http.post(
//       Uri.parse("$urls/myapp/view_report/"),
//       body: {'job_id': widget.jobId.toString()},
//     );
//
//     final jsonData = jsonDecode(response.body);
//     print("Fetched report: $jsonData");
//
//     if (jsonData['status'] == 'ok') {
//       setState(() {
//         reportData = jsonData['data'];
//       });
//     } else {
//       setState(() {
//         reportData = null;
//       });
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   // --------------------------------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Update Report"),
//         backgroundColor: Colors.green,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               DropdownButtonFormField<String>(
//                 value: selectedStatus,
//                 decoration: InputDecoration(
//                   labelText: "Select Status",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   prefixIcon:
//                   const Icon(Icons.assignment_turned_in_outlined),
//                 ),
//                 items: const [
//                   DropdownMenuItem(
//                     value: "Incompleted",
//                     child: Text("Incompleted"),
//                   ),
//                   DropdownMenuItem(
//                     value: "Completed",
//                     child: Text("Completed"),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     selectedStatus = value;
//                   });
//                 },
//               ),
//
//               const SizedBox(height: 20),
//
//               if (selectedStatus == "Completed")
//                 TextField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "Enter Amount",
//                     prefixIcon: const Icon(Icons.currency_rupee),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//
//               if (selectedStatus == "Completed")
//                 const SizedBox(height: 20),
//
//               TextField(
//                 controller: reportController,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   labelText: "Enter Report Message",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               Center(
//                 child: isLoading
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                   onPressed: submitReport,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 40, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     "Submit",
//                     style: TextStyle(
//                         fontSize: 16, color: Colors.white),
//                   ),
//                 ),
//               ),
//
//
//               // ---------------------------------------------------------------------------------
//
//               const SizedBox(height: 30),
//
//               if (reportData != null)
//                 Card(
//                   color: Colors.grey[100],
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("📅 Date: ${reportData!['date']}",
//                             style: const TextStyle(fontSize: 16)),
//                         Text("📝 Report: ${reportData!['work_report_status']}",
//                             style: const TextStyle(fontSize: 16)),
//                         Text("📊 Status: ${reportData!['status']}",
//                             style: const TextStyle(fontSize: 16)),
//
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
// //
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:flutter/material.dart';
// //
// // class UpdateReportPage extends StatefulWidget {
// //   final String jobId;
// //
// //   const UpdateReportPage({super.key, required this.jobId});
// //
// //   @override
// //   State<UpdateReportPage> createState() => _UpdateReportPageState();
// // }
// //
// // class _UpdateReportPageState extends State<UpdateReportPage> {
// //   final TextEditingController reportController = TextEditingController();
// //   final TextEditingController amountController = TextEditingController();
// //   String? selectedStatus; // new variable for dropdown
// //   bool isLoading = false;
// //
// //   Future<void> submitReport() async {
// //     final report = reportController.text.trim();
// //     final amount = amountController.text.trim();
// //
// //     if (report.isEmpty || selectedStatus == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Please fill in all fields")),
// //       );
// //       return;
// //     }
// //
// //     if (selectedStatus == "Completed" && amount.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Please enter amount for completed jobs")),
// //       );
// //       return;
// //     }
// //
// //
// //
// //     setState(() => isLoading = true);
// //
// //     try {
// //       SharedPreferences sh = await SharedPreferences.getInstance();
// //       String urls = sh.getString('url').toString();
// //
// //       final response = await http.post(
// //         Uri.parse("$urls/myapp/freelancer_job_report/"),
// //         body: {
// //           'job_id': widget.jobId.toString(),
// //           'report': report,
// //           'amount': selectedStatus == "Completed" ? amount : "0",
// //           'status': selectedStatus!,
// //         },
// //       );
// //
// //       final jsonData = jsonDecode(response.body);
// //       print("Response: $jsonData");
// //
// //       if (jsonData['status'].toString().toLowerCase() == 'ok') {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("Report submitted successfully ✅")),
// //         );
// //         reportController.clear();
// //         amountController.clear();
// //         setState(() => selectedStatus = null);
// //       }
// //       else if (jsonData['status'].toString().toLowerCase() == 'not ok'){
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("Error : work already completed ")),
// //         );
// //       }
// //       else {
// //         print("Responseeeeeeeeeeeeeeeeeeeeeee: $jsonData");
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("Errorrrr: ${jsonData['message'] ?? 'OK'}")),
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Error: $e")),
// //       );
// //     } finally {
// //       setState(() => isLoading = false);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Update Report"),
// //         backgroundColor: Colors.green,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // 🔽 Status Dropdown
// //             DropdownButtonFormField<String>(
// //               value: selectedStatus,
// //               decoration: InputDecoration(
// //                 labelText: "Select Status",
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 prefixIcon: const Icon(Icons.assignment_turned_in_outlined),
// //               ),
// //               items: const [
// //                 DropdownMenuItem(
// //                   value:"Incompleted",
// //                   // value: "Pending",
// //                   child: Text("Incompleted"),
// //                 ),
// //                 DropdownMenuItem(
// //                   value: "Completed",
// //                   child: Text("Completed"),
// //                 ),
// //               ],
// //               onChanged: (value) {
// //                 setState(() {
// //                   selectedStatus = value;
// //                 });
// //               },
// //             ),
// //
// //             const SizedBox(height: 20),
// //
// //             // 💰 Amount field only when status is Completed
// //             if (selectedStatus == "Completed")
// //               TextField(
// //                 controller: amountController,
// //                 keyboardType: TextInputType.number,
// //                 decoration: InputDecoration(
// //                   labelText: "Enter Amount",
// //                   prefixIcon: const Icon(Icons.currency_rupee),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                 ),
// //               ),
// //
// //             if (selectedStatus == "Completed")
// //               const SizedBox(height: 20),
// //
// //             // 📝 Report Field
// //             TextField(
// //               controller: reportController,
// //               maxLines: 4,
// //               decoration: InputDecoration(
// //                 labelText: "Enter Report Message",
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //               ),
// //             ),
// //
// //             const SizedBox(height: 20),
// //
// //             // Submit Button
// //             Center(
// //               child: isLoading
// //                   ? const CircularProgressIndicator()
// //
// //                   : ElevatedButton(
// //                 onPressed: submitReport,
// //
// //                   style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.green,
// //                   padding: const EdgeInsets.symmetric(
// //                       horizontal: 40, vertical: 12),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                 ),
// //                 child: const Text(
// //                   "Submit",
// //
// //                   style: TextStyle(fontSize: 16, color: Colors.white),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateReportPage extends StatefulWidget {
  final String jobId;

  const UpdateReportPage({super.key, required this.jobId});

  @override
  State<UpdateReportPage> createState() => _UpdateReportPageState();
}

class _UpdateReportPageState extends State<UpdateReportPage> {
  final TextEditingController reportController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedStatus = "Incompleted";
  List reports = [];

  @override
  void initState() {
    super.initState();
    viewReports();
  }

  Future<void> viewReports() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String urls = sh.getString('url').toString();

    var response = await http.post(
      Uri.parse("$urls/myapp/view_report/"),
      body: {'job_id': widget.jobId},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'ok') {
        setState(() {
          reports = data['data'];
        });
      }
    }
  }

  Future<void> submitReport() async {
    if (reportController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your work report")),
      );
      return;
    }

    // ✅ If Completed → check for amount
    if (selectedStatus == "Completed" && amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the amount")),
      );
      return;
    }

    // ✅ If Incompleted → set amount = 0 automatically
    String finalAmount =
    selectedStatus == "Incompleted" ? "0" : amountController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String urls = sh.getString('url').toString();

    var response = await http.post(
      Uri.parse("$urls/myapp/freelancer_job_report/"),
      body: {
        'job_id': widget.jobId,
        'report': reportController.text,
        'amount': finalAmount,
        'status': selectedStatus,
      },
    );

    var data = jsonDecode(response.body);
    if (data['status'] == 'ok') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report submitted successfully")),
      );
      reportController.clear();
      amountController.clear();
      setState(() {
        selectedStatus = "Incompleted";
      });
      viewReports();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You already marked report as Completed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Daily Report"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Submit New Report",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Work Report Field
              TextField(
                controller: reportController,
                decoration: const InputDecoration(
                  labelText: "Work Report",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),

              // Status Dropdown
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: ['Incompleted', 'Completed']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              // 👇 Amount field only visible when Completed
              if (selectedStatus == "Completed")
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),

              const SizedBox(height: 15),

              // Submit Button
              ElevatedButton(
                onPressed: submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Submit Report",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 25),
              const Divider(thickness: 1),
              const Text(
                "Previous Reports",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Report List
              reports.isEmpty
                  ? const Text("No reports found.")
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  var r = reports[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text("Date: ${r['date']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Work Report: ${r['work_report_status']}"),
                          Text("Amount: ₹${r['amount']}"),
                          Text("Status: ${r['status']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
