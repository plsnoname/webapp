import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../design_system/index.dart';
import '../models/chat.dart';
import '../widgets/chat_item.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat> chats = [];

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  Future<void> loadChats() async {
    final String response =
        await rootBundle.loadString('assets/data/chats_list.json');
    final data = json.decode(response);
    setState(() {
      chats =
          (data['chats'] as List).map((chat) => Chat.fromJson(chat)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats', style: AppTypography.heading3),
      ),
      body: ListView.builder(
        padding: AppSpacing.paddingMD,
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ChatItem(chat: chats[index]);
        },
      ),
    );
  }
}
