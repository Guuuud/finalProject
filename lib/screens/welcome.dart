// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';


// class WelcomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Text(
//                   'Welcome!',
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 32, bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                   ),
//                   width: 250,
//                   child: TextButton(
//                     child: Text('Sign Up',
//                         style: TextStyle(fontSize: 20, color: Colors.white)),
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => SignupScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 32, bottom: 16),
//                   decoration: BoxDecoration(
//                     // color: Colors.green,
//                     border: Border.all(color: Colors.green),
//                     // shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                   ),
//                   width: 250,
//                   child: TextButton(
//                     child: Text('Sign In',
//                         style: TextStyle(fontSize: 20, color: Colors.green)),
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => LoginScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 50,
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
