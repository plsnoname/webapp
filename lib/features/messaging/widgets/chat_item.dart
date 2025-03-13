import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../design_system/index.dart';
import '../models/chat.dart';

class ChatItem extends StatelessWidget {
  final Chat chat;

  const ChatItem({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: AppSpacing.paddingVerticalSM,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(chat.name, style: AppTypography.bodyLarge),
        subtitle: Text(chat.lastMessage, style: AppTypography.bodySmall),
        trailing: chat.unreadMessages > 0
            ? CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.error,
                child: Text(
                  chat.unreadMessages.toString(),
                  style: AppTypography.caption.copyWith(color: Colors.white),
                ),
              )
            : null,
        onTap: () {
          GoRouter.of(context)
              .push('/settings/messages/chat', extra: chat.chatId);
        },
      ),
    );
  }
}
