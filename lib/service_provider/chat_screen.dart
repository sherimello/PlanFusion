import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [
    ChatMessage(
      sender: 'Client 1',
      text: 'Hello, I want to book a service',
      time: '10:30 AM',
      isMe: false,
    ),
    ChatMessage(
      sender: 'You',
      text: 'Which service are you interested in?',
      time: '10:32 AM',
      isMe: true,
    ),
  ];

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F4),
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        backgroundColor: const Color(0xFFEFC8C5),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 4,
        shadowColor: const Color(0xFFDFC2BF),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: message.isMe
              ? const Color(0xFFEFC8C5)
              : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: message.isMe
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: message.isMe
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isMe)
              Text(
                message.sender,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            Text(message.text),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFFEFC8C5),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.black),
              onPressed: () {
                if (_messageController.text.isNotEmpty) {
                  setState(() {
                    messages.add(
                      ChatMessage(
                        sender: 'You',
                        text: _messageController.text,
                        time: 'Now',
                        isMe: true,
                      ),
                    );
                    _messageController.clear();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final String time;
  final bool isMe;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  });
}