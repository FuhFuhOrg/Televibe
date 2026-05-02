// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Televibe';

  @override
  String get signIn => 'Sign in';

  @override
  String get readyForLiveSync => 'Ready for live sync';

  @override
  String get loginIntro =>
      'Sign in to restore chats and media instantly. If the API is unavailable, you can still open the prepared conversation space.';

  @override
  String get loginLabel => 'Login';

  @override
  String get passwordLabel => 'Password';

  @override
  String get openChats => 'Open chats';

  @override
  String get newToTelevibe => 'New to Televibe?';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountHeading => 'Create account';

  @override
  String get registrationSubtitle =>
      'Set up your identity and continue to your conversations.';

  @override
  String get registrationIntro =>
      'Your account keeps chats, profile details, and media in one place. Choose a strong password so you can move between devices without friction.';

  @override
  String get repeatPasswordLabel => 'Repeat password';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get controlYourExperienceTitle => 'Control your experience';

  @override
  String get controlYourExperienceDescription =>
      'Tune notifications, sound behavior, and interface preferences so the app feels ready for daily use.';

  @override
  String get notificationsAndSound => 'Notifications and sound';

  @override
  String get messageNotificationsTitle => 'Message notifications';

  @override
  String get messageNotificationsDescription =>
      'Show alerts for new chats and incoming messages.';

  @override
  String get soundTitle => 'Sound';

  @override
  String get soundDescription =>
      'Play audio cues for message activity and updates.';

  @override
  String get interfaceTitle => 'Interface';

  @override
  String get languageTitle => 'Language';

  @override
  String get reviewLanguageOptions =>
      'Review the available UI language options.';

  @override
  String get navigationTitle => 'Navigation';

  @override
  String get backToChats => 'Back to chats';

  @override
  String get backToChatsDescription => 'Return to the conversation list.';

  @override
  String get languageSettingsDescription =>
      'Choose the interface language for the entire app. Chat content, names, and prepared conversations stay in English.';

  @override
  String get selectedLanguageDescription => 'Current app language';

  @override
  String get tapToSwitchLanguageDescription =>
      'Tap to switch the UI language instantly';

  @override
  String get newConversationTitle => 'New conversation';

  @override
  String get createConversationDescription =>
      'Create a new space for direct messages or group updates.';

  @override
  String get joinConversationDescription =>
      'Join an existing chat with its ID and access code.';

  @override
  String get createTabLabel => 'Create';

  @override
  String get joinTabLabel => 'Join';

  @override
  String get conversationDetailsSection => 'Conversation details';

  @override
  String get conversationNameLabel => 'Conversation name';

  @override
  String get conversationNameHint => 'Product sync, Family, Alex...';

  @override
  String get accessCodeLabel => 'Access code';

  @override
  String get optionalHint => 'Optional';

  @override
  String get createAsGroupTitle => 'Create as group';

  @override
  String get createAsGroupDescription =>
      'Turn this on if multiple participants should join the same conversation.';

  @override
  String get joinWithCredentialsSection => 'Join with credentials';

  @override
  String get displayNameLabel => 'Display name';

  @override
  String get displayNameHint => 'Optional label for this chat';

  @override
  String get chatIdLabel => 'Chat ID';

  @override
  String get pasteConversationIdHint => 'Paste the conversation ID';

  @override
  String get accessCodeRequiredHint => 'Required if the host set one';

  @override
  String get createConversationCta => 'Create conversation';

  @override
  String get joinChatCta => 'Join chat';

  @override
  String get addParticipantTitle => 'Add participant';

  @override
  String get inviteByIdTitle => 'Invite by ID';

  @override
  String get inviteByIdDescription =>
      'Paste the participant ID below to keep this conversation organized and ready for collaboration.';

  @override
  String get participantIdLabel => 'Participant ID';

  @override
  String get inviteParticipantCta => 'Invite participant';

  @override
  String get searchChatsHint => 'Search chats...';

  @override
  String get noChatsFound => 'No chats found';

  @override
  String get startTypingToBrowseConversations =>
      'Start typing to browse your conversations.';

  @override
  String get tryAnotherNameOrCreateChat =>
      'Try another name or create a new chat from the main screen.';

  @override
  String get searchMessagesHint => 'Search messages...';

  @override
  String get noMessagesFound => 'No messages found';

  @override
  String get searchCurrentConversationPrompt =>
      'Search within the current conversation.';

  @override
  String get tryAnotherKeywordOrChat =>
      'Try another keyword or open a different chat.';

  @override
  String fromUserAt({required String userName, required String time}) {
    return 'From $userName at $time';
  }

  @override
  String get nothingHereYet => 'Nothing here yet';

  @override
  String get noDirectChatsYet => 'No direct chats match this filter yet.';

  @override
  String get noGroupsYet =>
      'No group conversations are visible here right now.';

  @override
  String get noUnreadChatsYet =>
      'You are fully caught up. No unread chats in this folder.';

  @override
  String get archiveFolderEmpty =>
      'Archive a chat from the main list and it will appear here.';

  @override
  String get startDirectChatPrompt =>
      'Start a direct chat or create a group to see your conversations here.';

  @override
  String memberCount({required int count}) {
    return '$count members';
  }

  @override
  String get directChat => 'Direct chat';

  @override
  String get pinChat => 'Pin chat';

  @override
  String get unpinChat => 'Unpin chat';

  @override
  String get archiveChat => 'Archive chat';

  @override
  String get unarchiveChat => 'Unarchive chat';

  @override
  String get leaveGroup => 'Leave group';

  @override
  String get deleteChat => 'Delete chat';

  @override
  String get conversationHubTitle => 'Conversation hub';

  @override
  String get conversationHubDescription =>
      'Everything important stays one tap away: recent chats, pinned threads, and unread updates.';

  @override
  String get directStatLabel => 'Direct';

  @override
  String get groupsStatLabel => 'Groups';

  @override
  String get unreadStatLabel => 'Unread';

  @override
  String get allFilterLabel => 'All';

  @override
  String get directFilterLabel => 'Direct';

  @override
  String get groupsFilterLabel => 'Groups';

  @override
  String get unreadFilterLabel => 'Unread';

  @override
  String get archiveFilterLabel => 'Archive';

  @override
  String get personalAccount => 'Personal account';

  @override
  String chatsReadyToOpen({required int count}) {
    return '$count chats ready to open';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get archivedChatsTitle => 'Archived chats';

  @override
  String get callsTitle => 'Calls';

  @override
  String get contactsTitle => 'Contacts';

  @override
  String archivedChatsDescription({required int count}) {
    return '$count chats are currently hidden from the main list. This is a local portfolio archive, so unarchive is instant.';
  }

  @override
  String get archiveIsEmpty => 'Archive is empty';

  @override
  String get archiveEmptyDescription =>
      'Archive a chat from the main list to move it here while keeping the conversation intact.';

  @override
  String get callHistoryTitle => 'Call history';

  @override
  String get callsMvpDescription =>
      'This screen is local-only for the MVP, but it looks and behaves like a real messenger call log.';

  @override
  String get recentStatLabel => 'Recent';

  @override
  String get missedStatLabel => 'Missed';

  @override
  String get videoStatLabel => 'Video';

  @override
  String get allCallsFilter => 'All calls';

  @override
  String get missedCallsFilter => 'Missed';

  @override
  String get callTypeVideo => 'Video';

  @override
  String get callTypeVoice => 'Voice';

  @override
  String get pseudoVideoCallScreen => 'Pseudo video call screen';

  @override
  String get pseudoVoiceCallScreen => 'Pseudo voice call screen';

  @override
  String get noCallsInFilter => 'No calls in this filter';

  @override
  String get switchBackToAllCalls =>
      'Switch back to all calls to review the full mock history.';

  @override
  String get peopleAndTeamsTitle => 'People and teams';

  @override
  String contactsSummary({required int total, required int online}) {
    return '$total contacts available, $online online right now. This is a local demo directory for the portfolio flow.';
  }

  @override
  String get searchByNameOrUsername => 'Search by name or username';

  @override
  String get noContactsFound => 'No contacts found';

  @override
  String get tryAnotherContactQuery =>
      'Try another query to filter the local demo address book.';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get aboutSectionTitle => 'About';

  @override
  String get statusSectionTitle => 'Status';

  @override
  String get userIdLabel => 'User ID';

  @override
  String get usernameLabel => 'Username';

  @override
  String get userIdCopied => 'User ID copied';

  @override
  String get profileStatusDescription =>
      'Ready to sync chats, profile details, and shared media across your sessions.';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get imageNotSelected => 'Image was not selected';

  @override
  String get editValueTitle => 'Edit value';

  @override
  String get editValueDescription =>
      'Update the value and save it when you are done.';

  @override
  String get editValueHint => 'Enter a new value';

  @override
  String get displayNameField => 'Display name';

  @override
  String get usernameField => 'Username';

  @override
  String get chatNameField => 'Chat name';

  @override
  String get directConversation => 'Direct conversation';

  @override
  String get addParticipants => 'Add participants';

  @override
  String get chatIdCopied => 'Chat ID copied';

  @override
  String get copyChatId => 'Copy chat ID';

  @override
  String get sharedContentTitle => 'Shared content';

  @override
  String get sharedContentDescription =>
      'Local portfolio tabs that imitate the real messenger media browser.';

  @override
  String get mediaTab => 'Media';

  @override
  String get filesTab => 'Files';

  @override
  String get linksTab => 'Links';

  @override
  String get membersSectionTitle => 'Members';

  @override
  String get peopleSectionTitle => 'People';

  @override
  String get memberRole => 'Member';

  @override
  String get participantRole => 'Participant';

  @override
  String get noSharedMedia => 'No shared media yet';

  @override
  String get noSharedFiles => 'No shared files yet';

  @override
  String get noSharedLinks => 'No shared links yet';

  @override
  String get memberOptions => 'Member options';

  @override
  String get removeMember => 'Remove';

  @override
  String get chatRemoved => 'Chat removed';

  @override
  String get unableToDeleteChat => 'Unable to delete chat';

  @override
  String get chatCreated => 'Chat created';

  @override
  String chatCreatedWithId({required String chatId}) {
    return 'Chat created: $chatId';
  }

  @override
  String get chatAdded => 'Chat added';

  @override
  String addedUserToChat({required String userId}) {
    return 'Added user to chat: $userId';
  }

  @override
  String get chatDetailsTitle => 'Chat details';

  @override
  String get messageSearchHint => 'Search...';

  @override
  String get lastSeenRecently => 'last seen recently';

  @override
  String imageSendFailed({required String error}) {
    return 'Image send failed: $error';
  }

  @override
  String get messageInputHint => 'Message';

  @override
  String get messageActionsTitle => 'Message';

  @override
  String get copyAction => 'Copy';

  @override
  String get editAction => 'Edit';

  @override
  String get deleteAction => 'Delete';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get viewDetailsAction => 'View details';

  @override
  String get jumpToLatest => 'Jump to latest';

  @override
  String get editMessageTitle => 'Edit message';

  @override
  String get enterMessageTextHint => 'Enter message text';

  @override
  String get saveAction => 'Save';

  @override
  String get editedLabel => 'edited';

  @override
  String get storyPreviewDescription =>
      'Portfolio story preview. Taps switch between stories just like a live messenger, while the content stays local and mock-driven.';

  @override
  String get replyAction => 'Reply';
}
