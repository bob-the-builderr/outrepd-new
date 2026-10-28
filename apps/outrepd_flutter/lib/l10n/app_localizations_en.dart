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
  String get tabProfile => 'Profile';

  @override
  String get challengeFriend => 'Challenge a friend';

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
  String get settings => 'Settings';

  @override
  String get accountSection => 'Account';

  @override
  String get duelSection => 'Duel';

  @override
  String get hapticsEachRep => 'Haptics on each rep';

  @override
  String get showSkeleton => 'Show skeleton overlay';

  @override
  String get showSkeletonHint => 'How you can tell the camera is seeing you';

  @override
  String get manageNotifications => 'Manage notifications';

  @override
  String switchesOn(String on, String all) {
    return '$on of $all on';
  }

  @override
  String get whoCanChallenge => 'Who can challenge me';

  @override
  String get blockedAccounts => 'Blocked accounts';

  @override
  String get reportProblem => 'Report a problem';

  @override
  String get onDeviceNote =>
      'Pose detection runs on this phone. No video or pose data is ever uploaded.';

  @override
  String get visibilitySection => 'Visibility';

  @override
  String get showMyCountry => 'Show my country';

  @override
  String get showMyCountryHint => 'Off takes you off the country board';

  @override
  String get safetySection => 'Safety';

  @override
  String get socialSection => 'Social';

  @override
  String get noticeRaced => 'Someone raced my set';

  @override
  String get noticeRacedHint => 'The only way to find out a duel happened';

  @override
  String get noticeFriendOk => 'A request I sent was accepted';

  @override
  String get noticesStoredNote =>
      'Turning one off means it is never stored — not stored and hidden.';

  @override
  String get notSaved => 'Not saved';

  @override
  String get blockedIntro =>
      'A blocked account can\'t challenge you, find you, or send you a request. They aren\'t told.';

  @override
  String blockedWhen(String when) {
    return 'Blocked $when';
  }

  @override
  String get unblock => 'Unblock';

  @override
  String get noBlockedTitle => 'Nobody blocked';

  @override
  String get noBlockedBody =>
      'You can block somebody from their profile or a report.';

  @override
  String get whatHappened => 'What happened';

  @override
  String get reasonCheating => 'Cheating or fake reps';

  @override
  String get reasonHarassment => 'Harassment or abuse';

  @override
  String get reasonContent => 'Inappropriate content';

  @override
  String get reasonImpersonation => 'Impersonation';

  @override
  String get reasonOther => 'Something else';

  @override
  String get addDetails => 'Add details (optional)';

  @override
  String get alsoBlock => 'Also block this account';

  @override
  String get sendReport => 'Send report';

  @override
  String get reportSent => 'Report sent';

  @override
  String get reportingThisAccount => 'Reporting this account';

  @override
  String get exportIntro =>
      'We\'ll email a file with everything the server holds about you. It usually takes a minute.';

  @override
  String get whatsIncluded => 'What\'s included';

  @override
  String get incProfile => 'Your profile and rank';

  @override
  String get incSets => 'Every set and rep count';

  @override
  String get incDuels => 'Duel history and LP changes';

  @override
  String get incFriends => 'Friends and blocked accounts';

  @override
  String get incNotices => 'Notifications you were sent';

  @override
  String get noLandmarksNote =>
      'Pose landmarks are not in it, and never were. The camera reads them on your phone and they are not sent anywhere.';

  @override
  String get sendItTo => 'Send it to';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get createAccountTitle => 'Create account';

  @override
  String get createAccountBody => 'Sign in so this account is never just one phone away from gone.';

  @override
  String get createAccountAction => 'Create account';

  @override
  String get emailTakenSwitchToSignIn =>
      'That email already has an account — sign in instead.';

  @override
  String get emailSignUpInvalid =>
      'Check the email and password — six characters minimum.';

  @override
  String get tooManyCodes =>
      'Too many codes sent — wait a few minutes and try again.';

  @override
  String get sendCodeAction => 'Send code';

  @override
  String get noAccountForEmail =>
      'We couldn\'t find an account with that email.';

  @override
  String get authEntryTagline => 'Push. Compete. Climb the ladder.';

  @override
  String get signUpWithEmail => 'Sign up with email';

  @override
  String get alreadyHaveAccountQuestion => 'Already have an account?';

  @override
  String get logInAction => 'Log in';

  @override
  String get createYourAccountTitle => 'Create your account';

  @override
  String get createAccountSubtitle => 'Takes less than a minute.';

  @override
  String get usernameLabel => 'Username';

  @override
  String get emailLabel => 'Email';

  @override
  String get logInSubtitle => 'Log in to keep your rank.';

  @override
  String get checkYourEmailTitle => 'Check your email';

  @override
  String codeSentTo(String email) {
    return 'We sent a 6-digit code to $email.';
  }

  @override
  String get didntGetIt => 'Didn\'t get it?';

  @override
  String resendInSeconds(String time) {
    return 'Resend in $time';
  }

  @override
  String get wrongEmailGoBack => 'Wrong email? Go back';

  @override
  String get usernameTaken => 'That username is taken.';

  @override
  String get wrongCode => 'That code\'s wrong or expired.';

  @override
  String get resendCode => 'Resend code';

  @override
  String get codeResent => 'Sent a new code.';

  @override
  String signedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get addressNotKept =>
      'The address is used once and not stored — this account has no email on it.';

  @override
  String get requestMyData => 'Email my data';

  @override
  String exportSent(String address) {
    return 'Sent to $address';
  }

  @override
  String get deleteIntro =>
      'This erases everything permanently. It cannot be undone and we cannot restore it.';

  @override
  String get rankLabel => 'Rank';

  @override
  String get wantCopyFirst => 'Want a copy first?';

  @override
  String get wantCopyBody =>
      'Download your data before deleting. After this, it\'s gone.';

  @override
  String typeToConfirm(String word) {
    return 'Type $word to confirm';
  }

  @override
  String get deleteWord => 'DELETE';

  @override
  String get deletePermanently => 'Delete permanently';

  @override
  String get keepMyAccount => 'Keep my account';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get skip => 'Skip';

  @override
  String get yourPicture => 'Your picture';

  @override
  String get yourPictureHint =>
      'The frame comes from your rank and changes as you climb.';

  @override
  String get couldNotUsePicture => 'Could not use that picture';

  @override
  String get couldNotSyncAvatar =>
      'Your picture is saved, but it hasn\'t synced yet';

  @override
  String get couldNotShareCard => 'Could not share this card';

  @override
  String get couldNotOpenLink => 'Could not open that link';

  @override
  String get couldNotCheckUsername => 'Couldn\'t check that name — try again';

  @override
  String get changeUsername => 'Change username';

  @override
  String get usernameInvalidLength =>
      '4 to 20 characters: letters, numbers and _ only';

  @override
  String get usernameChanged => 'Username changed';

  @override
  String get usernameAlreadyChangedBody => 'A username can be changed once every 14 days.';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

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
  String get global => 'Global';

  @override
  String get topPlayers => 'Top Players';

  @override
  String get yourTier => 'Your Tier';

  @override
  String get challenge => 'Challenge';

  @override
  String get notifications => 'Notifications';

  @override
  String get start => 'Start';

  @override
  String get finish => 'Finish';

  @override
  String get reps => 'reps';

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
  String get language => 'Language';

  @override
  String get privacy => 'Privacy';

  @override
  String get data => 'Data';

  @override
  String get about => 'About';

  @override
  String get themeSystem => 'Match device';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get accept => 'Accept';

  @override
  String get visEveryone => 'Everyone';

  @override
  String get visFriends => 'Friends only';

  @override
  String get visNobody => 'Nobody';

  @override
  String get friendRequestsLabel => 'Friend requests';

  @override
  String get showOnLeaderboards => 'Show me on leaderboards';

  @override
  String get exportData => 'Export my data';

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
  String get deleteAccount => 'Delete account';

  @override
  String get needsServer => 'Couldn\'t connect. Check your internet and try again.';

  @override
  String get roomFriendly =>
      'Room matches are friendly — they do not affect your rank.';

  @override
  String get shareThisCode => 'Share this code';

  @override
  String get codeCopied => 'Code copied';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => 'Iron';

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
  String winLoss(String w, String l) {
    return '${w}W ${l}L';
  }

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
  String get ttl_bronze_tier => 'Out of the Iron';

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
  String get forfeitQ => 'Forfeit match?';

  @override
  String get forfeitBody => 'You will lose LP if you leave now.';

  @override
  String get forfeit => 'Forfeit';

  @override
  String get getReady => 'GET READY';

  @override
  String get you => 'You';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'BACK TO HOME';

  @override
  String get mgChest => 'Chest';

  @override
  String get nWonTitle => 'You won!';

  @override
  String nWonBody(String name, String muscle) {
    return 'You beat $name on $muscle day';
  }

  @override
  String get nFriendTitle => 'New friend request';

  @override
  String get nRacedTitle => 'Your set was raced';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name raced your set and fell short, $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name raced your set and won, $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => 'Friend request accepted';

  @override
  String nFriendOkBody(String name) {
    return '$name accepted your request';
  }

  @override
  String nFriendBody(String name) {
    return '$name wants to connect';
  }

  @override
  String get nChallengedTitle => 'Rematch';

  @override
  String nChallengedBody(String name) {
    return '$name wants a rematch';
  }

  @override
  String get challengeSentTitle => 'Challenge sent';

  @override
  String challengeSentBody(String name) {
    return 'We\'ll let $name know. Come back once they\'ve raced it.';
  }

  @override
  String get challengeNotSentTitle => 'Couldn\'t send that';

  @override
  String get challengeNotSentBody =>
      'Check your connection and try again from the match tab.';

  @override
  String get challengeGoneTitle => 'Challenge is gone';

  @override
  String get challengeGoneBody =>
      'It\'s already been raced, or it was withdrawn.';

  @override
  String repsRecordedLine(String reps) {
    return '$reps reps recorded';
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
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(String n) {
    return '${n}d ago';
  }

  @override
  String weeksAgo(String n) {
    return '${n}w ago';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get lpUnit => 'LP';

  @override
  String get trueCountHint => 'e.g. 12';

  @override
  String get couldNotSaveSession => 'Could not save the session';

  @override
  String lpOutOf(String total) {
    return '/ $total LP';
  }

  @override
  String get noFriendsTitle => 'No friends yet';

  @override
  String get noFriendsBody => 'Duels hit different against someone you know.';

  @override
  String get decline => 'Decline';

  @override
  String requestSent(String name) {
    return 'Request sent to $name';
  }

  @override
  String nowFriends(String name) {
    return 'You and $name are friends now';
  }

  @override
  String get noOneFound => 'Nobody goes by that name';

  @override
  String get noMatchesTitle => 'No matches yet';

  @override
  String get noMatchesBody => 'Your first one shows up here, win or lose.';

  @override
  String get noNotificationsTitle => 'Nothing new';

  @override
  String get noNotificationsBody =>
      'Match invites, results and friend requests land here.';

  @override
  String get countedThat => 'Counted that round';

  @override
  String get thatIsRight => 'That\'s right';

  @override
  String get useMyCount => 'Use my count';

  @override
  String get confirmHint => 'Change it if the camera got it wrong.';

  @override
  String get unsureMovement =>
      'Not sure this was the right movement — check the number.';

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
  String get searchByUsername => 'Search by username';

  @override
  String get incomingRequests => 'Incoming requests';

  @override
  String get noRequestsWaiting => 'No requests waiting right now';

  @override
  String get addFriendAction => 'Add Friend';

  @override
  String get addFriendHint =>
      'Enter their username, or the #code from their profile.';

  @override
  String get usernameOrCode => 'Username or #code';

  @override
  String get sendRequest => 'Send request';

  @override
  String onlineNowCount(String count) {
    return 'Online now · $count';
  }

  @override
  String offlineCount(String count) {
    return 'Offline · $count';
  }

  @override
  String get invite => 'Invite';

  @override
  String get headToHeadTitle => 'Head to head';

  @override
  String get vsYouCaption => 'vs you';

  @override
  String get h2hYou => 'you';

  @override
  String get h2hThem => 'them';

  @override
  String headToHead(String wins, String losses) {
    return '${wins}W ${losses}L vs you';
  }

  @override
  String get neverPlayedYou => 'Never played you';

  @override
  String noHistoryWithThem(String username) {
    return 'You haven\'t raced $username yet.';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return 'Last time: $yourReps–$theirReps, $when.';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return 'Your best against them is $reps.';
  }

  @override
  String get viewFullProfile => 'View full profile';

  @override
  String get moreOptions => 'More options';

  @override
  String get block => 'Block';

  @override
  String get blockRowBody => 'They can\'t challenge you or see your profile';

  @override
  String get report => 'Report';

  @override
  String get reportRowBody => 'Reviewed within 24 hours';

  @override
  String muteChallenges(String username) {
    return 'Mute challenges from $username';
  }

  @override
  String blockedLifter(String username) {
    return 'Blocked $username';
  }

  @override
  String mutedLifter(String username) {
    return 'Muted $username';
  }

  @override
  String get addFriendButton => 'Add friend';

  @override
  String get alreadyFriends => 'Friends';

  @override
  String get couldNotLoadProfile => 'Couldn\'t load this profile';

  @override
  String get noFriendsMatch => 'Nobody by that name';

  @override
  String get yourClimb => 'Your climb';

  @override
  String floorKept(String tier, String rank) {
    return '$tier is yours. You can\'t drop below $rank.';
  }

  @override
  String dayStreakCount(String count) {
    return '$count day streak';
  }

  @override
  String get findMatch => 'Find a match';

  @override
  String rankedTerms(String seconds) {
    return '$seconds seconds · ranked';
  }

  @override
  String get practiceTerms => 'Practice — no rank, no opponent';

  @override
  String get practiceComplete => 'PRACTICE COMPLETE';

  @override
  String get noRankYet => 'No rank yet';

  @override
  String get unranked => 'Unranked';

  @override
  String get practiceFirst => 'Practice first';

  @override
  String get noConnection => 'No connection';

  @override
  String get practiceOffline => 'Practice offline';

  @override
  String get retry => 'Retry';

  @override
  String get youWonPlain => 'You won';

  @override
  String get cameraNeededTitle => 'Camera access needed';

  @override
  String get cameraNeededBody =>
      'outrepd counts your reps by watching your body move. Pose detection runs on your device and nothing is uploaded.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get allowCamera => 'Allow camera';

  @override
  String get notNow => 'Not now';

  @override
  String get noCameraTitle => 'No camera found';

  @override
  String get noCameraBody =>
      'Reps are counted from the camera, so this device cannot score a duel. Everything else still works.';

  @override
  String get noConnectionBody =>
      'You need a connection to duel. Practice still works offline and your reps will sync later.';

  @override
  String get getBackInFrame => 'Get back in frame';

  @override
  String get clockStillRunning =>
      'The clock is still running. Reps are not counting.';

  @override
  String get giveUp => 'Give up';

  @override
  String get lpMovesWithGap =>
      'LP moves with the rep gap — win by more, gain more';

  @override
  String get searchingForOpponent => 'Searching for an opponent';

  @override
  String get getIntoPosition => 'Get into position';

  @override
  String get framingHint => 'Wrists and ankles must be in frame';

  @override
  String get goUp => 'Go up';

  @override
  String get goDown => 'Go down';

  @override
  String get bestSet => 'Best set';

  @override
  String get record => 'Record';

  @override
  String get last7Days => 'Last 7 days';

  @override
  String repsCount(String count) {
    return '$count reps';
  }

  @override
  String get viewAll => 'View all';

  @override
  String get shareProfile => 'Share profile';

  @override
  String get share => 'Share';

  @override
  String get duelMeOnOutrepd => 'Duel me on outrepd';

  @override
  String get shareStory => 'Story';

  @override
  String get sharePost => 'Post';

  @override
  String get copyLink => 'Copy';

  @override
  String get linkCopied => 'Link copied';

  @override
  String get currentRankLabel => 'Current rank';

  @override
  String get winInitial => 'W';

  @override
  String get lossInitial => 'L';

  @override
  String get dayInitial => 'd';

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline =>
      'Push-up battles. Your phone counts. Someone else is counting too.';

  @override
  String get obGetStarted => 'Get started';

  @override
  String get obHaveAccount => 'I already have an account';

  @override
  String get obTwoThings => 'Two quick things.';

  @override
  String get obAgeQuestion => 'How old are you?';

  @override
  String get obHealthConsent =>
      'I understand outrepd counts reps and does not give medical or training advice. I’ll stop if something hurts.';

  @override
  String get obTermsIntro => 'By continuing you agree to the';

  @override
  String get obTerms => 'Terms';

  @override
  String get obAnd => 'and';

  @override
  String get obPrivacy => 'Privacy Policy';

  @override
  String get obCameraTitle => 'outrepd needs your camera';

  @override
  String get obCameraBody =>
      'It watches your body move to count reps. There is no other way to do it.';

  @override
  String get obCameraPrivateTitle => 'Nothing leaves your phone';

  @override
  String get obCameraPrivateBody =>
      'Body tracking runs on this device. No video is ever saved or uploaded.';

  @override
  String get obWhyNeeded => 'Why is this needed?';

  @override
  String get obPlacementTitle => 'Set your phone on the floor';

  @override
  String get obPlacementBody =>
      'Lean it against a wall about a metre in front of you.';

  @override
  String get obCheckHandsFeet => 'Head, shoulders and hands in frame';

  @override
  String get obCheckFacing => 'Facing the phone, not sideways';

  @override
  String get obCheckLight => 'Room light on';

  @override
  String get obImSetUp => 'I’m set up';

  @override
  String get obFramingTitle => 'Get into a push-up position';

  @override
  String get obFramingShoulders => 'Shoulders and hips';

  @override
  String get obFramingWrists => 'Wrists';

  @override
  String get obLooksGood => 'Looks good';

  @override
  String get obCalibrating => 'Calibrating';

  @override
  String get obOneMoreRep => 'One more to learn your range';

  @override
  String get obCalibrationHint => 'Do three push-ups at your normal depth';

  @override
  String get obCalibrated => 'Calibrated.';

  @override
  String get obCalibratedBody =>
      'outrepd knows your range now. Depth is measured against you, not a fixed number.';

  @override
  String get obRepsCounted => 'Reps counted';

  @override
  String get obAverageDepth => 'Average depth';

  @override
  String get obForm => 'Form';

  @override
  String get obFormClean => 'Clean';

  @override
  String get obAvailable => 'Available';

  @override
  String get obTaken => 'Taken';

  @override
  String get obGotIt => 'Got it';

  @override
  String get obFormMixed => 'Mixed';

  @override
  String get justNow => 'Just now';

  @override
  String get counterAccuracy => 'Counter accuracy';

  @override
  String get counterAccuracyCaption => 'How close the camera gets';

  @override
  String measuredOverSets(String count) {
    return 'Measured over $count sets';
  }

  @override
  String get accExact => 'Exact';

  @override
  String get accWithinOne => 'Within 1 rep';

  @override
  String get accAverageMiss => 'Average miss';

  @override
  String get accTendsTo => 'Tends to';

  @override
  String get accCountsHigh => 'count high';

  @override
  String get accCountsLow => 'count low';

  @override
  String get accCountsEven => 'neither high nor low';

  @override
  String get accWorstMiss => 'Worst miss';

  @override
  String get accNothingYet => 'Nothing measured yet';

  @override
  String get accNothingYetBody =>
      'Every time you confirm a count after a practice set, that set is measured against what you said it was. The number appears here.';

  @override
  String accNeedMore(String count) {
    return 'Early days. About $count more sets before this number means much.';
  }

  @override
  String get accRecentSets => 'Recent sets';

  @override
  String get accCameraSaid => 'Camera';

  @override
  String get accYouSaid => 'You';

  @override
  String get accHowItWorks =>
      'These come from you, on this phone. Nothing is sent anywhere.';

  @override
  String levelNumber(String n) {
    return 'Level $n';
  }

  @override
  String get youLostPlain => 'You lost';

  @override
  String get rematch => 'Rematch';

  @override
  String get shareAction => 'Share';

  @override
  String get doneAction => 'Done';

  @override
  String get continueAction => 'Continue';

  @override
  String get promotedLabel => 'Promoted';

  @override
  String get highestReached => 'Highest you\'ve reached';

  @override
  String repsOff(String n) {
    return '$n reps off.';
  }

  @override
  String get closestYet => 'Closest match yet.';

  @override
  String repsAhead(String n) {
    return '$n reps ahead.';
  }

  @override
  String get winnerLabel => 'Winner';

  @override
  String get newPersonalBest => 'New personal best';

  @override
  String get cantReachServer =>
      'Couldn\'t reach the server. Check your connection and try again.';

  @override
  String pushUpsInSeconds(String seconds) {
    return 'Push-ups in $seconds seconds';
  }

  @override
  String beatOpponent(String name, String score) {
    return 'Beat $name $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return 'Lost to $name $score';
  }

  @override
  String get thinkYouCanBeatMe => 'Think you can beat me?';

  @override
  String get usernameNotAllowed => 'That name isn\'t allowed. Try another one.';

  @override
  String get yourBest => 'Your best';

  @override
  String get theClock => 'The clock';

  @override
  String get nobodyFreeRaceBest =>
      'Nobody near your rank is free right now. Race your best instead. This one doesn\'t move your rank.';

  @override
  String get nobodyFreeFirstScore =>
      'Nobody near your rank is free right now. Set your first score. This one doesn\'t move your rank.';

  @override
  String bestStillIs(String count) {
    return 'Your best is still $count';
  }

  @override
  String get setInPoolTitle => 'Your set is in the pool';

  @override
  String get setInPoolBody =>
      'The next lifter near your rank races it. You\'ll see who won in Notifications, and your rank moves then.';

  @override
  String get obWhyNeededBody =>
      'Each rep is judged by how low you go and how high you come back up, and only the camera can see that. Without it there is no count, and without a count there is no duel. The camera is only on during a set.';

  @override
  String get obWelcomeBack => 'Welcome back';

  @override
  String obTitlesHeading(String count) {
    return '$count titles to earn';
  }

  @override
  String get obTitlesBody =>
      'For wins, streaks, clean sets, early mornings and more. Wear one under your name.';

  @override
  String get obFriendsHeading => 'Settle it with friends';

  @override
  String get obFriendsBody =>
      'Friends add you with this code. Challenge them whenever you like, and the score between you is kept.';

  @override
  String get obLetsGo => 'Let’s go';

  @override
  String get paywallTitle => 'Climb from Iron to Master';

  @override
  String get paywallPerkDuels => 'Camera-judged duels';

  @override
  String get paywallPerkLadder => 'Live ranked ladder';

  @override
  String get paywallPerkFriends => 'Friends and challenges';

  @override
  String get paywallPerkHistory => 'Every rep of every match';

  @override
  String get paywallYearly => 'Yearly';

  @override
  String get paywallWeekly => 'Weekly';

  @override
  String paywallPerWeek(String price) {
    return '${price}/week';
  }

  @override
  String get paywallEveryWeek => 'per week';

  @override
  String paywallSave(String percent) {
    return 'Save ${percent}%';
  }

  @override
  String get paywallStart => 'Remove ads';

  @override
  String get paywallRenewsPlay => 'Renews automatically until you cancel. Cancel anytime in Google Play.';

  @override
  String get paywallRenewsApple => 'Renews automatically until you cancel. Cancel anytime in your Apple account settings.';

  @override
  String get paywallRestore => 'Restore';

  @override
  String get paywallTerms => 'Terms';

  @override
  String get paywallPrivacy => 'Privacy';

  @override
  String get paywallLoadFailed => 'Couldn\'t load the plans. Check your connection and try again.';

  @override
  String get paywallBuyFailed => 'The purchase didn\'t go through. Try again.';

  @override
  String get paywallPending => 'Your payment is pending. Everything unlocks as soon as the store confirms it.';

  @override
  String get paywallNothingToRestore => 'No subscription found to restore.';

  @override
  String get paywallRestored => 'Subscription restored';

  @override
  String paywallSignedInAs(String email) {
    return 'Signed in as ${email}';
  }

  @override
  String get deleteKeepsSubscription => 'Deleting your account doesn\'t cancel your subscription: the store bills it, not outrepd. Cancel it first in Google Play or in your Apple account settings.';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutQuestion => 'Sign out?';

  @override
  String get signOutBody => 'Your account stays as it is, with its rank, history and subscription. Sign back in any time the way you signed in.';

  @override
  String get shareVictory => 'VICTORY';

  @override
  String get shareRematch => 'REMATCH?';

  @override
  String friendCodeInvite(String code) {
    return 'Duel me on outrepd. Add me with my friend code ${code}\nhttps://outrepd.com';
  }

  @override
  String get soundsLabel => 'Sounds';

  @override
  String get soundsHint => 'A beep for 3, 2, 1, a tick for each rep, and the end of the round. Plays over your music.';

  @override
  String get phoneSection => 'On this phone';

  @override
  String get allowNotifications => 'Allow notifications';

  @override
  String get allowNotificationsHint => 'They\'re off for OUTREPD in your phone\'s settings, so nothing below can reach you.';

  @override
  String get remindersSection => 'Reminder';

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String get dailyReminderHint => 'Only on days you haven\'t met your goal yet.';

  @override
  String get reminderTime => 'Time';

  @override
  String get reminderTitle => 'Time for today\'s push-ups';

  @override
  String reminderStreakBody(String count) {
    return 'Keep your ${count}-day streak going. One set is enough.';
  }

  @override
  String get channelMatches => 'Matches and friends';

  @override
  String get channelReminders => 'Daily reminder';

  @override
  String get liveTag => 'Live';

  @override
  String get reconnecting => 'Reconnecting';

  @override
  String get rankedLive => 'Ranked · live';

  @override
  String get lookingForLive => 'Looking for a live opponent';

  @override
  String ofTime(String time) {
    return 'of ${time}';
  }

  @override
  String liveFallbackAt(String time) {
    return 'At ${time} you race a saved set instead';
  }

  @override
  String liveFoundBody(String name) {
    return '${name} is on the camera now. Same clock, same start.';
  }

  @override
  String get nobodyLiveTitle => 'Nobody\'s live right now';

  @override
  String get nobodyLiveBody => 'You\'ll race a saved set instead';

  @override
  String didRepsIn(String reps) {
    return 'Did ${reps} in 60 seconds';
  }

  @override
  String get sameRankPoints => 'Same rank points as a live match';

  @override
  String get raceIt => 'Race it';

  @override
  String get onlineNow => 'Online now';

  @override
  String get friendlyNoRank => 'Friendly · no rank';

  @override
  String waitingForName(String name) {
    return 'Waiting for ${name}';
  }

  @override
  String get weSentThemANotice => 'We sent them a notification';

  @override
  String get untilInviteRunsOut => 'until the invite runs out';

  @override
  String get cancelInvite => 'Cancel invite';

  @override
  String inviteDeclined(String name) {
    return '${name} said not now';
  }

  @override
  String get inviteRanOut => 'The invite ran out';

  @override
  String get inviteAgain => 'Invite again';

  @override
  String liveInviteFrom(String name) {
    return '${name} is live';
  }

  @override
  String timeLeft(String time) {
    return '${time} left';
  }

  @override
  String get joinLive => 'Join';

  @override
  String get nLiveTitle => 'Live invite';

  @override
  String nLiveBody(String name) {
    return '${name} wants to go live';
  }

  @override
  String get inviteGone => 'That invite has run out';

  @override
  String opponentDropped(String name) {
    return '${name}\'s connection dropped. Keep going: the round finishes on the clock.';
  }

  @override
  String opponentGaveUp(String name) {
    return '${name} gave up. Finish the round to take the win.';
  }

  @override
  String get calledOffTitle => 'Match called off';

  @override
  String calledOffBody(String name) {
    return '${name} didn\'t get into position in time. Nothing was recorded.';
  }

  @override
  String waitingForFinal(String name) {
    return 'Waiting for ${name}\'s final count…';
  }

  @override
  String get wantsToBeFriends => 'wants to be friends';

  @override
  String get giveUpQuestion => 'Give up this round?';

  @override
  String get giveUpBody => 'It counts as a loss, whatever your count is now.';

  @override
  String waitingToJoin(String name) {
    return 'Waiting for ${name} to join';
  }

  @override
  String get removeFriend => 'Remove friend';

  @override
  String get removeFriendBody => 'They aren\'t told, and you can add each other again';

  @override
  String removeFriendQuestion(String username) {
    return 'Remove ${username} from your friends?';
  }

  @override
  String get removeAction => 'Remove';

  @override
  String removedFriend(String username) {
    return 'Removed ${username} from your friends';
  }

  @override
  String get noticeChallenged => 'Someone challenged me to a rematch';

  @override
  String get noticeLiveInvite => 'A friend asked me to go live';

  @override
  String get trialToday => 'Today';

  @override
  String get trialTodayBody => 'Every duel, live and ranked, unlocked.';

  @override
  String trialDay(String day) {
    return 'Day ${day}';
  }

  @override
  String get trialReminderBody => 'We\'ll remind you the day before your trial ends.';

  @override
  String get trialEndBody => 'Your plan starts. Cancel any time before and you pay nothing.';

  @override
  String trialTag(String days) {
    return '${days} days free';
  }

  @override
  String trialCta(String days) {
    return 'Start my ${days}-day free trial';
  }

  @override
  String trialThenYearly(String price) {
    return 'No payment now · then ${price}/year';
  }

  @override
  String trialThenWeekly(String price) {
    return 'No payment now · then ${price}/week';
  }

  @override
  String get trialEndsTitle => 'Your free trial ends tomorrow';

  @override
  String get trialEndsBody => 'Keep climbing, or cancel before then in your subscription settings.';

  @override
  String get obIdeaTitle => '60 seconds. One opponent.';

  @override
  String get obIdeaRival => 'A real person, live or their recorded set';

  @override
  String get obIdeaCamera => 'Your camera counts every rep, on your phone';

  @override
  String get thisMonth => 'This Month';

  @override
  String shortDays(String n) {
    return '${n}d';
  }

  @override
  String shortHours(String n) {
    return '${n}h';
  }

  @override
  String get awardChampion => 'Champion';

  @override
  String get awardPodium => 'Podium';

  @override
  String get awardTop10 => 'Top 10';

  @override
  String get awardRegular => '20 Club';

  @override
  String monthToTop10(String lp) {
    return '${lp} LP to the top 10';
  }

  @override
  String monthIfEndedNow(String award) {
    return '${award} if the month ended now';
  }

  @override
  String get monthJoinHint => 'Play a ranked duel to get on this month\'s board';

  @override
  String monthRegularProgress(String progress) {
    return '20 Club badge · ${progress} ranked duels';
  }

  @override
  String get monthRegularEarned => '20 Club badge earned this month';

  @override
  String get monthEmptyTitle => 'A fresh month';

  @override
  String get monthEmptyBody => 'Nobody has won LP this month yet. Win the first ranked duel and you lead.';

  @override
  String rankedDuelsCount(String n) {
    return '${n} ranked duels';
  }

  @override
  String get monthlyAwards => 'Monthly awards';

  @override
  String get seasonOver => 'Season over';

  @override
  String get seasonOverBody => 'It\'s on your profile now. The new month starts from zero.';

  @override
  String get seasonPlayCta => 'Play the new month';

  @override
  String get rematchLive => 'Rematch live';

  @override
  String rematchWaiting(String name) {
    return 'Waiting for ${name}';
  }

  @override
  String rematchAsked(String name) {
    return '${name} wants a rematch';
  }

  @override
  String get rematchGone => 'No rematch this time';

  @override
  String get twoRankedADay => 'Friendly · 2 ranked a day with the same lifter';

  @override
  String monthMove(String move) {
    return 'This month · ${move}';
  }

  @override
  String promotedFrom(String rank) {
    return 'from ${rank}';
  }

  @override
  String liveOnlineNow(String n) {
    return '${n} online now';
  }

  @override
  String liveSearchingNow(String n) {
    return '${n} searching';
  }

  @override
  String get dailyGoalTitle => 'Today\'s goal';

  @override
  String get dailyGoalDone => 'Done for today';

  @override
  String dailyGoalProgress(String progress) {
    return '${progress} push-ups';
  }

  @override
  String dailyGoalLeft(String n) {
    return '${n} to go';
  }

  @override
  String get dailyGoalChange => 'Change';

  @override
  String get dailyGoalPick => 'Your daily goal';

  @override
  String dailyGoalOption(String n) {
    return '${n} push-ups a day';
  }

  @override
  String widgetGoalOf(String goal) {
    return 'of ${goal} today';
  }

  @override
  String get saveToAppleHealth => 'Save workouts to Apple Health';

  @override
  String get saveToHealthConnect => 'Save workouts to Health Connect';

  @override
  String get saveToHealthHint => 'Every set you lift is added as a strength workout. Nothing is read back.';

  @override
  String get healthNotAllowed => 'Not allowed yet. You can allow it in your phone\'s health settings.';

  @override
  String reminderLeft(String count) {
    return '${count} push-ups left for today\'s goal.';
  }

  @override
  String get liveInviteHint => 'Online friends can join right away. The rest get a notice and a minute to join.';

  @override
  String get requestSentShort => 'Request sent';

  @override
  String healthWorksWith(String health) {
    return 'OUTREPD works with ${health}';
  }

  @override
  String healthCardBody(String health) {
    return 'Every set you finish is saved to ${health} as a strength workout. OUTREPD never reads your health data.';
  }

  @override
  String savedToHealth(String health) {
    return 'Saved to ${health}';
  }

  @override
  String get usernameTooShort => 'Too short: at least 4 characters';

  @override
  String get usernameBadCharacters => 'Only letters, numbers and _';

  @override
  String get usernameNeedsLetter => 'Add at least one letter or number';

  @override
  String usernameChangeAgainOn(String date) {
    return 'You can change it again on ${date}';
  }

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get socialSignInFailed => 'Couldn\'t sign in. Try again.';

  @override
  String get chooseUsernameTitle => 'Choose your username';

  @override
  String get chooseUsernameSubtitle => 'It\'s how other lifters find you and see you on the boards.';

  @override
  String get authHeroTitle => 'OUT-REP ANYONE.';

  @override
  String get authHeroSubtitle => 'Live push-up duels, counted by your camera.';

  @override
  String get createAccountPitch => 'Your rank, your duels, on every phone.';

  @override
  String get usernameSpacesHint => 'Spaces become _';

  @override
  String get emailCodeNote => 'We\'ll email you a 6-digit code. No password.';

  @override
  String get continueWithEmail => 'Continue with email';

  @override
  String get thisSeason => 'This Season';

  @override
  String get thisWeek => 'This week';

  @override
  String get weekStartsAgain => 'Starts again every Monday';

  @override
  String get lengthWeek => 'Week';

  @override
  String get lengthMonth => 'Month';

  @override
  String get weekJoinHint => 'Win a ranked duel this week to get on the board';

  @override
  String get weekInTop3 => 'In the top 3 this week';

  @override
  String weekToTop3(String n) {
    return '${n} LP to the top 3';
  }

  @override
  String get boardActiveNote => 'Players active in the last 30 days';

  @override
  String get boardTieNote => 'ties: more wins first';

  @override
  String lpBreakdown(String reps, String adjust, String rank) {
    return '${reps} for the reps · ${adjust} for a ${rank} opponent';
  }

  @override
  String levelShort(String n) {
    return 'Lv ${n}';
  }

  @override
  String xpOf(String into, String span) {
    return '${into} / ${span} XP';
  }

  @override
  String xpToLevel(String n, String level) {
    return '${n} XP to Level ${level}';
  }

  @override
  String xpHow(String rep, String match) {
    return '${rep} XP a rep, ${match} a match';
  }

  @override
  String xpGained(String n) {
    return '+${n} XP';
  }

  @override
  String xpForReps(String n) {
    return '${n} for the reps';
  }

  @override
  String xpForMatch(String n) {
    return '${n} for the match';
  }

  @override
  String get levelUp => 'Level up';

  @override
  String get levelUpBody => 'Every rep counts. Keep going.';

  @override
  String giveUpAhead(String n) {
    return 'You\'re ${n} ahead';
  }

  @override
  String giveUpBehind(String n) {
    return 'You\'re ${n} behind';
  }

  @override
  String get giveUpTied => 'Tied';

  @override
  String get keepGoing => 'Keep going';

  @override
  String get stay => 'Stay';

  @override
  String lastN(String n) {
    return 'Last ${n}';
  }

  @override
  String get firstMatchForTier => 'Play your first match to get on the ladder. Everyone starts at Iron V.';

  @override
  String get firstMatchForBoard => 'Play your first match to get on the board. Everyone starts at Iron V.';

  @override
  String get playFirstMatch => 'Play first match';

  @override
  String firstMatchTerms(String seconds) {
    return 'One match · ${seconds} seconds';
  }

  @override
  String get placedLabel => 'You\'re on the ladder';

  @override
  String get placedBody => 'Everyone starts here. Only wins move you up.';

  @override
  String get placedHow => 'Win matches to earn LP. Beat someone ranked higher for more.';

  @override
  String get levelBesideName => 'Beside your name, everywhere';

  @override
  String get weekRaceTitle => 'This week\'s race';

  @override
  String get streakDoneToday => 'done today';

  @override
  String get streakTrainToday => 'train today to add a day';

  @override
  String get raceChartTitle => 'How the minute went';

  @override
  String raceYouLead(String time) {
    return '${time} · you took the lead';
  }

  @override
  String raceTheyLead(String time, String name) {
    return '${time} · ${name} took the lead';
  }

  @override
  String get bringFriendTitle => 'Bring a friend';

  @override
  String get bringFriendBody => 'Send your link. It opens your profile, where they can add you.';

  @override
  String get bringFriendShare => 'Share my link';

  @override
  String get bringFriendShareText => 'Race me at push-ups on OUTREPD. 60 seconds, live, and the camera counts.';

  @override
  String orFriendCode(String code) {
    return 'or friend code ${code}';
  }

  @override
  String get countryPickerTitle => 'Your country';

  @override
  String get countrySearch => 'Search';

  @override
  String get countryFromPhone => 'From your phone';

  @override
  String get countryAll => 'All countries';

  @override
  String get countryChoose => 'Choose your country';

  @override
  String get countryChange => 'Change';

  @override
  String get countryForBoard => 'For your country\'s leaderboard';

  @override
  String get countryLabel => 'Country';

  @override
  String get countryChanged => 'Country changed';

  @override
  String get countryEvery14 => 'Once every 14 days, like your name';

  @override
  String get countryNotSaved => 'Couldn\'t save your country. Try again.';

  @override
  String get adventure => 'Adventure';

  @override
  String stageNumber(String n) {
    return 'Level ${n}';
  }

  @override
  String adventureLevelIn(String level, String world) {
    return 'Level ${level} · ${world}';
  }

  @override
  String adventureClearedOf(String cleared, String total) {
    return '${cleared} of ${total} cleared · no rank';
  }

  @override
  String get worldIron => 'Iron Mines';

  @override
  String get worldBronze => 'Bronze Dunes';

  @override
  String get worldSilver => 'Silver Peaks';

  @override
  String get worldGold => 'Gold Citadel';

  @override
  String get worldPlatinum => 'Platinum Glacier';

  @override
  String get worldDiamond => 'Diamond Caverns';

  @override
  String get worldMaster => 'Master’s Throne';

  @override
  String worldNumber(String n) {
    return 'World ${n}';
  }

  @override
  String fightLevel(String level) {
    return 'Fight level ${level}';
  }

  @override
  String levelHpLine(String hp, String reps) {
    return 'HP ${hp} · about ${reps} push-ups';
  }

  @override
  String get hpShort => 'HP';

  @override
  String comboTag(String n) {
    return 'COMBO ×${n}';
  }

  @override
  String get levelCleared => 'CLEARED';

  @override
  String get outOfTime => 'OUT OF TIME';

  @override
  String get statPushUps => 'push-ups';

  @override
  String get statTimeLeft => 'left';

  @override
  String get statHpLeft => 'HP left';

  @override
  String get statXp => 'XP';

  @override
  String secondStarHint(String seconds) {
    return 'Finish with ${seconds} seconds left for the second star';
  }

  @override
  String thirdStarHint(String seconds) {
    return 'Finish with ${seconds} seconds left for the third star';
  }

  @override
  String get fightLostHint => 'Win earlier levels again for more stars: they unlock stronger weapons.';

  @override
  String get nextLevel => 'Next level';

  @override
  String get tryAgain => 'Try again';

  @override
  String get adventureMap => 'Map';

  @override
  String get nextKicker => 'NEXT';

  @override
  String nextLevelLine(String level, String hp) {
    return 'Level ${level} · HP ${hp}';
  }

  @override
  String get armory => 'Armory';

  @override
  String get armoryBody => 'Stars unlock weapons. Each world’s monsters only take hits from its own weapon or better.';

  @override
  String get equipped => 'EQUIPPED';

  @override
  String perPushUp(String damage) {
    return '${damage} per push-up';
  }

  @override
  String damagePerPushUp(String damage) {
    return '${damage} damage per push-up';
  }

  @override
  String wasWith(String damage, String weapon) {
    return 'was ${damage} with ${weapon}';
  }

  @override
  String moreStars(String count) {
    return '${count} more stars';
  }

  @override
  String get newWeapon => 'New weapon';

  @override
  String starsKicker(String count) {
    return '${count} STARS';
  }

  @override
  String get weaponGauntlets => 'Iron Gauntlets';

  @override
  String get weaponKnuckles => 'Bronze Knuckles';

  @override
  String get weaponFang => 'Silver Fang';

  @override
  String get weaponHammer => 'Gold Hammer';

  @override
  String get weaponAxe => 'Platinum Axe';

  @override
  String get weaponSpear => 'Diamond Spear';

  @override
  String get weaponSword => 'Master Sword';

  @override
  String get weaponCrownbreaker => 'Crownbreaker';

  @override
  String clearFirst(String level) {
    return 'Win level ${level} first';
  }

  @override
  String needsWeapon(String weapon) {
    return 'Needs ${weapon}';
  }

  @override
  String hurtOnlyBy(String weapon) {
    return 'Only ${weapon} or better can hurt it';
  }

  @override
  String worldNeedsWeapon(String world, String weapon, String count) {
    return '${world} needs ${weapon} · ${count} more stars';
  }

  @override
  String rematchOpponentLeft(String name) {
    return '${name} left · no rematch this time';
  }

  @override
  String get obNext => 'Next';

  @override
  String get obRaceTitle => 'Race a real person.';

  @override
  String get obRaceBody => 'Most reps in 60 seconds wins. Live, on their own phone — or their recorded set when nobody is online.';

  @override
  String get obRepsTitle => 'Only full reps count.';

  @override
  String get obRepsBody => 'Your camera watches how low you go and how high you come back.';

  @override
  String get obRepsDown => 'Down past the gold line';

  @override
  String get obRepsUp => 'Back up past the top line';

  @override
  String get obRepsBoth => 'Both, with your hands on the floor. A half rep is not a rep — on your phone or theirs.';

  @override
  String get obClimbTitle => 'Climb to Master.';

  @override
  String get obClimbBody => 'Win to move up the ladder: seven tiers, five steps each.';

  @override
  String get obAdventureTitle => 'Training alone?';

  @override
  String get obAdventureBody => 'Adventure has 140 levels of push-up fights, each harder than the last.';

  @override
  String get obCountedHere => 'Counted on this phone';

  @override
  String get obGoldLine => 'gold line';

  @override
  String obCalibrationRule(String gold) {
    return 'Down past the ${gold}, back up past the top one';
  }

  @override
  String get proTitleTop => 'No ads.';

  @override
  String get proTitleBottom => 'Just push-ups.';

  @override
  String get proBody => 'Every match stays free. Pro takes the ads out of all of them.';

  @override
  String get proThanks => 'Ads are off. Thanks for going Pro.';

  @override
  String get removeAds => 'Remove ads';

  @override
  String get adNotice => 'An ad plays when you leave';

  @override
  String get adAskTitle => 'Ads keep outrepd free';

  @override
  String get adAskBody => 'Next, your iPhone asks whether apps may use your activity to choose ads. Say yes and the ads fit you better; say no and you still get ads, just less relevant ones.';

  @override
  String get adAskCamera => 'Your camera is never part of it: body tracking stays on this phone, whatever you choose.';

  @override
  String get adAskRemove => 'Remove ads instead';

  @override
  String get monsterIronColossus => 'Iron Colossus';

  @override
  String get monsterScarab => 'Scarab';

  @override
  String get monsterScarabPharaoh => 'Scarab Pharaoh';

  @override
  String get monsterYeti => 'Yeti';

  @override
  String get monsterFrostYeti => 'Frost Yeti';

  @override
  String get monsterYetiChieftain => 'Yeti Chieftain';

  @override
  String get monsterGoldSoldier => 'Gold Soldier';

  @override
  String get monsterGoldKnight => 'Gold Knight';

  @override
  String get monsterGoldKing => 'Gold King';

  @override
  String get monsterWisp => 'Wisp';

  @override
  String get monsterWraith => 'Wraith';

  @override
  String get monsterFrostLich => 'Frost Lich';

  @override
  String get monsterCrystalDrake => 'Crystal Drake';

  @override
  String get monsterCrystalDragon => 'Crystal Dragon';

  @override
  String get monsterDiamondWyrm => 'Diamond Wyrm';

  @override
  String get monsterShadowGuard => 'Shadow Guard';

  @override
  String get monsterShadowKnight => 'Shadow Knight';

  @override
  String get monsterTheMaster => 'The Master';

  @override
  String get monsterPebbleGolem => 'Pebble Golem';

  @override
  String get monsterStoneGolem => 'Stone Golem';

  @override
  String get monsterOreGolem => 'Ore Golem';

  @override
  String get monsterMinerGolem => 'Miner Golem';

  @override
  String get monsterScarabGrub => 'Scarab Grub';

  @override
  String get monsterHornedScarab => 'Horned Scarab';

  @override
  String get monsterScarabWarrior => 'Scarab Warrior';

  @override
  String get monsterYetiCub => 'Yeti Cub';

  @override
  String get monsterHornedYeti => 'Horned Yeti';

  @override
  String get monsterGoldRecruit => 'Gold Recruit';

  @override
  String get monsterGoldGuard => 'Gold Guard';

  @override
  String get monsterShade => 'Shade';

  @override
  String get monsterIceSpecter => 'Ice Specter';

  @override
  String get monsterCrystalHatchling => 'Crystal Hatchling';

  @override
  String get monsterCrystalWhelp => 'Crystal Whelp';

  @override
  String get monsterShadowSquire => 'Shadow Squire';

  @override
  String get monsterShadowLord => 'Shadow Lord';

  @override
  String monsterWarden(String name) {
    return '${name} Warden';
  }

  @override
  String get obPhoneSees => 'What your phone should see';

  @override
  String get obPhoneSeesBody => 'From the top of your head to your hands, about a metre away, in a push-up.';

  @override
  String get obUnder13 => 'Under 13';

  @override
  String get obOver13 => '13 or over';

  @override
  String get obFor13 => 'outrepd is for 13 and over.';

  @override
  String get obUnder13Blocked => 'outrepd is for 13 and over. Come back when you get there — the push-ups will still be here.';

  @override
  String get obBeforeYouLift => 'Before you lift';
}
