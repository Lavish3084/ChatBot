import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

const apiKey = 'your api key'; // Replace with your actual API key

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];late Gemini gemini;
  bool _isTyping = false; // Track whether bot is typing

  @override
  void initState() {
    super.initState();
    Gemini.init(apiKey: apiKey);
    gemini = Gemini.instance;
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;
    final userMessage = _controller.text;
    setState(() {
      _messages.insert(0, {"role": "user", "text": userMessage});
    });
    _controller.clear();

    try {
      // Set typing indicator while waiting for response
      setState(() {
        _isTyping = true;
      });

      // Send message to Gemini and get response
      final response = await gemini.prompt(parts: [Part.text(userMessage)]);
      final botReply = response?.output ?? "No response";

      // Set isTyping to false once the bot reply is received
      setState(() {
        _isTyping = false;
        _messages.insert(0, {"role": "bot", "text": botReply});
      });
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.insert(0, {"role": "bot", "text": "Error: $e"});
      });
    }
  }

  Widget _buildMessageBubble(Map<String, String> message) {
    final bool isUser = message["role"] == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(14),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isUser ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade600, width: 1),
        ),
        child: Text(
          message["text"]!,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 15, // Increased font size
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                // Added highlight to the input field
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey.shade800],
                ),
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "THE BOYS ChatBot",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          if (_isTyping) // Show the loading indicator when bot is typing
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade600, width: 1),
                  ),
                  child: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 8),
                      Text("..."),
                    ],
                  ),
                ),
              ),
            ),
          SizedBox(height: 25),
          _buildInputArea(),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
