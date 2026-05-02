import 'package:flutter/material.dart';

class TelegramAvatar extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final double radius;
  final bool isGroup;

  const TelegramAvatar({
    super.key,
    required this.title,
    this.imageUrl,
    this.radius = 24,
    this.isGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl == null || imageUrl!.isEmpty
            ? _FallbackAvatar(
                title: title,
                isGroup: isGroup,
              )
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _FallbackAvatar(
                  title: title,
                  isGroup: isGroup,
                ),
              ),
      ),
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  final String title;
  final bool isGroup;

  const _FallbackAvatar({required this.title, required this.isGroup});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _colorsFor(title),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          _initials(title),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  static String _initials(String value) {
    final words = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first.characters.first.toUpperCase();
    return '${words[0].characters.first}${words[1].characters.first}'
        .toUpperCase();
  }

  static List<Color> _colorsFor(String value) {
    const palettes = [
      [Color(0xFF37AEE2), Color(0xFF1E96C8)],
      [Color(0xFF4CC38A), Color(0xFF229ED9)],
      [Color(0xFFEE7A62), Color(0xFFD95473)],
      [Color(0xFFF2B84B), Color(0xFFE87E39)],
      [Color(0xFF8E7CF6), Color(0xFF4C6FFF)],
      [Color(0xFF5AC8FA), Color(0xFF2D9CDB)],
    ];
    final index = value.codeUnits.fold<int>(0, (sum, code) => sum + code) %
        palettes.length;
    return palettes[index];
  }
}
