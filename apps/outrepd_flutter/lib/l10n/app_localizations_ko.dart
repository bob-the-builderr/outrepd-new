// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class LKo extends L {
  LKo([String locale = 'ko']) : super(locale);

  @override
  String get tabFriends => '친구';

  @override
  String get tabRanks => '랭크';

  @override
  String get tabMatch => '대결';

  @override
  String get tabProfile => '프로필';

  @override
  String get challengeFriend => '친구에게 도전';

  @override
  String get matchHistory => '대결 기록';

  @override
  String get allMatches => '전체 대결';

  @override
  String get wins => '승';

  @override
  String get losses => '패';

  @override
  String get winRate => '승률';

  @override
  String get streak => '연속 기록';

  @override
  String get settings => '설정';

  @override
  String get accountSection => '계정';

  @override
  String get duelSection => '대결';

  @override
  String get hapticsEachRep => '렙마다 진동';

  @override
  String get showSkeleton => '스켈레톤 표시';

  @override
  String get showSkeletonHint => '카메라가 인식 중인지 알 수 있습니다';

  @override
  String get manageNotifications => '알림 관리';

  @override
  String switchesOn(String on, String all) {
    return '$all개 중 $on개 켜짐';
  }

  @override
  String get whoCanChallenge => '누가 나에게 도전할 수 있는지';

  @override
  String get blockedAccounts => '차단한 계정';

  @override
  String get reportProblem => '문제 신고';

  @override
  String get onDeviceNote => '자세 인식은 이 휴대폰에서 실행됩니다. 영상이나 자세 데이터는 업로드되지 않습니다.';

  @override
  String get visibilitySection => '공개 범위';

  @override
  String get showMyCountry => '내 국가 표시';

  @override
  String get showMyCountryHint => '끄면 국가 순위표에서 빠집니다';

  @override
  String get safetySection => '안전';

  @override
  String get socialSection => '소셜';

  @override
  String get noticeRaced => '누군가 내 세트에 도전함';

  @override
  String get noticeRacedHint => '대결이 있었는지 알 수 있는 유일한 방법';

  @override
  String get noticeFriendOk => '보낸 요청이 수락됨';

  @override
  String get noticesStoredNote => '끄면 저장 자체가 되지 않습니다. 숨기는 것이 아닙니다.';

  @override
  String get notSaved => '저장되지 않았습니다';

  @override
  String get blockedIntro => '차단한 계정은 도전도, 검색도, 요청도 할 수 없습니다. 상대는 알 수 없습니다.';

  @override
  String blockedWhen(String when) {
    return '$when 차단함';
  }

  @override
  String get unblock => '차단 해제';

  @override
  String get noBlockedTitle => '차단한 사람 없음';

  @override
  String get noBlockedBody => '프로필이나 신고 화면에서 차단할 수 있습니다.';

  @override
  String get whatHappened => '무슨 일이 있었나요';

  @override
  String get reasonCheating => '부정 행위 또는 가짜 렙';

  @override
  String get reasonHarassment => '괴롭힘 또는 폭언';

  @override
  String get reasonContent => '부적절한 콘텐츠';

  @override
  String get reasonImpersonation => '사칭';

  @override
  String get reasonOther => '기타';

  @override
  String get addDetails => '상세 내용 (선택)';

  @override
  String get alsoBlock => '이 계정도 차단';

  @override
  String get sendReport => '신고 보내기';

  @override
  String get reportSent => '신고를 보냈습니다';

  @override
  String get reportingThisAccount => '이 계정을 신고합니다';

  @override
  String get exportIntro =>
      '서버가 보관 중인 회원님의 모든 정보를 파일로 이메일에 보내드립니다. 보통 1분 정도 걸립니다.';

  @override
  String get whatsIncluded => '포함되는 항목';

  @override
  String get incProfile => '프로필과 등급';

  @override
  String get incSets => '모든 세트와 렙 수';

  @override
  String get incDuels => '대결 기록과 LP 변화';

  @override
  String get incFriends => '친구와 차단한 계정';

  @override
  String get incNotices => '받은 알림';

  @override
  String get noLandmarksNote =>
      '자세 랜드마크는 포함되어 있지 않으며, 애초에 없습니다. 카메라가 휴대폰에서 읽고 어디로도 전송되지 않습니다.';

  @override
  String get sendItTo => '받을 주소';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get createAccountTitle => '계정 만들기';

  @override
  String get createAccountBody =>
      '이메일과 비밀번호를 추가해서 이 계정이 휴대폰 하나에만 의존하지 않도록 하세요.';

  @override
  String get createAccountAction => '계정 만들기';

  @override
  String get emailTakenSwitchToSignIn => '이 이메일은 이미 계정이 있습니다 — 대신 로그인하세요.';

  @override
  String get emailSignUpInvalid => '이메일과 비밀번호를 확인하세요 — 최소 6자.';

  @override
  String get tooManyCodes => '코드를 너무 많이 보냈습니다 — 몇 분 후 다시 시도하세요.';

  @override
  String get sendCodeAction => '코드 보내기';

  @override
  String get noAccountForEmail => '해당 이메일로 된 계정을 찾을 수 없어요.';

  @override
  String get authEntryTagline => '푸시업하고, 겨루고, 랭크를 올려라.';

  @override
  String get signUpWithEmail => '이메일로 가입하기';

  @override
  String get alreadyHaveAccountQuestion => '이미 계정이 있으신가요?';

  @override
  String get logInAction => '로그인';

  @override
  String get createYourAccountTitle => '계정 만들기';

  @override
  String get createAccountSubtitle => '1분도 안 걸려요.';

  @override
  String get usernameLabel => '사용자 이름';

  @override
  String get emailLabel => '이메일';

  @override
  String get logInSubtitle => '랭크를 유지하려면 로그인하세요.';

  @override
  String get checkYourEmailTitle => '이메일을 확인하세요';

  @override
  String codeSentTo(String email) {
    return '$email로 6자리 코드를 보냈습니다.';
  }

  @override
  String get didntGetIt => '받지 못하셨나요?';

  @override
  String resendInSeconds(String time) {
    return '$time 후 재전송';
  }

  @override
  String get wrongEmailGoBack => '이메일이 잘못됐나요? 뒤로 가기';

  @override
  String get usernameTaken => '이미 사용 중인 사용자 이름입니다.';

  @override
  String get wrongCode => '코드가 틀리거나 만료되었습니다.';

  @override
  String get resendCode => '코드 다시 보내기';

  @override
  String get codeResent => '새 코드를 보냈습니다.';

  @override
  String signedInAs(String email) {
    return '$email(으)로 로그인됨';
  }

  @override
  String get addressNotKept => '주소는 한 번만 사용되고 저장되지 않습니다. 이 계정에는 이메일이 없습니다.';

  @override
  String get requestMyData => '내 데이터 메일로 받기';

  @override
  String exportSent(String address) {
    return '$address 로 보냈습니다';
  }

  @override
  String get deleteIntro => '모든 것이 영구적으로 삭제됩니다. 되돌리거나 복구할 수 없습니다.';

  @override
  String get rankLabel => '등급';

  @override
  String get wantCopyFirst => '먼저 사본이 필요하신가요?';

  @override
  String get wantCopyBody => '삭제하기 전에 데이터를 받아두세요. 이후에는 사라집니다.';

  @override
  String typeToConfirm(String word) {
    return '확인하려면 $word 를 입력하세요';
  }

  @override
  String get deleteWord => '삭제';

  @override
  String get deletePermanently => '영구 삭제';

  @override
  String get keepMyAccount => '계정 유지';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get skip => '건너뛰기';

  @override
  String get yourPicture => '내 사진';

  @override
  String get yourPictureHint => '테두리는 랭크에 따라 정해지고, 올라갈 때마다 바뀝니다.';

  @override
  String get couldNotUsePicture => '그 사진을 사용할 수 없습니다';

  @override
  String get couldNotSyncAvatar => '사진은 저장됐지만 아직 동기화되지 않았어요';

  @override
  String get couldNotShareCard => '이 카드를 공유할 수 없었어요';

  @override
  String get couldNotOpenLink => '이 링크를 열 수 없었어요';

  @override
  String get couldNotCheckUsername => '그 이름을 확인할 수 없었어요 — 다시 시도해 주세요';

  @override
  String get changeUsername => '사용자 이름 변경';

  @override
  String get usernameInvalidLength => '4자에서 20자 사이의 영문자, 숫자, _만 사용할 수 있습니다';

  @override
  String get usernameChanged => '사용자 이름이 변경되었습니다';

  @override
  String get usernameAlreadyChangedBody =>
      '이미 단 한 번뿐인 사용자 이름 변경을 사용하셨습니다 — 모든 계정은 정확히 한 번만 변경할 수 있습니다.';

  @override
  String get gallery => '갤러리';

  @override
  String get camera => '카메라';

  @override
  String get awards => '업적';

  @override
  String get yourTitles => '보유한 칭호';

  @override
  String get stillToEarn => '아직 얻지 못한 칭호';

  @override
  String get noTitlesYet => '아직 없습니다. 첫 칭호는 대결 한 번이면 됩니다.';

  @override
  String get wearHint => '눌러서 착용하세요. 사람들이 당신을 보는 모든 곳에서 이름 옆에 표시됩니다.';

  @override
  String get worn => '착용 중';

  @override
  String get titleUnlocked => '칭호 획득';

  @override
  String get wearIt => '착용하기';

  @override
  String get wearItLater => '나중에';

  @override
  String get dayStreak => '일 연속';

  @override
  String get bestEver => '최고 기록';

  @override
  String get restDaysLeft => '남은 휴식일';

  @override
  String get restIsTraining => '휴식도 훈련입니다. 일주일에 이틀 쉬어도 연속 기록은 끊기지 않습니다.';

  @override
  String get global => '글로벌';

  @override
  String get topPlayers => '톱 플레이어';

  @override
  String get yourTier => '내 티어';

  @override
  String get challenge => '도전';

  @override
  String get notifications => '알림';

  @override
  String get start => '시작';

  @override
  String get finish => '종료';

  @override
  String get reps => '회';

  @override
  String get howManyReally => '실제로 몇 개 했나요?';

  @override
  String get howManyReallyHint =>
      '앱이 아니라 본인이 센 숫자입니다. 나중에 카운터 정확도를 재는 기준이 됩니다.';

  @override
  String get appearance => '화면';

  @override
  String get theme => '테마';

  @override
  String get language => '언어';

  @override
  String get privacy => '개인정보';

  @override
  String get data => '데이터';

  @override
  String get about => '앱 정보';

  @override
  String get themeSystem => '기기 설정 따르기';

  @override
  String get themeLight => '밝게';

  @override
  String get themeDark => '어둡게';

  @override
  String get accept => '수락';

  @override
  String get visEveryone => '모두';

  @override
  String get visFriends => '친구만';

  @override
  String get visNobody => '아무도';

  @override
  String get friendRequestsLabel => '친구 요청';

  @override
  String get showOnLeaderboards => '리더보드에 표시';

  @override
  String get exportData => '내 데이터 내보내기';

  @override
  String get version => '버전';

  @override
  String get rateApp => 'OUTREPD 평가하기';

  @override
  String get contactSupport => '고객지원 문의';

  @override
  String get termsOfService => '이용약관';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get openSourceLicences => '오픈소스 라이선스';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get needsServer => '연결할 수 없습니다. 인터넷 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get roomFriendly => '룸 대결은 친선전입니다. 랭크에는 반영되지 않습니다.';

  @override
  String get shareThisCode => '이 코드를 공유하세요';

  @override
  String get codeCopied => '코드를 복사했습니다';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => '아이언';

  @override
  String get tierBronze => '브론즈';

  @override
  String get tierSilver => '실버';

  @override
  String get tierGold => '골드';

  @override
  String get tierPlatinum => '플래티넘';

  @override
  String get tierDiamond => '다이아몬드';

  @override
  String get tierMaster => '마스터';

  @override
  String winLoss(String w, String l) {
    return '$w승 $l패';
  }

  @override
  String get continueLabel => '계속';

  @override
  String get ttl_first_blood => '첫 승부';

  @override
  String get tdesc_first_blood => '첫 대결을 마치세요';

  @override
  String get ttl_found_footing => '자리를 잡다';

  @override
  String get tdesc_found_footing => '대결 5회를 마치세요';

  @override
  String get ttl_regular => '단골';

  @override
  String get tdesc_regular => '대결 20회';

  @override
  String get ttl_fifty => '오십 고지';

  @override
  String get tdesc_fifty => '대결 50회';

  @override
  String get ttl_century => '센추리';

  @override
  String get tdesc_century => '대결 100회';

  @override
  String get ttl_veteran => '베테랑';

  @override
  String get tdesc_veteran => '대결 250회';

  @override
  String get ttl_thousand_matches => '고참';

  @override
  String get tdesc_thousand_matches => '대결 1000회';

  @override
  String get ttl_first_win => '위너';

  @override
  String get tdesc_first_win => '대결에서 이기세요';

  @override
  String get ttl_on_a_roll => '상승세';

  @override
  String get tdesc_on_a_roll => '3연승하세요';

  @override
  String get ttl_five_straight => '5연승';

  @override
  String get tdesc_five_straight => '5연승하세요';

  @override
  String get ttl_unstoppable => '멈출 수 없다';

  @override
  String get tdesc_unstoppable => '10연승하세요';

  @override
  String get ttl_untouchable => '건드릴 수 없다';

  @override
  String get tdesc_untouchable => '20연승하세요';

  @override
  String get ttl_giant_slayer => '자이언트 킬러';

  @override
  String get tdesc_giant_slayer => '두 랭크 위 상대를 이기세요';

  @override
  String get ttl_comeback => '역전';

  @override
  String get tdesc_comeback => '3연패 직후에 이기세요';

  @override
  String get ttl_nemesis => '숙적';

  @override
  String get tdesc_nemesis => '같은 상대를 다섯 번 이기세요';

  @override
  String get ttl_hundred_reps => '출발';

  @override
  String get tdesc_hundred_reps => '카운트된 100회';

  @override
  String get ttl_five_hundred => '몸이 풀렸다';

  @override
  String get tdesc_five_hundred => '카운트된 500회';

  @override
  String get ttl_the_machine => '머신';

  @override
  String get tdesc_the_machine => '카운트된 1000회';

  @override
  String get ttl_five_thousand => '가차 없다';

  @override
  String get tdesc_five_thousand => '카운트된 5000회';

  @override
  String get ttl_ten_thousand => '일만 회';

  @override
  String get tdesc_ten_thousand => '카운트된 10000회';

  @override
  String get ttl_fifty_thousand => '셀 수 없음';

  @override
  String get tdesc_fifty_thousand => '카운트된 50000회';

  @override
  String get ttl_first_tonne => '1톤';

  @override
  String get tdesc_first_tonne => '총 1000kg을 들어 올리세요';

  @override
  String get ttl_ten_tonnes => '10톤';

  @override
  String get tdesc_ten_tonnes => '총 10000kg을 들어 올리세요';

  @override
  String get ttl_six_figures => '여섯 자리';

  @override
  String get tdesc_six_figures => '총 10만kg을 들어 올리세요';

  @override
  String get ttl_half_million => '50만';

  @override
  String get tdesc_half_million => '총 50만kg을 들어 올리세요';

  @override
  String get ttl_million_kg => '백만 킬로 클럽';

  @override
  String get tdesc_million_kg => '총 100만kg을 들어 올리세요';

  @override
  String get ttl_two_days => '다시 왔다';

  @override
  String get tdesc_two_days => '이틀 연속 훈련하세요';

  @override
  String get ttl_no_days_off => '쉬는 날 없음';

  @override
  String get tdesc_no_days_off => '7일 연속 훈련하세요';

  @override
  String get ttl_fortnight => '두 주';

  @override
  String get tdesc_fortnight => '14일 연속 기록';

  @override
  String get ttl_unbroken => '끊이지 않음';

  @override
  String get tdesc_unbroken => '30일 연속 기록';

  @override
  String get ttl_sixty_days => '습관';

  @override
  String get tdesc_sixty_days => '60일 연속 기록';

  @override
  String get ttl_hundred_days => '백일';

  @override
  String get tdesc_hundred_days => '100일 연속 기록';

  @override
  String get ttl_year_round => '일 년 내내';

  @override
  String get tdesc_year_round => '365일 연속 기록';

  @override
  String get ttl_perfect_week => '완벽한 한 주';

  @override
  String get tdesc_perfect_week => '한 주 내내 매일 훈련하세요';

  @override
  String get ttl_perfect_month => '완벽한 한 달';

  @override
  String get tdesc_perfect_month => '완벽한 한 주 4회';

  @override
  String get ttl_bronze_tier => '아이언에서 벗어나다';

  @override
  String get tdesc_bronze_tier => '브론즈 도달';

  @override
  String get ttl_silver_tier => '은빛';

  @override
  String get tdesc_silver_tier => '실버 도달';

  @override
  String get ttl_golden_era => '황금기';

  @override
  String get tdesc_golden_era => '골드 도달';

  @override
  String get ttl_platinum_tier => '플래티넘';

  @override
  String get tdesc_platinum_tier => '플래티넘 도달';

  @override
  String get ttl_diamond_tier => '다이아몬드 핸드';

  @override
  String get tdesc_diamond_tier => '다이아몬드 도달';

  @override
  String get ttl_master_tier => '마스터';

  @override
  String get tdesc_master_tier => '마스터 도달';

  @override
  String get ttl_clean_hands => '깨끗한 손';

  @override
  String get tdesc_clean_hands => '모든 횟수가 인정된 한 세트';

  @override
  String get ttl_spotless => '티 없음';

  @override
  String get tdesc_spotless => '깨끗한 세트 10회';

  @override
  String get ttl_textbook => '교과서';

  @override
  String get tdesc_textbook => '깨끗한 세트 50회';

  @override
  String get ttl_all_rounder => '만능';

  @override
  String get tdesc_all_rounder => '다른 운동 5종을 카운트하세요';

  @override
  String get ttl_explorer => '탐험가';

  @override
  String get tdesc_explorer => '다른 운동 15종을 카운트하세요';

  @override
  String get ttl_encyclopedia => '백과사전';

  @override
  String get tdesc_encyclopedia => '다른 운동 40종을 카운트하세요';

  @override
  String get ttl_early_bird => '아침 근무';

  @override
  String get tdesc_early_bird => '오전 7시 이전 10세션';

  @override
  String get ttl_sunrise_club => '일출 클럽';

  @override
  String get tdesc_sunrise_club => '오전 7시 이전 50세션';

  @override
  String get ttl_night_owl => '야간 근무';

  @override
  String get tdesc_night_owl => '밤 10시 이후 10세션';

  @override
  String get ttl_graveyard => '새벽 근무';

  @override
  String get tdesc_graveyard => '밤 10시 이후 50세션';

  @override
  String get ttl_not_alone => '혼자가 아니다';

  @override
  String get tdesc_not_alone => '첫 친구를 추가하세요';

  @override
  String get ttl_well_connected => '넓은 인맥';

  @override
  String get tdesc_well_connected => '친구 10명';

  @override
  String get ttl_the_gym_knows => '헬스장이 당신을 안다';

  @override
  String get tdesc_the_gym_knows => '친구 50명';

  @override
  String get forfeitQ => '대결을 기권할까요?';

  @override
  String get forfeitBody => '지금 나가면 LP를 잃습니다.';

  @override
  String get stay => '남기';

  @override
  String get forfeit => '기권';

  @override
  String get getReady => '준비';

  @override
  String get you => '나';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => '홈으로';

  @override
  String get mgChest => '가슴';

  @override
  String get nWonTitle => '승리했습니다!';

  @override
  String nWonBody(String name, String muscle) {
    return '$muscle 데이에 $name을(를) 이겼습니다';
  }

  @override
  String get nFriendTitle => '새 친구 요청';

  @override
  String get nRacedTitle => '당신의 세트에 도전이 있었습니다';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name 님이 당신의 세트에 도전했지만 못 미쳤습니다, $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name 님이 당신의 세트에 도전해 이겼습니다, $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => '친구 요청이 수락되었습니다';

  @override
  String nFriendOkBody(String name) {
    return '$name 님이 요청을 수락했습니다';
  }

  @override
  String nFriendBody(String name) {
    return '$name님이 친구를 맺고 싶어 합니다';
  }

  @override
  String get nChallengedTitle => '재대결';

  @override
  String nChallengedBody(String name) {
    return '$name님이 재대결을 원합니다';
  }

  @override
  String get challengeSentTitle => '도전을 보냈습니다';

  @override
  String challengeSentBody(String name) {
    return '$name님에게 알려드릴게요. 상대가 도전하면 다시 확인하세요.';
  }

  @override
  String get challengeNotSentTitle => '보내지 못했습니다';

  @override
  String get challengeNotSentBody => '연결 상태를 확인하고 매치 탭에서 다시 시도하세요.';

  @override
  String get challengeGoneTitle => '도전이 사라졌습니다';

  @override
  String get challengeGoneBody => '이미 진행되었거나 철회되었습니다.';

  @override
  String repsRecordedLine(String reps) {
    return '$reps회 기록됨';
  }

  @override
  String get nAchTitle => '업적 해금';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => '랭크 상승!';

  @override
  String nRankBody(String rank) {
    return '$rank에 도달했습니다';
  }

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String daysAgo(String n) {
    return '$n일 전';
  }

  @override
  String weeksAgo(String n) {
    return '$n주 전';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get lpUnit => 'LP';

  @override
  String get trueCountHint => '예: 12';

  @override
  String get couldNotSaveSession => '세션을 저장할 수 없습니다';

  @override
  String lpOutOf(String total) {
    return '/ $total LP';
  }

  @override
  String get noFriendsTitle => '아직 친구가 없습니다';

  @override
  String get noFriendsBody => '아는 사람과의 대결은 느낌이 다릅니다.';

  @override
  String get decline => '거절';

  @override
  String requestSent(String name) {
    return '$name 님에게 요청을 보냈습니다';
  }

  @override
  String nowFriends(String name) {
    return '이제 $name 님과 친구입니다';
  }

  @override
  String get noOneFound => '그런 이름을 쓰는 사람이 없습니다';

  @override
  String get noMatchesTitle => '아직 대결이 없습니다';

  @override
  String get noMatchesBody => '첫 대결은 이기든 지든 여기에 남습니다.';

  @override
  String get noNotificationsTitle => '새 소식이 없습니다';

  @override
  String get noNotificationsBody => '대결 초대와 결과, 친구 요청이 여기로 옵니다.';

  @override
  String get countedThat => '이번 라운드 횟수';

  @override
  String get thatIsRight => '맞습니다';

  @override
  String get useMyCount => '내 횟수 사용';

  @override
  String get confirmHint => '카메라가 틀렸다면 고치세요.';

  @override
  String get unsureMovement => '올바른 동작인지 확신할 수 없습니다. 숫자를 확인하세요.';

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
  String get searchByUsername => '사용자 이름으로 검색';

  @override
  String get incomingRequests => '받은 요청';

  @override
  String get noRequestsWaiting => '지금은 대기 중인 요청이 없어요';

  @override
  String get addFriendAction => '친구 추가';

  @override
  String get addFriendHint => '상대방의 사용자 이름이나 프로필의 #코드를 입력하세요.';

  @override
  String get usernameOrCode => '사용자 이름 또는 #코드';

  @override
  String get sendRequest => '요청 보내기';

  @override
  String onlineNowCount(String count) {
    return '접속 중 · $count';
  }

  @override
  String offlineCount(String count) {
    return '오프라인 · $count';
  }

  @override
  String get invite => '초대';

  @override
  String get headToHeadTitle => '상대 전적';

  @override
  String get vsYouCaption => '당신과의 전적';

  @override
  String get h2hYou => '나';

  @override
  String get h2hThem => '상대';

  @override
  String headToHead(String wins, String losses) {
    return '당신에게 $wins승 $losses패';
  }

  @override
  String get neverPlayedYou => '아직 겨룬 적 없음';

  @override
  String noHistoryWithThem(String username) {
    return '아직 $username님과 겨루지 않았습니다.';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return '지난번: $yourReps–$theirReps, $when.';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return '상대에 대한 당신의 최고 기록은 $reps입니다.';
  }

  @override
  String get viewFullProfile => '전체 프로필 보기';

  @override
  String get moreOptions => '더 보기';

  @override
  String get block => '차단';

  @override
  String get blockRowBody => '도전도, 프로필 열람도 할 수 없게 됩니다';

  @override
  String get report => '신고';

  @override
  String get reportRowBody => '24시간 이내에 검토됩니다';

  @override
  String muteChallenges(String username) {
    return '$username의 도전 알림 끄기';
  }

  @override
  String blockedLifter(String username) {
    return '$username님을 차단했습니다';
  }

  @override
  String mutedLifter(String username) {
    return '$username님을 음소거했습니다';
  }

  @override
  String get addFriendButton => '친구 추가';

  @override
  String get alreadyFriends => '친구';

  @override
  String get couldNotLoadProfile => '프로필을 불러올 수 없습니다';

  @override
  String get noFriendsMatch => '그런 이름은 없습니다';

  @override
  String get yourClimb => '당신의 등반';

  @override
  String floorKept(String tier, String rank) {
    return '$tier은(는) 당신의 것입니다. $rank 아래로 떨어지지 않습니다.';
  }

  @override
  String dayStreakCount(String count) {
    return '$count일 연속';
  }

  @override
  String get findMatch => '대전 찾기';

  @override
  String rankedTerms(String seconds) {
    return '$seconds초 · 랭크전';
  }

  @override
  String get practiceTerms => '연습 — 랭크 없음, 상대 없음';

  @override
  String get practiceComplete => '연습 완료';

  @override
  String get noRankYet => '아직 랭크 없음';

  @override
  String placementsForFirstTier(String count) {
    return '첫 랭크를 얻으려면 배치 대결 $count판을 끝내세요.';
  }

  @override
  String get startPlacements => '배치 시작';

  @override
  String get unranked => '랭크 없음';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$total판 중 $done판 · 판당 $seconds초';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$total판 중 $done판 · 랭크까지 $left판';
  }

  @override
  String placementsForTier(String count) {
    return '내 랭크를 알아보려면 배치 대결 $count판을 끝내세요.';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '배치 $total판 중 $done판 완료';
  }

  @override
  String get practiceFirst => '먼저 연습';

  @override
  String get nextPlacement => '다음 배치';

  @override
  String get noConnection => '연결 없음';

  @override
  String get practiceOffline => '오프라인 연습';

  @override
  String get retry => '다시 시도';

  @override
  String get youWonPlain => '승리';

  @override
  String get cameraNeededTitle => '카메라 권한이 필요해요';

  @override
  String get cameraNeededBody =>
      'outrepd는 몸의 움직임을 보고 횟수를 셉니다. 분석은 기기에서 이뤄지며 아무것도 업로드되지 않습니다.';

  @override
  String get openSettings => '설정 열기';

  @override
  String get allowCamera => '카메라 허용';

  @override
  String get notNow => '나중에';

  @override
  String get noCameraTitle => '카메라가 없어요';

  @override
  String get noCameraBody =>
      '횟수는 카메라로 세기 때문에 이 기기로는 대결을 채점할 수 없습니다. 나머지는 그대로 작동합니다.';

  @override
  String get noConnectionBody =>
      '대결하려면 연결이 필요해요. 연습은 오프라인에서도 도에 기록은 나중에 동기화됩니다.';

  @override
  String get getBackInFrame => '화면 안으로 돌아오세요';

  @override
  String get clockStillRunning => '시계는 계속 가고 있어요. 카운트는 멈췄습니다.';

  @override
  String get giveUp => '포기';

  @override
  String get lpMovesWithGap => 'LP는 렙 차이만큼 움직여요 — 더 크게 이기면 더 많이 얻어요';

  @override
  String get searchingForOpponent => '상대를 찾는 중';

  @override
  String get getIntoPosition => '자세를 잡으세요';

  @override
  String get framingHint => '손목과 발목이 화면에 들어와야 해요';

  @override
  String get goUp => '올리세요';

  @override
  String get goDown => '내리세요';

  @override
  String get bestSet => '최고 세트';

  @override
  String get record => '전적';

  @override
  String get last7Days => '최근 7일';

  @override
  String repsCount(String count) {
    return '$count회';
  }

  @override
  String get viewAll => '전체 보기';

  @override
  String get shareProfile => '프로필 공유';

  @override
  String get share => '공유';

  @override
  String get duelMeOnOutrepd => 'outrepd에서 나와 붙자';

  @override
  String get shareStory => '스토리';

  @override
  String get sharePost => '포스트';

  @override
  String get copyLink => '복사';

  @override
  String get linkCopied => '링크 복사됨';

  @override
  String get currentRankLabel => '현재 랭크';

  @override
  String get winInitial => '승';

  @override
  String get lossInitial => '패';

  @override
  String get dayInitial => '일';

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline => '푸시업 대결. 폰이 센다. 다른 누군가도 세고 있다.';

  @override
  String get obGetStarted => '시작하기';

  @override
  String get obHaveAccount => '이미 계정이 있어요';

  @override
  String get obTwoThings => '빠르게 두 가지만.';

  @override
  String get obAgeQuestion => '나이가 어떻게 되나요?';

  @override
  String get obUnder16 => '16세 미만';

  @override
  String get obOver16 => '16세 이상';

  @override
  String get obHealthConsent =>
      'outrepd는 횟수만 세고 의학적·운동 조언은 하지 않는다는 것을 이해합니다. 아프면 멈추겠습니다.';

  @override
  String get obTermsIntro => '계속하면 다음에 동의하는 것으로 봅니다:';

  @override
  String get obTerms => '이용약관';

  @override
  String get obAnd => '및';

  @override
  String get obPrivacy => '개인정보 처리방침';

  @override
  String get obUnder16Blocked =>
      'outrepd는 16세 이상을 위한 앱입니다. 그때 다시 오세요 — 푸시업은 어디 안 갑니다.';

  @override
  String get obCameraTitle => 'outrepd에는 카메라가 필요합니다';

  @override
  String get obCameraBody => '몸의 움직임을 보고 셉니다. 다른 방법은 없습니다.';

  @override
  String get obCameraPrivateTitle => '폰 밖으로 나가는 건 없습니다';

  @override
  String get obCameraPrivateBody =>
      '몸 인식은 이 기기 안에서만 이루어져요. 영상은 저장되거나 업로드되지 않아요.';

  @override
  String get obWhyNeeded => '왜 필요한가요?';

  @override
  String get obPlacementTitle => '폰을 바닥에 두세요';

  @override
  String get obPlacementBody => '약 1미터 앞 벽에 기대 놓으세요.';

  @override
  String get obOneMetre => '약 1m';

  @override
  String get obFullBody => '전신이 화면에';

  @override
  String get obCheckHandsFeet => '손과 발이 모두 보이기';

  @override
  String get obCheckFacing => '옆이 아니라 폰을 향하기';

  @override
  String get obCheckLight => '방 불 켜기';

  @override
  String get obImSetUp => '준비됐어요';

  @override
  String get obFramingTitle => '푸시업 자세를 잡으세요';

  @override
  String get obFramingShoulders => '어깨와 엉덩이';

  @override
  String get obFramingWrists => '손목';

  @override
  String get obFramingAnkles => '발목';

  @override
  String get obLooksGood => '좋습니다';

  @override
  String get obCalibrating => '보정 중';

  @override
  String get obOneMoreRep => '가동 범위를 알기 위해 한 개만 더';

  @override
  String get obCalibrationHint => '평소 깊이로 세 개만 해 보세요';

  @override
  String get obCalibrated => '보정 완료.';

  @override
  String get obCalibratedBody =>
      '이제 outrepd가 당신의 가동 범위를 압니다. 깊이는 고정된 수치가 아니라 당신을 기준으로 측정됩니다.';

  @override
  String get obRepsCounted => '센 횟수';

  @override
  String get obAverageDepth => '평균 깊이';

  @override
  String get obForm => '자세';

  @override
  String get obFormClean => '깔끔함';

  @override
  String get obAvailable => '사용 가능';

  @override
  String get obTaken => '이미 사용 중';

  @override
  String get obGotIt => '알겠어요';

  @override
  String get obFormMixed => '들쭉날쭉';

  @override
  String get justNow => '방금';

  @override
  String get counterAccuracy => '카운터 정확도';

  @override
  String get counterAccuracyCaption => '카메라가 얼마나 맞히는지';

  @override
  String measuredOverSets(String count) {
    return '$count세트로 측정';
  }

  @override
  String get accExact => '정확';

  @override
  String get accWithinOne => '±1개';

  @override
  String get accAverageMiss => '평균 오차';

  @override
  String get accTendsTo => '경향';

  @override
  String get accCountsHigh => '많이 셈';

  @override
  String get accCountsLow => '적게 셈';

  @override
  String get accCountsEven => '어느 쪽도 아님';

  @override
  String get accWorstMiss => '최대 오차';

  @override
  String get accNothingYet => '아직 측정된 것이 없습니다';

  @override
  String get accNothingYetBody =>
      '대결이 끝나고 횟수를 확인할 때마다, 그 세트가 당신이 말한 숫자와 비교됩니다. 결과가 여기에 나옵니다.';

  @override
  String accNeedMore(String count) {
    return '아직 초반입니다. 이 숫자가 의미를 가지려면 $count세트쯤 더 필요합니다.';
  }

  @override
  String get accRecentSets => '최근 세트';

  @override
  String get accCameraSaid => '카메라';

  @override
  String get accYouSaid => '나';

  @override
  String get accHowItWorks => '모두 이 폰에서, 당신에게서 나온 것입니다. 어디에도 전송되지 않습니다.';

  @override
  String levelNumber(String n) {
    return '레벨 $n';
  }

  @override
  String get youLostPlain => '패배';

  @override
  String get rematch => '재대결';

  @override
  String get shareAction => '공유';

  @override
  String get doneAction => '완료';

  @override
  String get continueAction => '계속';

  @override
  String get promotedLabel => '승급';

  @override
  String get highestReached => '지금까지의 최고 기록';

  @override
  String repsOff(String n) {
    return '$n개 차이.';
  }

  @override
  String get closestYet => '지금까지 가장 근소한 대결.';

  @override
  String repsAhead(String n) {
    return '$n회 차이로 승리.';
  }

  @override
  String get winnerLabel => '승자';

  @override
  String get newPersonalBest => '개인 최고 기록 경신';

  @override
  String get cantReachServer => '서버에 연결할 수 없습니다. 연결을 확인하고 다시 시도하세요.';

  @override
  String pushUpsInSeconds(String seconds) {
    return '$seconds초 동안 푸시업';
  }

  @override
  String beatOpponent(String name, String score) {
    return '$name 상대로 승리 $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return '$name에게 패배 $score';
  }

  @override
  String get thinkYouCanBeatMe => '나를 이길 수 있을까?';

  @override
  String get usernameNotAllowed => '사용할 수 없는 이름이에요. 다른 이름을 입력하세요.';

  @override
  String get yourBest => '내 최고 기록';

  @override
  String get theClock => '시계';

  @override
  String get nobodyFreeRaceBest =>
      '지금은 비슷한 랭크의 상대가 없어요. 내 최고 기록과 겨뤄 보세요. 이번 판은 랭크에 반영되지 않아요.';

  @override
  String get nobodyFreeFirstScore =>
      '지금은 비슷한 랭크의 상대가 없어요. 첫 기록을 세워 보세요. 이번 판은 랭크에 반영되지 않아요.';

  @override
  String bestStillIs(String count) {
    return '최고 기록은 그대로 $count개';
  }

  @override
  String get setInPoolTitle => '내 세트가 대기열에 올라갔어요';

  @override
  String get setInPoolBody =>
      '비슷한 랭크의 다음 플레이어가 이 세트와 겨뤄요. 누가 이겼는지는 알림에서 볼 수 있고, 그때 랭크가 바뀌어요.';

  @override
  String get obWhyNeededBody =>
      '한 번 한 번은 어깨가 얼마나 내려갔다 올라오는지로 판정하고, 그건 카메라만 볼 수 있어요. 카메라가 없으면 카운트가 없고, 카운트가 없으면 대결도 없어요. 카메라는 세트 중에만 켜져요.';

  @override
  String get obWelcomeBack => '다시 오셨네요';

  @override
  String obTitlesHeading(String count) {
    return '얻을 수 있는 칭호 $count개';
  }

  @override
  String get obTitlesBody =>
      '승리, 연속 기록, 깔끔한 세트, 이른 아침 운동 등으로 얻어요. 하나를 골라 이름 아래에 달 수 있어요.';

  @override
  String get obFriendsHeading => '친구와 승부를 가려요';

  @override
  String get obFriendsBody => '친구는 이 코드로 나를 추가해요. 언제든 도전하고, 둘 사이의 전적이 기록돼요.';

  @override
  String get obLetsGo => '시작하기';

  @override
  String get paywallTitle => '아이언에서 마스터까지';

  @override
  String get paywallPerkDuels => '카메라가 판정하는 대결';

  @override
  String get paywallPerkLadder => '실시간 랭킹';

  @override
  String get paywallPerkFriends => '친구와 도전';

  @override
  String get paywallPerkHistory => '모든 경기의 모든 반복';

  @override
  String get paywallYearly => '연간';

  @override
  String get paywallWeekly => '주간';

  @override
  String paywallPerWeek(String price) {
    return '주당 ${price}';
  }

  @override
  String get paywallEveryWeek => '매주';

  @override
  String paywallSave(String percent) {
    return '${percent}% 절약';
  }

  @override
  String get paywallStart => '등반 시작';

  @override
  String get paywallRenewsPlay => '해지할 때까지 자동으로 갱신됩니다. Google Play에서 언제든지 해지할 수 있습니다.';

  @override
  String get paywallRenewsApple => '해지할 때까지 자동으로 갱신됩니다. Apple 계정 설정에서 언제든지 해지할 수 있습니다.';

  @override
  String get paywallRestore => '복원';

  @override
  String get paywallTerms => '약관';

  @override
  String get paywallPrivacy => '개인정보';

  @override
  String get paywallLoadFailed => '요금제를 불러오지 못했습니다. 연결을 확인하고 다시 시도하세요.';

  @override
  String get paywallBuyFailed => '구매가 완료되지 않았습니다. 다시 시도하세요.';

  @override
  String get paywallPending => '결제가 대기 중입니다. 스토어에서 확인되는 즉시 모든 기능이 열립니다.';

  @override
  String get paywallNothingToRestore => '복원할 구독이 없습니다.';

  @override
  String get paywallRestored => '구독이 복원되었습니다';

  @override
  String paywallSignedInAs(String email) {
    return '${email}(으)로 로그인됨';
  }

  @override
  String get deleteKeepsSubscription => '계정을 삭제해도 구독은 해지되지 않습니다. 요금은 outrepd가 아니라 스토어가 청구합니다. 먼저 Google Play 또는 Apple 계정 설정에서 해지하세요.';

  @override
  String get signOut => '로그아웃';

  @override
  String get signOutQuestion => '로그아웃할까요?';

  @override
  String get signOutBody => '계정은 랭크, 기록, 구독과 함께 그대로 남습니다. 언제든 이메일로 다시 로그인하세요.';

  @override
  String get shareVictory => '승리';

  @override
  String get shareRematch => '재대결?';

  @override
  String friendCodeInvite(String code) {
    return 'outrepd에서 나와 대결해 줘. 내 친구 코드 ${code}로 추가해 줘\nhttps://outrepd.com';
  }

  @override
  String get soundsLabel => '소리';

  @override
  String get soundsHint => '3, 2, 1 신호음, 반복마다 틱 소리, 라운드 종료음. 음악 위에 함께 재생됩니다.';

  @override
  String get phoneSection => '이 휴대폰';

  @override
  String get allowNotifications => '알림 허용';

  @override
  String get allowNotificationsHint => '휴대폰 설정에서 OUTREPD 알림이 꺼져 있어 아래 알림을 받을 수 없습니다.';

  @override
  String get remindersSection => '리마인더';

  @override
  String get dailyReminder => '매일 리마인더';

  @override
  String get dailyReminderHint => '아직 운동하지 않은 날에만.';

  @override
  String get reminderTime => '시간';

  @override
  String get reminderTitle => '오늘의 푸시업 시간이에요';

  @override
  String get reminderBody => '짧은 한 세트도 연속 기록에 포함돼요.';

  @override
  String reminderStreakBody(String count) {
    return '${count}일 연속 기록을 이어가세요. 한 세트면 충분해요.';
  }

  @override
  String get channelMatches => '대결과 친구';

  @override
  String get channelReminders => '매일 리마인더';

  @override
  String get liveTag => '라이브';

  @override
  String get reconnecting => '다시 연결 중';

  @override
  String get rankedLive => '랭크 · 라이브';

  @override
  String get lookingForLive => '라이브 상대를 찾는 중';

  @override
  String ofTime(String time) {
    return '${time} 중';
  }

  @override
  String liveFallbackAt(String time) {
    return '${time}이 되면 저장된 세트와 대결합니다';
  }

  @override
  String liveFoundBody(String name) {
    return '${name} 님이 지금 카메라 앞에 있어요. 같은 시계, 같은 출발.';
  }

  @override
  String get nobodyLiveTitle => '지금 라이브 중인 사람이 없어요';

  @override
  String get nobodyLiveBody => '대신 저장된 세트와 대결합니다';

  @override
  String didRepsIn(String reps) {
    return '60초에 ${reps}회';
  }

  @override
  String get sameRankPoints => '라이브 경기와 같은 랭크 포인트';

  @override
  String get raceIt => '대결하기';

  @override
  String get sendASet => '세트 보내기';

  @override
  String get onlineNow => '지금 온라인';

  @override
  String get liveOrSetHint => '라이브는 상대가 온라인일 때만 가능해요. 세트는 상대가 도전할 때까지 기다려요.';

  @override
  String get friendlyNoRank => '친선 · 랭크 없음';

  @override
  String waitingForName(String name) {
    return '${name} 님을 기다리는 중';
  }

  @override
  String get weSentThemANotice => '알림을 보냈어요';

  @override
  String get untilInviteRunsOut => '초대가 만료될 때까지';

  @override
  String get cancelInvite => '초대 취소';

  @override
  String inviteDeclined(String name) {
    return '${name} 님이 지금은 어렵대요';
  }

  @override
  String get inviteRanOut => '초대가 만료됐어요';

  @override
  String get inviteAgain => '다시 초대';

  @override
  String liveInviteFrom(String name) {
    return '${name} 님이 라이브 중';
  }

  @override
  String timeLeft(String time) {
    return '${time} 남음';
  }

  @override
  String get joinLive => '참가';

  @override
  String get nLiveTitle => '라이브 초대';

  @override
  String nLiveBody(String name) {
    return '${name} 님이 라이브 대결을 원해요';
  }

  @override
  String get inviteGone => '그 초대는 만료됐어요';

  @override
  String opponentDropped(String name) {
    return '${name} 님의 연결이 끊겼어요. 계속하세요: 라운드는 시간이 다 되면 끝나요.';
  }

  @override
  String opponentGaveUp(String name) {
    return '${name} 님이 포기했어요. 라운드를 끝내고 승리하세요.';
  }

  @override
  String get calledOffTitle => '대결이 취소됐어요';

  @override
  String calledOffBody(String name) {
    return '${name} 님이 제때 자세를 잡지 못했어요. 아무것도 기록되지 않았어요.';
  }

  @override
  String waitingForFinal(String name) {
    return '${name} 님의 최종 기록을 기다리는 중…';
  }

  @override
  String get wantsToBeFriends => '친구가 되고 싶어 해요';

  @override
  String get giveUpQuestion => '이번 라운드를 포기할까요?';

  @override
  String get giveUpBody => '지금 횟수와 상관없이 패배로 기록돼요.';

  @override
  String waitingToJoin(String name) {
    return '${name}님이 들어오길 기다리는 중';
  }

  @override
  String get removeFriend => '친구 삭제';

  @override
  String get removeFriendBody => '상대에게 알림이 가지 않으며, 다시 친구를 추가할 수 있어요';

  @override
  String removeFriendQuestion(String username) {
    return '${username}님을 친구에서 삭제할까요?';
  }

  @override
  String get removeAction => '삭제';

  @override
  String removedFriend(String username) {
    return '${username}님을 친구에서 삭제했어요';
  }

  @override
  String get noticeChallenged => '누군가 재대결을 신청했어요';

  @override
  String get noticeLiveInvite => '친구가 라이브 대결에 초대했어요';

  @override
  String trialHeadline(String days) {
    return '처음 ${days}일은 *무료*';
  }

  @override
  String get trialToday => '오늘';

  @override
  String get trialTodayBody => '라이브와 랭크, 모든 대결이 열려요.';

  @override
  String trialDay(String day) {
    return '${day}일째';
  }

  @override
  String get trialReminderBody => '체험이 끝나기 하루 전에 알려 드려요.';

  @override
  String get trialEndBody => '플랜이 시작돼요. 그 전에 취소하면 결제되지 않아요.';

  @override
  String trialTag(String days) {
    return '${days}일 무료';
  }

  @override
  String trialCta(String days) {
    return '${days}일 무료 체험 시작하기';
  }

  @override
  String trialThenYearly(String price) {
    return '지금은 결제 없음 · 이후 ${price}/년';
  }

  @override
  String trialThenWeekly(String price) {
    return '지금은 결제 없음 · 이후 ${price}/주';
  }

  @override
  String get trialEndsTitle => '무료 체험이 내일 끝나요';

  @override
  String get trialEndsBody => '계속 오르거나, 그 전에 구독 설정에서 취소하세요.';

  @override
  String get obIdeaTitle => '60초. 상대는 한 명.';

  @override
  String get obIdeaRival => '실제 사람과 대결, 실시간 또는 녹화된 세트로';

  @override
  String get obIdeaCamera => '카메라가 모든 반복을 휴대폰에서 셉니다';
}
