// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Televibe';

  @override
  String get signIn => 'Вход';

  @override
  String get readyForLiveSync => 'Готово к живой синхронизации';

  @override
  String get loginIntro =>
      'Войдите, чтобы сразу восстановить чаты и медиа. Если API недоступен, можно открыть подготовленное пространство переписки.';

  @override
  String get loginLabel => 'Логин';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get openChats => 'Открыть чаты';

  @override
  String get newToTelevibe => 'Впервые в Televibe?';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get createAccountHeading => 'Создать аккаунт';

  @override
  String get registrationSubtitle =>
      'Настройте свой профиль и переходите к перепискам.';

  @override
  String get registrationIntro =>
      'Аккаунт хранит чаты, данные профиля и медиа в одном месте. Выберите надёжный пароль, чтобы удобно переключаться между устройствами.';

  @override
  String get repeatPasswordLabel => 'Повторите пароль';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get backToSignIn => 'Вернуться ко входу';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get controlYourExperienceTitle => 'Управляйте своим опытом';

  @override
  String get controlYourExperienceDescription =>
      'Настройте уведомления, звук и параметры интерфейса так, чтобы приложением было удобно пользоваться каждый день.';

  @override
  String get notificationsAndSound => 'Уведомления и звук';

  @override
  String get messageNotificationsTitle => 'Уведомления о сообщениях';

  @override
  String get messageNotificationsDescription =>
      'Показывать оповещения о новых чатах и входящих сообщениях.';

  @override
  String get soundTitle => 'Звук';

  @override
  String get soundDescription =>
      'Воспроизводить звуковые сигналы для сообщений и обновлений.';

  @override
  String get interfaceTitle => 'Интерфейс';

  @override
  String get languageTitle => 'Язык';

  @override
  String get reviewLanguageOptions => 'Просмотреть доступные языки интерфейса.';

  @override
  String get navigationTitle => 'Навигация';

  @override
  String get backToChats => 'Назад к чатам';

  @override
  String get backToChatsDescription => 'Вернуться к списку переписок.';

  @override
  String get languageSettingsDescription =>
      'Выберите язык интерфейса для всего приложения. Содержимое чатов, имена и подготовленные переписки остаются на английском.';

  @override
  String get selectedLanguageDescription => 'Текущий язык приложения';

  @override
  String get tapToSwitchLanguageDescription =>
      'Нажмите, чтобы мгновенно сменить язык интерфейса';

  @override
  String get newConversationTitle => 'Новый чат';

  @override
  String get createConversationDescription =>
      'Создайте новое пространство для личных сообщений или групповых обновлений.';

  @override
  String get joinConversationDescription =>
      'Подключитесь к существующему чату по его ID и коду доступа.';

  @override
  String get createTabLabel => 'Создать';

  @override
  String get joinTabLabel => 'Войти';

  @override
  String get conversationDetailsSection => 'Параметры чата';

  @override
  String get conversationNameLabel => 'Название чата';

  @override
  String get conversationNameHint => 'Product sync, Family, Alex...';

  @override
  String get accessCodeLabel => 'Код доступа';

  @override
  String get optionalHint => 'Необязательно';

  @override
  String get createAsGroupTitle => 'Создать как группу';

  @override
  String get createAsGroupDescription =>
      'Включите это, если к одной переписке должно подключаться несколько участников.';

  @override
  String get joinWithCredentialsSection => 'Подключение по данным';

  @override
  String get displayNameLabel => 'Отображаемое имя';

  @override
  String get displayNameHint => 'Необязательная подпись для этого чата';

  @override
  String get chatIdLabel => 'ID чата';

  @override
  String get pasteConversationIdHint => 'Вставьте ID переписки';

  @override
  String get accessCodeRequiredHint => 'Нужно, если владелец установил код';

  @override
  String get createConversationCta => 'Создать чат';

  @override
  String get joinChatCta => 'Войти в чат';

  @override
  String get addParticipantTitle => 'Добавить участника';

  @override
  String get inviteByIdTitle => 'Пригласить по ID';

  @override
  String get inviteByIdDescription =>
      'Вставьте ID участника ниже, чтобы сохранить порядок в этой переписке и быстро пригласить человека.';

  @override
  String get participantIdLabel => 'ID участника';

  @override
  String get inviteParticipantCta => 'Пригласить участника';

  @override
  String get searchChatsHint => 'Поиск чатов...';

  @override
  String get noChatsFound => 'Чаты не найдены';

  @override
  String get startTypingToBrowseConversations =>
      'Начните вводить запрос, чтобы просматривать свои переписки.';

  @override
  String get tryAnotherNameOrCreateChat =>
      'Попробуйте другое имя или создайте новый чат с главного экрана.';

  @override
  String get searchMessagesHint => 'Поиск сообщений...';

  @override
  String get noMessagesFound => 'Сообщения не найдены';

  @override
  String get searchCurrentConversationPrompt =>
      'Ищите внутри текущей переписки.';

  @override
  String get tryAnotherKeywordOrChat =>
      'Попробуйте другое слово или откройте другой чат.';

  @override
  String fromUserAt({required String userName, required String time}) {
    return 'От $userName в $time';
  }

  @override
  String get nothingHereYet => 'Здесь пока пусто';

  @override
  String get noDirectChatsYet => 'Личных чатов по этому фильтру пока нет.';

  @override
  String get noGroupsYet =>
      'Групповые переписки сейчас не отображаются в этой вкладке.';

  @override
  String get noUnreadChatsYet =>
      'Вы всё прочитали. В этой папке нет непрочитанных чатов.';

  @override
  String get archiveFolderEmpty =>
      'Архивируйте чат из основного списка, и он появится здесь.';

  @override
  String get startDirectChatPrompt =>
      'Начните личный чат или создайте группу, чтобы увидеть переписки здесь.';

  @override
  String memberCount({required int count}) {
    return '$count участников';
  }

  @override
  String get directChat => 'Личный чат';

  @override
  String get pinChat => 'Закрепить чат';

  @override
  String get unpinChat => 'Открепить чат';

  @override
  String get archiveChat => 'Архивировать чат';

  @override
  String get unarchiveChat => 'Вернуть из архива';

  @override
  String get leaveGroup => 'Покинуть группу';

  @override
  String get deleteChat => 'Удалить чат';

  @override
  String get conversationHubTitle => 'Центр переписок';

  @override
  String get conversationHubDescription =>
      'Всё важное остаётся в одном касании: недавние чаты, закреплённые ветки и непрочитанные обновления.';

  @override
  String get directStatLabel => 'Личные';

  @override
  String get groupsStatLabel => 'Группы';

  @override
  String get unreadStatLabel => 'Непрочитанные';

  @override
  String get allFilterLabel => 'Все';

  @override
  String get directFilterLabel => 'Личные';

  @override
  String get groupsFilterLabel => 'Группы';

  @override
  String get unreadFilterLabel => 'Непрочитанные';

  @override
  String get archiveFilterLabel => 'Архив';

  @override
  String get personalAccount => 'Личный аккаунт';

  @override
  String chatsReadyToOpen({required int count}) {
    return 'Готово к открытию: $count чатов';
  }

  @override
  String get profileTitle => 'Профиль';

  @override
  String get archivedChatsTitle => 'Архив чатов';

  @override
  String get callsTitle => 'Звонки';

  @override
  String get contactsTitle => 'Контакты';

  @override
  String archivedChatsDescription({required int count}) {
    return 'Сейчас $count чатов скрыто из основного списка. Это локальный архив для портфолио, поэтому восстановление происходит мгновенно.';
  }

  @override
  String get archiveIsEmpty => 'Архив пуст';

  @override
  String get archiveEmptyDescription =>
      'Архивируйте чат из основного списка, чтобы переместить его сюда и сохранить переписку.';

  @override
  String get callHistoryTitle => 'История звонков';

  @override
  String get callsMvpDescription =>
      'Этот экран локальный для MVP, но выглядит и работает как настоящий журнал звонков мессенджера.';

  @override
  String get recentStatLabel => 'Недавние';

  @override
  String get missedStatLabel => 'Пропущенные';

  @override
  String get videoStatLabel => 'Видео';

  @override
  String get allCallsFilter => 'Все звонки';

  @override
  String get missedCallsFilter => 'Пропущенные';

  @override
  String get callTypeVideo => 'Видео';

  @override
  String get callTypeVoice => 'Голос';

  @override
  String get pseudoVideoCallScreen => 'Псевдоэкран видеозвонка';

  @override
  String get pseudoVoiceCallScreen => 'Псевдоэкран голосового звонка';

  @override
  String get noCallsInFilter => 'В этом фильтре нет звонков';

  @override
  String get switchBackToAllCalls =>
      'Переключитесь обратно на все звонки, чтобы увидеть полную тестовую историю.';

  @override
  String get peopleAndTeamsTitle => 'Люди и команды';

  @override
  String contactsSummary({required int total, required int online}) {
    return 'Доступно контактов: $total, сейчас онлайн: $online. Это локальный демонстрационный каталог для портфолио-сценария.';
  }

  @override
  String get searchByNameOrUsername => 'Поиск по имени или юзернейму';

  @override
  String get noContactsFound => 'Контакты не найдены';

  @override
  String get tryAnotherContactQuery =>
      'Попробуйте другой запрос, чтобы отфильтровать локальную демонстрационную адресную книгу.';

  @override
  String get accountSectionTitle => 'Аккаунт';

  @override
  String get aboutSectionTitle => 'О пользователе';

  @override
  String get statusSectionTitle => 'Статус';

  @override
  String get userIdLabel => 'ID пользователя';

  @override
  String get usernameLabel => 'Имя пользователя';

  @override
  String get userIdCopied => 'ID пользователя скопирован';

  @override
  String get profileStatusDescription =>
      'Готово к синхронизации чатов, данных профиля и общих медиа между вашими сессиями.';

  @override
  String get addPhoto => 'Добавить фото';

  @override
  String get removePhoto => 'Удалить фото';

  @override
  String get imageNotSelected => 'Изображение не выбрано';

  @override
  String get editValueTitle => 'Изменить значение';

  @override
  String get editValueDescription =>
      'Обновите значение и сохраните его, когда закончите.';

  @override
  String get editValueHint => 'Введите новое значение';

  @override
  String get displayNameField => 'Отображаемое имя';

  @override
  String get usernameField => 'Имя пользователя';

  @override
  String get chatNameField => 'Название чата';

  @override
  String get directConversation => 'Личная переписка';

  @override
  String get addParticipants => 'Добавить участников';

  @override
  String get chatIdCopied => 'ID чата скопирован';

  @override
  String get copyChatId => 'Скопировать ID чата';

  @override
  String get sharedContentTitle => 'Общий контент';

  @override
  String get sharedContentDescription =>
      'Локальные вкладки портфолио, имитирующие настоящий браузер медиа внутри мессенджера.';

  @override
  String get mediaTab => 'Медиа';

  @override
  String get filesTab => 'Файлы';

  @override
  String get linksTab => 'Ссылки';

  @override
  String get membersSectionTitle => 'Участники';

  @override
  String get peopleSectionTitle => 'Люди';

  @override
  String get memberRole => 'Участник';

  @override
  String get participantRole => 'Собеседник';

  @override
  String get noSharedMedia => 'Пока нет общих медиа';

  @override
  String get noSharedFiles => 'Пока нет общих файлов';

  @override
  String get noSharedLinks => 'Пока нет общих ссылок';

  @override
  String get memberOptions => 'Действия с участником';

  @override
  String get removeMember => 'Удалить';

  @override
  String get chatRemoved => 'Чат удалён';

  @override
  String get unableToDeleteChat => 'Не удалось удалить чат';

  @override
  String get chatCreated => 'Чат создан';

  @override
  String chatCreatedWithId({required String chatId}) {
    return 'Чат создан: $chatId';
  }

  @override
  String get chatAdded => 'Чат добавлен';

  @override
  String addedUserToChat({required String userId}) {
    return 'Пользователь добавлен в чат: $userId';
  }

  @override
  String get chatDetailsTitle => 'Информация о чате';

  @override
  String get messageSearchHint => 'Поиск...';

  @override
  String get lastSeenRecently => 'недавно был(а) в сети';

  @override
  String imageSendFailed({required String error}) {
    return 'Не удалось отправить изображение: $error';
  }

  @override
  String get messageInputHint => 'Сообщение';

  @override
  String get messageActionsTitle => 'Сообщение';

  @override
  String get copyAction => 'Копировать';

  @override
  String get editAction => 'Изменить';

  @override
  String get deleteAction => 'Удалить';

  @override
  String get cancelAction => 'Отмена';

  @override
  String get viewDetailsAction => 'Открыть детали';

  @override
  String get jumpToLatest => 'К последнему сообщению';

  @override
  String get editMessageTitle => 'Изменить сообщение';

  @override
  String get enterMessageTextHint => 'Введите текст сообщения';

  @override
  String get saveAction => 'Сохранить';

  @override
  String get editedLabel => 'изменено';

  @override
  String get storyPreviewDescription =>
      'Предпросмотр сторис для портфолио. Тапы переключают истории так же, как в живом мессенджере, а контент остаётся локальным и тестовым.';

  @override
  String get replyAction => 'Ответить';
}
