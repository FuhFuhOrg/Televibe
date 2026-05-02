import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/Data/user.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:pointycastle/asymmetric/api.dart';

class PseudoChatApi {
  static const int currentUserId = 1;
  static bool isEnabled = false;
  static const bool _useRemotePreviewAssets = true;

  static final RSAPublicKey _preparedPublicKey =
      RSAPublicKey(BigInt.from(3233), BigInt.from(17));
  static final RSAPrivateKey _preparedPrivateKey = RSAPrivateKey(
    BigInt.from(3233),
    BigInt.from(2753),
    BigInt.from(61),
    BigInt.from(53),
  );
  static final Set<String> _archivedChatIds = <String>{};
  static final Set<String> _viewedStoryIds = <String>{};

  static (RSAPublicKey, RSAPrivateKey) get _keyPair =>
      (_preparedPublicKey, _preparedPrivateKey);

  static Future<void> activate() async {
    isEnabled = true;
    NetServerController.reconnectEnabled = false;
    resetPortfolioState();
    Anon.anonId = currentUserId;
    Anon.anonPassword = 'reserved-session';
    Anon.username = 'You';
    Chats.setValue(await _buildInitialCollection());
    _archivedChatIds.addAll({'chat-private-8', 'chat-private-9', 'chat-group-10'});
  }

  static Future<void> deactivate() async {
    isEnabled = false;
    NetServerController.reconnectEnabled = true;
  }

  static void resetPortfolioState() {
    _archivedChatIds.clear();
    _viewedStoryIds.clear();
  }

  static List<PseudoStory> stories() {
    return List<PseudoStory>.unmodifiable(_stories);
  }

  static void markStoryViewed(String storyId) {
    _viewedStoryIds.add(storyId);
  }

  static bool isStoryViewed(String storyId) {
    return _viewedStoryIds.contains(storyId);
  }

  static List<PseudoCallEntry> calls() {
    return List<PseudoCallEntry>.unmodifiable(_calls);
  }

  static List<PseudoContact> contacts() {
    return List<PseudoContact>.unmodifiable(_contacts);
  }

  static bool isChatArchived(String chatId) {
    return _archivedChatIds.contains(chatId);
  }

  static void toggleArchived(String chatId) {
    if (_archivedChatIds.contains(chatId)) {
      _archivedChatIds.remove(chatId);
    } else {
      _archivedChatIds.add(chatId);
    }
    Chats.setValue(Chats.getValue());
  }

  static ChatData openOrCreateDirectChat(PseudoContact contact) {
    for (final chat in Chats.getValue().chats) {
      final hasContact = chat.subusers.any(
        (member) => member.id == contact.id || member.userName == contact.name,
      );
      if (!chat.isGroup && hasContact) {
        return chat;
      }
    }

    final chat = ChatData(
      chatName: contact.name,
      chatId: 'contact-${contact.id}',
      password: 'reserved',
      nowQueueId: -1,
      chatIp: 'app',
      yourUserId: currentUserId,
      subusers: [
        _currentUser(),
        Subuser(
          id: contact.id,
          userName: contact.name,
          publicKey: _keyPair.$1,
          privateKey: _keyPair.$2,
          image: null,
          avatarUrl: contact.avatarUrl,
        ),
      ],
      messages: [
        _message(
          id: 1,
          sender: Subuser(
            id: contact.id,
            userName: contact.name,
            publicKey: _keyPair.$1,
            privateKey: _keyPair.$2,
            image: null,
            avatarUrl: contact.avatarUrl,
          ),
          text: 'Started a local demo conversation from Contacts.',
          time: _timeLabel(DateTime.now()),
        ),
      ],
      isPreparedData: true,
      isGroup: false,
      avatarUrl: contact.avatarUrl,
      unreadCount: 0,
    );

    Chats.addChat(chat);
    return chat;
  }

