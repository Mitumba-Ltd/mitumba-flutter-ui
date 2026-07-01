import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

// ─── Models ─────────────────────────────────────────────────────────────────

/// A conversation in the inbox.
class Conversation {
  const Conversation({
    required this.id,
    required this.partnerId,
    required this.partnerName,
    this.partnerAvatarUrl,
    required this.lastMessage,
    required this.lastMessageAt,
    this.unread = false,
    this.listingTitle,
  });

  final String id;
  final String partnerId;
  final String partnerName;
  final String? partnerAvatarUrl;
  final String lastMessage;
  final String lastMessageAt;
  final bool unread;
  final String? listingTitle;
}

/// Attachment type for a chat message.
enum ChatAttachmentType { image, file }

/// An attachment on a [ChatMessage].
class ChatAttachment {
  const ChatAttachment({
    required this.type,
    required this.name,
    required this.url,
    this.size,
  });

  /// Attachment type.
  final ChatAttachmentType type;

  /// File or image name.
  final String name;

  /// URL to the resource.
  final String url;

  /// Human-readable file size (e.g. "2.4 MB").
  final String? size;
}

/// A single message in a chat thread.
class ChatMessage {
  const ChatMessage({
    required this.body,
    required this.timestamp,
    required this.isMine,
    this.senderName,
    this.attachment,
  });

  final String body;
  final String timestamp;
  final bool isMine;
  final String? senderName;

  /// Optional file or image attachment.
  final ChatAttachment? attachment;
}

// ─── InboxLayout ────────────────────────────────────────────────────────────

/// Split-pane inbox layout — list on left, thread on right (mobile: one at a time).
///
/// ```dart
/// InboxLayout(
///   conversationList: ConversationList(...),
///   chatThread: ChatThread(...),
/// )
/// ```
class InboxLayout extends StatelessWidget {
  const InboxLayout({
    super.key,
    required this.conversationList,
    required this.chatThread,
    this.title = 'Messages',
    this.showMobileBack = false,
    this.onMobileBack,
  });

  final Widget conversationList;
  final Widget chatThread;
  final String title;
  final bool showMobileBack;
  final VoidCallback? onMobileBack;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (constraints.maxWidth >= 768) {
        return Row(children: [
          SizedBox(width: 320, child: conversationList),
          const VerticalDivider(width: 1, color: MitumbaColors.divider),
          Expanded(child: chatThread),
        ]);
      }
      // Mobile: show back button when in thread
      if (showMobileBack) {
        return Column(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.md, vertical: MitumbaSpacing.md),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: onMobileBack),
              SizedBox(width: MitumbaSpacing.sm),
              Text(title, style: MitumbaTypography.h5),
            ]),
          ),
          Expanded(child: chatThread),
        ]);
      }
      return conversationList;
    });
  }
}

// ─── ConversationList ───────────────────────────────────────────────────────

/// List of conversations with search and compose.
class ConversationList extends StatelessWidget {
  const ConversationList({
    super.key,
    required this.conversations,
    this.activeId,
    required this.onSelect,
    this.onSearch,
    this.onCompose,
    this.loading = false,
  });

