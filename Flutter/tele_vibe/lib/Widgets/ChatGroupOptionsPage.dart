import 'package:flutter/material.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/ViewModel/chatGroupOptionVM.dart';

class ChatGroupOptionsPage extends StatefulWidget {
  const ChatGroupOptionsPage({super.key});

  @override
  State<ChatGroupOptionsPage> createState() => _ChatGroupOptionsPageState();
}

class _ChatGroupOptionsPageState extends State<ChatGroupOptionsPage> {
  bool _isCreatingGroup = true;
  bool _isAddingChat = false;
  bool _createAsGroup = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _createPasswordController =
      TextEditingController();
  final TextEditingController _chatIdController = TextEditingController();
  final TextEditingController _chatPasswordController = TextEditingController();
  final ChatGroupOptionVM _chatGroupOptionVM = ChatGroupOptionVM();
  final String _groupHost = '';

  @override
  void dispose() {
    _chatGroupOptionVM.dispose();
    _nameController.dispose();
    _createPasswordController.dispose();
    _chatIdController.dispose();
    _chatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      appBar: AppBar(
        title: Text(
          l10n.newConversationTitle,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF17212B),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF17212B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF243447)),
                ),
                child: Text(
                  _isCreatingGroup
                      ? l10n.createConversationDescription
                      : l10n.joinConversationDescription,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _ModeButton(
                      label: l10n.createTabLabel,
                      selected: _isCreatingGroup,
                      onTap: () {
                        setState(() {
                          _isCreatingGroup = true;
                          _isAddingChat = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ModeButton(
                      label: l10n.joinTabLabel,
                      selected: _isAddingChat,
                      onTap: () {
                        setState(() {
                          _isAddingChat = true;
                          _isCreatingGroup = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              if (_isCreatingGroup) ...[
                _buildSectionTitle(l10n.conversationDetailsSection),
                _buildTextField(
                  controller: _nameController,
                  label: l10n.conversationNameLabel,
                  hint: l10n.conversationNameHint,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _createPasswordController,
                  label: l10n.accessCodeLabel,
                  hint: l10n.optionalHint,
                  obscureText: true,
                ),
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF17212B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF243447)),
                  ),
                  child: SwitchListTile(
                    value: _createAsGroup,
                    onChanged: (value) {
                      setState(() {
                        _createAsGroup = value;
                      });
                    },
                    activeThumbColor: const Color(0xFF2AABEE),
                    title: Text(
                      l10n.createAsGroupTitle,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      l10n.createAsGroupDescription,
                      style: TextStyle(color: Color(0xFF7F91A4)),
                    ),
                  ),
                ),
              ],
              if (_isAddingChat) ...[
                _buildSectionTitle(l10n.joinWithCredentialsSection),
                _buildTextField(
                  controller: _nameController,
                  label: l10n.displayNameLabel,
                  hint: l10n.displayNameHint,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _chatIdController,
                  label: l10n.chatIdLabel,
                  hint: l10n.pasteConversationIdHint,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _chatPasswordController,
                  label: l10n.accessCodeLabel,
                  hint: l10n.accessCodeRequiredHint,
                  obscureText: true,
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isCreatingGroup || _isAddingChat
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_isCreatingGroup) {
                    _chatGroupOptionVM.createChat(
                      context,
                      _nameController.text,
                      _createPasswordController.text,
                      _groupHost,
                      _createAsGroup,
                    );
                  } else if (_isAddingChat) {
                    _chatGroupOptionVM.enterInChat(
                      context,
                      _nameController.text,
                      _chatIdController.text,
                      _chatPasswordController.text,
                      _groupHost,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2AABEE),
                  minimumSize: const Size(
                      double.infinity, 50), // Кнопка по ширине экрана
                ),
                child: Text(
                    _isCreatingGroup
                        ? l10n.createConversationCta
                        : l10n.joinChatCta,
                    style: const TextStyle(color: Colors.white)),
              ),
            )
          : null,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      cursorColor: const Color(0xFF2AABEE),
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Color(0xFF7F91A4)),
        hintStyle: const TextStyle(color: Color(0xFF56697C)),
        filled: true,
        fillColor: const Color(0xFF17212B),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF243447)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2AABEE)),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
              selected ? const Color(0xFF2AABEE) : const Color(0xFF243447),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
