import 'dart:convert';

// import 'package:final_project/chatMessage.dart';
import 'package:final_project/Trash/chat_messag_type.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'chat_message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

Future<String> generateResponse(String prompt) async {
  const apiKey = "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";
  var url = Uri.https("api.openai.com", "/v1/completions");
  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey",
    },
    body: json.encode({
      "model": "text-davinci-003",
      "prompt": prompt,
      "temperature": 1,
      "max_tokens": 4000,
      "top_p": 1,
      "frequency_penalty": 0.0,
      "presence_penalty": 0.0,
    }),
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> newresponse = jsonDecode(response.body);
    if (newresponse.containsKey('choices') &&
        newresponse['choices'].isNotEmpty) {
      return newresponse['choices'][0]['text'];
    } else {
      throw Exception('Invalid response format');
    }
  } else {
    throw Exception('Request failed with status: ${response.statusCode}');
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AI ChatBot"),
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Color.fromARGB(255, 204, 181, 255),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  var message = _messages[index];
                  return ChatMessageWidget(
                    text: message.text,
                    chatMessageType: message.chatMessageType,
                  );
                },
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(color: Colors.white),
                    controller: _textController,
                    decoration: InputDecoration(
                      fillColor: Colors.amber,
                      filled: true,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                Visibility(
                  visible: !isLoading,
                  child: Container(
                    color: Colors.blueGrey,
                    child: IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        setState(() {
                          _messages.add(
                            ChatMessage(
                              text: _textController.text,
                              chatMessageType: ChatMessageType.user,
                            ),
                          );
                          isLoading = true;
                        });

                        var input = _textController.text;
                        _textController.clear();

                        Future.delayed(Duration(milliseconds: 50))
                            .then((_) => _scrollDown());

                        generateResponse(input).then((value) {
                          setState(() {
                            isLoading = false;
                            _messages.add(
                              ChatMessage(
                                text: value,
                                chatMessageType: ChatMessageType.bot,
                              ),
                            );
                          });
                        });

                        _textController.clear();
                        Future.delayed(Duration(milliseconds: 50))
                            .then((_) => _scrollDown());
                      },
                    ),
                  ),
                ),
              ]),
            )
          ],
        )));
  }
}
