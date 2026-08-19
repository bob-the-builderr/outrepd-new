// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class LRu extends L {
  LRu([String locale = 'ru']) : super(locale);

  @override
  String get tabFriends => 'Друзья';

  @override
  String get tabRanks => 'Ранги';

  @override
  String get tabMatch => 'Матч';

  @override
  String get tabCrew => 'Команда';

  @override
  String get tabProfile => 'Профиль';

  @override
  String get searchOpponent => 'Найти соперника';

  @override
  String get searchOpponentHint => 'Подберём того, кто в твоём ранге';

  @override
  String get challengeFriend => 'Вызвать друга';

  @override
  String get trainWithCamera => 'Тренироваться с камерой';

  @override
  String get viewRoadmap => 'Посмотреть путь';

  @override
  String lpProgress(int lp, int left) {
    return '$lp / 100 ОЛ · до повышения $left';
  }

  @override
  String winStreak(int count) {
    return '$count побед подряд';
  }

  @override
  String get matchHistory => 'История матчей';

  @override
  String get allMatches => 'Все матчи';

  @override
  String get wins => 'Победы';

  @override
  String get losses => 'Поражения';

  @override
  String get winRate => 'Процент побед';

  @override
  String get streak => 'Серия';

  @override
  String get profile => 'Профиль';

  @override
  String get settings => 'Настройки';

  @override
  String get stats => 'Статистика';

  @override
  String get edit => 'Изменить';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get skip => 'Пропустить';

  @override
  String get totalMatches => 'Всего матчей';

  @override
  String get bestWinStreak => 'Лучшая серия побед';

  @override
  String get totalVolume => 'Общий поднятый объём';

  @override
  String get height => 'Рост';

  @override
  String get bodyweight => 'Вес тела';

  @override
  String get age => 'Возраст';

  @override
  String get editYourStats => 'Изменить свои данные';

  @override
  String get editStatsHint =>
      'Победы, объём и ранг зарабатываются — их нельзя вписать.';

  @override
  String get changeName => 'Сменить имя';

  @override
  String get changeNameLast => 'Это последняя смена. Отменить будет нельзя.';

  @override
  String changeNameLeft(int total, int left) {
    return 'Всего доступно $total смены. После этой останется $left.';
  }

  @override
  String get changeNameUsedUp => 'Обе смены имени уже использованы';

  @override
  String get yourPicture => 'Твоё фото';

  @override
  String get yourPictureHint =>
      'Рамка зависит от ранга и меняется по мере подъёма.';

  @override
  String get gallery => 'Галерея';

  @override
  String get camera => 'Камера';

  @override
  String get orPickOurs => 'Или выбери из наших';

  @override
  String get awards => 'Награды';

  @override
  String get yourTitles => 'Твои титулы';

  @override
  String get stillToEarn => 'Ещё предстоит заслужить';

  @override
  String get noTitlesYet => 'Пока ни одного. Для первого хватит одного матча.';

  @override
  String get wearHint =>
      'Нажми, чтобы надеть. Титул будет стоять рядом с именем везде, где тебя видят.';

  @override
  String get worn => 'надет';

  @override
  String get titleUnlocked => 'Титул открыт';

  @override
  String get wearIt => 'Надеть';

  @override
  String get wearItLater => 'Позже';

  @override
  String get dayStreak => 'дней подряд';

  @override
  String get bestEver => 'Рекорд';

  @override
  String get restDaysLeft => 'Дней отдыха осталось';

  @override
  String get restIsTraining =>
      'Отдых — часть тренировки. Два выходных в неделю серию не прервут.';

  @override
  String titlesAndStreak(int owned, int total, int streak) {
    return '$owned из $total титулов · серия $streak дней';
  }

  @override
  String get crew => 'Команда';

  @override
  String get myCrew => 'Моя команда';

  @override
  String get rankings => 'Рейтинг';

  @override
  String get trainWithCrew => 'Тренируйся в команде';

  @override
  String get trainWithCrewHint =>
      'До 20 человек под одним именем: общая недельная цель и место в таблице команд.';

  @override
  String get createCrew => 'Создать команду';

  @override
  String get createCrewHint => 'Назови её, выбери герб, позови своих';

  @override
  String get joinOpenCrew => 'Вступить в открытую команду';

  @override
  String get joinOpenCrewHint => 'Команды, открытые для всех';

  @override
  String get yourInvites => 'Твои приглашения';

  @override
  String get yourInvitesHint => 'Команды, которые тебя позвали';

  @override
  String get joinWithCode => 'Вступить по коду';

  @override
  String get joinWithCodeHint => 'Шесть символов от участника';

  @override
  String get topCrewsThisWeek => 'Лучшие команды недели';

  @override
  String get members => 'Участники';

  @override
  String get repsEach => 'Повторов на человека';

  @override
  String get rank => 'Место';

  @override
  String get weeklyGoal => 'Цель недели';

  @override
  String get weeklyGoalDone => 'Цель недели взята';

  @override
  String goalRemaining(int reps, int days) {
    return 'Осталось $reps повторов · $days дней';
  }

  @override
  String get goalDoneHint => 'Значок получат все, когда неделя закроется.';

  @override
  String get startCrewWar => 'Начать войну команд';

  @override
  String get startCrewWarHint =>
      'Семь дней, считают обе команды. Побеждает та, у кого больше повторов на человека.';

  @override
  String get whoIsPulling => 'Кто тянет команду';

  @override
  String get thisWeek => 'на этой неделе';

  @override
  String get inviteLifters => 'Пригласить спортсменов';

  @override
  String get referralCode => 'Код приглашения';

  @override
  String get inviteLink => 'Ссылка-приглашение';

  @override
  String get leaveCrew => 'Выйти из команды';

  @override
  String get owner => 'Владелец';

  @override
  String get crewTable => 'Таблица команд';

  @override
  String get repsPerMember => 'повторов на участника';

  @override
  String seasonResets(int days) {
    return 'Обнуление через $days дней — все начинают заново';
  }

  @override
  String get rankingExplained =>
      'Команды сравниваются по повторам на участника, а не по сумме — иначе самая большая выигрывала бы одним размером.';

  @override
  String get leaderboard => 'Рейтинг';

  @override
  String get global => 'Мир';

  @override
  String get myCountry => 'Моя страна';

  @override
  String yourFriends(int count) {
    return 'Твои друзья ($count)';
  }

  @override
  String get challenge => 'Вызов';

  @override
  String get notifications => 'Уведомления';

  @override
  String get pickMovement => 'Выбери движение';

  @override
  String get anyExercise => 'Любое упражнение';

  @override
  String get anyExerciseHint =>
      'Начинайте подход — движение распознаётся по ходу выполнения';

  @override
  String get start => 'Начать';

  @override
  String get finish => 'Закончить';

  @override
  String get reps => 'повт.';

  @override
  String get secondsHeld => 'секунд удержания';

  @override
  String get learningMovement =>
      'Изучаю твоё движение — счёт появится через мгновение';

  @override
  String get recalibrate => 'Перекалибровать';

  @override
  String get resetCount => 'Обнулить счёт';

  @override
  String get checksForm => 'проверяет технику';

  @override
  String get counts => 'считает';

  @override
  String get time => 'время';

  @override
  String get howManyReally => 'Сколько повторов вы сделали на самом деле?';

  @override
  String get howManyReallyHint =>
      'Укажите свой счёт, а не счёт приложения. Именно с ним будет сравниваться счётчик.';

  @override
  String get appearance => 'Оформление';

  @override
  String get theme => 'Тема';

  @override
  String get darkMode => 'Тёмная тема';

  @override
  String get language => 'Язык';

  @override
  String get units => 'Единицы';

  @override
  String get weight => 'Вес';

  @override
  String get notificationsSection => 'Уведомления';

  @override
  String get privacy => 'Приватность';

  @override
  String get matches => 'Матчи';

  @override
  String get data => 'Данные';

  @override
  String get about => 'О приложении';

  @override
  String get dangerZone => 'Опасная зона';

  @override
  String get themeSystem => 'Как на устройстве';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get openCrews => 'Открытые команды';

  @override
  String get openCrewsHint =>
      'Эти команды принимают всех. Выберите одну — и вы в составе.';

  @override
  String get yourInvitesSubtitle => 'Команды, которые позвали именно тебя.';

  @override
  String get pickOpponent => 'Выбери соперника';

  @override
  String get accept => 'Принять';

  @override
  String get join => 'Вступить';

  @override
  String get copy => 'Копировать';

  @override
  String get copied => 'Ссылка-приглашение скопирована';

  @override
  String season(String name) {
    return 'Сезон $name';
  }

  @override
  String challengeSent(String name) {
    return 'Вызов отправлен: $name';
  }

  @override
  String get inviteFriendPrivate => 'Пригласите друга на закрытый матч';

  @override
  String get joinWithCodePaste =>
      'Вставь шесть символов, которые прислал участник.';

  @override
  String get enterTheCode => 'Введи код из 6 символов';

  @override
  String get followingDevice => 'Сейчас следует настройке устройства';

  @override
  String get weightUnitTitle => 'Единица веса';

  @override
  String get heightUnitTitle => 'Единица роста';

  @override
  String get unitKg => 'Килограммы (кг)';

  @override
  String get unitLb => 'Фунты (lb)';

  @override
  String get unitCm => 'Сантиметры (см)';

  @override
  String get unitFt => 'Футы и дюймы';

  @override
  String get visEveryone => 'Все';

  @override
  String get visFriends => 'Только друзья';

  @override
  String get visNobody => 'Никто';

  @override
  String get visEveryoneHint => 'Профиль может открыть любой';

  @override
  String get visFriendsHint => 'Только те, кого ты добавил';

  @override
  String get visNobodyHint => 'Профиль остаётся закрытым';

  @override
  String get matchInvites => 'Приглашения на матчи';

  @override
  String get matchResults => 'Результаты матчей';

  @override
  String get friendRequestsLabel => 'Заявки в друзья';

  @override
  String get crewActivity => 'Активность команды';

  @override
  String get rankChanges => 'Смена ранга';

  @override
  String get weeklySummary => 'Итоги недели';

  @override
  String get soundLabel => 'Звук';

  @override
  String get vibration => 'Вибрация';

  @override
  String get whoCanSeeProfile => 'Кто видит мой профиль';

  @override
  String get profileVisibility => 'Видимость профиля';

  @override
  String get showOnLeaderboards => 'Показывать меня в рейтингах';

  @override
  String get allowMatchInvites => 'Разрешить приглашения на матчи';

  @override
  String get allowFriendRequests => 'Разрешить заявки в друзья';

  @override
  String get showHeightWeight => 'Показывать рост и вес';

  @override
  String get showHeightWeightHint =>
      'Выключено — данные тела остаются только у тебя';

  @override
  String get autoAcceptFriends => 'Автоматически принимать от друзей';

  @override
  String get restTimerBetweenSets => 'Таймер отдыха между подходами';

  @override
  String get exportData => 'Выгрузить мои данные';

  @override
  String get clearCache => 'Очистить кэш';

  @override
  String get cacheCleared => 'Кэш очищен';

  @override
  String get version => 'Версия';

  @override
  String get rateApp => 'Оценить OUTREPD';

  @override
  String get contactSupport => 'Написать в поддержку';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get openSourceLicences => 'Лицензии открытого кода';

  @override
  String get resetProgress => 'Сбросить прогресс';

  @override
  String get resetProgressTitle => 'Сбросить прогресс?';

  @override
  String get resetProgressBody =>
      'Ранг, очки и история матчей обнулятся. Отменить будет нельзя.';

  @override
  String get actionReset => 'Сбросить';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountBody =>
      'Профиль, команды и каждый сыгранный матч удаляются навсегда.';

  @override
  String get actionDelete => 'Удалить';

  @override
  String get needsServer =>
      'Для этой функции нужен сервер — он ещё не подключён';

  @override
  String get getStarted => 'Начать';

  @override
  String get skipToApp => 'Сразу в приложение';

  @override
  String get achievements => 'Достижения';

  @override
  String get unlocked => 'Открыто';

  @override
  String get roadTitle => 'Путь к Легенде';

  @override
  String get allTiers => 'Все ранги';

  @override
  String get topTier => 'Высший ранг';

  @override
  String lpToGo(int lp) {
    return '$lp ОЛ';
  }

  @override
  String get unlockedEverything => 'Ты открыл всё';

  @override
  String unlocksAt(String tier) {
    return 'Откроется на ранге $tier';
  }

  @override
  String get matchedSameGroup =>
      'Тебя сведут с тем, кто тренирует ту же группу.';

  @override
  String get roomFriendly =>
      'Матчи в комнате — товарищеские, на ранг они не влияют.';

  @override
  String get createRoom => 'Создать комнату';

  @override
  String get enterCode => 'ВВЕДИ КОД';

  @override
  String get joinRoom => 'Войти в комнату';

  @override
  String get shareThisCode => 'Поделись этим кодом';

  @override
  String get codeCopied => 'Код скопирован';

  @override
  String get pickMuscleAndStart => 'Выбери мышцу и начинай';

  @override
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(int a, int b) {
    return '$a / $b';
  }

  @override
  String get tierStone => 'Камень';

  @override
  String get tierBronze => 'Бронза';

  @override
  String get tierSilver => 'Серебро';

  @override
  String get tierGold => 'Золото';

  @override
  String get tierPlatinum => 'Платина';

  @override
  String get tierDiamond => 'Алмаз';

  @override
  String get tierMaster => 'Мастер';

  @override
  String get tierMythic => 'Мифический';

  @override
  String get tierLegend => 'Легенда';

  @override
  String get rewardStone => 'Каменная рамка';

  @override
  String get rewardBronze => 'Бронзовый значок';

  @override
  String get rewardSilver => 'Серебряный значок';

  @override
  String get rewardGold => 'Золотой значок';

  @override
  String get rewardPlatinum => 'Платиновый значок';

  @override
  String get rewardDiamond => 'Алмазный значок';

  @override
  String get rewardMaster => 'Значок мастера';

  @override
  String get rewardMythic => 'Мифический значок';

  @override
  String get rewardLegend => 'Значок легенды';

  @override
  String get shortKg => 'кг';

  @override
  String get shortLb => 'фнт';

  @override
  String get shortCm => 'см';

  @override
  String get shortFt => 'фут';

  @override
  String winLoss(int w, int l) {
    return '$wП $lП';
  }

  @override
  String get yearsSuffix => 'лет';

  @override
  String get yourCrew => 'Ваша команда';

  @override
  String get crewName => 'Название команды';

  @override
  String get motto => 'Девиз';

  @override
  String get mottoHint => 'Что отстаивает эта команда?';

  @override
  String get country => 'Страна';

  @override
  String get whoCanJoin => 'Кто может вступить';

  @override
  String get minimumRank => 'Минимальный ранг';

  @override
  String get anyone => 'Любой';

  @override
  String get emblem => 'Эмблема';

  @override
  String get colour => 'Цвет';

  @override
  String get createCrewButton => 'Создать команду';

  @override
  String get ownerNote => 'Вы станете владельцем. В команде до 20 участников.';

  @override
  String get searchCountries => 'Поиск страны';

  @override
  String get noCountryMatch => 'Такой страны не найдено';

  @override
  String get nameTooShort => 'Дайте команде название не короче трёх символов';

  @override
  String get privOpen => 'Открытая';

  @override
  String get privRequest => 'По заявке';

  @override
  String get privInviteOnly => 'Только по приглашению';

  @override
  String get privOpenHint => 'У кого есть код, тот сразу в составе';

  @override
  String get privRequestHint => 'Игрок подаёт заявку, ответственный одобряет';

  @override
  String get privInviteOnlyHint =>
      'Вступить можно только по прямому приглашению';

  @override
  String get embStrength => 'Сила';

  @override
  String get embCombat => 'Бой';

  @override
  String get embBeasts => 'Звери';

  @override
  String get embElements => 'Стихии';

  @override
  String get embHonours => 'Награды';

  @override
  String get embSymbols => 'Символы';

  @override
  String get ob1Title => 'Преврати каждую тренировку\nв поединок';

  @override
  String get ob1Body =>
      'Записывайте тренировку и выходите против того, кто работает над той же группой мышц.';

  @override
  String get ob2Title => 'Бросьте вызов\nдрузьям';

  @override
  String get ob2Body =>
      'Отправьте закрытое приглашение и решите, кто тренируется усерднее.';

  @override
  String get ob3Title => 'Поднимайтесь в рангах';

  @override
  String get ob3Body =>
      'Каждая победа приносит очки. Пройдите путь от Камня до Легенды.';

  @override
  String get ob4Title => 'В одиночку\nтяжелее';

  @override
  String get ob4Body =>
      'Когда никто не смотрит, легко сократить последний подход.';

  @override
  String get ob5Title => 'Станьте\nЛегендой';

  @override
  String get ob5Body =>
      'Постоянство накапливается. Приходите, превосходите, растите.';

  @override
  String get letsGo => 'Начнём';

  @override
  String get continueLabel => 'Далее';
}
