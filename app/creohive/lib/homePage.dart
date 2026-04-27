import 'package:creohive/JobStatus.dart';
import 'package:creohive/ip.dart';
import 'package:creohive/review.dart';
import 'package:creohive/view_jobs.dart';
import 'package:creohive/view_payment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'complaint.dart';
import 'loginn.dart';
import 'view_complaint.dart'; // Make sure this file exists

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name = '';
  String? email = '';
  String? photo = '';
  String? imgurl='';
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    setState(() {
      name = sh.getString('name') ?? 'User';
      email = sh.getString('email') ?? 'user@example.com';
      photo = sh.getString('photo');
      imgurl = sh.getString('imgurl').toString();
    });
  }

  @override
  Widget build(BuildContext context) {

    // after login ..not going to back unless logout
    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          backgroundColor: Colors.blue[700],
        ),

        // 🧭 Drawer Section
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer Header
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.blue[700]),
                accountName: Text(
                  "Welcome $name",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(email ?? ''),

                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: (photo != null && photo!.isNotEmpty)
                      ? NetworkImage('$imgurl$photo') // full URL to your image
                      : const AssetImage('assets/default_user.png') as ImageProvider,
                ),
              ),


              // Drawer Menu Items
              ListTile(
                leading: const Icon(Icons.home, color: Colors.blue),
                title: const Text("Home"),
                onTap: () {
                  Navigator.pop(context); // just close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.work, color: Colors.blue),
                title: const Text("View Jobs"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FreelancersJobView()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.assignment, color: Colors.blue),
                title: const Text("Job Status"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FreelancerJobRequestStatus()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_comment, color: Colors.blue),
                title: const Text("Add Complaint"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ComplaintForm()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_alt, color: Colors.blue),
                title: const Text("View Complaints"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FreelancersComplaintView()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_alt, color: Colors.blue),
                title: const Text("View Review"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FreelancerReviewsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_alt, color: Colors.blue),
                title: const Text("Payment Details"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentDetailsPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout"),
                onTap: () async {
                  // SharedPreferences sh = await SharedPreferences.getInstance();
                  // await sh.clear(); // clears user data
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),

          body: Container(
            decoration: const BoxDecoration(
              // Retaining a smooth, professional gradient
              gradient: LinearGradient(
                colors: [Color(0xFF0D47A1),Color(0xFF2196F3)], // Slightly deeper, more vibrant blue/teal
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView( // Use SingleChildScrollView for safety
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Photo/Icon - Styled for a Freelancer
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3), // White border for emphasis
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        // Using a laptop/screen icon for a generic professional freelancer look
                        child: Icon(Icons.laptop_chromebook_outlined, size: 70, color: Colors.blue[700]),
                        // Note: You would replace the Icon with NetworkImage(fullPhotoUrl) if available
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Welcome text - More pronounced
                    Text(
                      "Welcome, $name!",
                      style: const TextStyle(
                        fontSize: 25, // Larger font
                        fontWeight: FontWeight.w900, // Extra bold
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black38,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Email
                    Text(
                      "$email",
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 50),

                    // 🌟 Freelancer Icon Row (Adds industry flair)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.code, color: Colors.white70, size: 30),
                        const SizedBox(width: 25),
                        Icon(Icons.design_services, color: Colors.white, size: 30),
                        const SizedBox(width: 25),
                        Icon(Icons.analytics_outlined, color: Colors.white70, size: 30),
                      ],
                    ),

                    const SizedBox(height: 50),

                    // Tag line / motivational text - Cleaned up and highlighted
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25), // Stronger background contrast
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 1.5), // Solid white border
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Your workspace is ready. Time to secure that next project! 🚀",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Navigate using the menu icon above.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // NOTE: The Log Out Button has been successfully removed.
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}


// body: Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Color(0xFF74ebd5), Color(0xFFACB6E5)], // soft blue gradient
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //     ),
          //   ),
          //   child: Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         // Profile Icon or Photo
          //         Container(
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.black26,
          //                 blurRadius: 10,
          //                 offset: const Offset(0, 5),
          //               ),
          //             ],
          //           ),
          //           child: CircleAvatar(
          //             radius: 55,
          //             backgroundColor: Colors.white,
          //             child: Icon(Icons.person, size: 70, color: Colors.blue[700]),
          //           ),
          //         ),
          //
          //         const SizedBox(height: 25),
          //
          //         // Welcome text
          //         Text(
          //           "Welcome, $name 👋",
          //           style: const TextStyle(
          //             fontSize: 26,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //
          //         const SizedBox(height: 8),
          //
          //         // Email
          //         Text(
          //           "$email",
          //           style: const TextStyle(
          //             fontSize: 16,
          //             color: Colors.white70,
          //           ),
          //         ),
          //
          //         const SizedBox(height: 40),
          //
          //         // Cute tag line / motivational text
          //         Container(
          //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          //           decoration: BoxDecoration(
          //             color: Colors.white.withOpacity(0.2),
          //             borderRadius: BorderRadius.circular(16),
          //             border: Border.all(color: Colors.white70, width: 1),
          //           ),
          //           child: const Text(
          //             "Keep up the great work, freelancer! 💪",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //               fontSize: 16,
          //               color: Colors.white,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //         ),
          //
          //         const SizedBox(height: 40),
          //
          //         // Logout button
          //         ElevatedButton.icon(
          //           onPressed: () {
          //             // logout logic here
          //           },
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: Colors.white,
          //             foregroundColor: Colors.blue[700],
          //             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(30),
          //             ),
          //             elevation: 6,
          //           ),
          //           icon: const Icon(Icons.logout),
          //           label: const Text(
          //             "Log Out",
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),





// import 'package:creohive/JobStatus.dart';
// import 'package:creohive/view_jobs.dart';
// import 'package:flutter/material.dart';
// import 'complaint.dart';
// import 'view_complaint.dart'; // Make sure this file exists
//
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home"),
//         backgroundColor: Colors.blue[700],
//       ),
//
//       // 🧭 Drawer Section
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             // Drawer Header
//             UserAccountsDrawerHeader(
//               decoration: BoxDecoration(color: Colors.blue[700]),
//               accountName: const Text(
//                 "Welcome User",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               accountEmail: const Text("user@example.com"),
//               currentAccountPicture: const CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.person, size: 50, color: Colors.blue),
//               ),
//             ),
//
//             // Drawer Menu Items
//             ListTile(
//               leading: const Icon(Icons.home, color: Colors.blue),
//               title: const Text("Home"),
//               onTap: () {
//                 Navigator.pop(context); // just close the drawer
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.add_comment, color: Colors.blue),
//               title: const Text("View Jobs"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const FreelancersJobView()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.add_comment, color: Colors.blue),
//               title: const Text("Job Status"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const FreelancerJobRequestStatus()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.add_comment, color: Colors.blue),
//               title: const Text("Add Complaint"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ComplaintForm()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.list_alt, color: Colors.blue),
//               title: const Text("View Complaints"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const FreelancersComplaintView()),
//                 );
//               },
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text("Logout"),
//               onTap: () {
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Logged out successfully")),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//
//       // 🏡 Main Body
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.home, size: 100, color: Colors.blue[700]),
//               const SizedBox(height: 20),
//               Text(
//                 "Welcome to the Freelancer Portal",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//
//
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
