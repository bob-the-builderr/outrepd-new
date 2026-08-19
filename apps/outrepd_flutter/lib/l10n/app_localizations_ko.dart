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
  String get tabCrew => '크루';

  @override
  String get tabProfile => '프로필';

  @override
  String get searchOpponent => '상대 찾기';

  @override
  String get searchOpponentHint => '같은 랭크의 상대와 매칭해 드립니다';

  @override
  String get challengeFriend => '친구에게 도전';

  @override
  String get trainWithCamera => '카메라로 훈련';

  @override
  String get viewRoadmap => '로드맵 보기';

  @override
  String lpProgress(int lp, int left) {
    return '$lp / 100 LP · 승급까지 $left';
  }

  @override
  String winStreak(int count) {
    return '$count연승 중';
  }

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
  String get profile => '프로필';

  @override
  String get settings => '설정';

  @override
  String get stats => '기록';

  @override
  String get edit => '수정';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get skip => '건너뛰기';

  @override
  String get totalMatches => '총 대결 수';

  @override
  String get bestWinStreak => '최고 연승';

  @override
  String get totalVolume => '총 든 무게';

  @override
  String get height => '키';

  @override
  String get bodyweight => '몸무게';

  @override
  String get age => '나이';

  @override
  String get editYourStats => '내 정보 수정';

  @override
  String get editStatsHint => '승리와 볼륨, 랭크는 얻는 것이지 적는 것이 아닙니다.';

  @override
  String get changeName => '이름 변경';

  @override
  String get changeNameLast => '마지막 변경입니다. 되돌릴 수 없습니다.';

  @override
  String changeNameLeft(int total, int left) {
    return '변경은 총 $total번까지입니다. 이번 뒤로 $left번 남습니다.';
  }

  @override
  String get changeNameUsedUp => '이름 변경 기회를 모두 사용했습니다';

  @override
  String get yourPicture => '내 사진';

  @override
  String get yourPictureHint => '테두리는 랭크에 따라 정해지고, 올라갈 때마다 바뀝니다.';

  @override
  String get gallery => '갤러리';

  @override
  String get camera => '카메라';

  @override
  String get orPickOurs => '준비된 이미지에서 고르기';

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
  String titlesAndStreak(int owned, int total, int streak) {
    return '$total개 중 $owned개 · $streak일 연속';
  }

  @override
  String get crew => '크루';

  @override
  String get myCrew => '내 크루';

  @override
  String get rankings => '순위';

  @override
  String get trainWithCrew => '크루와 함께 훈련';

  @override
  String get trainWithCrewHint => '한 이름 아래 최대 20명이 주간 목표를 함께 쫓고 크루 순위표를 올라갑니다.';

  @override
  String get createCrew => '크루 만들기';

  @override
  String get createCrewHint => '이름을 짓고, 엠블럼을 고르고, 사람들을 부르세요';

  @override
  String get joinOpenCrew => '공개 크루 가입';

  @override
  String get joinOpenCrewHint => '누구나 참여할 수 있는 크루입니다';

  @override
  String get yourInvites => '받은 초대';

  @override
  String get yourInvitesHint => '당신을 부른 크루';

  @override
  String get joinWithCode => '코드로 가입';

  @override
  String get joinWithCodeHint => '크루원에게 받은 여섯 자리';

  @override
  String get topCrewsThisWeek => '이번 주 상위 크루';

  @override
  String get members => '인원';

  @override
  String get repsEach => '1인당 횟수';

  @override
  String get rank => '순위';

  @override
  String get weeklyGoal => '주간 목표';

  @override
  String get weeklyGoalDone => '주간 목표 달성';

  @override
  String goalRemaining(int reps, int days) {
    return '$reps회 남음 · $days일 남음';
  }

  @override
  String get goalDoneHint => '주가 끝나면 배지는 전원에게 지급됩니다.';

  @override
  String get startCrewWar => '크루전 시작';

  @override
  String get startCrewWarHint => '7일 동안 두 크루가 함께 셉니다. 1인당 횟수가 많은 쪽이 이깁니다.';

  @override
  String get whoIsPulling => '크루를 이끄는 사람';

  @override
  String get thisWeek => '이번 주';

  @override
  String get inviteLifters => '선수 초대';

  @override
  String get referralCode => '초대 코드';

  @override
  String get inviteLink => '초대 링크';

  @override
  String get leaveCrew => '크루 나가기';

  @override
  String get owner => '크루장';

  @override
  String get crewTable => '크루 순위표';

  @override
  String get repsPerMember => '1인당 횟수';

  @override
  String seasonResets(int days) {
    return '$days일 뒤 초기화 — 모두 같은 자리에서 다시 시작';
  }

  @override
  String get rankingExplained =>
      '크루 순위는 총합이 아니라 1인당 횟수로 매깁니다. 총합으로 하면 인원이 많은 크루가 숫자만으로 이기기 때문입니다.';

  @override
  String get leaderboard => '리더보드';

  @override
  String get global => '글로벌';

  @override
  String get myCountry => '내 국가';

  @override
  String yourFriends(int count) {
    return '친구 ($count)';
  }

  @override
  String get challenge => '도전';

  @override
  String get notifications => '알림';

  @override
  String get pickMovement => '동작 선택';

  @override
  String get anyExercise => '아무 운동';

  @override
  String get anyExerciseHint => '세트를 시작하세요. 동작은 수행 중에 인식됩니다';

  @override
  String get start => '시작';

  @override
  String get finish => '종료';

  @override
  String get reps => '회';

  @override
  String get secondsHeld => '초 버팀';

  @override
  String get learningMovement => '동작을 익히는 중 — 곧 횟수가 표시됩니다';

  @override
  String get recalibrate => '재보정';

  @override
  String get resetCount => '횟수 초기화';

  @override
  String get checksForm => '자세 확인';

  @override
  String get counts => '카운트';

  @override
  String get time => '시간';

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
  String get darkMode => '다크 모드';

  @override
  String get language => '언어';

  @override
  String get units => '단위';

  @override
  String get weight => '무게';

  @override
  String get notificationsSection => '알림';

  @override
  String get privacy => '개인정보';

  @override
  String get matches => '대결';

  @override
  String get data => '데이터';

  @override
  String get about => '앱 정보';

  @override
  String get dangerZone => '위험 구역';

  @override
  String get themeSystem => '기기 설정 따르기';

  @override
  String get themeLight => '밝게';

  @override
  String get themeDark => '어둡게';

  @override
  String get openCrews => '공개 크루';

  @override
  String get openCrewsHint => '여긴 누구나 들어갈 수 있습니다. 고르면 바로 가입됩니다.';

  @override
  String get yourInvitesSubtitle => '당신을 콕 집어 부른 크루입니다.';

  @override
  String get pickOpponent => '상대를 고르세요';

  @override
  String get accept => '수락';

  @override
  String get join => '가입';

  @override
  String get copy => '복사';

  @override
  String get copied => '초대 링크를 복사했습니다';

  @override
  String season(String name) {
    return '$name 시즌';
  }

  @override
  String challengeSent(String name) {
    return '$name에게 도전장을 보냈습니다';
  }

  @override
  String get inviteFriendPrivate => '친구를 비공개 대결에 초대하기';

  @override
  String get joinWithCodePaste => '크루원이 보낸 여섯 자리를 붙여넣으세요.';

  @override
  String get enterTheCode => '6자리 코드를 입력하세요';

  @override
  String get followingDevice => '지금은 기기 설정을 따릅니다';

  @override
  String get weightUnitTitle => '무게 단위';

  @override
  String get heightUnitTitle => '키 단위';

  @override
  String get unitKg => '킬로그램 (kg)';

  @override
  String get unitLb => '파운드 (lb)';

  @override
  String get unitCm => '센티미터 (cm)';

  @override
  String get unitFt => '피트·인치';

  @override
  String get visEveryone => '모두';

  @override
  String get visFriends => '친구만';

  @override
  String get visNobody => '아무도';

  @override
  String get visEveryoneHint => '누구나 프로필을 열 수 있습니다';

  @override
  String get visFriendsHint => '추가한 사람만';

  @override
  String get visNobodyHint => '프로필이 비공개로 유지됩니다';

  @override
  String get matchInvites => '대결 초대';

  @override
  String get matchResults => '대결 결과';

  @override
  String get friendRequestsLabel => '친구 요청';

  @override
  String get crewActivity => '크루 활동';

  @override
  String get rankChanges => '랭크 변동';

  @override
  String get weeklySummary => '주간 요약';

  @override
  String get soundLabel => '소리';

  @override
  String get vibration => '진동';

  @override
  String get whoCanSeeProfile => '내 프로필을 볼 수 있는 사람';

  @override
  String get profileVisibility => '프로필 공개 범위';

  @override
  String get showOnLeaderboards => '리더보드에 표시';

  @override
  String get allowMatchInvites => '대결 초대 허용';

  @override
  String get allowFriendRequests => '친구 요청 허용';

  @override
  String get showHeightWeight => '키와 몸무게 표시';

  @override
  String get showHeightWeightHint => '끄면 신체 정보는 나만 봅니다';

  @override
  String get autoAcceptFriends => '친구 요청은 자동 수락';

  @override
  String get restTimerBetweenSets => '세트 사이 휴식 타이머';

  @override
  String get exportData => '내 데이터 내보내기';

  @override
  String get clearCache => '캐시 지우기';

  @override
  String get cacheCleared => '캐시를 지웠습니다';

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
  String get resetProgress => '진행도 초기화';

  @override
  String get resetProgressTitle => '진행도를 초기화할까요?';

  @override
  String get resetProgressBody => '랭크와 LP, 대결 기록이 전부 0으로 돌아갑니다. 되돌릴 수 없습니다.';

  @override
  String get actionReset => '초기화';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get deleteAccountTitle => '계정을 삭제할까요?';

  @override
  String get deleteAccountBody => '프로필과 크루, 지금까지 치른 모든 대결이 영구히 사라집니다.';

  @override
  String get actionDelete => '삭제';

  @override
  String get needsServer => '이 기능에는 서버가 필요하며 아직 연결되지 않았습니다';

  @override
  String get getStarted => '시작하기';

  @override
  String get skipToApp => '바로 앱으로';

  @override
  String get achievements => '업적';

  @override
  String get unlocked => '해금됨';

  @override
  String get roadTitle => '레전드로 가는 길';

  @override
  String get allTiers => '모든 랭크';

  @override
  String get topTier => '최고 랭크';

  @override
  String lpToGo(int lp) {
    return '$lp LP';
  }

  @override
  String get unlockedEverything => '전부 해금했습니다';

  @override
  String unlocksAt(String tier) {
    return '$tier에서 해금';
  }

  @override
  String get matchedSameGroup => '같은 부위를 훈련하는 상대와 매칭됩니다.';

  @override
  String get roomFriendly => '룸 대결은 친선전입니다. 랭크에는 반영되지 않습니다.';

  @override
  String get createRoom => '룸 만들기';

  @override
  String get enterCode => '코드 입력';

  @override
  String get joinRoom => '룸 참가';

  @override
  String get shareThisCode => '이 코드를 공유하세요';

  @override
  String get codeCopied => '코드를 복사했습니다';

  @override
  String get pickMuscleAndStart => '부위를 고르고 시작';

  @override
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(int a, int b) {
    return '$a / $b';
  }

  @override
  String get tierStone => '스톤';

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
  String get tierMythic => '미시크';

  @override
  String get tierLegend => '레전드';

  @override
  String get rewardStone => '스톤 테두리';

  @override
  String get rewardBronze => '브론즈 배지';

  @override
  String get rewardSilver => '실버 배지';

  @override
  String get rewardGold => '골드 배지';

  @override
  String get rewardPlatinum => '플래티넘 배지';

  @override
  String get rewardDiamond => '다이아몬드 배지';

  @override
  String get rewardMaster => '마스터 배지';

  @override
  String get rewardMythic => '미시크 배지';

  @override
  String get rewardLegend => '레전드 배지';

  @override
  String get shortKg => 'kg';

  @override
  String get shortLb => 'lb';

  @override
  String get shortCm => 'cm';

  @override
  String get shortFt => 'ft';

  @override
  String winLoss(int w, int l) {
    return '$w승 $l패';
  }

  @override
  String get yearsSuffix => '세';

  @override
  String get yourCrew => '당신의 크루';

  @override
  String get crewName => '크루 이름';

  @override
  String get motto => '모토';

  @override
  String get mottoHint => '이 크루는 무엇을 내세우나요?';

  @override
  String get country => '국가';

  @override
  String get whoCanJoin => '가입 가능 대상';

  @override
  String get minimumRank => '최소 랭크';

  @override
  String get anyone => '누구나';

  @override
  String get emblem => '엠블럼';

  @override
  String get colour => '색상';

  @override
  String get createCrewButton => '크루 만들기';

  @override
  String get ownerNote => '당신이 크루장이 됩니다. 크루는 최대 20명까지입니다.';

  @override
  String get searchCountries => '국가 검색';

  @override
  String get noCountryMatch => '일치하는 국가가 없습니다';

  @override
  String get nameTooShort => '크루 이름은 세 글자 이상이어야 합니다';

  @override
  String get privOpen => '공개';

  @override
  String get privRequest => '가입 신청';

  @override
  String get privInviteOnly => '초대 전용';

  @override
  String get privOpenHint => '코드를 가진 사람은 바로 참여합니다';

  @override
  String get privRequestHint => '신청하면 관리자가 승인합니다';

  @override
  String get privInviteOnlyHint => '직접 초대를 받아야 가입할 수 있습니다';

  @override
  String get embStrength => '힘';

  @override
  String get embCombat => '전투';

  @override
  String get embBeasts => '야수';

  @override
  String get embElements => '원소';

  @override
  String get embHonours => '훈장';

  @override
  String get embSymbols => '상징';

  @override
  String get ob1Title => '모든 훈련을\n승부로 바꾸세요';

  @override
  String get ob1Body => '운동을 기록하고 같은 부위를 훈련하는 상대와 정면으로 겨루세요.';

  @override
  String get ob2Title => '친구에게\n도전하세요';

  @override
  String get ob2Body => '비공개 초대를 보내 누가 정말 더 열심히 하는지 가려 보세요.';

  @override
  String get ob3Title => '랭크를 올리세요';

  @override
  String get ob3Body => '이길 때마다 LP를 얻습니다. 스톤에서 레전드까지 올라가세요.';

  @override
  String get ob4Title => '혼자 하는 노력은\n버겁습니다';

  @override
  String get ob4Body => '아무도 보지 않으면 마지막 세트를 줄이기 쉬워집니다.';

  @override
  String get ob5Title => '레전드가\n되세요';

  @override
  String get ob5Body => '꾸준함은 쌓입니다. 나오고, 넘어서고, 올라가세요.';

  @override
  String get letsGo => '시작하기';

  @override
  String get continueLabel => '계속';
}
