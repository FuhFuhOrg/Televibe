import 'package:flutter/material.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';

class AddParticipantScreen extends StatefulWidget {
  const AddParticipantScreen({super.key});

  @override
  State<AddParticipantScreen> createState() => _AddParticipantScreenState();
}

class _AddParticipantScreenState extends State<AddParticipantScreen> {
  final TextEditingController _idController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _idController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      appBar: AppBar(
        title: Text(l10n.addParticipantTitle,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF17212B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF17212B),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF243447)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  l10n.inviteByIdTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.inviteByIdDescription,
                  style: TextStyle(
                    color: Color(0xFF7F91A4),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  cursorColor: const Color(0xFF2AABEE),
                  controller: _idController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: l10n.participantIdLabel,
                    labelStyle: const TextStyle(color: Color(0xFF7F91A4)),
                    filled: true,
                    fillColor: const Color(0xFF0E1621),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF243447)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2AABEE)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF243447)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  onEditingComplete: () {
                    _focusNode.unfocus();
                  },
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () {
                    final participantId = _idController.text;
                    debugPrint('Entered participant ID: $participantId');
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2AABEE),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(l10n.inviteParticipantCta,
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
