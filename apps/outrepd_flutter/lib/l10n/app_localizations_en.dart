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
  String get passwordHint => 'Password';

  @override
  String get codeHint => 'Verification code';

  @override
  String get createAccountTitle => 'Create account';

  @override
  String get createAccountBody =>
      'Add an email and password so this account is never just one phone away from gone.';

  @override
  String get createAccountAction => 'Create account';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get signInBody =>
      'Sign in with the email and password on your account.';

  @override
  String get signInAction => 'Sign in';

  @override
  String get switchToSignIn => 'Already have an account? Sign in';

  @override
  String get switchToSignUp => 'New here? Create an account';

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
  String get orDivider => 'or';

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
  String get usernameHint => 'Username';

  @override
  String get usernameLabel => 'Username';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordMinLength => 'At least 8 characters';

  @override
  String get logInSubtitle => 'Log in to keep your rank.';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String resetPasswordSent(String email) {
    return 'If an account exists for $email, a reset link is on its way.';
  }

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
  String get socialLinkFailed => 'Couldn\'t finish signing in. Try again.';

  @override
  String get showLabel => 'Show';

  @override
  String get hideLabel => 'Hide';

  @override
  String get resetPasswordTitle => 'Set a new password';

  @override
  String get resetPasswordBody => 'Choose a new password for your account.';

  @override
  String get setPasswordAction => 'Set password';

  @override
  String get wrongEmailOrPassword => 'Wrong email or password.';

  @override
  String get enterCodeTitle => 'Enter code';

  @override
  String codeInstructions(String email) {
    return 'Enter the code we sent to $email.';
  }

  @override
  String get verifyAction => 'Verify';

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
  String get height => 'Height';

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
      '4 to 20 characters, letters and numbers only';

  @override
  String get usernameChanged => 'Username changed';

  @override
  String get usernameAlreadyChangedBody =>
      'You\'ve already used your one username change — every account gets exactly one.';

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
  String get recalibrate => 'Recalibrate';

  @override
  String get resetCount => 'Reset count';

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
  String get units => 'Units';

  @override
  String get weight => 'Weight';

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
  String challengeSent(String name) {
    return 'Challenge sent to $name';
  }

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
  String get needsServer => 'This needs a server — not wired up yet';

  @override
  String get achievements => 'Achievements';

  @override
  String get roadTitle => 'Road to Master';

  @override
  String get allTiers => 'All tiers';

  @override
  String get topTier => 'Top tier';

  @override
  String lpToGo(String lp) {
    return '$lp LP';
  }

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
  String get stay => 'Stay';

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
    return '$n weeks ago';
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
  String get addFriend => 'Add';

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
  String get local => 'Local';

  @override
  String get weekly => 'Weekly';

  @override
  String get seasonTab => 'Season';

  @override
  String get allTime => 'All-time';

  @override
  String get daily => 'Daily';

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
  String get findPeople => 'Find people';

  @override
  String get noRankYet => 'No rank yet';

  @override
  String placementsForFirstTier(String count) {
    return 'Finish $count placement duels to earn your first tier.';
  }

  @override
  String get startPlacements => 'Start placements';

  @override
  String get unranked => 'Unranked';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$done of $total · $seconds seconds each';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$done of $total · $left more to get your tier';
  }

  @override
  String placementsForTier(String count) {
    return 'Finish $count placement duels to see where you land.';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '$done of $total done';
  }

  @override
  String get practiceFirst => 'Practice first';

  @override
  String get nextPlacement => 'Next placement';

  @override
  String get noConnection => 'No connection';

  @override
  String get practiceOffline => 'Practice offline';

  @override
  String get retry => 'Retry';

  @override
  String get youWonPlain => 'You won';

  @override
  String opponentDisconnected(String name) {
    return '$name disconnected';
  }

  @override
  String get forfeitNoMargin => 'Forfeit · margin not counted';

  @override
  String get findAnotherMatch => 'Find another match';

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
  String lpSwing(String gain, String loss) {
    return '+$gain / −$loss LP';
  }

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
  String get yourRankCard => 'Your rank card';

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
  String get obHowTitle => 'Three things, then you’re in.';

  @override
  String get obHow1 => 'Prop your phone on the floor';

  @override
  String get obHow1Body => 'Lean it against a wall, a metre in front of you.';

  @override
  String get obHow2 => 'The camera counts your reps';

  @override
  String get obHow2Body =>
      'Every rep is checked for depth. Half reps don’t count.';

  @override
  String get obHow3 => 'Sixty seconds against someone';

  @override
  String get obHow3Body =>
      'Win to climb. Lose and you drop. Same rules for everyone.';

  @override
  String get obTwoThings => 'Two quick things.';

  @override
  String get obAgeQuestion => 'How old are you?';

  @override
  String get obUnder16 => 'Under 16';

  @override
  String get obOver16 => '16 or over';

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
  String get obUnder16Blocked =>
      'outrepd is for 16 and over. Come back when you get there — the push-ups will still be here.';

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
  String get obOneMetre => '~1 m';

  @override
  String get obFullBody => 'full body in frame';

  @override
  String get obCheckHandsFeet => 'Hands and feet both visible';

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
  String get obFramingAnkles => 'Ankles';

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
  String get obPlacementsBody =>
      'Five duels decide your starting tier. Nothing counts against you yet.';

  @override
  String get obFindFirstOpponent => 'Find my first opponent';

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
      'Every time you confirm a count after a duel, that set is measured against what you said it was. The number appears here.';

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
  String get lpRowWin => 'Win';

  @override
  String get lpRowLoss => 'Loss';

  @override
  String get lpRowOpponent => 'Opponent\'s rank';

  @override
  String get lpRowMargin => 'Margin';

  @override
  String get lpRowDepth => 'Depth';

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
      'Each rep is judged by how far your shoulders drop and rise, and only the camera can see that. Without it there is no count, and without a count there is no duel. The camera is only on during a set.';

  @override
  String get obWelcomeBack => 'Welcome back';
}
