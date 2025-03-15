import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../design_system/index.dart';
import '../models/message.dart';
import '../widgets/message_item.dart';
import '../../../shared/widgets/unified_text_field.dart'; // Add import for UnifiedTextField

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    final String response =
        await rootBundle.loadString('assets/data/chat01.json');
    final data = json.decode(response);
    setState(() {
      messages = (data['messages'] as List)
          .map((msg) => Message.fromJson(msg))
          .toList();
    });
  }

  void sendMessage(String content) {
    final newMessage = Message(
      id: 'MSG${messages.length + 1}',
      content: content,
      metadata: MessageMetadata(
        timestamp: DateTime.now().toIso8601String(),
        senderId: 'USER001',
        type: 'user',
        read: true,
      ),
    );
    setState(() {
      messages.add(newMessage);
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat', style: AppTypography.heading3),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: AppSpacing.paddingMD,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageItem(message: messages[index]);
              },
            ),
          ),
          Padding(
            padding: AppSpacing.paddingMD,
            child: Row(
              children: [
                Expanded(
                  child: UnifiedTextField(
                    // Replace TextField with UnifiedTextField
                    controller: _controller,
                    labelText: '',
                    hintText: 'Type a message',
                    style: TextFieldStyle.material,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
