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
  String lpProgress(String lp, String left) {
    return '$lp / 100 LP · $left to promotion';
  }

  @override
  String winStreak(String count) {
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
  String changeNameLeft(String total, String left) {
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
  String titlesAndStreak(String owned, String total, String streak) {
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
  String goalRemaining(String reps, String days) {
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
  String seasonResets(String days) {
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
  String yourFriends(String count) {
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
  String lpToGo(String lp) {
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
  String xOfY(String a, String b) {
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
  String winLoss(String w, String l) {
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

  @override
  String get ttl_first_blood => 'First Blood';

  @override
  String get tdesc_first_blood => 'Finish your first match';

  @override
  String get ttl_found_footing => 'Found Your Footing';

  @override
  String get tdesc_found_footing => 'Finish five matches';

  @override
  String get ttl_regular => 'Regular';

  @override
  String get tdesc_regular => 'Twenty matches';

  @override
  String get ttl_fifty => 'Fifty Deep';

  @override
  String get tdesc_fifty => 'Fifty matches';

  @override
  String get ttl_century => 'Century';

  @override
  String get tdesc_century => 'A hundred matches';

  @override
  String get ttl_veteran => 'Veteran';

  @override
  String get tdesc_veteran => 'Two hundred and fifty matches';

  @override
  String get ttl_thousand_matches => 'Old Guard';

  @override
  String get tdesc_thousand_matches => 'A thousand matches';

  @override
  String get ttl_first_win => 'Winner';

  @override
  String get tdesc_first_win => 'Win a match';

  @override
  String get ttl_on_a_roll => 'On a Roll';

  @override
  String get tdesc_on_a_roll => 'Win three in a row';

  @override
  String get ttl_five_straight => 'Five Straight';

  @override
  String get tdesc_five_straight => 'Win five in a row';

  @override
  String get ttl_unstoppable => 'Unstoppable';

  @override
  String get tdesc_unstoppable => 'Win ten in a row';

  @override
  String get ttl_untouchable => 'Untouchable';

  @override
  String get tdesc_untouchable => 'Win twenty in a row';

  @override
  String get ttl_giant_slayer => 'Giant Slayer';

  @override
  String get tdesc_giant_slayer => 'Beat someone two tiers above you';

  @override
  String get ttl_comeback => 'Comeback';

  @override
  String get tdesc_comeback => 'Win straight after three losses';

  @override
  String get ttl_nemesis => 'Nemesis';

  @override
  String get tdesc_nemesis => 'Beat the same lifter five times';

  @override
  String get ttl_hundred_reps => 'Off the Mark';

  @override
  String get tdesc_hundred_reps => 'A hundred counted reps';

  @override
  String get ttl_five_hundred => 'Warmed Up';

  @override
  String get tdesc_five_hundred => 'Five hundred counted reps';

  @override
  String get ttl_the_machine => 'The Machine';

  @override
  String get tdesc_the_machine => 'A thousand counted reps';

  @override
  String get ttl_five_thousand => 'Relentless';

  @override
  String get tdesc_five_thousand => 'Five thousand counted reps';

  @override
  String get ttl_ten_thousand => 'Ten Thousand';

  @override
  String get tdesc_ten_thousand => 'Ten thousand counted reps';

  @override
  String get ttl_fifty_thousand => 'Beyond Counting';

  @override
  String get tdesc_fifty_thousand => 'Fifty thousand counted reps';

  @override
  String get ttl_first_tonne => 'A Tonne';

  @override
  String get tdesc_first_tonne => 'Move a thousand kilos in total';

  @override
  String get ttl_ten_tonnes => 'Ten Tonnes';

  @override
  String get tdesc_ten_tonnes => 'Move ten thousand kilos';

  @override
  String get ttl_six_figures => 'Six Figures';

  @override
  String get tdesc_six_figures => 'Move a hundred thousand kilos';

  @override
  String get ttl_half_million => 'Half a Million';

  @override
  String get tdesc_half_million => 'Move five hundred thousand kilos';

  @override
  String get ttl_million_kg => 'Million Kilo Club';

  @override
  String get tdesc_million_kg => 'Move a million kilos';

  @override
  String get ttl_two_days => 'Back Again';

  @override
  String get tdesc_two_days => 'Train two days running';

  @override
  String get ttl_no_days_off => 'No Days Off';

  @override
  String get tdesc_no_days_off => 'Train seven days running';

  @override
  String get ttl_fortnight => 'Fortnight';

  @override
  String get tdesc_fortnight => 'A fourteen day streak';

  @override
  String get ttl_unbroken => 'Unbroken';

  @override
  String get tdesc_unbroken => 'A thirty day streak';

  @override
  String get ttl_sixty_days => 'Habit';

  @override
  String get tdesc_sixty_days => 'A sixty day streak';

  @override
  String get ttl_hundred_days => 'Hundred Days';

  @override
  String get tdesc_hundred_days => 'A hundred day streak';

  @override
  String get ttl_year_round => 'Year Round';

  @override
  String get tdesc_year_round => 'A three hundred and sixty five day streak';

  @override
  String get ttl_perfect_week => 'Perfect Week';

  @override
  String get tdesc_perfect_week => 'Train every day of one week';

  @override
  String get ttl_perfect_month => 'Perfect Month';

  @override
  String get tdesc_perfect_month => 'Four perfect weeks';

  @override
  String get ttl_bronze_tier => 'Out of the Stone';

  @override
  String get tdesc_bronze_tier => 'Reach Bronze';

  @override
  String get ttl_silver_tier => 'Silverside';

  @override
  String get tdesc_silver_tier => 'Reach Silver';

  @override
  String get ttl_golden_era => 'Golden Era';

  @override
  String get tdesc_golden_era => 'Reach Gold';

  @override
  String get ttl_platinum_tier => 'Platinum';

  @override
  String get tdesc_platinum_tier => 'Reach Platinum';

  @override
  String get ttl_diamond_tier => 'Diamond Hands';

  @override
  String get tdesc_diamond_tier => 'Reach Diamond';

  @override
  String get ttl_master_tier => 'Master';

  @override
  String get tdesc_master_tier => 'Reach Master';

  @override
  String get ttl_mythic_tier => 'Mythic';

  @override
  String get tdesc_mythic_tier => 'Reach Mythic';

  @override
  String get ttl_legend_tier => 'Legend';

  @override
  String get tdesc_legend_tier => 'Reach Legend';

  @override
  String get ttl_clean_hands => 'Clean Hands';

  @override
  String get tdesc_clean_hands => 'A full set with every rep counted';

  @override
  String get ttl_spotless => 'Spotless';

  @override
  String get tdesc_spotless => 'Ten clean sets';

  @override
  String get ttl_textbook => 'Textbook';

  @override
  String get tdesc_textbook => 'Fifty clean sets';

  @override
  String get ttl_iron_hold => 'Iron Hold';

  @override
  String get tdesc_iron_hold => 'Hold a plank for two minutes';

  @override
  String get ttl_statue => 'Statue';

  @override
  String get tdesc_statue => 'Hold a plank for five minutes';

  @override
  String get ttl_all_rounder => 'All Rounder';

  @override
  String get tdesc_all_rounder => 'Count five different exercises';

  @override
  String get ttl_explorer => 'Explorer';

  @override
  String get tdesc_explorer => 'Count fifteen different exercises';

  @override
  String get ttl_encyclopedia => 'Encyclopedia';

  @override
  String get tdesc_encyclopedia => 'Count forty different exercises';

  @override
  String get ttl_early_bird => 'Early Shift';

  @override
  String get tdesc_early_bird => 'Ten sessions before seven in the morning';

  @override
  String get ttl_sunrise_club => 'Sunrise Club';

  @override
  String get tdesc_sunrise_club => 'Fifty sessions before seven';

  @override
  String get ttl_night_owl => 'Night Shift';

  @override
  String get tdesc_night_owl => 'Ten sessions after ten at night';

  @override
  String get ttl_graveyard => 'Graveyard Shift';

  @override
  String get tdesc_graveyard => 'Fifty sessions after ten';

  @override
  String get ttl_joined_up => 'Joined Up';

  @override
  String get tdesc_joined_up => 'Be in a crew';

  @override
  String get ttl_backbone => 'Backbone';

  @override
  String get tdesc_backbone => 'Top your crew four weeks running';

  @override
  String get ttl_cornerstone => 'Cornerstone';

  @override
  String get tdesc_cornerstone => 'Top your crew twelve weeks running';

  @override
  String get ttl_not_alone => 'Not Alone';

  @override
  String get tdesc_not_alone => 'Add your first friend';

  @override
  String get ttl_well_connected => 'Well Connected';

  @override
  String get tdesc_well_connected => 'Ten friends';

  @override
  String get ttl_the_gym_knows => 'The Gym Knows You';

  @override
  String get tdesc_the_gym_knows => 'Fifty friends';

  @override
  String get finish2 => 'Finish';

  @override
  String get qExperience => 'How experienced are you\nwith working out?';

  @override
  String get expBeginner => 'Beginner – Tried it before';

  @override
  String get expIntermediate => 'Intermediate – Regular training';

  @override
  String get expAdvanced => 'Advanced – Years of experience';

  @override
  String get qGoal => 'What\'s your top\nfitness goal?';

  @override
  String get goalStronger => 'Become stronger';

  @override
  String get goalConsistent => 'Become more consistent';

  @override
  String get goalLean => 'Lose weight and get lean';

  @override
  String get goalMass => 'Build muscle mass';

  @override
  String get aboutYou => 'This journey is all about you...';

  @override
  String get qThinkAbout => 'How often do you think\nabout getting in shape?';

  @override
  String get freqNever => 'Never';

  @override
  String get freqSometimes => 'Sometimes';

  @override
  String get freqOften => 'Often';

  @override
  String get freqAllTime => 'All The Time';

  @override
  String get qEnergy => 'How are your energy levels\nduring workouts?';

  @override
  String get energyLow => 'Low energy, I feel drained all day';

  @override
  String get energyDrops => 'Performance drops mid-session';

  @override
  String get energyHard => 'Hard to push through the last set';

  @override
  String get energyHigh => 'High and steady from start to finish';

  @override
  String get stProgress =>
      'Sometimes, it\'s hard to notice progress when I workout';

  @override
  String get stEffortTitle => 'Effort no one sees\nis easy to quit';

  @override
  String get stEffortBody =>
      'When there\'s no one to prove yourself against, progress feels slow and effort feels pointless';

  @override
  String get stAloneTitle => 'Training alone\nis boring';

  @override
  String get stAloneBody =>
      'No one\'s watching. No one\'s counting. It\'s easy to skip a rep, or the whole set';

  @override
  String get qName => 'What should we\ncall you?';

  @override
  String get nameHint => 'At least 3 characters. This is what rivals will see.';

  @override
  String get basicInfo => 'Alright! Lets get\nsome basic info';

  @override
  String get qAge => 'How old are you?';

  @override
  String get qWeight => 'What\'s your\ncurrent weight?';

  @override
  String get weightWhy => 'Body weight is essential to calculate your rank.';

  @override
  String get privateNote =>
      'Your information is private and will not be shared with anyone.';

  @override
  String get qHeight => 'How tall are you?';

  @override
  String get qRelate => 'Do you relate to the\nstatement below?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get grindTitle => 'The grind hits different\nwith a rival';

  @override
  String get grindBody =>
      'Every match puts you against a real opponent, put in the work, and prove who trained harder.';

  @override
  String get allSet => 'You\'re all set!';

  @override
  String welcomeLifter(String name) {
    return 'Welcome, $name. Time to find your first rival.';
  }

  @override
  String get lifter => 'lifter';

  @override
  String get enterApp => 'Enter OUTREPD';

  @override
  String get commitTitle =>
      'Now let\'s make a commitment\nto your fitness journey';

  @override
  String get holdLogo => 'Hold the logo to confirm you\'re ready';

  @override
  String get expNone => 'I\'ve never worked out';

  @override
  String get iAm => 'I am...';

  @override
  String get finishMatchQ => 'Finish match?';

  @override
  String get finishMatchBody =>
      'Your volume will be locked in and compared with your opponent.';

  @override
  String get keepGoing => 'Keep going';

  @override
  String get forfeitQ => 'Forfeit match?';

  @override
  String get forfeitBody => 'You will lose LP if you leave now.';

  @override
  String get stay => 'Stay';

  @override
  String get forfeit => 'Forfeit';

  @override
  String get pickExercises => 'Pick the exercises you will train';

  @override
  String matchingWith(String muscle) {
    return 'Matching you with a lifter at your rank · $muscle';
  }

  @override
  String get getReady => 'GET READY';

  @override
  String get timeLeft => 'TIME LEFT';

  @override
  String vsName(String name) {
    return 'vs $name';
  }

  @override
  String kgTotalVolume(String unit) {
    return '$unit total volume';
  }

  @override
  String get finishMatch => 'FINISH MATCH';

  @override
  String get kgHint => 'KG';

  @override
  String get repsHint => 'REPS';

  @override
  String get addSet => 'ADD SET';

  @override
  String get matchComplete => 'MATCH COMPLETE';

  @override
  String get you => 'YOU';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'BACK TO HOME';

  @override
  String get mgChest => 'Chest';

  @override
  String get mgBack => 'Back';

  @override
  String get mgLegs => 'Legs';

  @override
  String get mgShoulders => 'Shoulders';

  @override
  String get mgArms => 'Arms';

  @override
  String get mgCore => 'Core';

  @override
  String get achRivalry => 'Rivalry';

  @override
  String get achRivalryHint => 'Beat the same opponent 3 times';

  @override
  String get nWonTitle => 'You won!';

  @override
  String nWonBody(String name, String muscle) {
    return 'You beat $name on $muscle day';
  }

  @override
  String get nFriendTitle => 'New friend request';

  @override
  String nFriendBody(String name) {
    return '$name wants to connect';
  }

  @override
  String get nAchTitle => 'Achievement unlocked';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => 'Rank up!';

  @override
  String nRankBody(String rank) {
    return 'You reached $rank';
  }

  @override
  String get nameTooShortInline => 'Pick a name of at least 3 characters';

  @override
  String get whyName => 'Rivals will see this beside every result';

  @override
  String get whyExperience => 'We match you against people at your level';

  @override
  String get whyGoal => 'Your first suggested exercises come from this';

  @override
  String get whyAge =>
      'Age affects the strength standards you are measured against';

  @override
  String get whyWeight =>
      'Rank compares lifts relative to bodyweight, not raw kilos';

  @override
  String get whyHeight => 'Used with your weight to set fair standards';

  @override
  String get whyHabits =>
      'This shapes the reminders and the weekly target we suggest';

  @override
  String get transitionPartOfIt =>
      '...so let\'s make sure you\'re truly part of it!';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get usernamePlaceholder => 'username';

  @override
  String get stRoutine =>
      'I don\'t know which body part really needs work so I usually follow the same routine';

  @override
  String get shortIn => 'in';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(String n) {
    return '$n days ago';
  }

  @override
  String weeksAgo(String n) {
    return '$n weeks ago';
  }

  @override
  String membersCount(String n) {
    return '$n members';
  }

  @override
  String eachCount(String n) {
    return '$n each';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get countWithCamera => 'Count with camera';

  @override
  String get youWin => 'YOU WIN!';

  @override
  String get defeated => 'DEFEATED';

  @override
  String get fillWholeNumbers => 'Fill all three with whole numbers';

  @override
  String heightRange(String min, String max, String unit) {
    return 'Height should be between $min and $max $unit';
  }

  @override
  String weightRange(String min, String max, String unit) {
    return 'Bodyweight should be between $min and $max $unit';
  }

  @override
  String ageRange(String min, String max) {
    return 'Age should be between $min and $max';
  }
}
