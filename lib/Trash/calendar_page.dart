

// import 'package:flutter/material.dart';


// class CalnedarPage extends StatelessWidget {
//   String defaultImamgeURL = "https://handong.edu/site/handong/res/img/logo.png";
//   String defaultImamgeURL2 =
//       "https://firebasestorage.googleapis.com/v0/b/final-exam-v3.appspot.com/o/online_prove.jpg?alt=media&token=a97a26d1-24fe-489f-b211-69e55cefb6ce";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: <Widget>[
//           //signout
//           IconButton(
//             icon: const Icon(
//               Icons.exit_to_app,
//               semanticLabel: 'signout',
//             ),
//             onPressed: () {
//               _signOut();
//             },
//           ),
//         ],
//       ),
//       //로그인 한게 google이면
//       // print(LoginPage.isGoogle),
//       body: LoginPage.isGoogle
//           ? _buildGoogleContent(context)
//           : _buildAnonymousContent(context),
//     );
//   }

//   Widget _buildGoogleContent(context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListView(
//         children: [
//           //image 보여주고
//           Container(
//             width: MediaQuery.of(context).size.width / 3,
//             height: MediaQuery.of(context).size.height / 4,
//             child: Image.network(
//               //현재 user의 photourl 보여주기
//               FirebaseAuth.instance.currentUser?.photoURL ?? defaultImamgeURL2,
//               // defaultImamgeURL,
//               fit: BoxFit.cover,
//             ),
//           ),
//           SizedBox(
//             height: 50,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(40.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   FirebaseAuth.instance.currentUser!.uid,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Divider(
//                   height: 8,
//                   thickness: 1,
//                   indent: 2,
//                   endIndent: 2,
//                   color: Colors.grey,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(FirebaseAuth.instance.currentUser!.email!),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Text("Eunho Roh"),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text("I promise to take the test honestly before GOD"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAnonymousContent(context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListView(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width / 4,
//             height: MediaQuery.of(context).size.height / 4,
//             child: Image.network(
//               //그냥 image 보여주기
//               defaultImamgeURL,
//               fit: BoxFit.cover,
//             ),
//           ),
//           SizedBox(
//             height: 50,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(30.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(FirebaseAuth.instance.currentUser!.uid),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Divider(
//                   height: 8,
//                   thickness: 1,
//                   indent: 2,
//                   endIndent: 2,
//                   color: Colors.grey,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text("Anonymous"),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Text("Eunho Roh"),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text("I promise to take the test honestly before GOD"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _signOut() async {
//     await FirebaseAuth.instance.signOut();
//     //loginpage는 false로 두기
//     LoginPage.go = false;
//     //loadproducts도 초기화
//     //다 초기화
//     // 새로운 user가 들어올 수 있으니까
//     ProductsRepository.loadProducts = [];
//     ProductsRepository.doIWish = {};
//     ProductsRepository.doILike = {};
//     Get.to(LoginPage());
//   }
// }