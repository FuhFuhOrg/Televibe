import 'package:flutter/material.dart';
import 'package:tele_vibe/GettedData/pseudoChatApi.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/Widgets/UnderWidgets/telegramAvatar.dart';

class StoriesViewerScreen extends StatefulWidget {
  final int initialIndex;

  const StoriesViewerScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<StoriesViewerScreen> createState() => _StoriesViewerScreenState();
}

class _StoriesViewerScreenState extends State<StoriesViewerScreen> {
  late final PageController _pageController;
  late final List<PseudoStory> _stories;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _stories = PseudoChatApi.stories();
    _currentIndex = _stories.isEmpty
        ? 0
        : widget.initialIndex.clamp(0, _stories.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
    if (_stories.isNotEmpty) {
      PseudoChatApi.markStoryViewed(_stories[_currentIndex].id);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openAdjacent(int delta) {
    final next = _currentIndex + delta;
    if (next < 0) {
      Navigator.pop(context);
      return;
    }
    if (next >= _stories.length) {
      Navigator.pop(context);
      return;
    }
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (_stories.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Text(
              'No stories available',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
            PseudoChatApi.markStoryViewed(_stories[index].id);
          },
          itemCount: _stories.length,
          itemBuilder: (context, index) {
            final story = _stories[index];
            return GestureDetector(
              onTapDown: (details) {
                final width = MediaQuery.of(context).size.width;
                if (details.localPosition.dx < width * 0.35) {
                  _openAdjacent(-1);
                } else {
                  _openAdjacent(1);
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  story.backgroundUrl.isEmpty
                      ? Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF21364A), Color(0xFF0E1621)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        )
                      : Image.network(
                          story.backgroundUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF21364A), Color(0xFF0E1621)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xAA000000),
                          Color(0x22000000),
                          Color(0xCC000000)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, 0.45, 1],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(
                            _stories.length,
                            (progressIndex) => Expanded(
                              child: Container(
                                height: 3,
                                margin: EdgeInsets.only(
                                  right: progressIndex == _stories.length - 1
                                      ? 0
                                      : 4,
                                ),
                                decoration: BoxDecoration(
                                  color: progressIndex <= _currentIndex
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.32),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            TelegramAvatar(
                              title: story.title,
                              imageUrl: story.avatarUrl,
                              radius: 21,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    story.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    story.ageLabel,
                                    style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.74),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close_rounded,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.28),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.16)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                story.subtitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  height: 1.05,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                l10n.storyPreviewDescription,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.84),
                                  fontSize: 14,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () {},
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        minimumSize:
                                            const Size(double.infinity, 46),
                                      ),
                                      icon: const Icon(Icons.reply_rounded),
                                      label: Text(l10n.replyAction),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.2),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.favorite_border_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
