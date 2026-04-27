// import 'package:flutter/material.dart';
//
// void main(){
//   runApp(Myapp());
// }
// class Myapp extends StatelessWidget {
//   const Myapp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: RegistrationPage(),
//     );
//   }
// }
//
//
// class RegistrationPage extends StatefulWidget{
//   const RegistrationPage({super.key});
//
//   @override
//   State<RegistrationPage> createState() => _RegistrationPage();
//   }
//
// class _RegistrationPage  extends State<RegistrationPage>{
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Registration'),
//       ),
//
//       body: Column(
//         children: [
//           SizedBox(height: 20,),
//           Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: TextFormField(
//
//               decoration: InputDecoration(
//                   hintText: 'Username',
//                   border: OutlineInputBorder()
//               ),
//             ),
//           ),
//
//           Padding(
//             padding:const EdgeInsets.all(18.0),
//             child: TextFormField(
//               decoration: InputDecoration(
//                 hintText: 'gmail',
//                   border: OutlineInputBorder()
//               ),
//             ),
//           ),
//
//           Padding(
//               padding:const EdgeInsets.all(18.0),
//               child:TextFormField(
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   border: OutlineInputBorder()
//                 ),
//               ),
//           ),
//
//
//
//         ],
//       ),
//     );
//   }
// }
//
//
