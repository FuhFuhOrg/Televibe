// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Televibe';

  @override
  String get signIn => 'Anmelden';

  @override
  String get readyForLiveSync => 'Bereit für Live-Synchronisierung';

  @override
  String get loginIntro =>
      'Melden Sie sich an, um Chats und Medien sofort wiederherzustellen. Wenn die API nicht verfügbar ist, können Sie trotzdem den vorbereiteten Gesprächsbereich öffnen.';

  @override
  String get loginLabel => 'Login';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get openChats => 'Chats öffnen';

  @override
  String get newToTelevibe => 'Neu bei Televibe?';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get createAccountHeading => 'Konto erstellen';

  @override
  String get registrationSubtitle =>
      'Richten Sie Ihre Identität ein und wechseln Sie dann zu Ihren Unterhaltungen.';

  @override
  String get registrationIntro =>
      'Ihr Konto hält Chats, Profildaten und Medien an einem Ort. Wählen Sie ein starkes Passwort, damit Sie problemlos zwischen Geräten wechseln können.';

  @override
  String get repeatPasswordLabel => 'Passwort wiederholen';

  @override
  String get alreadyHaveAccount => 'Haben Sie bereits ein Konto?';

  @override
  String get backToSignIn => 'Zurück zur Anmeldung';

  @override
  String get passwordsDoNotMatch => 'Die Passwörter stimmen nicht überein';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get controlYourExperienceTitle => 'Erlebnis steuern';

  @override
  String get controlYourExperienceDescription =>
      'Passen Sie Benachrichtigungen, Tonverhalten und Oberflächeneinstellungen so an, dass sich die App im Alltag gut anfühlt.';

  @override
  String get notificationsAndSound => 'Benachrichtigungen und Ton';

  @override
  String get messageNotificationsTitle => 'Nachrichtenbenachrichtigungen';

  @override
  String get messageNotificationsDescription =>
      'Hinweise für neue Chats und eingehende Nachrichten anzeigen.';

  @override
  String get soundTitle => 'Ton';

  @override
  String get soundDescription =>
      'Audiosignale für Nachrichtenaktivität und Updates abspielen.';

  @override
  String get interfaceTitle => 'Oberfläche';

  @override
  String get languageTitle => 'Sprache';

  @override
  String get reviewLanguageOptions => 'Verfügbare UI-Sprachen anzeigen.';

  @override
  String get navigationTitle => 'Navigation';

  @override
  String get backToChats => 'Zurück zu den Chats';

  @override
  String get backToChatsDescription => 'Zur Unterhaltungsliste zurückkehren.';

  @override
  String get languageSettingsDescription =>
      'Wählen Sie die Oberflächensprache für die gesamte App. Chat-Inhalte, Namen und vorbereitete Gespräche bleiben auf Englisch.';

  @override
  String get selectedLanguageDescription => 'Aktuelle App-Sprache';

  @override
  String get tapToSwitchLanguageDescription =>
      'Tippen Sie, um die UI-Sprache sofort zu wechseln';

  @override
  String get newConversationTitle => 'Neue Unterhaltung';

  @override
  String get createConversationDescription =>
      'Erstellen Sie einen neuen Bereich für Direktnachrichten oder Gruppenupdates.';

  @override
  String get joinConversationDescription =>
      'Treten Sie einem vorhandenen Chat mit seiner ID und dem Zugangscode bei.';

  @override
  String get createTabLabel => 'Erstellen';

  @override
  String get joinTabLabel => 'Beitreten';

  @override
  String get conversationDetailsSection => 'Unterhaltungsdetails';

  @override
  String get conversationNameLabel => 'Name der Unterhaltung';

  @override
  String get conversationNameHint => 'Product sync, Family, Alex...';

  @override
  String get accessCodeLabel => 'Zugangscode';

  @override
  String get optionalHint => 'Optional';

  @override
  String get createAsGroupTitle => 'Als Gruppe erstellen';

  @override
  String get createAsGroupDescription =>
      'Aktivieren Sie dies, wenn mehrere Teilnehmende derselben Unterhaltung beitreten sollen.';

  @override
  String get joinWithCredentialsSection => 'Mit Zugangsdaten beitreten';

  @override
  String get displayNameLabel => 'Anzeigename';

  @override
  String get displayNameHint => 'Optionales Label für diesen Chat';

  @override
  String get chatIdLabel => 'Chat-ID';

  @override
  String get pasteConversationIdHint => 'Unterhaltungs-ID einfügen';

  @override
  String get accessCodeRequiredHint =>
      'Erforderlich, wenn der Host einen Code gesetzt hat';

  @override
  String get createConversationCta => 'Unterhaltung erstellen';

  @override
  String get joinChatCta => 'Chat beitreten';

  @override
  String get addParticipantTitle => 'Teilnehmer hinzufügen';

  @override
  String get inviteByIdTitle => 'Per ID einladen';

  @override
  String get inviteByIdDescription =>
      'Fügen Sie unten die Teilnehmer-ID ein, um diese Unterhaltung geordnet und kollaborationsbereit zu halten.';

  @override
  String get participantIdLabel => 'Teilnehmer-ID';

  @override
  String get inviteParticipantCta => 'Teilnehmer einladen';

  @override
  String get searchChatsHint => 'Chats durchsuchen...';

  @override
  String get noChatsFound => 'Keine Chats gefunden';

  @override
  String get startTypingToBrowseConversations =>
      'Beginnen Sie zu tippen, um Ihre Unterhaltungen zu durchsuchen.';

  @override
  String get tryAnotherNameOrCreateChat =>
      'Versuchen Sie einen anderen Namen oder erstellen Sie einen neuen Chat vom Hauptbildschirm aus.';

  @override
  String get searchMessagesHint => 'Nachrichten durchsuchen...';

  @override
  String get noMessagesFound => 'Keine Nachrichten gefunden';

  @override
  String get searchCurrentConversationPrompt =>
      'Innerhalb der aktuellen Unterhaltung suchen.';

  @override
  String get tryAnotherKeywordOrChat =>
      'Versuchen Sie ein anderes Stichwort oder öffnen Sie einen anderen Chat.';

  @override
  String fromUserAt({required String userName, required String time}) {
    return 'Von $userName um $time';
  }

  @override
  String get nothingHereYet => 'Hier ist noch nichts';

  @override
  String get noDirectChatsYet => 'Noch keine Direktchats für diesen Filter.';

  @override
  String get noGroupsYet =>
      'Derzeit sind hier keine Gruppengespräche sichtbar.';

  @override
  String get noUnreadChatsYet =>
      'Sie sind vollständig auf dem Laufenden. In diesem Ordner gibt es keine ungelesenen Chats.';

  @override
  String get archiveFolderEmpty =>
      'Archivieren Sie einen Chat aus der Hauptliste, dann erscheint er hier.';

  @override
  String get startDirectChatPrompt =>
      'Starten Sie einen Direktchat oder erstellen Sie eine Gruppe, um Ihre Unterhaltungen hier zu sehen.';

  @override
  String memberCount({required int count}) {
    return '$count Mitglieder';
  }

  @override
  String get directChat => 'Direktchat';

  @override
  String get pinChat => 'Chat anheften';

  @override
  String get unpinChat => 'Chat lösen';

  @override
  String get archiveChat => 'Chat archivieren';

  @override
  String get unarchiveChat => 'Chat aus Archiv holen';

  @override
  String get leaveGroup => 'Gruppe verlassen';

  @override
  String get deleteChat => 'Chat löschen';

  @override
  String get conversationHubTitle => 'Unterhaltungszentrale';

  @override
  String get conversationHubDescription =>
      'Alles Wichtige bleibt einen Tipp entfernt: letzte Chats, angeheftete Threads und ungelesene Updates.';

  @override
  String get directStatLabel => 'Direkt';

  @override
  String get groupsStatLabel => 'Gruppen';

  @override
  String get unreadStatLabel => 'Ungelesen';

  @override
  String get allFilterLabel => 'Alle';

  @override
  String get directFilterLabel => 'Direkt';

  @override
  String get groupsFilterLabel => 'Gruppen';

  @override
  String get unreadFilterLabel => 'Ungelesen';

  @override
  String get archiveFilterLabel => 'Archiv';

  @override
  String get personalAccount => 'Persönliches Konto';

  @override
  String chatsReadyToOpen({required int count}) {
    return '$count Chats bereit zum Öffnen';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get archivedChatsTitle => 'Archivierte Chats';

  @override
  String get callsTitle => 'Anrufe';

  @override
  String get contactsTitle => 'Kontakte';

  @override
  String archivedChatsDescription({required int count}) {
    return '$count Chats sind derzeit in der Hauptliste ausgeblendet. Dies ist ein lokales Portfolio-Archiv, daher erfolgt das Wiederherstellen sofort.';
  }

  @override
  String get archiveIsEmpty => 'Archiv ist leer';

  @override
  String get archiveEmptyDescription =>
      'Archivieren Sie einen Chat aus der Hauptliste, um ihn hierhin zu verschieben und die Unterhaltung beizubehalten.';

  @override
  String get callHistoryTitle => 'Anrufverlauf';

  @override
  String get callsMvpDescription =>
      'Dieser Bildschirm ist lokal für das MVP, wirkt aber wie ein echtes Anrufprotokoll eines Messengers.';

  @override
  String get recentStatLabel => 'Zuletzt';

  @override
  String get missedStatLabel => 'Verpasst';

  @override
  String get videoStatLabel => 'Video';

  @override
  String get allCallsFilter => 'Alle Anrufe';

  @override
  String get missedCallsFilter => 'Verpasste';

  @override
  String get callTypeVideo => 'Video';

  @override
  String get callTypeVoice => 'Sprache';

  @override
  String get pseudoVideoCallScreen => 'Pseudo-Videoanrufbildschirm';

  @override
  String get pseudoVoiceCallScreen => 'Pseudo-Sprachanrufbildschirm';

  @override
  String get noCallsInFilter => 'Keine Anrufe in diesem Filter';

  @override
  String get switchBackToAllCalls =>
      'Wechseln Sie zurück zu allen Anrufen, um den vollständigen Mock-Verlauf zu sehen.';

  @override
  String get peopleAndTeamsTitle => 'Personen und Teams';

  @override
  String contactsSummary({required int total, required int online}) {
    return '$total Kontakte verfügbar, $online gerade online. Dies ist ein lokales Demo-Verzeichnis für den Portfolio-Ablauf.';
  }

  @override
  String get searchByNameOrUsername => 'Nach Name oder Benutzernamen suchen';

  @override
  String get noContactsFound => 'Keine Kontakte gefunden';

  @override
  String get tryAnotherContactQuery =>
      'Versuchen Sie eine andere Suchanfrage, um das lokale Demo-Adressbuch zu filtern.';

  @override
  String get accountSectionTitle => 'Konto';

  @override
  String get aboutSectionTitle => 'Info';

  @override
  String get statusSectionTitle => 'Status';

  @override
  String get userIdLabel => 'Benutzer-ID';

  @override
  String get usernameLabel => 'Benutzername';

  @override
  String get userIdCopied => 'Benutzer-ID kopiert';

  @override
  String get profileStatusDescription =>
      'Bereit, Chats, Profildetails und geteilte Medien über Ihre Sitzungen hinweg zu synchronisieren.';

  @override
  String get addPhoto => 'Foto hinzufügen';

  @override
  String get removePhoto => 'Foto entfernen';

  @override
  String get imageNotSelected => 'Kein Bild ausgewählt';

  @override
  String get editValueTitle => 'Wert bearbeiten';

  @override
  String get editValueDescription =>
      'Aktualisieren Sie den Wert und speichern Sie ihn, wenn Sie fertig sind.';

  @override
  String get editValueHint => 'Neuen Wert eingeben';

  @override
  String get displayNameField => 'Anzeigename';

  @override
  String get usernameField => 'Benutzername';

  @override
  String get chatNameField => 'Chatname';

  @override
  String get directConversation => 'Direkte Unterhaltung';

  @override
  String get addParticipants => 'Teilnehmer hinzufügen';

  @override
  String get chatIdCopied => 'Chat-ID kopiert';

  @override
  String get copyChatId => 'Chat-ID kopieren';

  @override
  String get sharedContentTitle => 'Geteilte Inhalte';

  @override
  String get sharedContentDescription =>
      'Lokale Portfolio-Tabs, die den echten Medienbrowser eines Messengers nachahmen.';

  @override
  String get mediaTab => 'Medien';

  @override
  String get filesTab => 'Dateien';

  @override
  String get linksTab => 'Links';

  @override
  String get membersSectionTitle => 'Mitglieder';

  @override
  String get peopleSectionTitle => 'Personen';

  @override
  String get memberRole => 'Mitglied';

  @override
  String get participantRole => 'Teilnehmer';

  @override
  String get noSharedMedia => 'Noch keine geteilten Medien';

  @override
  String get noSharedFiles => 'Noch keine geteilten Dateien';

  @override
  String get noSharedLinks => 'Noch keine geteilten Links';

  @override
  String get memberOptions => 'Mitgliedsoptionen';

  @override
  String get removeMember => 'Entfernen';

  @override
  String get chatRemoved => 'Chat entfernt';

  @override
  String get unableToDeleteChat => 'Chat konnte nicht gelöscht werden';

  @override
  String get chatCreated => 'Chat erstellt';

  @override
  String chatCreatedWithId({required String chatId}) {
    return 'Chat erstellt: $chatId';
  }

  @override
  String get chatAdded => 'Chat hinzugefügt';

  @override
  String addedUserToChat({required String userId}) {
    return 'Benutzer zum Chat hinzugefügt: $userId';
  }

  @override
  String get chatDetailsTitle => 'Chatdetails';

  @override
  String get messageSearchHint => 'Suchen...';

  @override
  String get lastSeenRecently => 'zuletzt kürzlich online';

  @override
  String imageSendFailed({required String error}) {
    return 'Bild konnte nicht gesendet werden: $error';
  }

  @override
  String get messageInputHint => 'Nachricht';

  @override
  String get messageActionsTitle => 'Nachricht';

  @override
  String get copyAction => 'Kopieren';

  @override
  String get editAction => 'Bearbeiten';

  @override
  String get deleteAction => 'Löschen';

  @override
  String get cancelAction => 'Abbrechen';

  @override
  String get viewDetailsAction => 'Details anzeigen';

  @override
  String get jumpToLatest => 'Zum neuesten springen';

  @override
  String get editMessageTitle => 'Nachricht bearbeiten';

  @override
  String get enterMessageTextHint => 'Nachrichtentext eingeben';

  @override
  String get saveAction => 'Speichern';

  @override
  String get editedLabel => 'bearbeitet';

  @override
  String get storyPreviewDescription =>
      'Portfolio-Story-Vorschau. Tippen schaltet zwischen Stories wie in einem Live-Messenger um, während der Inhalt lokal und mock-basiert bleibt.';

  @override
  String get replyAction => 'Antworten';
}
