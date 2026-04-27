import 'dart:convert';
import 'dart:io';
import 'package:creohive/loginn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: regapp(),
  ));
}

class regapp extends StatefulWidget {
  const regapp({super.key});

  @override
  State<regapp> createState() => _regappState();
}

class _regappState extends State<regapp> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController qualification = TextEditingController();
  TextEditingController skill = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController post = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController dob = TextEditingController();
  String? gender_ = '';
  File? _selectedImage;
  final _formkey = GlobalKey<FormState>();

  Future<void> _chooseImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      Fluttertoast.showToast(msg: "No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Freelancer Registration",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // ---------------- Personal Details (reordered) ----------------
                      const Text("Personal Details",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const Divider(),

                      // Name (validator preserved)
                      TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                          label: const Text('Enter the name'),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your name";
                          }
                          if (value.trim().length < 3) {
                            return "Name must be at least 3 characters";
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return "Name can only contain letters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // DOB (validator logic preserved earlier used Toast; kept readOnly and check)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: TextFormField(
                          controller: dob,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Date of Birth",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              DateTime today = DateTime.now();
                              int age = today.year - pickedDate.year;
                              if (today.month < pickedDate.month ||
                                  (today.month == pickedDate.month &&
                                      today.day < pickedDate.day)) {
                                age--;
                              }

                              if (age < 18) {
                                Fluttertoast.showToast(
                                  msg: "You must be at least 18 years old.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                              } else {
                                setState(() {
                                  dob.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                });
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Gender label + radios (kept original behavior)
                      const Text("Gender",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Male',
                                groupValue: gender_,
                                onChanged: (String? value) {
                                  setState(() {
                                    gender_ = value!;
                                  });
                                },
                              ),
                              const Text('Male'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Female',
                                groupValue: gender_,
                                onChanged: (String? value) {
                                  setState(() {
                                    gender_ = value!;
                                  });
                                },
                              ),
                              const Text('Female'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Other',
                                groupValue: gender_,
                                onChanged: (String? value) {
                                  setState(() {
                                    gender_ = value!;
                                  });
                                },
                              ),
                              const Text('Other'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Profile Picture label + image (kept your image picker and validation intact)
                      const Text("Profile Picture",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      GestureDetector(
                        onTap: () {
                          _chooseImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _selectedImage != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _selectedImage!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                              : const Icon(Icons.camera_alt, size: 100, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email (validator preserved)
                      TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                          label: const Text('Enter the gmail'),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "please enter your email";
                          }
                          String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value.trim())) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Phone (validator preserved)
                      TextFormField(
                        controller: phone,
                        decoration: InputDecoration(
                          label: const Text("Enter the phone number"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter valid phone number";
                          }
                          String pattern = r'^[6-9]\d{9}$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value.trim())) {
                            return "Please enter a valid 10 digit number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // ---------------- Address Details ----------------
                      const Text("Address Details",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const Divider(),

                      TextFormField(
                        controller: place,
                        decoration: InputDecoration(
                          label: const Text("Place"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return " Please enter valid place";
                          }
                          if (value.trim().length < 2) {
                            return "Place must be atleast 2 characters long";
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return "Pace can only contain letters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: post,
                        decoration: InputDecoration(
                          label: const Text("Post Office"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return " Please enter valid place";
                          }
                          if (value.trim().length < 2) {
                            return "Place must be atleast 2 characters long";
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return "Place can only contain letters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: district,
                        decoration: InputDecoration(
                          label: const Text("District"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return " Please enter valid district";
                          }
                          if (value.trim().length < 2) {
                            return "District must be atleast 2 characters long";
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return "District can only contain letters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: pin,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: const Text("Pin"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter valid pin code";
                          }
                          String pattern = r'^[0-9]{6}$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value.trim())) {
                            return "Pin Code must be exactly 6 digits";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // ---------------- Professional Details ----------------
                      const Text("Professional Details",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const Divider(),

                      TextFormField(
                        controller: qualification,
                        decoration: InputDecoration(
                          label: const Text("Qualification"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return " Please enter qualification";
                          }
                          if (value.trim().length < 2) {
                            return "Qualification must be atleast 2 characters long";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: skill,
                        decoration: InputDecoration(
                          label: const Text("Skills"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return " Please enter qualification";
                          }
                          if (value.trim().length < 2) {
                            return "Skills must be atleast 2 characters long";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // ---------------- Account Details ----------------
                      const Text("Account Details",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const Divider(),

                      TextFormField(
                        controller: username,
                        decoration: InputDecoration(
                          label: const Text("Username"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a username";
                          }
                          if (value.trim().length < 4) {
                            return "Username must be at least 4 characters long";
                          }
                          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                            return "Username can only contain letters, numbers, and underscores";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          label: const Text("Password"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your password";
                          }
                          if (value.length < 8) {
                            return "Password must be at least 8 characters long";
                          }
                          String pattern =
                              r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$';
                          RegExp regex = RegExp(pattern);

                          if (!regex.hasMatch(value)) {
                            return "Password must contain uppercase, lowercase, number & special character";
                          }

                          return null; // means validation passed
                        },
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            if (gender_ == null || gender_!.isEmpty) {
                              Fluttertoast.showToast(msg: "Please select your gender");
                              return;
                            }

                            if (_selectedImage == null) {
                              Fluttertoast.showToast(msg: "Please select a profile picture");
                              return;
                            }
                            bool success = await sendData(); // wait for completion
                            if (success) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please correct the errors before submitting");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> sendData() async {
    String _name = name.text;
    String _email = email.text;
    String _phone = phone.text;
    String _pin = pin.text;
    String _place = place.text;
    String _district = district.text;
    String _qualification = qualification.text;
    String _skill = skill.text;
    String _username = username.text;
    String _password = password.text;
    String _dob = dob.text;
    String _post = post.text;
    String _gender = gender_ ?? '';

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    final uri = Uri.parse('$url/myapp/freelancers_registration/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = _name;
    request.fields['email'] = _email;
    request.fields['phone'] = _phone;
    request.fields['pin'] = _pin;
    request.fields['place'] = _place;
    request.fields['district'] = _district;
    request.fields['qualification'] = _qualification;
    request.fields['skill'] = _skill;
    request.fields['username'] = _username;
    request.fields['password'] = _password;
    request.fields['dob'] = _dob;
    request.fields['post'] = _post;
    request.fields['gender'] = _gender;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', _selectedImage!.path));
    }

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(msg: "Submitted successfully.");
        return true;
      } else  if (response.statusCode == 200 && data['status'] == 'not ok') {
        Fluttertoast.showToast(msg: "Username existed");
        return false;
      }
      else {
        Fluttertoast.showToast(msg: "Submission failed.");
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      return false;
    }
  }
}


// import 'dart:convert';
// import 'package:creohive/loginn.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import '../login.dart';
//
// class SignUpForm extends StatefulWidget {
//   const SignUpForm({Key? key}) : super(key: key);
//
//   @override
//   State<SignUpForm> createState() => _SignUpFormState();
// }
//
// class _SignUpFormState extends State<SignUpForm> {
//   // Controllers
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController placeController = TextEditingController();
//   final TextEditingController pinController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController qualificationController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController skillsController = TextEditingController();
//   final TextEditingController postController = TextEditingController();
//   final TextEditingController districtController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//
//
//   bool _obscurePassword = true;
//   XFile? _profileImage;
//   XFile? _idProofImage;
//   bool _isLoading = false;
//
//   // New: Gender variable
//   String? selectedGender;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 20),
//                 Icon(Icons.work, size: 80, color: Colors.blue[700]),
//                 SizedBox(height: 16),
//                 Text(
//
//                   "CREOHIVE",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue[700]),
//
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   "Create Your Account",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.grey[800]),
//                 ),
//                 SizedBox(height: 30),
//
//                 _buildCircularImagePicker(
//                   title: "Add Profile Photo",
//                   onImagePick: _pickProfileImage,
//                   selectedImage: _profileImage,
//                 ),
//                 SizedBox(height: 30),
//
//                 _buildSectionTitle("Personal Information"),
//                 SizedBox(height: 16),
//                 _buildTextField(controller: nameController, label: "Name", icon: Icons.person_outline),
//                 SizedBox(height: 16),
//
//                 // 🔹 Gender Dropdown Field
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white,
//                     labelText: "Gender",
//                     prefixIcon: Icon(Icons.person, color: Colors.blue[700]),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//                   ),
//                   value: selectedGender,
//                   items: ["Male", "Female", "Other"]
//                       .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedGender = value;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 16),
//
//                 _buildTextField(controller: emailController, label: "Email", icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
//                 SizedBox(height: 16),
//                 _buildTextField(controller: phoneController, label: "Phone", icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
//                 SizedBox(height: 16),
//                 _buildTextField(controller: qualificationController, label: "Qualification", icon: Icons.school),
//                 SizedBox(height: 16),
//                 _buildTextField(controller: skillsController, label: "Skills", icon: Icons.computer),
//                 SizedBox(height: 16),
//                 _buildDateOfBirthField(),
//                 SizedBox(height: 16),
//                 _buildTextField(controller: placeController, label: "Place", icon: Icons.place_outlined),
//                 SizedBox(height: 16),
//                 _buildTextField(controller: postController, label: "Post Office", icon: Icons.place_outlined),
//                 SizedBox(height: 16),
//                 _buildTextField(controller: districtController, label: "District", icon: Icons.place_outlined),
//                 SizedBox(height: 16),
//                 _buildTextField(controller: pinController, label: "Pin Code", icon: Icons.pin_drop_outlined, keyboardType: TextInputType.number),
//                 SizedBox(height: 30),
//
//                 _buildSectionTitle("Account Information"),
//                 SizedBox(height: 16),
//                 _buildTextField(controller: usernameController, label: "Username (Email)", icon: Icons.person_outline),
//                 SizedBox(height: 16),
//                 _buildTextField(
//                   controller: passwordController,
//                   label: "Password",
//                   icon: Icons.lock_outlined,
//                   obscureText: _obscurePassword,
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
//                     onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//
//                 ElevatedButton(
//
//                   onPressed: (){
//                     if (_formKey.currentState!.validate()) {
//                       // Process data
//                     }
//                     _isLoading ? null : _registerUser();
//                     style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue[700],
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     );
//                   },
//
//                   child: _isLoading
//                       ? CircularProgressIndicator(color: Colors.white)
//                       : Text("Register", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Date of Birth Field
//   Widget _buildDateOfBirthField() {
//     return TextFormField(
//       controller: dobController,
//       readOnly: true,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white,
//         labelText: "Date of Birth",
//         prefixIcon: Icon(Icons.date_range, color: Colors.blue[700]),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//         contentPadding: EdgeInsets.symmetric(vertical: 16),
//       ),
//       onTap: () async {
//         FocusScope.of(context).requestFocus(FocusNode());
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
//           firstDate: DateTime(1900),
//           lastDate: DateTime.now(),
//         );
//         if (pickedDate != null) {
//           String formattedDate =
//               "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
//           setState(() {
//             dobController.text = formattedDate;
//           });
//         }
//       },
//     );
//   }
//
//   // Text Field
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     bool obscureText = false,
//     Widget? suffixIcon,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white,
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.blue[700]),
//         suffixIcon: suffixIcon,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//         contentPadding: EdgeInsets.symmetric(vertical: 16),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your email';
//         }
//         if (!value.contains('@')) {
//           return 'Enter a valid email';
//         }
//         return null;
//       },
//
//
//     );
//   }
//
//   // Section Title
//   Widget _buildSectionTitle(String title) {
//     return Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]));
//   }
//
//   // Profile Image Picker
//   Widget _buildCircularImagePicker({required String title, required Function() onImagePick, required XFile? selectedImage}) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: onImagePick,
//           child: CircleAvatar(
//             radius: 60,
//             backgroundColor: Colors.blue[100],
//             backgroundImage: selectedImage != null ? FileImage(File(selectedImage.path)) : null,
//             child: selectedImage == null ? Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.blue[700]) : null,
//           ),
//         ),
//         SizedBox(height: 12),
//         Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700])),
//       ],
//     );
//   }
//
//   // Pick Images
//   Future<void> _pickProfileImage() async {
//     final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
//     setState(() {
//       _profileImage = image;
//     });
//   }
//
//   // Register User with gender + age validation
//   Future<void> _registerUser() async {
//     if (dobController.text.isEmpty) {
//       _showSnackBar("Please select your Date of Birth");
//       return;
//     }
//     if (selectedGender == null) {
//       _showSnackBar("Please select your Gender");
//       return;
//     }
//
//     DateTime dob = DateTime.parse(dobController.text);
//     DateTime today = DateTime.now();
//     int age = today.year - dob.year;
//     if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
//       age--;
//     }
//
//     if (age < 18) {
//       _showSnackBar("You must be at least 18 years old to register");
//       return;
//     }
//
//     setState(() => _isLoading = true);
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       String url = prefs.getString("url") ?? '';
//
//       var request = http.MultipartRequest('POST', Uri.parse('$url/myapp/freelancers_registration/'));
//       request.fields.addAll({
//         'name': nameController.text,
//         'gender': selectedGender ?? '',
//         'place': placeController.text,
//         'pin': pinController.text,
//         'email': emailController.text,
//         'phone': phoneController.text,
//         'username': usernameController.text,
//         'password': passwordController.text,
//         'qualification': qualificationController.text,
//         'skills': skillsController.text,
//         'dob': dobController.text,
//         'post': postController.text,
//         'district': districtController.text,
//       });
//
//       if (_profileImage != null) {
//         request.files.add(await http.MultipartFile.fromPath('image', _profileImage!.path));
//       }
//
//       final response = await request.send();
//       if (response.statusCode == 200) {
//         _showSnackBar("Registration Successful");
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
//       } else {
//         _showSnackBar("Registration Failed");
//       }
//     } catch (e) {
//       _showSnackBar("An error occurred: $e");
//     }
//     setState(() => _isLoading = false);
//   }
//
//   // Snackbar
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
// }
