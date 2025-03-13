import 'package:flutter/material.dart';
import '../../../design_system/index.dart';
import '../models/message.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.metadata.type == 'user';
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: AppSpacing.paddingVerticalSM,
        padding: AppSpacing.paddingMD,
        decoration: BoxDecoration(
          color: isUserMessage ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.content,
          style: isUserMessage
              ? AppTypography.bodyMedium.copyWith(color: Colors.white)
              : AppTypography.bodyMedium,
        ),
      ),
    );
  }
}