  static List<PseudoMediaItem> mediaForChat(ChatData? chat) {
    if (chat == null) return const <PseudoMediaItem>[];

    final derived = <PseudoMediaItem>[];
    for (int index = 0; index < chat.messages.length; index++) {
      final message = chat.messages[index];
      if (message['isImage'] == true) {
        derived.add(
          PseudoMediaItem(
            id: '${chat.chatId}-media-$index',
            caption: (message['caption'] ?? 'Shared photo').toString(),
            senderName: (message['userName'] ?? chat.chatName).toString(),
            timeLabel: (message['time'] ?? '').toString(),
            imageUrl: message['imageUrl'] as String?,
            imageData: message['imageData'] as String?,
          ),
        );
      }
    }

    final seeded = _mediaByChat[chat.chatId] ?? const <PseudoMediaItem>[];
    if (derived.isEmpty && seeded.isEmpty) {
      return <PseudoMediaItem>[
        PseudoMediaItem(
          id: '${chat.chatId}-fallback-media',
          caption: 'Shared board preview',
          senderName: chat.chatName,
          timeLabel: 'Today',
          imageUrl: _photo('fallback-${chat.chatId}', 720),
        ),
      ];
    }

    return <PseudoMediaItem>[...derived, ...seeded];
  }

  static List<PseudoFileItem> filesForChat(ChatData? chat) {
    if (chat == null) return const <PseudoFileItem>[];
    final seeded = _filesByChat[chat.chatId];
    if (seeded != null) {
      return List<PseudoFileItem>.from(seeded);
    }

    return <PseudoFileItem>[
      PseudoFileItem(
        title: '${chat.chatName} brief.pdf',
        fileType: 'pdf',
        sizeLabel: '2.4 MB',
        detailLabel: 'Shared today',
      ),
      PseudoFileItem(
        title: '${chat.chatName} assets.zip',
        fileType: 'zip',
        sizeLabel: '18.1 MB',
        detailLabel: 'Local mock package',
      ),
      PseudoFileItem(
        title: 'voice-notes.m4a',
        fileType: 'audio',
        sizeLabel: '5:12',
        detailLabel: 'Pseudo voice memo',
      ),
    ];
  }

  static List<PseudoLinkItem> linksForChat(ChatData? chat) {
    if (chat == null) return const <PseudoLinkItem>[];
    final seeded = _linksByChat[chat.chatId];
    if (seeded != null) {
      return List<PseudoLinkItem>.from(seeded);
    }

    return <PseudoLinkItem>[
      PseudoLinkItem(
        title: 'Televibe portfolio board',
        url: 'https://demo.televibe.app/board/${chat.chatId}',
        previewLabel: 'Shared design board',
        timeLabel: 'Today',
      ),
      PseudoLinkItem(
        title: 'Sprint notes',
        url: 'https://demo.televibe.app/docs/${chat.chatId}',
        previewLabel: 'Project notes and status',
        timeLabel: 'Yesterday',
      ),
    ];
  }

  static List<Map<String, dynamic>> messagesForCurrentChat() {
    final chat = Chats.getNowChat();
    if (chat == null) return [];
    return List<Map<String, dynamic>>.from(chat.messages);
  }

  static Future<bool> sendMessage(String text) async {
    final chat = Chats.getNowChat();
    if (chat == null || text.trim().isEmpty) return false;
    final imageData = _extractImageData(text.trim());

    chat.messages.add(_message(
      id: _nextMessageId(chat),
      sender: _currentUser(),
      text: imageData == null ? text.trim() : 'Photo attachment',
      time: _timeLabel(DateTime.now()),
      imageData: imageData,
      status: 'read',
    ));
    chat.unreadCount = 0;
    _moveChatToTop(chat);
    Chats.setValue(Chats.getValue());
    return true;
  }

  static Future<void> editMessage(int id, String text) async {
    final chat = Chats.getNowChat();
    if (chat == null || text.trim().isEmpty) return;

    final index = chat.messages.indexWhere((message) => message['id'] == id);
    if (index == -1) return;

    chat.messages[index]['text'] = text.trim();
    chat.messages[index]['isEdited'] = true;
    Chats.setValue(Chats.getValue());
  }

  static Future<void> deleteMessage(int id) async {
    final chat = Chats.getNowChat();
    if (chat == null) return;

    chat.messages.removeWhere((message) => message['id'] == id);
    Chats.setValue(Chats.getValue());
  }

