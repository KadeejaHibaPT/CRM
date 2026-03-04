import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Assistant Pro',
      theme: _buildTheme(),
      home: const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      fontFamily: 'SF Pro Display',
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF6366F1),
        secondary: Color(0xFF8B5CF6),
        surface: Color(0xFFFAFAFA),
        background: Color(0xFFF8FAFC),
        onPrimary: Colors.white,
        onSurface: Color(0xFF1F2937),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1F2937),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];

  bool _isTyping = false;
  bool _isLoading = false;
  bool _isInitialized = false;

  late AnimationController _typingAnimationController;
  late AnimationController _sendButtonController;
  late AnimationController _appBarController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeGemini();
    _addWelcomeMessage();
  }

  void _initializeAnimations() {
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _appBarController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
  }

  Future<void> _initializeGemini() async {
    try {
      const apiKey = 'AIzaSyCX9zECZMJX3xKNl-icIXEkqcQ6dv17CJQ';
      Gemini.init(apiKey: apiKey, enableDebugging: false);
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Gemini initialization error: $e');
      setState(() {
        _isInitialized = false;
      });
    }
  }

  void _addWelcomeMessage() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: "Hello! I'm your AI assistant. How can I help you today?",
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
      }
    });
  }

  @override
  void dispose() {
    _typingAnimationController.dispose();
    _sendButtonController.dispose();
    _appBarController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final userMessage = _textController.text.trim();
    if (userMessage.isEmpty || _isLoading || !_isInitialized) return;

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _textController.clear();
      _isLoading = true;
      _isTyping = true;
    });

    // Animate send button and scroll
    _sendButtonController.forward().then((_) => _sendButtonController.reverse());
    await _scrollToBottom();

    try {
      // Simulate processing delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      final response = await Gemini.instance.prompt(
        parts: [Part.text(userMessage)],
      );

      if (mounted) {
        final botReply = response?.output ??
            "I'm sorry, I couldn't process that request. Please try again.";

        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: botReply,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });

        await _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: 'I encountered an error while processing your request. Please check your connection and try again.',
            isUser: false,
            timestamp: DateTime.now(),
            isError: true,
          ));
          _isLoading = false;
        });

        await _scrollToBottom();
      }
    }
  }

  Future<void> _scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (_scrollController.hasClients && mounted) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 80, top: 8, bottom: 16),
      child: Row(
        children: [
          _buildAvatarIcon(),
          const SizedBox(width: 12),
          AnimatedBuilder(
            animation: _typingAnimationController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) => _buildDot(index)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
      child: AnimatedBuilder(
        animation: _typingAnimationController,
        builder: (context, child) {
          final animationValue = _typingAnimationController.value;
          final delay = index * 0.2;
          double opacity = 0.3;

          if (animationValue >= delay && animationValue <= delay + 0.4) {
            opacity = 1.0;
          }

          return Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(opacity),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarIcon({bool isLarge = false}) {
    final size = isLarge ? 40.0 : 32.0;
    final iconSize = isLarge ? 22.0 : 18.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.psychology_outlined,
        color: Colors.white,
        size: iconSize,
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    final isUser = message.isUser;
    final showAvatar = index == 0 ||
        (index > 0 && _messages[index - 1].isUser != message.isUser);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 500)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        // Clamp the animation value to prevent opacity issues
        final clampedValue = value.clamp(0.0, 1.0);

        return Transform.scale(
          scale: 0.8 + (0.2 * clampedValue),
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - clampedValue)),
            child: Opacity(
              opacity: clampedValue,
              child: Container(
                margin: EdgeInsets.only(
                  left: isUser ? 60 : 16,
                  right: isUser ? 16 : 60,
                  top: showAvatar ? 20 : 6,
                  bottom: 6,
                ),
                child: Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (showAvatar && !isUser) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            _buildAvatarIcon(),
                            const SizedBox(width: 10),
                            Text(
                              "AI Assistant",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        gradient: isUser
                            ? const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                        color: isUser
                            ? null
                            : message.isError
                            ? const Color(0xFFFEF2F2)
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(isUser ? 20 : 6),
                          bottomRight: Radius.circular(isUser ? 6 : 20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isUser
                                ? const Color(0xFF6366F1).withOpacity(0.25)
                                : Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: message.isError
                            ? Border.all(
                          color: const Color(0xFFFECACA),
                          width: 1.5,
                        )
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.text,
                            style: TextStyle(
                              color: isUser
                                  ? Colors.white
                                  : message.isError
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF1F2937),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatTimestamp(message.timestamp),
                                style: TextStyle(
                                  color: isUser
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.grey[500],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              if (isUser && !message.isError) ...[
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 30) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _focusNode.hasFocus
                        ? const Color(0xFF6366F1).withOpacity(0.5)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: "Type your message...",
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                  enabled: !_isLoading && _isInitialized,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return AnimatedBuilder(
      animation: _sendButtonController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_sendButtonController.value * 0.1),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: _isLoading || !_isInitialized
                  ? null
                  : const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              color: _isLoading || !_isInitialized
                  ? const Color(0xFFE5E7EB)
                  : null,
              shape: BoxShape.circle,
              boxShadow: _isLoading || !_isInitialized
                  ? null
                  : [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(26),
                onTap: (_isLoading || !_isInitialized) ? null : _sendMessage,
                child: Center(
                  child: _isLoading
                      ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.grey[600]!,
                      ),
                    ),
                  )
                      : const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: AnimatedBuilder(
          animation: _appBarController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _appBarController,
              child: Row(
                children: [
                  _buildAvatarIcon(isLarge: true),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "AI Assistant Pro",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                          letterSpacing: 0.3,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _isInitialized
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isInitialized ? "Online" : "Connecting...",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _isInitialized
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF6B7280)),
            onPressed: () {
              // Add menu functionality here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index], index);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });
}