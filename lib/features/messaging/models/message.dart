class Message {
  final String id;
  final String content;
  final MessageMetadata metadata;

  Message({
    required this.id,
    required this.content,
    required this.metadata,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      metadata: MessageMetadata.fromJson(json['metadata']),
    );
  }
}

class MessageMetadata {
  final String timestamp;
  final String senderId;
  final String type;
  final bool read;

  MessageMetadata({
    required this.timestamp,
    required this.senderId,
    required this.type,
    required this.read,
  });

  factory MessageMetadata.fromJson(Map<String, dynamic> json) {
    return MessageMetadata(
      timestamp: json['timestamp'],
      senderId: json['senderId'],
      type: json['type'],
      read: json['read'],
    );
  }
}