  final List<Conversation> conversations;
  final String? activeId;
  final ValueChanged<String> onSelect;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onCompose;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(MitumbaSpacing.lg),
          child: Row(
            children: [
              Expanded(child: Text('Messages', style: MitumbaTypography.h5)),
              if (onCompose != null)
                IconButton(icon: const Icon(Icons.edit_outlined), onPressed: onCompose, iconSize: 20),
            ],
          ),
        ),
        if (onSearch != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.lg),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search messages...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
              ),
              onChanged: onSearch,
            ),
          ),
        SizedBox(height: MitumbaSpacing.md),
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : conversations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 48, color: MitumbaColors.textDisabled),
                          SizedBox(height: MitumbaSpacing.md),
                          Text('No conversations yet', style: MitumbaTypography.body2.copyWith(color: MitumbaColors.textSecondary)),
                        ],
                      ),
                    )
                  : ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (_, i) => _ConversationTile(
                    conversation: conversations[i],
                    isActive: conversations[i].id == activeId,
                    onTap: () => onSelect(conversations[i].id),
                  ),
                ),
        ),
      ],
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation, required this.isActive, required this.onTap});
  final Conversation conversation;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.lg, vertical: MitumbaSpacing.base),
        color: isActive ? MitumbaColors.greenLight : null,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: MitumbaColors.background,
              child: Text(
                conversation.partnerName.isNotEmpty ? conversation.partnerName[0] : '?',
                style: const TextStyle(fontWeight: FontWeight.w700, color: MitumbaColors.textSecondary),
              ),
            ),
            SizedBox(width: MitumbaSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.partnerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: MitumbaTypography.body2.copyWith(
                            fontWeight: conversation.unread ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(conversation.lastMessageAt, style: MitumbaTypography.caption.copyWith(color: MitumbaColors.textDisabled)),
                    ],
                  ),
                  SizedBox(height: MitumbaSpacing.xxs),
                  Text(
                    conversation.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: MitumbaTypography.caption.copyWith(color: MitumbaColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (conversation.unread)
              Container(
                margin: EdgeInsets.only(left: MitumbaSpacing.md),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: MitumbaColors.green, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── ChatThread ─────────────────────────────────────────────────────────────

/// Chat thread with messages and message input.
class ChatThread extends StatefulWidget {
  const ChatThread({
    super.key,
    required this.messages,
    required this.partnerName,
    required this.onSend,
    this.partnerAvatarUrl,
    this.partnerStatus,
    this.sending = false,
    this.loading = false,
  });

  final List<ChatMessage> messages;
  final String partnerName;
  final String? partnerAvatarUrl;
  final String? partnerStatus;
  final ValueChanged<String> onSend;
  final bool sending;
  final bool loading;

  @override
  State<ChatThread> createState() => _ChatThreadState();
}

class _ChatThreadState extends State<ChatThread> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.all(MitumbaSpacing.lg),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: MitumbaColors.divider))),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: MitumbaColors.greenLight,
                child: Text(widget.partnerName.isNotEmpty ? widget.partnerName[0] : '?',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: MitumbaColors.green)),
              ),
              SizedBox(width: MitumbaSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.partnerName, style: MitumbaTypography.body2.copyWith(fontWeight: FontWeight.w700)),
                  if (widget.partnerStatus != null)
                    Text(widget.partnerStatus!, style: MitumbaTypography.caption.copyWith(color: MitumbaColors.textDisabled)),
                ],
              ),
            ],
          ),
        ),
        // Messages
        Expanded(
          child: widget.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(MitumbaSpacing.lg),
                  itemCount: widget.messages.length,
                  itemBuilder: (_, i) {
                    final msg = widget.messages[widget.messages.length - 1 - i];
                    return _MessageBubble(message: msg);
                  },
                ),
        ),
        // Input
        Container(
          padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.lg, vertical: MitumbaSpacing.md),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: MitumbaColors.divider))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(MitumbaRadius.full)),
                    contentPadding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.lg, vertical: MitumbaSpacing.md),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              SizedBox(width: MitumbaSpacing.md),
              Semantics(
                button: true,
                label: 'Send message',
                child: IconButton(
                  onPressed: widget.sending ? null : _send,
                  icon: const Icon(Icons.send),
                  color: MitumbaColors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMine) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: MitumbaColors.background,
              child: Text(
                message.senderName != null && message.senderName!.isNotEmpty
                    ? message.senderName![0]
                    : '?',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: MitumbaColors.textSecondary,
                ),
              ),
            ),
            SizedBox(width: MitumbaSpacing.sm),
          ],
          Flexible(
            child: Container(
              margin: EdgeInsets.only(bottom: MitumbaSpacing.md),
              padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.base, vertical: MitumbaSpacing.md),
              constraints: const BoxConstraints(maxWidth: 280),
              decoration: BoxDecoration(
                color: message.isMine ? MitumbaColors.green : MitumbaColors.background,
                borderRadius: message.isMine
                    ? BorderRadius.only(
                        topLeft: Radius.circular(MitumbaRadius.lg),
                        topRight: Radius.circular(MitumbaRadius.lg),
                        bottomLeft: Radius.circular(MitumbaRadius.lg),
                        bottomRight: Radius.circular(MitumbaRadius.xs),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(MitumbaRadius.lg),
                        topRight: Radius.circular(MitumbaRadius.lg),
                        bottomLeft: Radius.circular(MitumbaRadius.xs),
                        bottomRight: Radius.circular(MitumbaRadius.lg),
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image attachment
                  if (message.attachment?.type == ChatAttachmentType.image)
                    Padding(
                      padding: EdgeInsets.only(bottom: MitumbaSpacing.md),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(MitumbaRadius.md),
                        child: Image.network(
                          message.attachment!.url,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            color: MitumbaColors.divider,
                            child: const Icon(Icons.broken_image_outlined, color: MitumbaColors.textDisabled),
                          ),
                        ),
                      ),
                    ),
                  // File attachment
                  if (message.attachment?.type == ChatAttachmentType.file)
                    Container(
                      margin: EdgeInsets.only(bottom: MitumbaSpacing.md),
                      padding: EdgeInsets.all(MitumbaSpacing.md),
                      decoration: BoxDecoration(
                        color: message.isMine
                            ? MitumbaColors.white.withAlpha(38)
                            : MitumbaColors.surface,
                        borderRadius: BorderRadius.circular(MitumbaRadius.md),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.insert_drive_file_outlined,
                            size: 18,
                            color: message.isMine ? MitumbaColors.white : MitumbaColors.textSecondary,
                          ),
                          SizedBox(width: MitumbaSpacing.sm),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.attachment!.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: MitumbaTypography.caption.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: message.isMine ? MitumbaColors.white : MitumbaColors.textPrimary,
                                  ),
                                ),
                                if (message.attachment!.size != null)
                                  Text(
                                    message.attachment!.size!,
                                    style: MitumbaTypography.caption.copyWith(
                                      fontSize: 10,
                                      color: message.isMine
                                          ? MitumbaColors.white.withAlpha(180)
                                          : MitumbaColors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    message.body,
                    style: MitumbaTypography.body2.copyWith(
                      color: message.isMine ? MitumbaColors.white : MitumbaColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: MitumbaSpacing.xxs),
                  Text(
                    message.timestamp,
                    style: MitumbaTypography.caption.copyWith(
                      fontSize: 10,
                      color: message.isMine ? MitumbaColors.white.withAlpha(180) : MitumbaColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
