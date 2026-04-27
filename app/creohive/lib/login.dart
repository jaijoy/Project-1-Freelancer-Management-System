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
//       home: LoginPage(),
//     );
//   }
// }
//
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
// title: Text('Login'),
//         backgroundColor: Colors.green,
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 20,),
//           Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: TextFormField(
//
//               decoration: InputDecoration(
//                 hintText: 'Username',
//                 border: OutlineInputBorder()
//               ),
//             ),
//           ),
//
//           Padding(padding: const EdgeInsets.all(18.0),
//           child:TextFormField(
//             decoration: InputDecoration(
//               hintText: 'Password',
//                 border: OutlineInputBorder()
//
//             ),
//           ),
//           ),
//
//           Padding(padding: const EdgeInsets.all(18.0),
//             child:TextFormField(
//               decoration:InputDecoration(
//                 hintText: 'Confirm Password',
//                 border:OutlineInputBorder()
//               ),
//             ),
//           ),
//           // ElevatedButton(onPressed: (){}, child: Icon(Icons.login))
//           ElevatedButton(onPressed: (){}, child: Text('Login'))
//
//
//         ],
//       ),
//     );
//   }
// }
