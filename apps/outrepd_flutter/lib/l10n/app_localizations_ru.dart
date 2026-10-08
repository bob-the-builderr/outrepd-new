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
  String get tabProfile => 'Профиль';

  @override
  String get challengeFriend => 'Вызвать друга';

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
  String get settings => 'Настройки';

  @override
  String get accountSection => 'Аккаунт';

  @override
  String get duelSection => 'Дуэль';

  @override
  String get hapticsEachRep => 'Вибрация на каждом повторе';

  @override
  String get showSkeleton => 'Показывать скелет';

  @override
  String get showSkeletonHint => 'Так видно, что камера вас видит';

  @override
  String get manageNotifications => 'Настроить уведомления';

  @override
  String switchesOn(String on, String all) {
    return '$on из $all включено';
  }

  @override
  String get whoCanChallenge => 'Кто может бросить мне вызов';

  @override
  String get blockedAccounts => 'Заблокированные';

  @override
  String get reportProblem => 'Сообщить о проблеме';

  @override
  String get onDeviceNote =>
      'Распознавание позы работает на этом телефоне. Ни видео, ни данные позы не загружаются.';

  @override
  String get visibilitySection => 'Видимость';

  @override
  String get showMyCountry => 'Показывать страну';

  @override
  String get showMyCountryHint => 'Выключено — вас нет в таблице страны';

  @override
  String get safetySection => 'Безопасность';

  @override
  String get socialSection => 'Общение';

  @override
  String get noticeRaced => 'Кто-то принял мой подход';

  @override
  String get noticeRacedHint => 'Единственный способ узнать о дуэли';

  @override
  String get noticeFriendOk => 'Мой запрос приняли';

  @override
  String get noticesStoredNote =>
      'Выключено — значит не сохраняется вовсе, а не прячется.';

  @override
  String get notSaved => 'Не сохранено';

  @override
  String get blockedIntro =>
      'Заблокированный не может вызвать вас, найти вас или отправить запрос. Ему не сообщают.';

  @override
  String blockedWhen(String when) {
    return 'Заблокирован $when';
  }

  @override
  String get unblock => 'Разблокировать';

  @override
  String get noBlockedTitle => 'Никто не заблокирован';

  @override
  String get noBlockedBody => 'Заблокировать можно из профиля или из жалобы.';

  @override
  String get whatHappened => 'Что произошло';

  @override
  String get reasonCheating => 'Мошенничество или фальшивые повторы';

  @override
  String get reasonHarassment => 'Травля или оскорбления';

  @override
  String get reasonContent => 'Неприемлемый контент';

  @override
  String get reasonImpersonation => 'Выдаёт себя за другого';

  @override
  String get reasonOther => 'Другое';

  @override
  String get addDetails => 'Добавить подробности (необязательно)';

  @override
  String get alsoBlock => 'Также заблокировать';

  @override
  String get sendReport => 'Отправить жалобу';

  @override
  String get reportSent => 'Жалоба отправлена';

  @override
  String get reportingThisAccount => 'Жалоба на этот аккаунт';

  @override
  String get exportIntro =>
      'Мы пришлём на почту файл со всем, что сервер хранит о вас. Обычно это занимает минуту.';

  @override
  String get whatsIncluded => 'Что входит';

  @override
  String get incProfile => 'Профиль и ранг';

  @override
  String get incSets => 'Все подходы и повторы';

  @override
  String get incDuels => 'История дуэлей и изменения LP';

  @override
  String get incFriends => 'Друзья и заблокированные';

  @override
  String get incNotices => 'Полученные уведомления';

  @override
  String get noLandmarksNote =>
      'Точек позы там нет и никогда не было. Камера читает их на вашем телефоне, и они никуда не отправляются.';

  @override
  String get sendItTo => 'Отправить на';

  @override
  String get emailHint => 'vy@primer.com';

  @override
  String get createAccountTitle => 'Создать аккаунт';

  @override
  String get createAccountBody =>
      'Добавьте email и пароль, чтобы этот аккаунт не зависел только от одного телефона.';

  @override
  String get createAccountAction => 'Создать аккаунт';

  @override
  String get emailTakenSwitchToSignIn =>
      'У этого email уже есть аккаунт — войдите вместо этого.';

  @override
  String get emailSignUpInvalid =>
      'Проверьте email и пароль — минимум шесть символов.';

  @override
  String get tooManyCodes =>
      'Слишком много кодов отправлено — подождите пару минут и попробуйте снова.';

  @override
  String get sendCodeAction => 'Отправить код';

  @override
  String get noAccountForEmail => 'Мы не нашли аккаунт с таким email.';

  @override
  String get authEntryTagline =>
      'Отжимайся. Соревнуйся. Поднимайся по лестнице.';

  @override
  String get signUpWithEmail => 'Регистрация по email';

  @override
  String get alreadyHaveAccountQuestion => 'Уже есть аккаунт?';

  @override
  String get logInAction => 'Войти';

  @override
  String get createYourAccountTitle => 'Создайте аккаунт';

  @override
  String get createAccountSubtitle => 'Займёт меньше минуты.';

  @override
  String get usernameLabel => 'Имя пользователя';

  @override
  String get emailLabel => 'Эл. почта';

  @override
  String get logInSubtitle => 'Войдите, чтобы сохранить свой ранг.';

  @override
  String get checkYourEmailTitle => 'Проверьте почту';

  @override
  String codeSentTo(String email) {
    return 'Мы отправили 6-значный код на $email.';
  }

  @override
  String get didntGetIt => 'Не получили код?';

  @override
  String resendInSeconds(String time) {
    return 'Повторная отправка через $time';
  }

  @override
  String get wrongEmailGoBack => 'Неверный email? Назад';

  @override
  String get usernameTaken => 'Это имя пользователя уже занято.';

  @override
  String get wrongCode => 'Код неверный или истёк.';

  @override
  String get resendCode => 'Отправить код ещё раз';

  @override
  String get codeResent => 'Отправлен новый код.';

  @override
  String signedInAs(String email) {
    return 'Вход выполнен как $email';
  }

  @override
  String get addressNotKept =>
      'Адрес используется один раз и не сохраняется — у этого аккаунта нет почты.';

  @override
  String get requestMyData => 'Прислать мои данные';

  @override
  String exportSent(String address) {
    return 'Отправлено на $address';
  }

  @override
  String get deleteIntro =>
      'Это удалит всё навсегда. Отменить и восстановить нельзя.';

  @override
  String get rankLabel => 'Ранг';

  @override
  String get wantCopyFirst => 'Сначала забрать копию?';

  @override
  String get wantCopyBody =>
      'Скачайте данные до удаления. После — их не будет.';

  @override
  String typeToConfirm(String word) {
    return 'Введите $word для подтверждения';
  }

  @override
  String get deleteWord => 'УДАЛИТЬ';

  @override
  String get deletePermanently => 'Удалить навсегда';

  @override
  String get keepMyAccount => 'Оставить аккаунт';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get skip => 'Пропустить';

  @override
  String get yourPicture => 'Твоё фото';

  @override
  String get yourPictureHint =>
      'Рамка зависит от ранга и меняется по мере подъёма.';

  @override
  String get couldNotUsePicture => 'Не удалось использовать это фото';

  @override
  String get couldNotSyncAvatar =>
      'Фото сохранено, но пока не синхронизировано';

  @override
  String get couldNotShareCard => 'Не удалось поделиться карточкой';

  @override
  String get couldNotOpenLink => 'Не удалось открыть эту ссылку';

  @override
  String get couldNotCheckUsername =>
      'Не удалось проверить это имя — попробуйте снова';

  @override
  String get changeUsername => 'Изменить имя пользователя';

  @override
  String get usernameInvalidLength =>
      'Должно быть от 4 до 20 символов, только буквы, цифры и _';

  @override
  String get usernameChanged => 'Имя пользователя изменено';

  @override
  String get usernameAlreadyChangedBody =>
      'Вы уже использовали своё единственное изменение имени пользователя — на каждый аккаунт даётся ровно одно.';

  @override
  String get gallery => 'Галерея';

  @override
  String get camera => 'Камера';

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
  String get global => 'Глобальный';

  @override
  String get topPlayers => 'Лучшие игроки';

  @override
  String get yourTier => 'Ваш уровень';

  @override
  String get challenge => 'Вызов';

  @override
  String get notifications => 'Уведомления';

  @override
  String get start => 'Начать';

  @override
  String get finish => 'Закончить';

  @override
  String get reps => 'повт.';

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
  String get language => 'Язык';

  @override
  String get privacy => 'Приватность';

  @override
  String get data => 'Данные';

  @override
  String get about => 'О приложении';

  @override
  String get themeSystem => 'Как на устройстве';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get accept => 'Принять';

  @override
  String get visEveryone => 'Все';

  @override
  String get visFriends => 'Только друзья';

  @override
  String get visNobody => 'Никто';

  @override
  String get friendRequestsLabel => 'Заявки в друзья';

  @override
  String get showOnLeaderboards => 'Показывать меня в рейтингах';

  @override
  String get exportData => 'Выгрузить мои данные';

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
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get needsServer =>
      'Не удалось подключиться. Проверьте интернет и попробуйте снова.';

  @override
  String get roomFriendly =>
      'Матчи в комнате — товарищеские, на ранг они не влияют.';

  @override
  String get shareThisCode => 'Поделись этим кодом';

  @override
  String get codeCopied => 'Код скопирован';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => 'Железо';

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
  String winLoss(String w, String l) {
    return '$wП $lП';
  }

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
  String get ttl_bronze_tier => 'Из Железа';

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
  String get forfeitQ => 'Сдать матч?';

  @override
  String get forfeitBody => 'Если выйти сейчас, вы потеряете очки.';

  @override
  String get stay => 'Остаться';

  @override
  String get forfeit => 'Сдаться';

  @override
  String get getReady => 'ПРИГОТОВЬТЕСЬ';

  @override
  String get you => 'ВЫ';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'НА ГЛАВНУЮ';

  @override
  String get mgChest => 'Грудь';

  @override
  String get nWonTitle => 'Вы победили!';

  @override
  String nWonBody(String name, String muscle) {
    return 'Вы обыграли $name в день $muscle';
  }

  @override
  String get nFriendTitle => 'Новая заявка в друзья';

  @override
  String get nRacedTitle => 'Ваш подход приняли вызовом';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name принял ваш подход и не дотянул, $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name принял ваш подход и победил, $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => 'Запрос в друзья принят';

  @override
  String nFriendOkBody(String name) {
    return '$name принял ваш запрос';
  }

  @override
  String nFriendBody(String name) {
    return '$name хочет добавить вас';
  }

  @override
  String get nChallengedTitle => 'Реванш';

  @override
  String nChallengedBody(String name) {
    return '$name хочет реванш';
  }

  @override
  String get challengeSentTitle => 'Вызов отправлен';

  @override
  String challengeSentBody(String name) {
    return 'Мы сообщим $name. Возвращайтесь, когда он будет принят.';
  }

  @override
  String get challengeNotSentTitle => 'Не удалось отправить';

  @override
  String get challengeNotSentBody =>
      'Проверьте соединение и попробуйте снова во вкладке Матч.';

  @override
  String get challengeGoneTitle => 'Вызов больше не действует';

  @override
  String get challengeGoneBody => 'Он уже сыгран или был отозван.';

  @override
  String repsRecordedLine(String reps) {
    return 'Засчитано повторений: $reps';
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
  String lpAmount(String n) {
    return '$n ОЛ';
  }

  @override
  String get lpUnit => 'ОЛ';

  @override
  String get trueCountHint => 'напр. 12';

  @override
  String get couldNotSaveSession => 'Не удалось сохранить сессию';

  @override
  String lpOutOf(String total) {
    return '/ $total ОЛ';
  }

  @override
  String get noFriendsTitle => 'Друзей пока нет';

  @override
  String get noFriendsBody => 'Дуэль с знакомым — совсем другое дело.';

  @override
  String get decline => 'Отклонить';

  @override
  String requestSent(String name) {
    return 'Запрос отправлен: $name';
  }

  @override
  String nowFriends(String name) {
    return 'Теперь вы друзья с $name';
  }

  @override
  String get noOneFound => 'Никто не носит это имя';

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
  String get countedThat => 'Засчитано за раунд';

  @override
  String get thatIsRight => 'Верно';

  @override
  String get useMyCount => 'Взять мой счёт';

  @override
  String get confirmHint => 'Исправьте, если камера ошиблась.';

  @override
  String get unsureMovement =>
      'Не уверен, что это было то движение — проверьте число.';

  @override
  String get noRanksYet => 'No ranks yet';

  @override
  String get noRanksYetBody => 'Play a duel and the board fills in.';

  @override
  String get ranksTitle => 'Ranks';

  @override
  String get totalReps => 'Total reps';

  @override
  String get recent => 'Recent';

  @override
  String wonVs(String name) {
    return 'Won vs $name';
  }

  @override
  String lostVs(String name) {
    return 'Lost vs $name';
  }

  @override
  String hoursAgo(String n) {
    return '${n}h ago';
  }

  @override
  String toNextTier(String n, String tier) {
    return '$n to $tier';
  }

  @override
  String get noMatchesYet => 'No duels yet';

  @override
  String get noMatchesYetBody => 'Your first one shows up here, win or lose.';

  @override
  String get searchByUsername => 'Поиск по имени';

  @override
  String get incomingRequests => 'Входящие заявки';

  @override
  String get noRequestsWaiting => 'Сейчас нет ожидающих запросов';

  @override
  String get addFriendAction => 'Добавить друга';

  @override
  String get addFriendHint =>
      'Введите их имя пользователя или #код из их профиля.';

  @override
  String get usernameOrCode => 'Имя пользователя или #код';

  @override
  String get sendRequest => 'Отправить запрос';

  @override
  String onlineNowCount(String count) {
    return 'Сейчас в сети · $count';
  }

  @override
  String offlineCount(String count) {
    return 'Не в сети · $count';
  }

  @override
  String get invite => 'Пригласить';

  @override
  String get headToHeadTitle => 'Личные встречи';

  @override
  String get vsYouCaption => 'против вас';

  @override
  String get h2hYou => 'вы';

  @override
  String get h2hThem => 'он';

  @override
  String headToHead(String wins, String losses) {
    return '$winsП $lossesПр против вас';
  }

  @override
  String get neverPlayedYou => 'Ещё не играл с вами';

  @override
  String noHistoryWithThem(String username) {
    return 'Вы ещё не играли с $username.';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return 'В прошлый раз: $yourReps–$theirReps, $when.';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return 'Ваш лучший результат против него — $reps.';
  }

  @override
  String get viewFullProfile => 'Смотреть полный профиль';

  @override
  String get moreOptions => 'Ещё варианты';

  @override
  String get block => 'Заблокировать';

  @override
  String get blockRowBody => 'Не сможет вызвать вас или увидеть ваш профиль';

  @override
  String get report => 'Пожаловаться';

  @override
  String get reportRowBody => 'Рассмотрим в течение 24 часов';

  @override
  String muteChallenges(String username) {
    return 'Не показывать вызовы от $username';
  }

  @override
  String blockedLifter(String username) {
    return '$username заблокирован';
  }

  @override
  String mutedLifter(String username) {
    return '$username отключён';
  }

  @override
  String get addFriendButton => 'Добавить в друзья';

  @override
  String get alreadyFriends => 'Друзья';

  @override
  String get couldNotLoadProfile => 'Не удалось загрузить этот профиль';

  @override
  String get noFriendsMatch => 'Никого с таким именем';

  @override
  String get yourClimb => 'Ваш подъём';

  @override
  String floorKept(String tier, String rank) {
    return '$tier теперь ваш. Ниже $rank вы не опуститесь.';
  }

  @override
  String dayStreakCount(String count) {
    return '$count дней подряд';
  }

  @override
  String get findMatch => 'Найти матч';

  @override
  String rankedTerms(String seconds) {
    return '$seconds секунд · рейтинговый';
  }

  @override
  String get practiceTerms => 'Тренировка — без рейтинга и соперника';

  @override
  String get practiceComplete => 'ТРЕНИРОВКА ЗАВЕРШЕНА';

  @override
  String get noRankYet => 'Ранга пока нет';

  @override
  String placementsForFirstTier(String count) {
    return 'Сыграйте $count квалификационных дуэлей, чтобы получить первый ранг.';
  }

  @override
  String get startPlacements => 'Начать квалификацию';

  @override
  String get unranked => 'Без ранга';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$done из $total · по $seconds секунд';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$done из $total · ещё $left до ранга';
  }

  @override
  String placementsForTier(String count) {
    return 'Сыграйте $count квалификационных дуэлей, чтобы узнать свой ранг.';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '$done из $total квалификаций сыграно';
  }

  @override
  String get practiceFirst => 'Сначала тренировка';

  @override
  String get nextPlacement => 'Следующая квалификация';

  @override
  String get noConnection => 'Нет соединения';

  @override
  String get practiceOffline => 'Тренировка офлайн';

  @override
  String get retry => 'Повторить';

  @override
  String get youWonPlain => 'Вы победили';

  @override
  String get cameraNeededTitle => 'Нужен доступ к камере';

  @override
  String get cameraNeededBody =>
      'outrepd считает повторы, наблюдая за движением тела. Распознавание работает на вашем устройстве, ничего не отправляется.';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get allowCamera => 'Разрешить камеру';

  @override
  String get notNow => 'Не сейчас';

  @override
  String get noCameraTitle => 'Камера не найдена';

  @override
  String get noCameraBody =>
      'Повторы считаются по камере, поэтому это устройство не сможет судить дуэль. Всё остальное работает.';

  @override
  String get noConnectionBody =>
      'Для дуэли нужно соединение. Тренировка работает офлайн, повторы синхронизируются позже.';

  @override
  String get getBackInFrame => 'Вернитесь в кадр';

  @override
  String get clockStillRunning => 'Время идёт. Повторы не считаются.';

  @override
  String get giveUp => 'Сдаться';

  @override
  String get lpMovesWithGap =>
      'LP меняется в зависимости от разницы повторений — чем больше отрыв, тем больше очков';

  @override
  String get searchingForOpponent => 'Ищем соперника';

  @override
  String get getIntoPosition => 'Займите позицию';

  @override
  String get framingHint => 'Запястья и щиколотки должны быть в кадре';

  @override
  String get goUp => 'Вверх';

  @override
  String get goDown => 'Вниз';

  @override
  String get bestSet => 'Лучший подход';

  @override
  String get record => 'Счёт';

  @override
  String get last7Days => 'Последние 7 дней';

  @override
  String repsCount(String count) {
    return '$count повт.';
  }

  @override
  String get viewAll => 'Смотреть всё';

  @override
  String get shareProfile => 'Поделиться профилем';

  @override
  String get share => 'Поделиться';

  @override
  String get duelMeOnOutrepd => 'Вызови меня на outrepd';

  @override
  String get shareStory => 'История';

  @override
  String get sharePost => 'Пост';

  @override
  String get copyLink => 'Копировать';

  @override
  String get linkCopied => 'Ссылка скопирована';

  @override
  String get currentRankLabel => 'Текущий ранг';

  @override
  String get winInitial => 'П';

  @override
  String get lossInitial => 'Пр';

  @override
  String get dayInitial => 'д';

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline =>
      'Отжимания на счёт. Телефон считает. Кто-то ещё считает тоже.';

  @override
  String get obGetStarted => 'Начать';

  @override
  String get obHaveAccount => 'У меня уже есть аккаунт';

  @override
  String get obHowTitle => 'Три вещи — и ты в деле.';

  @override
  String get obHow1 => 'Поставь телефон на пол';

  @override
  String get obHow1Body => 'Прислони к стене, в метре перед собой.';

  @override
  String get obHow2 => 'Камера считает повторы';

  @override
  String get obHow2Body =>
      'У каждого повтора проверяется глубина. Половинчатые не в счёт.';

  @override
  String get obHow3 => 'Шестьдесят секунд против соперника';

  @override
  String get obHow3Body =>
      'Выиграл — поднялся. Проиграл — опустился. Правила для всех одни.';

  @override
  String get obTwoThings => 'Две короткие вещи.';

  @override
  String get obAgeQuestion => 'Сколько тебе лет?';

  @override
  String get obUnder16 => 'Меньше 16';

  @override
  String get obOver16 => '16 и старше';

  @override
  String get obHealthConsent =>
      'Я понимаю, что outrepd считает повторы и не даёт медицинских или тренировочных советов. Если что-то болит, я остановлюсь.';

  @override
  String get obTermsIntro => 'Продолжая, ты принимаешь';

  @override
  String get obTerms => 'Условия';

  @override
  String get obAnd => 'и';

  @override
  String get obPrivacy => 'Политику конфиденциальности';

  @override
  String get obUnder16Blocked =>
      'outrepd — с 16 лет. Возвращайся, когда дорастёшь: отжимания никуда не денутся.';

  @override
  String get obCameraTitle => 'outrepd нужна камера';

  @override
  String get obCameraBody =>
      'Она следит за движением тела, чтобы считать. По-другому никак.';

  @override
  String get obCameraPrivateTitle => 'Ничего не покидает телефон';

  @override
  String get obCameraPrivateBody =>
      'Отслеживание тела работает на этом устройстве. Видео никогда не сохраняется и не отправляется.';

  @override
  String get obWhyNeeded => 'Зачем это нужно?';

  @override
  String get obPlacementTitle => 'Поставь телефон на пол';

  @override
  String get obPlacementBody =>
      'Прислони к стене примерно в метре перед собой.';

  @override
  String get obOneMetre => '~1 м';

  @override
  String get obFullBody => 'всё тело в кадре';

  @override
  String get obCheckHandsFeet => 'Видно и руки, и ноги';

  @override
  String get obCheckFacing => 'Лицом к телефону, не боком';

  @override
  String get obCheckLight => 'Свет в комнате включён';

  @override
  String get obImSetUp => 'Всё готово';

  @override
  String get obFramingTitle => 'Прими упор лёжа';

  @override
  String get obFramingShoulders => 'Плечи и таз';

  @override
  String get obFramingWrists => 'Запястья';

  @override
  String get obFramingAnkles => 'Щиколотки';

  @override
  String get obLooksGood => 'Отлично';

  @override
  String get obCalibrating => 'Калибровка';

  @override
  String get obOneMoreRep => 'Ещё один — чтобы понять твою амплитуду';

  @override
  String get obCalibrationHint =>
      'Сделай три отжимания на своей обычной глубине';

  @override
  String get obCalibrated => 'Готово.';

  @override
  String get obCalibratedBody =>
      'Теперь outrepd знает твою амплитуду. Глубина меряется по тебе, а не по фиксированному числу.';

  @override
  String get obRepsCounted => 'Засчитано повторов';

  @override
  String get obAverageDepth => 'Средняя глубина';

  @override
  String get obForm => 'Техника';

  @override
  String get obFormClean => 'Чисто';

  @override
  String get obAvailable => 'Свободно';

  @override
  String get obTaken => 'Занято';

  @override
  String get obPlacementsBody =>
      'Пять дуэлей определят стартовый ранг. Пока ничего не идёт тебе в минус.';

  @override
  String get obFindFirstOpponent => 'Найти первого соперника';

  @override
  String get obGotIt => 'Понятно';

  @override
  String get obFormMixed => 'Неровно';

  @override
  String get justNow => 'Только что';

  @override
  String get counterAccuracy => 'Точность счётчика';

  @override
  String get counterAccuracyCaption => 'Насколько близко считает камера';

  @override
  String measuredOverSets(String count) {
    return 'Измерено по $count подходам';
  }

  @override
  String get accExact => 'Точно';

  @override
  String get accWithinOne => '±1 повтор';

  @override
  String get accAverageMiss => 'Средняя ошибка';

  @override
  String get accTendsTo => 'Склонность';

  @override
  String get accCountsHigh => 'считать больше';

  @override
  String get accCountsLow => 'считать меньше';

  @override
  String get accCountsEven => 'ни больше, ни меньше';

  @override
  String get accWorstMiss => 'Худшая ошибка';

  @override
  String get accNothingYet => 'Пока нечего измерять';

  @override
  String get accNothingYetBody =>
      'Каждый раз, когда ты подтверждаешь счёт после дуэли, подход сверяется с твоим числом. Результат появляется здесь.';

  @override
  String accNeedMore(String count) {
    return 'Ещё рано. Нужно примерно $count подходов, чтобы число что-то значило.';
  }

  @override
  String get accRecentSets => 'Последние подходы';

  @override
  String get accCameraSaid => 'Камера';

  @override
  String get accYouSaid => 'Ты';

  @override
  String get accHowItWorks =>
      'Всё это — от тебя и на этом телефоне. Никуда не отправляется.';

  @override
  String levelNumber(String n) {
    return 'Уровень $n';
  }

  @override
  String get youLostPlain => 'Поражение';

  @override
  String get rematch => 'Реванш';

  @override
  String get shareAction => 'Поделиться';

  @override
  String get doneAction => 'Готово';

  @override
  String get continueAction => 'Дальше';

  @override
  String get promotedLabel => 'Повышение';

  @override
  String get highestReached => 'Твой максимум';

  @override
  String repsOff(String n) {
    return 'Отставание $n повторов.';
  }

  @override
  String get closestYet => 'Самая близкая дуэль пока что.';

  @override
  String repsAhead(String n) {
    return 'Отрыв: $n повт.';
  }

  @override
  String get winnerLabel => 'Победитель';

  @override
  String get newPersonalBest => 'Новый личный рекорд';

  @override
  String get cantReachServer =>
      'Не удалось связаться с сервером. Проверьте подключение и попробуйте снова.';

  @override
  String pushUpsInSeconds(String seconds) {
    return 'Отжиманий за $seconds секунд';
  }

  @override
  String beatOpponent(String name, String score) {
    return 'Победа над $name $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return 'Поражение от $name $score';
  }

  @override
  String get thinkYouCanBeatMe => 'Думаешь, сможешь меня победить?';

  @override
  String get usernameNotAllowed =>
      'Это имя использовать нельзя. Попробуйте другое.';

  @override
  String get yourBest => 'Ваш рекорд';

  @override
  String get theClock => 'Таймер';

  @override
  String get nobodyFreeRaceBest =>
      'Сейчас нет свободных соперников вашего уровня. Посоревнуйтесь со своим рекордом. Этот раунд не влияет на ранг.';

  @override
  String get nobodyFreeFirstScore =>
      'Сейчас нет свободных соперников вашего уровня. Поставьте первый рекорд. Этот раунд не влияет на ранг.';

  @override
  String bestStillIs(String count) {
    return 'Ваш рекорд по-прежнему $count';
  }

  @override
  String get setInPoolTitle => 'Ваш подход в очереди';

  @override
  String get setInPoolBody =>
      'Следующий спортсмен вашего уровня посоревнуется с ним. Кто победил, вы увидите в уведомлениях, и тогда изменится ваш ранг.';

  @override
  String get obWhyNeededBody =>
      'Каждый повтор оценивается по тому, насколько опускаются и поднимаются плечи, и видит это только камера. Без неё нет счёта, а без счёта нет дуэли. Камера включена только во время подхода.';

  @override
  String get obWelcomeBack => 'С возвращением';

  @override
  String get obDuelTitle => 'Вы соревнуетесь с минутой живого человека';

  @override
  String get obDuelBody =>
      'Их подход записан по каждому повтору. Вы видите его вживую, пока делаете свой.';

  @override
  String obDuelWinBy(String count) {
    return 'Победа с отрывом в $count повт.';
  }

  @override
  String get obDuelLpRule =>
      'Очки ранга — это разница в повторах. Побеждайте с отрывом и растите быстрее.';

  @override
  String get obLadderTitle => 'Семь ступеней наверх';

  @override
  String get obLadderBody =>
      'Пять отборочных дуэлей определяют стартовую ступень. Побеждайте, чтобы расти; достигнутая ступень остаётся за вами.';

  @override
  String obTitlesHeading(String count) {
    return '$count титулов, которые можно получить';
  }

  @override
  String get obTitlesBody =>
      'За победы, серии, чистые подходы, ранние утра и многое другое. Носите один под своим именем.';

  @override
  String get obFriendsHeading => 'Выясните всё с друзьями';

  @override
  String get obFriendsBody =>
      'Друзья добавляют вас по этому коду. Вызывайте их когда угодно — счёт между вами сохраняется.';

  @override
  String get obLetsGo => 'Поехали';

  @override
  String get paywallTitle => 'Поднимись от Железа до Мастера';

  @override
  String get paywallPerkDuels => 'Дуэли под судейством камеры';

  @override
  String get paywallPerkLadder => 'Рейтинг в реальном времени';

  @override
  String get paywallPerkFriends => 'Друзья и вызовы';

  @override
  String get paywallPerkHistory => 'Каждое повторение каждого матча';

  @override
  String get paywallYearly => 'На год';

  @override
  String get paywallWeekly => 'На неделю';

  @override
  String paywallPerWeek(String price) {
    return '${price}/нед.';
  }

  @override
  String get paywallEveryWeek => 'в неделю';

  @override
  String paywallSave(String percent) {
    return 'Экономия ${percent}%';
  }

  @override
  String get paywallStart => 'Начать восхождение';

  @override
  String get paywallRenewsPlay => 'Продлевается автоматически, пока вы не отмените. Отменить можно в любой момент в Google Play.';

  @override
  String get paywallRenewsApple => 'Продлевается автоматически, пока вы не отмените. Отменить можно в любой момент в настройках аккаунта Apple.';

  @override
  String get paywallRestore => 'Восстановить';

  @override
  String get paywallTerms => 'Условия';

  @override
  String get paywallPrivacy => 'Конфиденциальность';

  @override
  String get paywallLoadFailed => 'Не удалось загрузить тарифы. Проверьте подключение и попробуйте снова.';

  @override
  String get paywallBuyFailed => 'Покупка не прошла. Попробуйте снова.';

  @override
  String get paywallPending => 'Платёж обрабатывается. Всё откроется, как только магазин его подтвердит.';

  @override
  String get paywallNothingToRestore => 'Подписка для восстановления не найдена.';

  @override
  String get paywallRestored => 'Подписка восстановлена';

  @override
  String paywallSignedInAs(String email) {
    return 'Вы вошли как ${email}';
  }

  @override
  String get deleteKeepsSubscription => 'Удаление аккаунта не отменяет подписку — её списывает магазин, а не outrepd. Сначала отмените её в Google Play или в настройках аккаунта Apple.';

  @override
  String get signOut => 'Выйти';

  @override
  String get signOutQuestion => 'Выйти из аккаунта?';

  @override
  String get signOutBody => 'Аккаунт останется как есть — с рангом, историей и подпиской. Войдите снова в любой момент по своей почте.';

  @override
  String get shareVictory => 'ПОБЕДА';

  @override
  String get shareRematch => 'РЕВАНШ?';

  @override
  String friendCodeInvite(String code) {
    return 'Вызови меня на дуэль в outrepd. Добавь меня по коду друга ${code}\nhttps://outrepd.com';
  }

  @override
  String get soundsLabel => 'Звуки';

  @override
  String get soundsHint => 'Сигнал на 3, 2, 1, щелчок на каждое повторение и конец раунда. Поверх вашей музыки.';

  @override
  String get phoneSection => 'На этом телефоне';

  @override
  String get allowNotifications => 'Разрешить уведомления';

  @override
  String get allowNotificationsHint => 'Они отключены для OUTREPD в настройках телефона, поэтому ничего из списка ниже до вас не дойдёт.';

  @override
  String get remindersSection => 'Напоминание';

  @override
  String get dailyReminder => 'Ежедневное напоминание';

  @override
  String get dailyReminderHint => 'Только в дни, когда вы ещё не тренировались.';

  @override
  String get reminderTime => 'Время';

  @override
  String get reminderTitle => 'Время сегодняшних отжиманий';

  @override
  String get reminderBody => 'Один быстрый подход засчитывается в вашу серию.';

  @override
  String reminderStreakBody(String count) {
    return 'Сохраните серию из ${count} дн. Достаточно одного подхода.';
  }

  @override
  String get channelMatches => 'Матчи и друзья';

  @override
  String get channelReminders => 'Ежедневное напоминание';

  @override
  String get liveTag => 'Вживую';

  @override
  String get reconnecting => 'Переподключение';

  @override
  String get rankedLive => 'Рейтинговый · вживую';

  @override
  String get lookingForLive => 'Ищем соперника вживую';

  @override
  String ofTime(String time) {
    return 'из ${time}';
  }

  @override
  String liveFallbackAt(String time) {
    return 'На ${time} вы будете соревноваться с сохранённым подходом';
  }

  @override
  String liveFoundBody(String name) {
    return '${name} сейчас перед камерой. Одни часы, один старт.';
  }

  @override
  String get nobodyLiveTitle => 'Сейчас никого нет вживую';

  @override
  String get nobodyLiveBody => 'Вы будете соревноваться с сохранённым подходом';

  @override
  String didRepsIn(String reps) {
    return 'Сделал(а) ${reps} за 60 секунд';
  }

  @override
  String get sameRankPoints => 'Столько же очков рейтинга, как вживую';

  @override
  String get raceIt => 'Соревноваться';

  @override
  String get sendASet => 'Отправить подход';

  @override
  String get onlineNow => 'Сейчас в сети';

  @override
  String get liveOrSetHint => 'Для игры вживую друг должен быть в сети. Подход подождёт, пока он его не пройдёт.';

  @override
  String get friendlyNoRank => 'Дружеский · без рейтинга';

  @override
  String waitingForName(String name) {
    return 'Ждём ${name}';
  }

  @override
  String get weSentThemANotice => 'Мы отправили уведомление';

  @override
  String get untilInviteRunsOut => 'до конца приглашения';

  @override
  String get cancelInvite => 'Отменить приглашение';

  @override
  String inviteDeclined(String name) {
    return '${name} ответил(а): не сейчас';
  }

  @override
  String get inviteRanOut => 'Приглашение истекло';

  @override
  String get inviteAgain => 'Пригласить снова';

  @override
  String liveInviteFrom(String name) {
    return '${name} ждёт вживую';
  }

  @override
  String timeLeft(String time) {
    return 'Осталось ${time}';
  }

  @override
  String get joinLive => 'Присоединиться';

  @override
  String get nLiveTitle => 'Приглашение вживую';

  @override
  String nLiveBody(String name) {
    return '${name} хочет сразиться вживую';
  }

  @override
  String get inviteGone => 'Это приглашение уже истекло';

  @override
  String opponentDropped(String name) {
    return 'У ${name} пропало соединение. Продолжайте: раунд закончится по времени.';
  }

  @override
  String opponentGaveUp(String name) {
    return '${name} сдался(ась). Закончите раунд, чтобы забрать победу.';
  }

  @override
  String get calledOffTitle => 'Матч отменён';

  @override
  String calledOffBody(String name) {
    return '${name} не занял(а) позицию вовремя. Ничего не записано.';
  }

  @override
  String waitingForFinal(String name) {
    return 'Ждём итоговый счёт ${name}…';
  }

  @override
  String get wantsToBeFriends => 'хочет дружить';

  @override
  String get giveUpQuestion => 'Сдаться в этом раунде?';

  @override
  String get giveUpBody => 'Это засчитается как поражение, каким бы ни был ваш счёт.';

  @override
  String waitingToJoin(String name) {
    return 'Ждём, пока ${name} присоединится';
  }

  @override
  String get removeFriend => 'Удалить из друзей';

  @override
  String get removeFriendBody => 'Ему не сообщат, и вы сможете снова добавить друг друга';

  @override
  String removeFriendQuestion(String username) {
    return 'Удалить ${username} из друзей?';
  }

  @override
  String get removeAction => 'Удалить';

  @override
  String removedFriend(String username) {
    return '${username} удалён из друзей';
  }

  @override
  String get noticeChallenged => 'Меня вызвали на реванш';

  @override
  String get noticeLiveInvite => 'Друг позвал меня на живой матч';

  @override
  String trialHeadline(String days) {
    return 'Первые ${days} дня — *бесплатно*';
  }

  @override
  String get trialToday => 'Сегодня';

  @override
  String get trialTodayBody => 'Все дуэли, живые и рейтинговые, открыты.';

  @override
  String trialDay(String day) {
    return 'День ${day}';
  }

  @override
  String get trialReminderBody => 'Напомним за день до конца пробного периода.';

  @override
  String get trialEndBody => 'Подписка начинается. Отмените раньше — и ничего не заплатите.';

  @override
  String trialTag(String days) {
    return '${days} дня бесплатно';
  }

  @override
  String trialCta(String days) {
    return 'Начать бесплатный период на ${days} дня';
  }

  @override
  String trialThenYearly(String price) {
    return 'Сейчас без оплаты · затем ${price}/год';
  }

  @override
  String trialThenWeekly(String price) {
    return 'Сейчас без оплаты · затем ${price}/нед.';
  }

  @override
  String get trialEndsTitle => 'Пробный период заканчивается завтра';

  @override
  String get trialEndsBody => 'Продолжайте подниматься или отмените заранее в настройках подписки.';
}
