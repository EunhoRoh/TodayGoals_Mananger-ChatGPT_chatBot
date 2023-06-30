// import 'dart:async';

// // import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';

// import '../chatmessage.dart';
// import '../threedots.dart';

// // class ChatScreen extends StatefulWidget {
// //   const ChatScreen({super.key});

// //   @override
// //   State<ChatScreen> createState() => _ChatScreenState();
// // }

// // class _ChatScreenState extends State<ChatScreen> {
// //   final TextEditingController _controller = TextEditingController();
// //   final List<ChatMessage> _messages = [];
// //   late OpenAI chatGPT;

// //   StreamSubscription? _subscription;
// //   bool _isTyping = false;

// //   @override
// //   void initState() {
// //     chatGPT = OpenAI.instance.build(
// //         token: "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",
// //         baseOption: HttpSetup(
// //             receiveTimeout: const Duration(seconds: 20),
// //             connectTimeout: const Duration(seconds: 20)),
// //         enableLog: true).on;
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     _subscription?.cancel();
// //     super.dispose();
// //   }

// //   // Link for api - https://beta.openai.com/account/api-keys

// //   void _sendMessage() {
// //     ChatMessage message = ChatMessage(text: _controller.text, sender: "user");

// //     setState(() {
// //       _messages.insert(0, message);
// //       _isTyping = true;
// //     });

// //     _controller.clear();

// //     final request = CompleteText(
// //         prompt: message.text, maxTokens: 200, model: TextDavinci3Model());

// //     _subscription = chatGPT!
// //         .builder("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",
// //             orgId: "")
// //         .onCompleteStream(request: request)
// //         .listen((response) {
// //       Vx.log(response!.choices[0].text);
// //       ChatMessage botMessage =
// //           ChatMessage(text: response.choices[0].text, sender: "bot");

// //       setState(() {
// //         _isTyping = false;
// //         _messages.insert(0, botMessage);
// //       });
// //     });
// //   }

// //   Widget _buildTextComposer() {
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: TextField(
// //             controller: _controller,
// //             onSubmitted: (value) => _sendMessage(),
// //             decoration:
// //                 const InputDecoration.collapsed(hintText: "Send a message"),
// //           ),
// //         ),
// //         IconButton(
// //           icon: const Icon(Icons.send),
// //           onPressed: () => _sendMessage(),
// //         ),
// //       ],
// //     ).px16();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         appBar: AppBar(title: const Text("ChatGPT Demo")),
// //         body: SafeArea(
// //           child: Column(
// //             children: [
// //               Flexible(
// //                   child: ListView.builder(
// //                 reverse: true,
// //                 padding: Vx.m8,
// //                 itemCount: _messages.length,
// //                 itemBuilder: (context, index) {
// //                   return _messages[index];
// //                 },
// //               )),
// //               if (_isTyping) const ThreeDots(),
// //               const Divider(
// //                 height: 1.0,
// //               ),
// //               Container(
// //                 decoration: BoxDecoration(
// //                   color: context.cardColor,
// //                 ),
// //                 child: _buildTextComposer(),
// //               )
// //             ],
// //           ),
// //         ));
// //   }
// // }

// import 'dart:async';

// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';

// import '../chatmessage.dart';
// import '../threedots.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<ChatMessage> _messages = [];
//   late OpenAI chatGPT;

//   // StreamSubscription? _subscription;
//   Future<CompleteResponse?>? _translateFuture;
//   bool _isTyping = false;

//   @override
//   void initState() {
//     chatGPT = OpenAI.instance.build(
//       token: "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",
//       baseOption: HttpSetup(
//         receiveTimeout: const Duration(seconds: 20),
//         connectTimeout: const Duration(seconds: 20),
//       ),
//       enableLog: true,
//     );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // _subscription?.cancel();
//     super.dispose();
//   }

//   void _sendMessage() async {
//     final message = ChatMessage(text: _controller.text, sender: "user");

//     setState(() {
//       _messages.insert(0, message);
//       _isTyping = true;
//     });

//     _controller.clear();

//     final request = CompleteText(
//       prompt: message.text,
//       maxTokens: 200,
//       model: TextDavinci3Model(),
//     );

//     setState(() {
//       _translateFuture = chatGPT.onCompletion(request: request);
//     });

//     _translateFuture = chatGPT!.onCompletion(request: request).listen((response) {
//       Vx.log(response!.choices[0].text);
//       final botMessage = ChatMessage(
//         text: response.choices[0].text,
//         sender: "bot",
//       );

//       setState(() {
//         _isTyping = false;
//         _messages.insert(0, botMessage);
//       });
//     });
//   }

//   Widget _buildTextComposer() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: _controller,
//             onSubmitted: (_) => _sendMessage(),
//             decoration: const InputDecoration.collapsed(
//               hintText: "Send a message",
//             ),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.send),
//           onPressed: _sendMessage,
//         ),
//       ],
//     ).px16();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("ChatGPT Demo")),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Flexible(
//               child: ListView.builder(
//                 reverse: true,
//                 padding: const EdgeInsets.all(8.0),
//                 itemCount: _messages.length,
//                 itemBuilder: (context, index) => _messages[index],
//               ),
//             ),
//             if (_isTyping) const ThreeDots(),
//             const Divider(height: 1.0),
//             Container(
//               decoration: BoxDecoration(
//                 color: context.cardColor,
//               ),
//               child: _buildTextComposer(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
