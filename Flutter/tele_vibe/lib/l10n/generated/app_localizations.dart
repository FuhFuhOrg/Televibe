import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de'),
    Locale('ru')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Televibe'**
  String get appName;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @readyForLiveSync.
  ///
  /// In en, this message translates to:
  /// **'Ready for live sync'**
  String get readyForLiveSync;

  /// No description provided for @loginIntro.
  ///
  /// In en, this message translates to:
  /// **'Sign in to restore chats and media instantly. If the API is unavailable, you can still open the prepared conversation space.'**
  String get loginIntro;

  /// No description provided for @loginLabel.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @openChats.
  ///
  /// In en, this message translates to:
  /// **'Open chats'**
  String get openChats;

  /// No description provided for @newToTelevibe.
  ///
  /// In en, this message translates to:
  /// **'New to Televibe?'**
  String get newToTelevibe;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @createAccountHeading.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountHeading;

  /// No description provided for @registrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your identity and continue to your conversations.'**
  String get registrationSubtitle;

  /// No description provided for @registrationIntro.
  ///
  /// In en, this message translates to:
  /// **'Your account keeps chats, profile details, and media in one place. Choose a strong password so you can move between devices without friction.'**
  String get registrationIntro;

  /// No description provided for @repeatPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeatPasswordLabel;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @controlYourExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Control your experience'**
  String get controlYourExperienceTitle;

  /// No description provided for @controlYourExperienceDescription.
  ///
  /// In en, this message translates to:
  /// **'Tune notifications, sound behavior, and interface preferences so the app feels ready for daily use.'**
  String get controlYourExperienceDescription;

  /// No description provided for @notificationsAndSound.
  ///
  /// In en, this message translates to:
  /// **'Notifications and sound'**
  String get notificationsAndSound;

  /// No description provided for @messageNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Message notifications'**
  String get messageNotificationsTitle;

  /// No description provided for @messageNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Show alerts for new chats and incoming messages.'**
  String get messageNotificationsDescription;

  /// No description provided for @soundTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get soundTitle;

  /// No description provided for @soundDescription.
  ///
  /// In en, this message translates to:
  /// **'Play audio cues for message activity and updates.'**
  String get soundDescription;

  /// No description provided for @interfaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Interface'**
  String get interfaceTitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @reviewLanguageOptions.
  ///
  /// In en, this message translates to:
  /// **'Review the available UI language options.'**
  String get reviewLanguageOptions;

  /// No description provided for @navigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get navigationTitle;

  /// No description provided for @backToChats.
  ///
  /// In en, this message translates to:
  /// **'Back to chats'**
  String get backToChats;

  /// No description provided for @backToChatsDescription.
  ///
  /// In en, this message translates to:
  /// **'Return to the conversation list.'**
  String get backToChatsDescription;

  /// No description provided for @languageSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the interface language for the entire app. Chat content, names, and prepared conversations stay in English.'**
  String get languageSettingsDescription;

  /// No description provided for @selectedLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Current app language'**
  String get selectedLanguageDescription;

  /// No description provided for @tapToSwitchLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap to switch the UI language instantly'**
  String get tapToSwitchLanguageDescription;

  /// No description provided for @newConversationTitle.
  ///
  /// In en, this message translates to:
  /// **'New conversation'**
  String get newConversationTitle;

  /// No description provided for @createConversationDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new space for direct messages or group updates.'**
  String get createConversationDescription;

  /// No description provided for @joinConversationDescription.
  ///
  /// In en, this message translates to:
  /// **'Join an existing chat with its ID and access code.'**
  String get joinConversationDescription;

  /// No description provided for @createTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createTabLabel;

  /// No description provided for @joinTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get joinTabLabel;

  /// No description provided for @conversationDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'Conversation details'**
  String get conversationDetailsSection;

  /// No description provided for @conversationNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Conversation name'**
  String get conversationNameLabel;

  /// No description provided for @conversationNameHint.
  ///
  /// In en, this message translates to:
  /// **'Product sync, Family, Alex...'**
  String get conversationNameHint;

  /// No description provided for @accessCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Access code'**
  String get accessCodeLabel;

  /// No description provided for @optionalHint.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optionalHint;

  /// No description provided for @createAsGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create as group'**
  String get createAsGroupTitle;

  /// No description provided for @createAsGroupDescription.
  ///
  /// In en, this message translates to:
  /// **'Turn this on if multiple participants should join the same conversation.'**
  String get createAsGroupDescription;

  /// No description provided for @joinWithCredentialsSection.
  ///
  /// In en, this message translates to:
  /// **'Join with credentials'**
  String get joinWithCredentialsSection;

  /// No description provided for @displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayNameLabel;

  /// No description provided for @displayNameHint.
  ///
  /// In en, this message translates to:
  /// **'Optional label for this chat'**
  String get displayNameHint;

  /// No description provided for @chatIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat ID'**
  String get chatIdLabel;

  /// No description provided for @pasteConversationIdHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the conversation ID'**
  String get pasteConversationIdHint;

  /// No description provided for @accessCodeRequiredHint.
  ///
  /// In en, this message translates to:
  /// **'Required if the host set one'**
  String get accessCodeRequiredHint;

  /// No description provided for @createConversationCta.
  ///
  /// In en, this message translates to:
  /// **'Create conversation'**
  String get createConversationCta;

  /// No description provided for @joinChatCta.
  ///
  /// In en, this message translates to:
  /// **'Join chat'**
  String get joinChatCta;

  /// No description provided for @addParticipantTitle.
  ///
  /// In en, this message translates to:
  /// **'Add participant'**
  String get addParticipantTitle;

  /// No description provided for @inviteByIdTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite by ID'**
  String get inviteByIdTitle;

  /// No description provided for @inviteByIdDescription.
  ///
  /// In en, this message translates to:
  /// **'Paste the participant ID below to keep this conversation organized and ready for collaboration.'**
  String get inviteByIdDescription;

  /// No description provided for @participantIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Participant ID'**
  String get participantIdLabel;

  /// No description provided for @inviteParticipantCta.
  ///
  /// In en, this message translates to:
  /// **'Invite participant'**
  String get inviteParticipantCta;

  /// No description provided for @searchChatsHint.
  ///
  /// In en, this message translates to:
  /// **'Search chats...'**
  String get searchChatsHint;

  /// No description provided for @noChatsFound.
  ///
  /// In en, this message translates to:
  /// **'No chats found'**
  String get noChatsFound;

  /// No description provided for @startTypingToBrowseConversations.
  ///
  /// In en, this message translates to:
  /// **'Start typing to browse your conversations.'**
  String get startTypingToBrowseConversations;

  /// No description provided for @tryAnotherNameOrCreateChat.
  ///
  /// In en, this message translates to:
  /// **'Try another name or create a new chat from the main screen.'**
  String get tryAnotherNameOrCreateChat;

  /// No description provided for @searchMessagesHint.
  ///
  /// In en, this message translates to:
  /// **'Search messages...'**
  String get searchMessagesHint;

  /// No description provided for @noMessagesFound.
  ///
  /// In en, this message translates to:
  /// **'No messages found'**
  String get noMessagesFound;

  /// No description provided for @searchCurrentConversationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Search within the current conversation.'**
  String get searchCurrentConversationPrompt;

  /// No description provided for @tryAnotherKeywordOrChat.
  ///
  /// In en, this message translates to:
  /// **'Try another keyword or open a different chat.'**
  String get tryAnotherKeywordOrChat;

  /// No description provided for @fromUserAt.
  ///
  /// In en, this message translates to:
  /// **'From {userName} at {time}'**
  String fromUserAt({required String userName, required String time});

  /// No description provided for @nothingHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get nothingHereYet;

  /// No description provided for @noDirectChatsYet.
  ///
  /// In en, this message translates to:
  /// **'No direct chats match this filter yet.'**
  String get noDirectChatsYet;

  /// No description provided for @noGroupsYet.
  ///
  /// In en, this message translates to:
  /// **'No group conversations are visible here right now.'**
  String get noGroupsYet;

  /// No description provided for @noUnreadChatsYet.
  ///
  /// In en, this message translates to:
  /// **'You are fully caught up. No unread chats in this folder.'**
  String get noUnreadChatsYet;

  /// No description provided for @archiveFolderEmpty.
  ///
  /// In en, this message translates to:
  /// **'Archive a chat from the main list and it will appear here.'**
  String get archiveFolderEmpty;

  /// No description provided for @startDirectChatPrompt.
  ///
  /// In en, this message translates to:
  /// **'Start a direct chat or create a group to see your conversations here.'**
  String get startDirectChatPrompt;

  /// No description provided for @memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String memberCount({required int count});

  /// No description provided for @directChat.
  ///
  /// In en, this message translates to:
  /// **'Direct chat'**
  String get directChat;

  /// No description provided for @pinChat.
  ///
  /// In en, this message translates to:
  /// **'Pin chat'**
  String get pinChat;

  /// No description provided for @unpinChat.
  ///
  /// In en, this message translates to:
  /// **'Unpin chat'**
  String get unpinChat;

  /// No description provided for @archiveChat.
  ///
  /// In en, this message translates to:
  /// **'Archive chat'**
  String get archiveChat;

  /// No description provided for @unarchiveChat.
  ///
  /// In en, this message translates to:
  /// **'Unarchive chat'**
  String get unarchiveChat;

  /// No description provided for @leaveGroup.
  ///
  /// In en, this message translates to:
  /// **'Leave group'**
  String get leaveGroup;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete chat'**
  String get deleteChat;

  /// No description provided for @conversationHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversation hub'**
  String get conversationHubTitle;

  /// No description provided for @conversationHubDescription.
  ///
  /// In en, this message translates to:
  /// **'Everything important stays one tap away: recent chats, pinned threads, and unread updates.'**
  String get conversationHubDescription;

  /// No description provided for @directStatLabel.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get directStatLabel;

  /// No description provided for @groupsStatLabel.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groupsStatLabel;

  /// No description provided for @unreadStatLabel.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unreadStatLabel;

  /// No description provided for @allFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilterLabel;

  /// No description provided for @directFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get directFilterLabel;

  /// No description provided for @groupsFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groupsFilterLabel;

  /// No description provided for @unreadFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unreadFilterLabel;

  /// No description provided for @archiveFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveFilterLabel;

  /// No description provided for @personalAccount.
  ///
  /// In en, this message translates to:
  /// **'Personal account'**
  String get personalAccount;

  /// No description provided for @chatsReadyToOpen.
  ///
  /// In en, this message translates to:
  /// **'{count} chats ready to open'**
  String chatsReadyToOpen({required int count});

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @archivedChatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Archived chats'**
  String get archivedChatsTitle;

  /// No description provided for @callsTitle.
  ///
  /// In en, this message translates to:
  /// **'Calls'**
  String get callsTitle;

  /// No description provided for @contactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contactsTitle;

  /// No description provided for @archivedChatsDescription.
  ///
  /// In en, this message translates to:
  /// **'{count} chats are currently hidden from the main list. This is a local portfolio archive, so unarchive is instant.'**
  String archivedChatsDescription({required int count});

  /// No description provided for @archiveIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Archive is empty'**
  String get archiveIsEmpty;

  /// No description provided for @archiveEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Archive a chat from the main list to move it here while keeping the conversation intact.'**
  String get archiveEmptyDescription;

  /// No description provided for @callHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Call history'**
  String get callHistoryTitle;

  /// No description provided for @callsMvpDescription.
  ///
  /// In en, this message translates to:
  /// **'This screen is local-only for the MVP, but it looks and behaves like a real messenger call log.'**
  String get callsMvpDescription;

  /// No description provided for @recentStatLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentStatLabel;

  /// No description provided for @missedStatLabel.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missedStatLabel;

  /// No description provided for @videoStatLabel.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get videoStatLabel;

  /// No description provided for @allCallsFilter.
  ///
  /// In en, this message translates to:
  /// **'All calls'**
  String get allCallsFilter;

  /// No description provided for @missedCallsFilter.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missedCallsFilter;

  /// No description provided for @callTypeVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get callTypeVideo;

  /// No description provided for @callTypeVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get callTypeVoice;

  /// No description provided for @pseudoVideoCallScreen.
  ///
  /// In en, this message translates to:
  /// **'Pseudo video call screen'**
  String get pseudoVideoCallScreen;

  /// No description provided for @pseudoVoiceCallScreen.
  ///
  /// In en, this message translates to:
  /// **'Pseudo voice call screen'**
  String get pseudoVoiceCallScreen;

  /// No description provided for @noCallsInFilter.
  ///
  /// In en, this message translates to:
  /// **'No calls in this filter'**
  String get noCallsInFilter;

  /// No description provided for @switchBackToAllCalls.
  ///
  /// In en, this message translates to:
  /// **'Switch back to all calls to review the full mock history.'**
  String get switchBackToAllCalls;

  /// No description provided for @peopleAndTeamsTitle.
  ///
  /// In en, this message translates to:
  /// **'People and teams'**
  String get peopleAndTeamsTitle;

  /// No description provided for @contactsSummary.
  ///
  /// In en, this message translates to:
  /// **'{total} contacts available, {online} online right now. This is a local demo directory for the portfolio flow.'**
  String contactsSummary({required int total, required int online});

  /// No description provided for @searchByNameOrUsername.
  ///
  /// In en, this message translates to:
  /// **'Search by name or username'**
  String get searchByNameOrUsername;

  /// No description provided for @noContactsFound.
  ///
  /// In en, this message translates to:
  /// **'No contacts found'**
  String get noContactsFound;

  /// No description provided for @tryAnotherContactQuery.
  ///
  /// In en, this message translates to:
  /// **'Try another query to filter the local demo address book.'**
  String get tryAnotherContactQuery;

  /// No description provided for @accountSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSectionTitle;

  /// No description provided for @aboutSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSectionTitle;

  /// No description provided for @statusSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusSectionTitle;

  /// No description provided for @userIdLabel.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userIdLabel;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @userIdCopied.
  ///
  /// In en, this message translates to:
  /// **'User ID copied'**
  String get userIdCopied;

  /// No description provided for @profileStatusDescription.
  ///
  /// In en, this message translates to:
  /// **'Ready to sync chats, profile details, and shared media across your sessions.'**
  String get profileStatusDescription;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @imageNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Image was not selected'**
  String get imageNotSelected;

  /// No description provided for @editValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit value'**
  String get editValueTitle;

  /// No description provided for @editValueDescription.
  ///
  /// In en, this message translates to:
  /// **'Update the value and save it when you are done.'**
  String get editValueDescription;

  /// No description provided for @editValueHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a new value'**
  String get editValueHint;

  /// No description provided for @displayNameField.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayNameField;

  /// No description provided for @usernameField.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameField;

  /// No description provided for @chatNameField.
  ///
  /// In en, this message translates to:
  /// **'Chat name'**
  String get chatNameField;

  /// No description provided for @directConversation.
  ///
  /// In en, this message translates to:
  /// **'Direct conversation'**
  String get directConversation;

  /// No description provided for @addParticipants.
  ///
  /// In en, this message translates to:
  /// **'Add participants'**
  String get addParticipants;

  /// No description provided for @chatIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Chat ID copied'**
  String get chatIdCopied;

  /// No description provided for @copyChatId.
  ///
  /// In en, this message translates to:
  /// **'Copy chat ID'**
  String get copyChatId;

  /// No description provided for @sharedContentTitle.
  ///
  /// In en, this message translates to:
  /// **'Shared content'**
  String get sharedContentTitle;

  /// No description provided for @sharedContentDescription.
  ///
  /// In en, this message translates to:
  /// **'Local portfolio tabs that imitate the real messenger media browser.'**
  String get sharedContentDescription;

  /// No description provided for @mediaTab.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get mediaTab;

  /// No description provided for @filesTab.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get filesTab;

  /// No description provided for @linksTab.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get linksTab;

  /// No description provided for @membersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersSectionTitle;

  /// No description provided for @peopleSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get peopleSectionTitle;

  /// No description provided for @memberRole.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get memberRole;

  /// No description provided for @participantRole.
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get participantRole;

  /// No description provided for @noSharedMedia.
  ///
  /// In en, this message translates to:
  /// **'No shared media yet'**
  String get noSharedMedia;

  /// No description provided for @noSharedFiles.
  ///
  /// In en, this message translates to:
  /// **'No shared files yet'**
  String get noSharedFiles;

  /// No description provided for @noSharedLinks.
  ///
  /// In en, this message translates to:
  /// **'No shared links yet'**
  String get noSharedLinks;

  /// No description provided for @memberOptions.
  ///
  /// In en, this message translates to:
  /// **'Member options'**
  String get memberOptions;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeMember;

  /// No description provided for @chatRemoved.
  ///
  /// In en, this message translates to:
  /// **'Chat removed'**
  String get chatRemoved;

  /// No description provided for @unableToDeleteChat.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete chat'**
  String get unableToDeleteChat;

  /// No description provided for @chatCreated.
  ///
  /// In en, this message translates to:
  /// **'Chat created'**
  String get chatCreated;

  /// No description provided for @chatCreatedWithId.
  ///
  /// In en, this message translates to:
  /// **'Chat created: {chatId}'**
  String chatCreatedWithId({required String chatId});

  /// No description provided for @chatAdded.
  ///
  /// In en, this message translates to:
  /// **'Chat added'**
  String get chatAdded;

  /// No description provided for @addedUserToChat.
  ///
  /// In en, this message translates to:
  /// **'Added user to chat: {userId}'**
  String addedUserToChat({required String userId});

  /// No description provided for @chatDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat details'**
  String get chatDetailsTitle;

  /// No description provided for @messageSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get messageSearchHint;

  /// No description provided for @lastSeenRecently.
  ///
  /// In en, this message translates to:
  /// **'last seen recently'**
  String get lastSeenRecently;

  /// No description provided for @imageSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Image send failed: {error}'**
  String imageSendFailed({required String error});

  /// No description provided for @messageInputHint.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageInputHint;

  /// No description provided for @messageActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageActionsTitle;

  /// No description provided for @copyAction.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyAction;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @viewDetailsAction.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetailsAction;

  /// No description provided for @jumpToLatest.
  ///
  /// In en, this message translates to:
  /// **'Jump to latest'**
  String get jumpToLatest;

  /// No description provided for @editMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit message'**
  String get editMessageTitle;

  /// No description provided for @enterMessageTextHint.
  ///
  /// In en, this message translates to:
  /// **'Enter message text'**
  String get enterMessageTextHint;

  /// No description provided for @saveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAction;

  /// No description provided for @editedLabel.
  ///
  /// In en, this message translates to:
  /// **'edited'**
  String get editedLabel;

  /// No description provided for @storyPreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Portfolio story preview. Taps switch between stories just like a live messenger, while the content stays local and mock-driven.'**
  String get storyPreviewDescription;

  /// No description provided for @replyAction.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get replyAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
