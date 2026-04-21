import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/chat_messages_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ticket_status_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/presentation/manager/inbox_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/presentation/manager/inbox_states.dart';

class ChatScreen extends StatefulWidget {
  final TicketStatusEntity ticket;
  final String ticketId;

  const ChatScreen({super.key, required this.ticket, required this.ticketId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  // تأكد أن هذه القيم يتم تمريرها بشكل صحيح من الـ Cubit أو الـ Auth
  int senderId = 1;
  String senderType = 'user';

  @override
  void initState() {
    super.initState();
    context.read<InboxCubit>().getChatMessages(widget.ticket.conversationId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      context.read<InboxCubit>().sendMessage(
        widget.ticket.conversationId,
        senderId,
        text,
        senderType,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context), // الـ Header كامل بكل بيانات التذكرة
          Expanded(
            child: BlocBuilder<InboxCubit, InboxStates>(
              builder: (context, state) {
                if (state.getChatMessagesRequestStatus ==
                    RequestStatus.loading) {
                  return _buildChatShimmer();
                } else if (state.getChatMessagesRequestStatus ==
                    RequestStatus.error) {
                  return Center(
                    child: Text(state.getChatMessagesErrorMessage ?? "Error"),
                  );
                }

                final messages = state.chatMessages ?? [];
                bool isSending =
                    state.sendMessageRequestStatus == RequestStatus.loading;
                bool hasError =
                    state.sendMessageRequestStatus == RequestStatus.error;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (isSending || hasError ? 1 : 0),
                  itemBuilder: (context, index) {
                    // إذا وصلنا لآخر عنصر وكان هناك عملية إرسال أو خطأ
                    if (index == messages.length) {
                      return _buildStatusMessageCard(
                        state.lastSentMessage ??
                            "", // يجب إضافة هذا الحقل في الـ State
                        isSending,
                        hasError,
                      );
                    }

                    final message = messages[index];
                    bool isMe = message.senderType == 'user';
                    return _buildMessageBubble(message, isMe);
                  },
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  // الكارد الذي يظهر أثناء التحميل أو عند حدوث خطأ في الإرسال
  Widget _buildStatusMessageCard(String content, bool isLoading, bool isError) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isError
              ? Colors.red[50]
              : const Color(0xFF0047AB).withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          border: isError ? Border.all(color: Colors.red) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: TextStyle(
                color: isError ? Colors.black87 : Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  const SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                if (isError) ...[
                  const Icon(Icons.error_outline, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    "Failed",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.read<InboxCubit>().sendMessage(
                      widget.ticket.conversationId,
                      senderId,
                      content,
                      senderType,
                    ),
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessagesEntity message, bool isMe) {
    String formattedDate = DateFormat(
      'MMM d, yyyy hh:mm a',
    ).format(message.createdAt);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF0047AB) : Colors.white,
          border: isMe ? null : Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isMe
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey[300],
                  child: Text(
                    isMe ? "Y" : "S",
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isMe ? "You" : "Support",
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: isMe ? Colors.white70 : Colors.grey,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              message.content,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                height: 1.4,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type your reply...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _handleSend,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0047AB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // --- Header المعاد بالكامل كما طلبت ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0047AB),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'Ticket #${widget.ticketId}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _headerRow("Status", widget.ticket.ticketStatus, Colors.orangeAccent),
          _headerRow(
            "Priority",
            widget.ticket.ticketPriority,
            Colors.greenAccent,
          ),
          _headerRow("Category", widget.ticket.category, Colors.white),
        ],
      ),
    );
  }

  Widget _headerRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(color: valueColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildChatShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) {
          bool isRight = index % 2 == 0;
          return Align(
            alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 80,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        },
      ),
    );
  }
}
