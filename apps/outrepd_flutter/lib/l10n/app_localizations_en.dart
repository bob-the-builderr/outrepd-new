// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LEn extends L {
  LEn([String locale = 'en']) : super(locale);

  @override
  String get tabFriends => 'Friends';

  @override
  String get tabRanks => 'Ranks';

  @override
  String get tabMatch => 'Match';

  @override
  String get tabCrew => 'Crew';

  @override
  String get tabProfile => 'Profile';

  @override
  String get searchOpponent => 'Search for opponent';

  @override
  String get searchOpponentHint => 'Get matched with a lifter at your rank';

  @override
  String get challengeFriend => 'Challenge a friend';

  @override
  String get trainWithCamera => 'Train with the camera';

  @override
  String get viewRoadmap => 'View Roadmap';

  @override
  String lpProgress(int lp, int left) {
    return '$lp / 100 LP · $left to promotion';
  }

  @override
  String winStreak(int count) {
    return '$count win streak';
  }

  @override
  String get matchHistory => 'Match history';

  @override
  String get allMatches => 'All matches';

  @override
  String get wins => 'Wins';

  @override
  String get losses => 'Losses';

  @override
  String get winRate => 'Win rate';

  @override
  String get streak => 'Streak';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get stats => 'Stats';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get skip => 'Skip';

  @override
  String get totalMatches => 'Total matches';

  @override
  String get bestWinStreak => 'Best win streak';

  @override
  String get totalVolume => 'Total volume lifted';

  @override
  String get height => 'Height';

  @override
  String get bodyweight => 'Bodyweight';

  @override
  String get age => 'Age';

  @override
  String get editYourStats => 'Edit your stats';

  @override
  String get editStatsHint =>
      'Wins, volume and rank are earned — they cannot be edited.';

  @override
  String get changeName => 'Change your name';

  @override
  String get changeNameLast => 'This is your last change. It cannot be undone.';

  @override
  String changeNameLeft(int total, int left) {
    return 'You get $total changes in total. $left left after this one.';
  }

  @override
  String get changeNameUsedUp => 'You have used both of your name changes';

  @override
  String get yourPicture => 'Your picture';

  @override
  String get yourPictureHint =>
      'The frame comes from your rank and changes as you climb.';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get orPickOurs => 'Or pick one of ours';

  @override
  String get awards => 'Awards';

  @override
  String get yourTitles => 'Your titles';

  @override
  String get stillToEarn => 'Still to earn';

  @override
  String get noTitlesYet => 'None yet. The first one takes a single match.';

  @override
  String get wearHint =>
      'Tap one to wear it. It shows beside your name wherever people see you.';

  @override
  String get worn => 'worn';

  @override
  String get titleUnlocked => 'Title unlocked';

  @override
  String get wearIt => 'Wear it';

  @override
  String get wearItLater => 'Wear it later';

  @override
  String get dayStreak => 'day streak';

  @override
  String get bestEver => 'Best ever';

  @override
  String get restDaysLeft => 'Rest days left';

  @override
  String get restIsTraining =>
      'Rest is part of training. Two days off a week will not break your streak.';

  @override
  String titlesAndStreak(int owned, int total, int streak) {
    return '$owned of $total titles · $streak day streak';
  }

  @override
  String get crew => 'Crew';

  @override
  String get myCrew => 'My crew';

  @override
  String get rankings => 'Rankings';

  @override
  String get trainWithCrew => 'Train with a crew';

  @override
  String get trainWithCrewHint =>
      'Up to 20 lifters under one name, chasing a weekly target together and climbing the crew table.';

  @override
  String get createCrew => 'Create a crew';

  @override
  String get createCrewHint => 'Name it, pick a badge, invite your people';

  @override
  String get joinOpenCrew => 'Join an open crew';

  @override
  String get joinOpenCrewHint => 'Crews anyone can walk into';

  @override
  String get yourInvites => 'Your invites';

  @override
  String get yourInvitesHint => 'Crews that asked for you';

  @override
  String get joinWithCode => 'Join with a code';

  @override
  String get joinWithCodeHint => 'Six characters from a member';

  @override
  String get topCrewsThisWeek => 'Top crews this week';

  @override
  String get members => 'Members';

  @override
  String get repsEach => 'Reps each';

  @override
  String get rank => 'Rank';

  @override
  String get weeklyGoal => 'Weekly goal';

  @override
  String get weeklyGoalDone => 'Weekly goal smashed';

  @override
  String goalRemaining(int reps, int days) {
    return '$reps reps to go · $days days left';
  }

  @override
  String get goalDoneHint => 'Everyone gets the badge when the week closes.';

  @override
  String get startCrewWar => 'Start a crew war';

  @override
  String get startCrewWarHint =>
      'Seven days, both crews counting. Most reps each wins.';

  @override
  String get whoIsPulling => 'Who is pulling';

  @override
  String get thisWeek => 'this week';

  @override
  String get inviteLifters => 'Invite lifters';

  @override
  String get referralCode => 'Referral code';

  @override
  String get inviteLink => 'Invite link';

  @override
  String get leaveCrew => 'Leave crew';

  @override
  String get owner => 'Owner';

  @override
  String get crewTable => 'Crew table';

  @override
  String get repsPerMember => 'reps per member';

  @override
  String seasonResets(int days) {
    return 'Resets in $days days — everyone starts level';
  }

  @override
  String get rankingExplained =>
      'Crews are ranked on reps per member, not the total — otherwise the biggest crew wins by size alone.';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get global => 'Global';

  @override
  String get myCountry => 'My country';

  @override
  String yourFriends(int count) {
    return 'Your friends ($count)';
  }

  @override
  String get challenge => 'Challenge';

  @override
  String get notifications => 'Notifications';

  @override
  String get pickMovement => 'Pick a movement';

  @override
  String get anyExercise => 'Any exercise';

  @override
  String get anyExerciseHint =>
      'Start your set — it works the movement out as you go';

  @override
  String get start => 'Start';

  @override
  String get finish => 'Finish';

  @override
  String get reps => 'reps';

  @override
  String get secondsHeld => 'seconds held';

  @override
  String get learningMovement =>
      'Learning your movement — your reps appear in a moment';

  @override
  String get recalibrate => 'Recalibrate';

  @override
  String get resetCount => 'Reset count';

  @override
  String get checksForm => 'checks form';

  @override
  String get counts => 'counts';

  @override
  String get time => 'time';

  @override
  String get howManyReally => 'How many did you really do?';

  @override
  String get howManyReallyHint =>
      'Your own count, not the app\'s. It is what the counter gets measured against later.';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get units => 'Units';

  @override
  String get weight => 'Weight';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get privacy => 'Privacy';

  @override
  String get matches => 'Matches';

  @override
  String get data => 'Data';

  @override
  String get about => 'About';

  @override
  String get dangerZone => 'Danger zone';

  @override
  String get themeSystem => 'Match device';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get openCrews => 'Open crews';

  @override
  String get openCrewsHint =>
      'These let anyone in. Pick one and you are in straight away.';

  @override
  String get yourInvitesSubtitle => 'Crews that asked for you by name.';

  @override
  String get pickOpponent => 'Pick your opponent';

  @override
  String get accept => 'Accept';

  @override
  String get join => 'Join';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Invite link copied';

  @override
  String season(String name) {
    return 'Season $name';
  }

  @override
  String challengeSent(String name) {
    return 'Challenge sent to $name';
  }

  @override
  String get inviteFriendPrivate => 'Invite a friend to a private match';

  @override
  String get joinWithCodePaste => 'Paste the six characters a member sent you.';

  @override
  String get enterTheCode => 'Enter the 6-character code';

  @override
  String get followingDevice => 'Following your device right now';

  @override
  String get weightUnitTitle => 'Weight unit';

  @override
  String get heightUnitTitle => 'Height unit';

  @override
  String get unitKg => 'Kilograms (kg)';

  @override
  String get unitLb => 'Pounds (lb)';

  @override
  String get unitCm => 'Centimetres (cm)';

  @override
  String get unitFt => 'Feet & inches';

  @override
  String get visEveryone => 'Everyone';

  @override
  String get visFriends => 'Friends only';

  @override
  String get visNobody => 'Nobody';

  @override
  String get visEveryoneHint => 'Anyone can open your profile';

  @override
  String get visFriendsHint => 'Only lifters you have added';

  @override
  String get visNobodyHint => 'Your profile stays private';

  @override
  String get matchInvites => 'Match invites';

  @override
  String get matchResults => 'Match results';

  @override
  String get friendRequestsLabel => 'Friend requests';

  @override
  String get crewActivity => 'Crew activity';

  @override
  String get rankChanges => 'Rank changes';

  @override
  String get weeklySummary => 'Weekly summary';

  @override
  String get soundLabel => 'Sound';

  @override
  String get vibration => 'Vibration';

  @override
  String get whoCanSeeProfile => 'Who can see my profile';

  @override
  String get profileVisibility => 'Profile visibility';

  @override
  String get showOnLeaderboards => 'Show me on leaderboards';

  @override
  String get allowMatchInvites => 'Allow match invites';

  @override
  String get allowFriendRequests => 'Allow friend requests';

  @override
  String get showHeightWeight => 'Show height and weight';

  @override
  String get showHeightWeightHint => 'Off keeps your body stats to yourself';

  @override
  String get autoAcceptFriends => 'Auto-accept from friends';

  @override
  String get restTimerBetweenSets => 'Rest timer between sets';

  @override
  String get exportData => 'Export my data';

  @override
  String get clearCache => 'Clear cache';

  @override
  String get cacheCleared => 'Cache cleared';

  @override
  String get version => 'Version';

  @override
  String get rateApp => 'Rate OUTREPD';

  @override
  String get contactSupport => 'Contact support';

  @override
  String get termsOfService => 'Terms of service';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get openSourceLicences => 'Open source licences';

  @override
  String get resetProgress => 'Reset my progress';

  @override
  String get resetProgressTitle => 'Reset your progress?';

  @override
  String get resetProgressBody =>
      'Rank, LP and match history all go back to zero. This cannot be undone.';

  @override
  String get actionReset => 'Reset';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountBody =>
      'Your profile, crews and every match you have lifted are removed for good.';

  @override
  String get actionDelete => 'Delete';

  @override
  String get needsServer => 'This needs a server — not wired up yet';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skipToApp => 'Skip to the app';

  @override
  String get achievements => 'Achievements';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get roadTitle => 'Road to Legend';

  @override
  String get allTiers => 'All tiers';

  @override
  String get topTier => 'Top tier';

  @override
  String lpToGo(int lp) {
    return '$lp LP';
  }

  @override
  String get unlockedEverything => 'You have unlocked everything';

  @override
  String unlocksAt(String tier) {
    return 'Unlocks at $tier';
  }

  @override
  String get matchedSameGroup =>
      'You will be matched with someone training the same group.';

  @override
  String get roomFriendly =>
      'Room matches are friendly — they do not affect your rank.';

  @override
  String get createRoom => 'Create a room';

  @override
  String get enterCode => 'ENTER CODE';

  @override
  String get joinRoom => 'Join room';

  @override
  String get shareThisCode => 'Share this code';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get pickMuscleAndStart => 'Pick muscle and start';

  @override
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(int a, int b) {
    return '$a / $b';
  }

  @override
  String get tierStone => 'Stone';

  @override
  String get tierBronze => 'Bronze';

  @override
  String get tierSilver => 'Silver';

  @override
  String get tierGold => 'Gold';

  @override
  String get tierPlatinum => 'Platinum';

  @override
  String get tierDiamond => 'Diamond';

  @override
  String get tierMaster => 'Master';

  @override
  String get tierMythic => 'Mythic';

  @override
  String get tierLegend => 'Legend';

  @override
  String get rewardStone => 'Stone border frame';

  @override
  String get rewardBronze => 'Bronze badge';

  @override
  String get rewardSilver => 'Silver badge';

  @override
  String get rewardGold => 'Gold badge';

  @override
  String get rewardPlatinum => 'Platinum badge';

  @override
  String get rewardDiamond => 'Diamond badge';

  @override
  String get rewardMaster => 'Master badge';

  @override
  String get rewardMythic => 'Mythic badge';

  @override
  String get rewardLegend => 'Legend badge';

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
    return '${w}W ${l}L';
  }

  @override
  String get yearsSuffix => 'years';

  @override
  String get yourCrew => 'Your crew';

  @override
  String get crewName => 'Crew name';

  @override
  String get motto => 'Motto';

  @override
  String get mottoHint => 'What does this crew stand for?';

  @override
  String get country => 'Country';

  @override
  String get whoCanJoin => 'Who can join';

  @override
  String get minimumRank => 'Minimum rank';

  @override
  String get anyone => 'Anyone';

  @override
  String get emblem => 'Emblem';

  @override
  String get colour => 'Colour';

  @override
  String get createCrewButton => 'Create crew';

  @override
  String get ownerNote => 'You will be the owner. Crews hold up to 20 lifters.';

  @override
  String get searchCountries => 'Search countries';

  @override
  String get noCountryMatch => 'No country matches that';

  @override
  String get nameTooShort => 'Give the crew a name of at least 3 characters';

  @override
  String get privOpen => 'Open';

  @override
  String get privRequest => 'Request to join';

  @override
  String get privInviteOnly => 'Invite only';

  @override
  String get privOpenHint => 'Anyone with the code can walk straight in';

  @override
  String get privRequestHint => 'People ask, an officer approves';

  @override
  String get privInviteOnlyHint => 'Members must be invited directly';

  @override
  String get embStrength => 'Strength';

  @override
  String get embCombat => 'Combat';

  @override
  String get embBeasts => 'Beasts';

  @override
  String get embElements => 'Elements';

  @override
  String get embHonours => 'Honours';

  @override
  String get embSymbols => 'Symbols';

  @override
  String get ob1Title => 'Turn every session\ninto a battle';

  @override
  String get ob1Body =>
      'Log your workout and go head to head with someone training the same muscle group.';

  @override
  String get ob2Title => 'Challenge your\nfriends';

  @override
  String get ob2Body =>
      'Send a private invite and settle who really trains harder.';

  @override
  String get ob3Title => 'Climb the ranks';

  @override
  String get ob3Body =>
      'Every win earns LP. Push from Stone all the way to Legend.';

  @override
  String get ob4Title => 'Effort alone\nis hard';

  @override
  String get ob4Body =>
      'Training with no one watching makes it easy to cut the last set short.';

  @override
  String get ob5Title => 'Become a\nLegend';

  @override
  String get ob5Body => 'Consistency compounds. Show up, out-lift, rank up.';

  @override
  String get letsGo => 'Let\'s go';

  @override
  String get continueLabel => 'Continue';
}