  static Future<void> createChat(
      {required String name, required bool isGroup}) async {
    final members = isGroup ? _membersFor(8, 99) : _membersFor(2, 98);
    final chat = ChatData(
      chatName: name.trim().isEmpty ? 'New chat' : name.trim(),
      chatId: 'chat-created-${DateTime.now().millisecondsSinceEpoch}',
      password: 'reserved',
      nowQueueId: -1,
      chatIp: 'app',
      yourUserId: currentUserId,
      subusers: members,
      isPreparedData: true,
      isGroup: isGroup,
      avatarUrl: _photo('created-${name.hashCode}', 240),
      unreadCount: 0,
      messages: [
        _message(
          id: 1,
          sender: members.first,
          text: isGroup
              ? 'Group created. You can start the conversation.'
              : 'Chat created. You can start messaging.',
          time: _timeLabel(DateTime.now()),
          status: 'read',
        ),
      ],
    );

    Chats.addChat(chat);
  }

  static Future<ChatCollection> _buildInitialCollection() async {
    final chats = <ChatData>[];
    for (int i = 0; i < _dmSeeds.length; i++) {
      chats.add(_buildDirectChat(i, _dmSeeds[i]));
      if (i.isOdd) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    for (int i = 0; i < _groupSeeds.length; i++) {
      chats.add(_buildGroupChat(i, _groupSeeds[i]));
      if (i.isOdd) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    return ChatCollection(chats: chats);
  }

  static ChatData _buildDirectChat(int index, _DirectSeed seed) {
    final other = Subuser(
      id: 100 + index,
      userName: seed.name,
      publicKey: _keyPair.$1,
      privateKey: _keyPair.$2,
      image: null,
      avatarUrl: seed.avatarUrl,
    );
    final members = [_currentUser(), other];
    final messages = <Map<String, dynamic>>[];
    final baseTime = DateTime.now().subtract(Duration(hours: index + 1));

    for (int i = 0; i < seed.messages.length; i++) {
      final isMe = i.isOdd;
      messages.add(_message(
        id: i + 1,
        sender: isMe ? members.first : other,
        text: seed.messages[i],
        time: _timeLabel(baseTime.add(Duration(minutes: i * 7))),
        status: isMe ? 'read' : null,
      ));
    }

    return ChatData(
      chatName: seed.name,
      chatId: 'chat-private-$index',
      password: 'reserved',
      nowQueueId: -1,
      chatIp: 'app',
      yourUserId: currentUserId,
      subusers: members,
      messages: messages,
      isPreparedData: true,
      isGroup: false,
      avatarUrl: seed.avatarUrl,
      unreadCount: index % 3 == 0 ? index + 1 : 0,
      isPinned: index == 0,
    );
  }

  static ChatData _buildGroupChat(int index, _GroupSeed seed) {
    final members = _membersFor(seed.memberCount, index);
    final messages = <Map<String, dynamic>>[];
    final baseTime =
        DateTime.now().subtract(Duration(days: index % 4, hours: 2));

    for (int i = 0; i < seed.messages.length; i++) {
      final sender = i == seed.messages.length - 1 && index.isEven
          ? members.first
          : members[(i % (members.length - 1)) + 1];
      messages.add(_message(
        id: i + 1,
        sender: sender,
        text: seed.messages[i],
        time: _timeLabel(baseTime.add(Duration(minutes: i * 11))),
        imageUrl: seed.imageMessageIndex == i ? seed.imageUrl : null,
        status: sender.id == currentUserId ? 'read' : null,
      ));
    }

    return ChatData(
      chatName: seed.name,
      chatId: 'chat-group-$index',
      password: 'reserved',
      nowQueueId: -1,
      chatIp: 'app',
      yourUserId: currentUserId,
      subusers: members,
      messages: messages,
      isPreparedData: true,
      isGroup: true,
      avatarUrl: seed.avatarUrl,
      unreadCount: index.isOdd ? (index % 5) + 2 : 0,
      isPinned: index == 1,
    );
  }

  static Subuser _currentUser() {
    return Subuser(
      id: currentUserId,
      userName: 'You',
      publicKey: _keyPair.$1,
      privateKey: _keyPair.$2,
      image: null,
      avatarUrl: _avatar(1),
    );
  }

  static List<Subuser> _membersFor(int count, int chatIndex) {
    final members = <Subuser>[_currentUser()];
    for (int i = 1; i < count; i++) {
      final name = _names[(chatIndex * 3 + i) % _names.length];
      members.add(Subuser(
        id: chatIndex * 1000 + i + 2,
        userName: name,
        publicKey: _keyPair.$1,
        privateKey: _keyPair.$2,
        image: null,
        avatarUrl: _avatar((chatIndex * 7 + i) % 70 + 1),
      ));
    }
    return members;
  }

  static Map<String, dynamic> _message({
    required int id,
    required Subuser sender,
    required String text,
    required String time,
    String? imageUrl,
    String? imageData,
    String? status,
  }) {
    final isImage = imageUrl != null || imageData != null;
    return {
      'id': id,
      'senderId': sender.id,
      'text': isImage ? '[Photo]' : text,
      'caption': isImage ? text : null,
      'isMe': sender.id == currentUserId,
      'userName': sender.userName,
      'time': time,
      'isImage': isImage,
      'imageUrl': imageUrl,
      'imageData': imageData,
      'status': status,
      'senderAvatarUrl': sender.avatarUrl,
      'isEdited': false,
    };
  }

  static int _nextMessageId(ChatData chat) {
    if (chat.messages.isEmpty) return 1;
    return chat.messages
            .map((message) => message['id'] as int? ?? 0)
            .fold<int>(0, (max, id) => id > max ? id : max) +
        1;
  }

  static void _moveChatToTop(ChatData chat) {
    final collection = Chats.getValue();
    collection.chats.removeWhere((item) => item.chatId == chat.chatId);
    collection.chats.insert(0, chat);
  }

  static String _timeLabel(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String _avatar(int id) {
    if (!_useRemotePreviewAssets) return '';
    return 'https://i.pravatar.cc/160?img=$id';
  }

  static String? _extractImageData(String value) {
    if (!value.startsWith('<img>') || !value.endsWith('</img>')) return null;
    return value.substring(5, value.length - 6);
  }

  static String _photo(String seed, int size) {
    if (!_useRemotePreviewAssets) return '';
    return 'https://picsum.photos/seed/televibe-$seed/$size/$size';
  }

  static final List<_DirectSeed> _dmSeeds = [
    _DirectSeed('Anna Carter', _avatar(12), [
      'Hi! I moved the meeting to 3:30 PM. Does that still work for you?',
      'Yes, that is perfect. I will make it in time.',
      'Great. I will send the final mockup an hour before the call.',
      'Perfect, I will review it and leave notes in the file.',
    ]),
    _DirectSeed('Noah Reed', _avatar(18), [
      'The server is lagging again today.',
      'I can see it. If the connection drifts, we can still open the prepared chats.',
      'Good fallback. The chat layouts already feel close to the real product.',
      'Let us run the mobile check after lunch.',
    ]),
    _DirectSeed('Maya Collins', _avatar(23), [
      'I left a list of questions for the presentation.',
      'Thanks, I am opening it now.',
      'We mainly need to confirm the timing and who shows the app.',
      'I will handle the demo and write the timeline in the notes.',
    ]),
    _DirectSeed('Liam Hayes', _avatar(31), [
      'I booked the meeting room for tomorrow.',
      'Nice. Does it have a screen?',
      'Yes, and the audio setup is good for the call.',
      'Perfect, we will use that room.',
    ]),
    _DirectSeed('Olivia Brooks', _avatar(37), [
      'I need a short task summary before the evening.',
      'I will put everything into one list and send it here.',
      'Please mention what is already complete as well.',
      'Of course, I will mark everything with status notes.',
    ]),
    _DirectSeed('Daniel Ross', _avatar(44), [
      'I found a couple of strong references for the home screen.',
      'Send them over, I want to check the spacing and rhythm.',
      'They use a lot of air and really clean message cards.',
      'That is exactly what we need for a modern messenger feel.',
    ]),
    _DirectSeed('Sofia Bennett', _avatar(49), [
      'Will you be on the stand-up today?',
      'Yes, I will join from my laptop.',
      'Great, then I will ask you to walk through the current progress.',
      'No problem, I will prepare a short overview.',
    ]),
    _DirectSeed('Ethan Miller', _avatar(52), [
      'I checked the Android build this morning.',
      'How did it go?',
      'It builds, but a Gradle warning is still coming from the packages.',
      'Okay, we can clean that up separately with dependency updates.',
    ]),
    _DirectSeed('Chloe Foster', _avatar(57), [
      'I finished a set of photos for the chats.',
      'Perfect, we really needed more natural avatars.',
      'I picked neutral images without branding or visual noise.',
      'That sounds ideal.',
    ]),
    _DirectSeed('Ryan Scott', _avatar(61), [
      'I can validate chat search later tonight.',
      'Great. Please pay attention to long titles and long previews.',
      'Will do, especially around edge cases in the results list.',
      'Thanks, that scenario matters a lot.',
    ]),
    _DirectSeed('Grace Turner', _avatar(65), [
      'I added profile notes for the participants.',
      'Nice, that will help the info screen feel less empty.',
      'Exactly. The groups should look lived-in, not placeholder-heavy.',
      'Agreed, we will make them feel denser and more alive.',
    ]),
    _DirectSeed('Luke Parker', _avatar(69), [
      'Quick ping. Did you see the latest message screen pass?',
      'Yes, the direction is strong.',
      'I think we can push a bit more contrast between incoming and outgoing bubbles.',
      'I will deepen the outgoing bubble color.',
    ]),
  ];

  static final List<_GroupSeed> _groupSeeds = [
    _GroupSeed('Product Team', 5, _photo('product', 240), [
      'This morning we review the first-run experience.',
      'I will add notes for the onboarding sequence.',
      'The fallback path has to feel like a real part of the app.',
      'Agreed, it should feel fully intentional.',
      'Then for review we show the chat list and one conversation.',
    ]),
    _GroupSeed(
        'Televibe Design',
        7,
        _photo('design', 240),
        [
          'I think the dark theme should stay the default.',
          'And outgoing messages need a cleaner blue accent.',
          'For groups, we should keep participant avatars inside message threads.',
          'We also need a compact connection status line.',
          'Yes, something subtle in the chat list header would work.',
        ],
        imageMessageIndex: 2,
        imageUrl: _photo('design-shot', 720)),
    _GroupSeed('Home and Neighbors', 9, _photo('home', 240), [
      'Who picked up the parcel from reception?',
      'I saw the box near the security desk about an hour ago.',
      'Thanks, I will stop by in the evening.',
      'Reminder: the water will be off tomorrow from 10 to 12.',
      'Glad you posted that.',
    ]),
    _GroupSeed(
        'Trip to Kazan',
        12,
        _photo('kazan', 240),
        [
          'Does everyone already have their tickets?',
          'Yes, I am in car 7.',
          'I am nearby in car 8. Let us meet by the exit.',
          'I booked a cafe for the first evening.',
          'Perfect, send the address here.',
        ],
        imageMessageIndex: 4,
        imageUrl: _photo('kazan-cafe', 720)),
    _GroupSeed('Book Club', 16, _photo('books', 240), [
      'This week we are discussing the final chapters.',
      'I finished it, and the ending surprised me.',
      'No spoilers before the meetup please.',
      'Fair. Then everyone brings one discussion question.',
      'I will bring a few quotes as well.',
    ]),
    _GroupSeed(
        'Photo Walks',
        21,
        _photo('photo-walk', 240),
        [
          'Saturday should have soft light after 5 PM.',
          'We can walk along the riverfront.',
          'I will take a wide lens and a portrait lens.',
          'I added the route to the map.',
          'Nice, the sunset should look great there.',
        ],
        imageMessageIndex: 3,
        imageUrl: _photo('sunset-route', 720)),
    _GroupSeed('Startup Room', 24, _photo('startup', 240), [
      'Today we focus on the demo and avoid extra features.',
      'Agreed, the stable path matters more right now.',
      'The backup API behavior must stay predictable.',
      'I will validate new chat creation next.',
      'After that we can move into visual polish.',
    ]),
    _GroupSeed('Interface Notes', 29, _photo('interface', 240), [
      'Who has a fresh Telegram-style list reference?',
      'The key is density, contrast, and clear hierarchy.',
      'We also need proper empty states for the list and search.',
      'The list should only be empty if every chat was removed.',
      'On first launch we still begin with 24 conversations.',
    ]),
    _GroupSeed('Evening Music', 34, _photo('music', 240), [
      'The playlist for tonight is almost ready.',
      'Add something calm near the beginning.',
      'And a couple of brighter tracks after 9 PM.',
      'I will make the transition feel smooth.',
      'Great, send the link when it is ready.',
    ]),
    _GroupSeed(
        'Coffee by the Park',
        38,
        _photo('coffee', 240),
        [
          'We received a new coffee filter today.',
          'Oh, which region?',
          'Ethiopia, with a bright berry profile.',
          'Then I will stop by after work.',
          'It should still be available until 8 PM.',
        ],
        imageMessageIndex: 0,
        imageUrl: _photo('coffee-cup', 720)),
    _GroupSeed('Morning Run', 45, _photo('run', 240), [
      'Tomorrow we start at 7:20 by the arch.',
      'Easy pace?',
      'Yes, around 6:30-6:45 with no hard pushes.',
      'I will join during the second half of the route.',
      'Sounds good, we can wait by the bridge.',
    ]),
    _GroupSeed('City Updates', 50, _photo('city', 240), [
      'A new bike lane opened on the main street.',
      'Has anyone already tried it?',
      'I rode through this morning and it feels much safer.',
      'The area still needs more bike parking.',
      'True, but it is a strong start.',
    ]),
  ];

  static final List<PseudoStory> _stories = [
    PseudoStory(
      id: 'story-anna',
      title: 'Anna Carter',
      subtitle: 'Presentation room is ready',
      avatarUrl: _avatar(12),
      backgroundUrl: _photo('story-room', 1080),
      ageLabel: '12m ago',
    ),
    PseudoStory(
      id: 'story-design',
      title: 'Televibe Design',
      subtitle: 'Fresh preview for the message screen',
      avatarUrl: _photo('design', 240),
      backgroundUrl: _photo('story-design', 1080),
      ageLabel: '24m ago',
    ),
    PseudoStory(
      id: 'story-maya',
      title: 'Maya Collins',
      subtitle: 'Slides exported for review',
      avatarUrl: _avatar(23),
      backgroundUrl: _photo('story-slides', 1080),
      ageLabel: '39m ago',
    ),
    PseudoStory(
      id: 'story-product',
      title: 'Product Team',
      subtitle: 'Roadmap checkpoint',
      avatarUrl: _photo('product', 240),
      backgroundUrl: _photo('story-roadmap', 1080),
      ageLabel: '1h ago',
    ),
    PseudoStory(
      id: 'story-coffee',
      title: 'Coffee by the Park',
      subtitle: 'New filter on the bar today',
      avatarUrl: _photo('coffee', 240),
      backgroundUrl: _photo('story-coffee', 1080),
      ageLabel: '2h ago',
    ),
    PseudoStory(
      id: 'story-run',
      title: 'Morning Run',
      subtitle: 'Bridge route looks clear',
      avatarUrl: _photo('run', 240),
      backgroundUrl: _photo('story-run', 1080),
      ageLabel: '3h ago',
    ),
  ];

  static final List<PseudoCallEntry> _calls = [
    PseudoCallEntry(
      id: 'call-1',
      title: 'Anna Carter',
      avatarUrl: _avatar(12),
      timeLabel: 'Today, 09:12',
      direction: 'outgoing',
      isVideo: true,
      missed: false,
    ),
    PseudoCallEntry(
      id: 'call-2',
      title: 'Product Team',
      avatarUrl: _photo('product', 240),
      timeLabel: 'Today, 08:40',
      direction: 'incoming',
      isVideo: true,
      missed: false,
    ),
    PseudoCallEntry(
      id: 'call-3',
      title: 'Noah Reed',
      avatarUrl: _avatar(18),
      timeLabel: 'Yesterday, 18:05',
      direction: 'missed',
      isVideo: false,
      missed: true,
    ),
    PseudoCallEntry(
      id: 'call-4',
      title: 'Televibe Design',
      avatarUrl: _photo('design', 240),
      timeLabel: 'Yesterday, 16:18',
      direction: 'outgoing',
      isVideo: false,
      missed: false,
    ),
    PseudoCallEntry(
      id: 'call-5',
      title: 'Maya Collins',
      avatarUrl: _avatar(23),
      timeLabel: 'Yesterday, 12:07',
      direction: 'incoming',
      isVideo: false,
      missed: false,
    ),
    PseudoCallEntry(
      id: 'call-6',
      title: 'Startup Room',
      avatarUrl: _photo('startup', 240),
      timeLabel: 'Mon, 20:14',
      direction: 'missed',
      isVideo: true,
      missed: true,
    ),
  ];

  static final List<PseudoContact> _contacts = [
    PseudoContact(
      id: 1201,
      name: 'Anna Carter',
      username: '@annacarter',
      status: 'online',
      avatarUrl: _avatar(12),
      phoneLabel: '+1 555 014 201',
      isOnline: true,
    ),
    PseudoContact(
      id: 1202,
      name: 'Noah Reed',
      username: '@noahreed',
      status: 'last seen 8 min ago',
      avatarUrl: _avatar(18),
      phoneLabel: '+1 555 014 202',
    ),
    PseudoContact(
      id: 1203,
      name: 'Maya Collins',
      username: '@mayacollins',
      status: 'online',
      avatarUrl: _avatar(23),
      phoneLabel: '+1 555 014 203',
      isOnline: true,
    ),
    PseudoContact(
      id: 1204,
      name: 'Liam Hayes',
      username: '@liamhayes',
      status: 'last seen recently',
      avatarUrl: _avatar(31),
      phoneLabel: '+1 555 014 204',
    ),
    PseudoContact(
      id: 1205,
      name: 'Olivia Brooks',
      username: '@oliviabrooks',
      status: 'typing in Product Team',
      avatarUrl: _avatar(37),
      phoneLabel: '+1 555 014 205',
      isOnline: true,
    ),
    PseudoContact(
      id: 1206,
      name: 'Daniel Ross',
      username: '@danross',
      status: 'last seen 1 hour ago',
      avatarUrl: _avatar(44),
      phoneLabel: '+1 555 014 206',
    ),
    PseudoContact(
      id: 1207,
      name: 'Sofia Bennett',
      username: '@sofiab',
      status: 'online',
      avatarUrl: _avatar(49),
      phoneLabel: '+1 555 014 207',
      isOnline: true,
    ),
    PseudoContact(
      id: 1208,
      name: 'Chloe Foster',
      username: '@chloefoster',
      status: 'last seen yesterday',
      avatarUrl: _avatar(57),
      phoneLabel: '+1 555 014 208',
    ),
  ];

  static final Map<String, List<PseudoMediaItem>> _mediaByChat = {
    'chat-group-6': [
      PseudoMediaItem(
        id: 'startup-demo-1',
        caption: 'Demo walkthrough preview',
        senderName: 'Ryan',
        timeLabel: 'Yesterday',
        imageUrl: _photo('startup-demo', 720),
      ),
      PseudoMediaItem(
        id: 'startup-demo-2',
        caption: 'Pitch deck thumbnail',
        senderName: 'Maya',
        timeLabel: 'Mon',
        imageUrl: _photo('pitch-deck', 720),
      ),
    ],
    'chat-group-1': [
      PseudoMediaItem(
        id: 'design-board-1',
        caption: 'Alternative bubble colors',
        senderName: 'Televibe Design',
        timeLabel: 'Today',
        imageUrl: _photo('bubble-variants', 720),
      ),
    ],
  };

  static final Map<String, List<PseudoFileItem>> _filesByChat = {
    'chat-group-6': [
      PseudoFileItem(
        title: 'investor-update.pdf',
        fileType: 'pdf',
        sizeLabel: '3.8 MB',
        detailLabel: 'Executive summary',
      ),
      PseudoFileItem(
        title: 'mobile-demo-assets.zip',
        fileType: 'zip',
        sizeLabel: '24.1 MB',
        detailLabel: 'Screens, icons, mock bundles',
      ),
      PseudoFileItem(
        title: 'meeting-recap.m4a',
        fileType: 'audio',
        sizeLabel: '8:42',
        detailLabel: 'Voice recap',
      ),
    ],
    'chat-group-1': [
      PseudoFileItem(
        title: 'ui-audit.docx',
        fileType: 'doc',
        sizeLabel: '1.2 MB',
        detailLabel: 'Interface review notes',
      ),
      PseudoFileItem(
        title: 'palette-export.sketch',
        fileType: 'design',
        sizeLabel: '12.6 MB',
        detailLabel: 'Color and layout exploration',
      ),
    ],
  };

  static final Map<String, List<PseudoLinkItem>> _linksByChat = {
    'chat-group-6': [
      PseudoLinkItem(
        title: 'Runtime validation dashboard',
        url: 'https://demo.televibe.app/runtime',
        previewLabel: 'Internal QA board',
        timeLabel: 'Today',
      ),
      PseudoLinkItem(
        title: 'Launch checklist',
        url: 'https://demo.televibe.app/checklist',
        previewLabel: 'Release prep',
        timeLabel: 'Yesterday',
      ),
    ],
    'chat-group-1': [
      PseudoLinkItem(
        title: 'Motion references',
        url: 'https://demo.televibe.app/motion',
        previewLabel: 'Animation direction',
        timeLabel: 'Today',
      ),
      PseudoLinkItem(
        title: 'Avatar library',
        url: 'https://demo.televibe.app/avatars',
        previewLabel: 'Approved profile assets',
        timeLabel: 'Mon',
      ),
    ],
  };

  static const List<String> _names = [
    'Anna',
    'Noah',
    'Maya',
    'Liam',
    'Olivia',
    'Daniel',
    'Sofia',
    'Ethan',
    'Chloe',
    'Ryan',
    'Grace',
    'Luke',
    'Julia',
    'Emma',
    'Mason',
    'Ava',
    'Leo',
    'Nora',
    'Caleb',
    'Mia',
    'Ella',
    'Owen',
    'Ruby',
    'Isaac',
    'Sarah',
    'James',
    'Lily',
    'Henry',
    'Zoe',
    'Jacob',
  ];
}

class _DirectSeed {
  final String name;
  final String avatarUrl;
  final List<String> messages;

  const _DirectSeed(this.name, this.avatarUrl, this.messages);
}

class _GroupSeed {
  final String name;
  final int memberCount;
  final String avatarUrl;
  final List<String> messages;
  final int? imageMessageIndex;
  final String? imageUrl;

  const _GroupSeed(
    this.name,
    this.memberCount,
    this.avatarUrl,
    this.messages, {
    this.imageMessageIndex,
    this.imageUrl,
  });
}

class PseudoStory {
  final String id;
  final String title;
  final String subtitle;
  final String avatarUrl;
  final String backgroundUrl;
  final String ageLabel;

  const PseudoStory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.avatarUrl,
    required this.backgroundUrl,
    required this.ageLabel,
  });
}

class PseudoCallEntry {
  final String id;
  final String title;
  final String avatarUrl;
  final String timeLabel;
  final String direction;
  final bool isVideo;
  final bool missed;

