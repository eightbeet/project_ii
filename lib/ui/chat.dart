import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'api_key_page.dart';

class Chat extends StatefulWidget {
  static const title = 'AI Chat';

  const Chat({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<Chat> createState() => _AppState();
}

class _AppState extends State<Chat> {
  String? _geminiApiKey;

  @override
  void initState() {
    super.initState();
     _geminiApiKey = "API_KEY_GOES_HERE";
    // _geminiApiKey = widget.prefs.getString('gemini_api_key');
  }

  void _setApiKey(String apiKey) {
    setState(() => _geminiApiKey = apiKey);
    widget.prefs.setString('gemini_api_key', apiKey);
  }

  void _resetApiKey() {
    setState(() => _geminiApiKey = null);
    widget.prefs.remove('gemini_api_key');
  }

  @override
  Widget build(BuildContext context) =>
          ChatPage(
                    geminiApiKey: _geminiApiKey!,
                    onResetApiKey: _resetApiKey,
          );
              // _geminiApiKey == null
                  // ? GeminiApiKeyPage(title: Chat.title, onApiKey: _setApiKey)
                  // :
}

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.geminiApiKey,
    required this.onResetApiKey,
    super.key,
  });

  final String geminiApiKey;
  final void Function() onResetApiKey;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.25,
    upperBound: 1.0,
  );

  late final _provider = GeminiProvider(
    model: GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: widget.geminiApiKey,
    ),
  );

  final llmChatMode = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _resetAnimation();
  }

  void _resetAnimation() {
    _animationController.value = 1.0;
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _clearHistory() {
    _provider.history = [];
    _resetAnimation();
  }

  void _exitChat() {
     Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: llmChatMode,
    builder:
        (context, aiChat, child) =>
        Scaffold(
          appBar: AppBar(
            title: const Text(Chat.title),
            backgroundColor: Theme.of(context).colorScheme.surfaceDim,
            actions: [
              IconButton(
                onPressed: widget.onResetApiKey,
                tooltip: 'Reset API Key',
                icon: const Icon(Icons.key),
              ),
              IconButton(
                onPressed: _clearHistory,
                tooltip: 'Clear History',
                icon: const Icon(Icons.history),
              ),
              Container(
               decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  color: Theme.of(context).colorScheme.primaryFixedDim,
               ),
               child: IconButton(
                onPressed: _exitChat,
                tooltip: 'back',
                icon: const Icon(Icons.exit_to_app),
              )),
            ],
          ),
          body: AnimatedBuilder(
            animation: _animationController,
            builder:
                (context, child) { 
                  return Stack(
                     children: [
                        SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child:  Container(
                             decoration: BoxDecoration(
                                color: Colors.white, 
                             ),
                          ),
                        ),
                        LlmChatView(
                           provider: _provider,
                           style: style,
                           welcomeMessage: 'Hello! How how can i be of help today!',
                           suggestions: [
                              'What are some coping strategies I can use when I feel overwhelmed?',
                              'What can I do when a\'m feeling really down?',
                              'What can I do when I feel the urge to check on my social media?'
                          ],
                       ),
                    ],
                );
             },
          ),
       ),
   ); 

   LlmChatViewStyle get style {
      final aiChatActionButtonStyle = ActionButtonStyle(
         iconColor: Color(0xFFD1D1D1),
         iconDecoration: BoxDecoration(
           color: Theme.of(context).colorScheme.primary,
           borderRadius: BorderRadius.circular(20),
         ),
      );

      final aiChatMenuButtonStyle = ActionButtonStyle(
         iconDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
      ),
    );

    return LlmChatViewStyle(
      backgroundColor: Colors.transparent,
      progressIndicatorColor: Theme.of(context).colorScheme.primary,

      suggestionStyle: SuggestionStyle(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.zero,
            topRight: Radius.zero,
            bottomRight: Radius.circular(20),
          ),
          color: Theme.of(context).colorScheme.secondaryFixed,
        ),
      ),

     chatInputStyle: ChatInputStyle(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh, 
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          border: Border.all(color: Color(0xFF919191)),
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.outlineVariant),
        hintText: 'Talk to me...',
      ),

      userMessageStyle: UserMessageStyle(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer, 
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.zero,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(76),
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),

      llmMessageStyle: LlmMessageStyle(
        iconColor: Theme.of(context).colorScheme.secondary,
        iconDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            topRight: Radius.zero,
            bottomRight: Radius.circular(8),
          ),
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
        ),

        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.only(
            topLeft: Radius.zero,
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        // markdownStyle: MarkdownStyleSheet(),
      ),
      recordButtonStyle: aiChatActionButtonStyle,
      stopButtonStyle: aiChatActionButtonStyle,
      submitButtonStyle: aiChatActionButtonStyle,
      addButtonStyle: aiChatActionButtonStyle,
      closeButtonStyle: aiChatActionButtonStyle,
      cancelButtonStyle: aiChatActionButtonStyle,
      closeMenuButtonStyle: aiChatActionButtonStyle,
      copyButtonStyle: aiChatMenuButtonStyle,
      actionButtonBarDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryFixedDim,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
