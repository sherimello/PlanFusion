import 'dart:async'; // For StreamSubscription
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:intl/intl.dart'; // For date formatting

// Assume you have a way to get the admin's UID
const String adminUid = "ADMIN_USER_ID"; // << REPLACE WITH ACTUAL ADMIN UID

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance; // RTDB instance

  User? _currentUser;
  String? _chatRoomPath; // Path to the messages node in RTDB
  List<Map<dynamic, dynamic>> _messages = []; // Store messages
  StreamSubscription<DatabaseEvent>? _messagesSubscription;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _chatRoomPath = "chat_rooms/${_currentUser!.uid}";
      _listenToMessages();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User not logged in!")));
        }
      });
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_messages.isNotEmpty && _scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_messages.isNotEmpty && _scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  void _listenToMessages() {
    if (_chatRoomPath == null) return;

    DatabaseReference messagesRef = _database.ref("$_chatRoomPath/messages");

    // Order by timestamp (if you store them as numbers or use priority)
    // Or rely on RTDB's natural ordering of pushed keys if timestamps are reliable
    _messagesSubscription = messagesRef
        .orderByChild("timestamp") // Make sure 'timestamp' is a child of each message
        .onValue
        .listen((DatabaseEvent event) {
      if (mounted) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          final newMessages = data.entries.map((entry) {
            final messageData = Map<String, dynamic>.from(entry.value as Map);
            messageData['key'] = entry.key; // Keep the message key
            return messageData;
          }).toList();
          // RTDB order by child might not give exactly what you expect for complex objects immediately,
          // often simpler to sort client-side if 'timestamp' field exists.
          newMessages.sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));
          setState(() {
            _messages = newMessages;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        } else {
          setState(() {
            _messages = [];
          });
        }
      }
    }, onError: (error) {
      print("Error listening to messages: $error");
      // Handle error
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty ||
        _currentUser == null ||
        _chatRoomPath == null) {
      return;
    }

    String messageText = _messageController.text.trim();
    _messageController.clear();

    DatabaseReference messagesRef = _database.ref("$_chatRoomPath/messages");
    DatabaseReference newMessageref = messagesRef.push(); // Generate unique key

    final messageData = {
      'text': messageText,
      'senderId': _currentUser!.uid,
      // 'receiverId': adminUid, // Implicit in this chat room structure
      'timestamp': ServerValue.timestamp, // Use RTDB server timestamp
    };

    try {
      await newMessageref.set(messageData);

      // Update metadata for the chat room
      DatabaseReference chatRoomMetadataRef = _database.ref("$_chatRoomPath/metadata");
      await chatRoomMetadataRef.update({
        "lastMessage": messageText,
        "lastMessageTimestamp": ServerValue.timestamp,
        "userName": _currentUser!.displayName ?? _currentUser!.email ?? "User",
        // Ensure participants are set (could be done on chat creation)
        "participants/${_currentUser!.uid}": true,
        "participants/$adminUid": true,
      });

      _scrollToBottom(); // Should happen automatically via listener now

      // TODO: Trigger Cloud Function for FCM to admin
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null || _chatRoomPath == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Chat with Admin")),
        body: const Center(child: Text("Login required to chat.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with Admin"),
        backgroundColor: const Color(0xFFEFC8C5),
        centerTitle: true,
        elevation: 4,
        shadowColor: const Color(0xFFDFC2BF),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('No messages yet. Say hi!'))
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                bool isMe = message['senderId'] == _currentUser!.uid;
                // int? timestamp = message['timestamp'] as int?;
                // String timeString = "";
                // if (timestamp != null) {
                //   DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
                //   timeString = DateFormat('hh:mm a').format(dateTime);
                // }

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                        color: isMe ? Theme.of(context).primaryColorLight : Colors.grey.shade200,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                          bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0,1),
                          )
                        ]
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['text'] ?? '',
                          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                        ),
                        // if (timeString.isNotEmpty)
                        //   Padding(
                        //     padding: const EdgeInsets.only(top: 4.0),
                        //     child: Text(
                        //       timeString,
                        //       style: TextStyle(
                        //         fontSize: 10,
                        //         color: isMe ? Colors.white70 : Colors.black54,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 2.0,
            color: Colors.grey.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}