class Chat {
  final String chatId;
  final String name;
  final String lastMessage;
  final int unreadMessages;

  Chat({
    required this.chatId,
    required this.name,
    required this.lastMessage,
    required this.unreadMessages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'],
      name: json['name'],
      lastMessage: json['lastMessage'],
      unreadMessages: json['unreadMessages'],
    );
  }
}
