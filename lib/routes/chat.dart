import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(text: "Hi! How can I help you today?", sender: "Coach", time: "10:00 AM"),
   
  ];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: _messageController.text,
          sender: "me",
          time: "${DateTime.now().hour}:${DateTime.now().minute}",
        ));
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
          color: Colors.white, // White background for entire body
  child: Column(
        children: [
          
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                
                return Align(
                  
                  alignment: message.sender == "me" 
                      ? Alignment.centerRight 
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                   
                    decoration: BoxDecoration(
                      color: message.sender == "me" 
                          ? Color(0xFF01CF12) 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: message.sender == "me" 
                          ? null 
                          : Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                            color: message.sender == "me" 
                                ? Colors.white 
                                : Color(0xFF0B2545),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          message.time,
                          style: TextStyle(
                            fontSize: 10,
                            color: message.sender == "me" 
                                ? Colors.white70 
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Color(0xFF01CF12),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                  
                ),
                SizedBox(height: 40),
                    
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class ChatMessage {
  final String text;
  final String sender;
  final String time;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.time,
  });
}