  const PseudoCallEntry({
    required this.id,
    required this.title,
    required this.avatarUrl,
    required this.timeLabel,
    required this.direction,
    required this.isVideo,
    this.missed = false,
  });
}

class PseudoContact {
  final int id;
  final String name;
  final String username;
  final String status;
  final String avatarUrl;
  final String phoneLabel;
  final bool isOnline;

  const PseudoContact({
    required this.id,
    required this.name,
    required this.username,
    required this.status,
    required this.avatarUrl,
    required this.phoneLabel,
    this.isOnline = false,
  });
}

class PseudoMediaItem {
  final String id;
  final String caption;
  final String senderName;
  final String timeLabel;
  final String? imageUrl;
  final String? imageData;

  const PseudoMediaItem({
    required this.id,
    required this.caption,
    required this.senderName,
    required this.timeLabel,
    this.imageUrl,
    this.imageData,
  });
}

class PseudoFileItem {
  final String title;
  final String fileType;
  final String sizeLabel;
  final String detailLabel;

  const PseudoFileItem({
    required this.title,
    required this.fileType,
    required this.sizeLabel,
    required this.detailLabel,
  });
}

class PseudoLinkItem {
  final String title;
  final String url;
  final String previewLabel;
  final String timeLabel;

  const PseudoLinkItem({
    required this.title,
    required this.url,
    required this.previewLabel,
    required this.timeLabel,
  });
}
