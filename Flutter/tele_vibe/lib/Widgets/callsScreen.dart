import 'package:flutter/material.dart';
import 'package:tele_vibe/GettedData/pseudoChatApi.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/Widgets/UnderWidgets/telegramAvatar.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  bool _showMissedOnly = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final calls = PseudoChatApi.calls()
        .where((entry) => !_showMissedOnly || entry.missed)
        .toList();
    final allCalls = PseudoChatApi.calls();
    final missedCount = allCalls.where((entry) => entry.missed).length;
    final videoCount = allCalls.where((entry) => entry.isVideo).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17212B),
        title:
            Text(l10n.callsTitle, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF17212B),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF243447)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.callHistoryTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.callsMvpDescription,
                  style: TextStyle(
                    color: Color(0xFF7F91A4),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _CallStat(
                      label: l10n.recentStatLabel,
                      value: allCalls.length.toString(),
                    ),
                    _CallStat(
                      label: l10n.missedStatLabel,
                      value: missedCount.toString(),
                    ),
                    _CallStat(
                      label: l10n.videoStatLabel,
                      value: videoCount.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _CallsFilterChip(
                  label: l10n.allCallsFilter,
                  selected: !_showMissedOnly,
                  onTap: () => setState(() => _showMissedOnly = false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CallsFilterChip(
                  label: l10n.missedCallsFilter,
                  selected: _showMissedOnly,
                  onTap: () => setState(() => _showMissedOnly = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (calls.isEmpty)
            const _EmptyCallsState()
          else
            ...calls.map(
              (entry) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF17212B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF243447)),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  leading: TelegramAvatar(
                    title: entry.title,
                    imageUrl: entry.avatarUrl,
                    radius: 24,
                  ),
                  title: Text(
                    entry.title,
                    style: TextStyle(
                      color:
                          entry.missed ? const Color(0xFFFF8C82) : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        _directionIcon(entry),
                        size: 16,
                        color: entry.missed
                            ? const Color(0xFFFF8C82)
                            : const Color(0xFF7F91A4),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${entry.timeLabel} • ${entry.isVideo ? l10n.callTypeVideo : l10n.callTypeVoice}',
                          style: const TextStyle(color: Color(0xFF7F91A4)),
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            entry.isVideo
                                ? l10n.pseudoVideoCallScreen
                                : l10n.pseudoVoiceCallScreen,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      entry.isVideo
                          ? Icons.videocam_rounded
                          : Icons.call_rounded,
                      color: const Color(0xFF2AABEE),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _directionIcon(PseudoCallEntry entry) {
    switch (entry.direction) {
      case 'outgoing':
        return Icons.call_made_rounded;
      case 'incoming':
        return Icons.call_received_rounded;
      default:
        return Icons.call_missed_rounded;
    }
  }
}

class _CallStat extends StatelessWidget {
  final String label;
  final String value;

  const _CallStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1621),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF7F91A4), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _CallsFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CallsFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2AABEE) : const Color(0xFF17212B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF2AABEE) : const Color(0xFF243447),
          ),
        ),
        child: Text(
          label,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _EmptyCallsState extends StatelessWidget {
  const _EmptyCallsState();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF17212B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF243447)),
      ),
      child: Column(
        children: [
          Icon(Icons.call_end_rounded, color: Color(0xFF7F91A4), size: 36),
          SizedBox(height: 12),
          Text(
            l10n.noCallsInFilter,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            l10n.switchBackToAllCalls,
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF7F91A4), height: 1.35),
          ),
        ],
      ),
    );
  }
}
