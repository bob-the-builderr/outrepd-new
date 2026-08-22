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
  String lpProgress(String lp, String left) {
    return '$lp / 100 ОЛ · до повышения $left';
  }

  @override
  String winStreak(String count) {
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
  String changeNameLeft(String total, String left) {
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
  String titlesAndStreak(String owned, String total, String streak) {
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
  String goalRemaining(String reps, String days) {
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
  String seasonResets(String days) {
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
  String yourFriends(String count) {
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
  String lpToGo(String lp) {
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
  String xOfY(String a, String b) {
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
  String winLoss(String w, String l) {
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

  @override
  String get ttl_first_blood => 'Первая кровь';

  @override
  String get tdesc_first_blood => 'Завершите первый матч';

  @override
  String get ttl_found_footing => 'Твёрдая опора';

  @override
  String get tdesc_found_footing => 'Завершите пять матчей';

  @override
  String get ttl_regular => 'Завсегдатай';

  @override
  String get tdesc_regular => 'Двадцать матчей';

  @override
  String get ttl_fifty => 'Полсотни';

  @override
  String get tdesc_fifty => 'Пятьдесят матчей';

  @override
  String get ttl_century => 'Столетие';

  @override
  String get tdesc_century => 'Сто матчей';

  @override
  String get ttl_veteran => 'Ветеран';

  @override
  String get tdesc_veteran => 'Двести пятьдесят матчей';

  @override
  String get ttl_thousand_matches => 'Старая гвардия';

  @override
  String get tdesc_thousand_matches => 'Тысяча матчей';

  @override
  String get ttl_first_win => 'Победитель';

  @override
  String get tdesc_first_win => 'Выиграйте матч';

  @override
  String get ttl_on_a_roll => 'На ходу';

  @override
  String get tdesc_on_a_roll => 'Выиграйте три подряд';

  @override
  String get ttl_five_straight => 'Пять подряд';

  @override
  String get tdesc_five_straight => 'Выиграйте пять подряд';

  @override
  String get ttl_unstoppable => 'Неудержимый';

  @override
  String get tdesc_unstoppable => 'Выиграйте десять подряд';

  @override
  String get ttl_untouchable => 'Неприкасаемый';

  @override
  String get tdesc_untouchable => 'Выиграйте двадцать подряд';

  @override
  String get ttl_giant_slayer => 'Убийца гигантов';

  @override
  String get tdesc_giant_slayer => 'Обыграйте соперника на два ранга выше';

  @override
  String get ttl_comeback => 'Возвращение';

  @override
  String get tdesc_comeback => 'Выиграйте сразу после трёх поражений';

  @override
  String get ttl_nemesis => 'Немезида';

  @override
  String get tdesc_nemesis => 'Обыграйте одного соперника пять раз';

  @override
  String get ttl_hundred_reps => 'Со старта';

  @override
  String get tdesc_hundred_reps => 'Сто засчитанных повторов';

  @override
  String get ttl_five_hundred => 'Разогрет';

  @override
  String get tdesc_five_hundred => 'Пятьсот засчитанных повторов';

  @override
  String get ttl_the_machine => 'Машина';

  @override
  String get tdesc_the_machine => 'Тысяча засчитанных повторов';

  @override
  String get ttl_five_thousand => 'Неумолимый';

  @override
  String get tdesc_five_thousand => 'Пять тысяч засчитанных повторов';

  @override
  String get ttl_ten_thousand => 'Десять тысяч';

  @override
  String get tdesc_ten_thousand => 'Десять тысяч засчитанных повторов';

  @override
  String get ttl_fifty_thousand => 'Вне счёта';

  @override
  String get tdesc_fifty_thousand => 'Пятьдесят тысяч засчитанных повторов';

  @override
  String get ttl_first_tonne => 'Тонна';

  @override
  String get tdesc_first_tonne => 'Поднимите тысячу килограммов суммарно';

  @override
  String get ttl_ten_tonnes => 'Десять тонн';

  @override
  String get tdesc_ten_tonnes => 'Поднимите десять тысяч килограммов';

  @override
  String get ttl_six_figures => 'Шесть знаков';

  @override
  String get tdesc_six_figures => 'Поднимите сто тысяч килограммов';

  @override
  String get ttl_half_million => 'Полмиллиона';

  @override
  String get tdesc_half_million => 'Поднимите пятьсот тысяч килограммов';

  @override
  String get ttl_million_kg => 'Клуб миллиона';

  @override
  String get tdesc_million_kg => 'Поднимите миллион килограммов';

  @override
  String get ttl_two_days => 'Снова здесь';

  @override
  String get tdesc_two_days => 'Тренируйтесь два дня подряд';

  @override
  String get ttl_no_days_off => 'Без выходных';

  @override
  String get tdesc_no_days_off => 'Тренируйтесь семь дней подряд';

  @override
  String get ttl_fortnight => 'Две недели';

  @override
  String get tdesc_fortnight => 'Серия в четырнадцать дней';

  @override
  String get ttl_unbroken => 'Непрерывно';

  @override
  String get tdesc_unbroken => 'Серия в тридцать дней';

  @override
  String get ttl_sixty_days => 'Привычка';

  @override
  String get tdesc_sixty_days => 'Серия в шестьдесят дней';

  @override
  String get ttl_hundred_days => 'Сто дней';

  @override
  String get tdesc_hundred_days => 'Серия в сто дней';

  @override
  String get ttl_year_round => 'Круглый год';

  @override
  String get tdesc_year_round => 'Серия в триста шестьдесят пять дней';

  @override
  String get ttl_perfect_week => 'Идеальная неделя';

  @override
  String get tdesc_perfect_week => 'Тренируйтесь каждый день недели';

  @override
  String get ttl_perfect_month => 'Идеальный месяц';

  @override
  String get tdesc_perfect_month => 'Четыре идеальные недели';

  @override
  String get ttl_bronze_tier => 'Из камня';

  @override
  String get tdesc_bronze_tier => 'Достигните Бронзы';

  @override
  String get ttl_silver_tier => 'Серебристый';

  @override
  String get tdesc_silver_tier => 'Достигните Серебра';

  @override
  String get ttl_golden_era => 'Золотая эра';

  @override
  String get tdesc_golden_era => 'Достигните Золота';

  @override
  String get ttl_platinum_tier => 'Платина';

  @override
  String get tdesc_platinum_tier => 'Достигните Платины';

  @override
  String get ttl_diamond_tier => 'Алмазная хватка';

  @override
  String get tdesc_diamond_tier => 'Достигните Алмаза';

  @override
  String get ttl_master_tier => 'Мастер';

  @override
  String get tdesc_master_tier => 'Достигните Мастера';

  @override
  String get ttl_mythic_tier => 'Мифический';

  @override
  String get tdesc_mythic_tier => 'Достигните Мифического ранга';

  @override
  String get ttl_legend_tier => 'Легенда';

  @override
  String get tdesc_legend_tier => 'Достигните Легенды';

  @override
  String get ttl_clean_hands => 'Чистые руки';

  @override
  String get tdesc_clean_hands => 'Полный подход, где засчитан каждый повтор';

  @override
  String get ttl_spotless => 'Безупречно';

  @override
  String get tdesc_spotless => 'Десять чистых подходов';

  @override
  String get ttl_textbook => 'По учебнику';

  @override
  String get tdesc_textbook => 'Пятьдесят чистых подходов';

  @override
  String get ttl_iron_hold => 'Железная хватка';

  @override
  String get tdesc_iron_hold => 'Продержите планку две минуты';

  @override
  String get ttl_statue => 'Статуя';

  @override
  String get tdesc_statue => 'Продержите планку пять минут';

  @override
  String get ttl_all_rounder => 'Универсал';

  @override
  String get tdesc_all_rounder => 'Засчитайте пять разных упражнений';

  @override
  String get ttl_explorer => 'Исследователь';

  @override
  String get tdesc_explorer => 'Засчитайте пятнадцать разных упражнений';

  @override
  String get ttl_encyclopedia => 'Энциклопедия';

  @override
  String get tdesc_encyclopedia => 'Засчитайте сорок разных упражнений';

  @override
  String get ttl_early_bird => 'Утренняя смена';

  @override
  String get tdesc_early_bird => 'Десять тренировок до семи утра';

  @override
  String get ttl_sunrise_club => 'Клуб рассвета';

  @override
  String get tdesc_sunrise_club => 'Пятьдесят тренировок до семи утра';

  @override
  String get ttl_night_owl => 'Ночная смена';

  @override
  String get tdesc_night_owl => 'Десять тренировок после десяти вечера';

  @override
  String get ttl_graveyard => 'Смена на рассвете';

  @override
  String get tdesc_graveyard => 'Пятьдесят тренировок после десяти вечера';

  @override
  String get ttl_joined_up => 'В составе';

  @override
  String get tdesc_joined_up => 'Состоите в команде';

  @override
  String get ttl_backbone => 'Хребет';

  @override
  String get tdesc_backbone => 'Возглавьте команду четыре недели подряд';

  @override
  String get ttl_cornerstone => 'Краеугольный камень';

  @override
  String get tdesc_cornerstone => 'Возглавьте команду двенадцать недель подряд';

  @override
  String get ttl_not_alone => 'Не один';

  @override
  String get tdesc_not_alone => 'Добавьте первого друга';

  @override
  String get ttl_well_connected => 'Со связями';

  @override
  String get tdesc_well_connected => 'Десять друзей';

  @override
  String get ttl_the_gym_knows => 'Зал вас знает';

  @override
  String get tdesc_the_gym_knows => 'Пятьдесят друзей';

  @override
  String get finish2 => 'Готово';

  @override
  String get qExperience => 'Какой у вас опыт\nтренировок?';

  @override
  String get expBeginner => 'Новичок – пробовал раньше';

  @override
  String get expIntermediate => 'Средний – тренируюсь регулярно';

  @override
  String get expAdvanced => 'Продвинутый – годы практики';

  @override
  String get qGoal => 'Какая у вас главная\nцель?';

  @override
  String get goalStronger => 'Стать сильнее';

  @override
  String get goalConsistent => 'Стать более последовательным';

  @override
  String get goalLean => 'Сбросить вес и подсушиться';

  @override
  String get goalMass => 'Набрать мышечную массу';

  @override
  String get aboutYou => 'Этот путь — только о вас...';

  @override
  String get qThinkAbout =>
      'Как часто вы думаете\nо том, чтобы прийти в форму?';

  @override
  String get freqNever => 'Никогда';

  @override
  String get freqSometimes => 'Иногда';

  @override
  String get freqOften => 'Часто';

  @override
  String get freqAllTime => 'Постоянно';

  @override
  String get qEnergy => 'Как у вас с энергией\nво время тренировки?';

  @override
  String get energyLow => 'Низкая, весь день чувствую себя выжатым';

  @override
  String get energyDrops => 'Работоспособность падает к середине';

  @override
  String get energyHard => 'Тяжело дожать последний подход';

  @override
  String get energyHigh => 'Высокая и ровная от начала до конца';

  @override
  String get stProgress =>
      'Иногда трудно заметить прогресс во время тренировок';

  @override
  String get stEffortTitle => 'Усилие, которого никто не видит,\nлегко бросить';

  @override
  String get stEffortBody =>
      'Когда некому ничего доказывать, прогресс кажется медленным, а усилие бессмысленным';

  @override
  String get stAloneTitle => 'Тренироваться в одиночку\nскучно';

  @override
  String get stAloneBody =>
      'Никто не смотрит. Никто не считает. Легко пропустить повтор — или весь подход';

  @override
  String get qName => 'Как нам вас\nназывать?';

  @override
  String get nameHint => 'Не меньше трёх символов. Это увидят соперники.';

  @override
  String get basicInfo => 'Отлично! Теперь\nнесколько базовых данных';

  @override
  String get qAge => 'Сколько вам лет?';

  @override
  String get qWeight => 'Какой у вас\nтекущий вес?';

  @override
  String get weightWhy => 'Вес тела нужен для расчёта вашего ранга.';

  @override
  String get privateNote => 'Ваши данные закрыты и никому не передаются.';

  @override
  String get qHeight => 'Какой у вас рост?';

  @override
  String get qRelate => 'Узнаёте себя\nв утверждении ниже?';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get grindTitle => 'С соперником\nработа идёт иначе';

  @override
  String get grindBody =>
      'Каждый матч ставит вас против реального соперника: сделайте работу и покажите, кто тренировался усерднее.';

  @override
  String get allSet => 'Всё готово!';

  @override
  String welcomeLifter(String name) {
    return 'Добро пожаловать, $name. Пора найти первого соперника.';
  }

  @override
  String get lifter => 'атлет';

  @override
  String get enterApp => 'Войти в OUTREPD';

  @override
  String get commitTitle => 'А теперь дадим обещание\nсвоему пути';

  @override
  String get holdLogo => 'Удерживайте логотип, чтобы подтвердить готовность';

  @override
  String get expNone => 'Никогда не тренировался';

  @override
  String get iAm => 'Я...';

  @override
  String get finishMatchQ => 'Завершить матч?';

  @override
  String get finishMatchBody =>
      'Ваш объём будет зафиксирован и сравнён с объёмом соперника.';

  @override
  String get keepGoing => 'Продолжить';

  @override
  String get forfeitQ => 'Сдать матч?';

  @override
  String get forfeitBody => 'Если выйти сейчас, вы потеряете очки.';

  @override
  String get stay => 'Остаться';

  @override
  String get forfeit => 'Сдаться';

  @override
  String get pickExercises => 'Выберите упражнения, которые будете делать';

  @override
  String matchingWith(String muscle) {
    return 'Подбираем соперника вашего ранга · $muscle';
  }

  @override
  String get getReady => 'ПРИГОТОВЬТЕСЬ';

  @override
  String get timeLeft => 'ОСТАЛОСЬ';

  @override
  String vsName(String name) {
    return 'против $name';
  }

  @override
  String kgTotalVolume(String unit) {
    return '$unit общего объёма';
  }

  @override
  String get finishMatch => 'ЗАВЕРШИТЬ МАТЧ';

  @override
  String get kgHint => 'КГ';

  @override
  String get repsHint => 'ПОВТ.';

  @override
  String get addSet => 'ДОБАВИТЬ ПОДХОД';

  @override
  String get matchComplete => 'МАТЧ ЗАВЕРШЁН';

  @override
  String get you => 'ВЫ';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'НА ГЛАВНУЮ';

  @override
  String get mgChest => 'Грудь';

  @override
  String get mgBack => 'Спина';

  @override
  String get mgLegs => 'Ноги';

  @override
  String get mgShoulders => 'Плечи';

  @override
  String get mgArms => 'Руки';

  @override
  String get mgCore => 'Кор';

  @override
  String get achRivalry => 'Соперничество';

  @override
  String get achRivalryHint => 'Обыграйте одного соперника 3 раза';

  @override
  String get nWonTitle => 'Вы победили!';

  @override
  String nWonBody(String name, String muscle) {
    return 'Вы обыграли $name в день $muscle';
  }

  @override
  String get nFriendTitle => 'Новая заявка в друзья';

  @override
  String nFriendBody(String name) {
    return '$name хочет добавить вас';
  }

  @override
  String get nAchTitle => 'Достижение открыто';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => 'Повышение ранга!';

  @override
  String nRankBody(String rank) {
    return 'Вы достигли $rank';
  }

  @override
  String get nameTooShortInline => 'Выберите имя не короче трёх символов';

  @override
  String get whyName => 'Соперники увидят его рядом с каждым результатом';

  @override
  String get whyExperience => 'Мы сводим вас с людьми вашего уровня';

  @override
  String get whyGoal => 'От этого зависят первые предложенные упражнения';

  @override
  String get whyAge =>
      'Возраст влияет на силовые нормативы, с которыми вас сравнивают';

  @override
  String get whyWeight =>
      'Ранг сравнивает вес снаряда относительно веса тела, а не голые килограммы';

  @override
  String get whyHeight =>
      'Используется вместе с весом, чтобы нормативы были честными';

  @override
  String get whyHabits =>
      'От этого зависят напоминания и предлагаемая недельная цель';

  @override
  String get transitionPartOfIt =>
      '...так давайте убедимся, что вы действительно её часть.';

  @override
  String get male => 'Мужской';

  @override
  String get female => 'Женский';

  @override
  String get usernamePlaceholder => 'имя';

  @override
  String get stRoutine =>
      'Я не знаю, какая группа мышц действительно требует работы, поэтому обычно повторяю одну и ту же программу';

  @override
  String get shortIn => 'дюйм';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String daysAgo(String n) {
    return '$n дней назад';
  }

  @override
  String weeksAgo(String n) {
    return '$n недель назад';
  }

  @override
  String membersCount(String n) {
    return '$n участников';
  }

  @override
  String eachCount(String n) {
    return '$n на человека';
  }

  @override
  String lpAmount(String n) {
    return '$n ОЛ';
  }

  @override
  String get countWithCamera => 'Считать камерой';

  @override
  String get youWin => 'ПОБЕДА!';

  @override
  String get defeated => 'ПОРАЖЕНИЕ';

  @override
  String get fillWholeNumbers => 'Заполните все три целыми числами';

  @override
  String heightRange(String min, String max, String unit) {
    return 'Рост должен быть от $min до $max $unit';
  }

  @override
  String weightRange(String min, String max, String unit) {
    return 'Вес должен быть от $min до $max $unit';
  }

  @override
  String ageRange(String min, String max) {
    return 'Возраст должен быть от $min до $max';
  }

  @override
  String get discPush => 'Push';

  @override
  String get discPull => 'Pull';

  @override
  String get discLegs => 'Legs';

  @override
  String get discPushHint => 'Chest, shoulders and triceps';

  @override
  String get discPullHint => 'Back and biceps';

  @override
  String get discLegsHint => 'Quads, hamstrings and core';

  @override
  String get pickYourThree => 'Pick your three';

  @override
  String get pickThreeHint =>
      'Both of you lift all six — your three and theirs';

  @override
  String roundOf(String n, String total) {
    return 'Round $n of $total';
  }

  @override
  String get rest => 'Rest';

  @override
  String get work => 'Work';

  @override
  String get nextUp => 'Next up';

  @override
  String picksLeft(String n) {
    return '$n left to pick';
  }

  @override
  String get yourPick => 'Your pick';

  @override
  String get theirPick => 'Their pick';

  @override
  String secondsOfWork(String n) {
    return '$n seconds of work';
  }

  @override
  String lpOutOf(String total) {
    return '/ $total ОЛ';
  }

  @override
  String toPromotion(String n) {
    return 'до повышения $n';
  }

  @override
  String get noFriendsTitle => 'Друзей пока нет';

  @override
  String get noFriendsBody =>
      'Добавьте кого-нибудь — и сможете вызвать его на приватный матч в любой момент.';

  @override
  String get noMatchesTitle => 'Матчей пока нет';

  @override
  String get noMatchesBody =>
      'Первый появится здесь, победа это или поражение.';

  @override
  String get noNotificationsTitle => 'Ничего нового';

  @override
  String get noNotificationsBody =>
      'Приглашения, результаты и заявки в друзья приходят сюда.';

  @override
  String roundDone(String n) {
    return 'Раунд $n пройден';
  }

  @override
  String get bestRoundYet => 'Лучший раунд пока что';

  @override
  String get countedThat => 'Засчитано за раунд';

  @override
  String get thatIsRight => 'Верно';

  @override
  String get useMyCount => 'Взять мой счёт';

  @override
  String get confirmHint => 'Исправьте, если камера ошиблась.';

  @override
  String pickNMore(String n) {
    return 'Выберите ещё $n';
  }

  @override
  String get findOpponent => 'Найти соперника';
}
