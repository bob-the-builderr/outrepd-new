import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L
/// returned by `L.of(context)`.
///
/// Applications need to include `L.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L.localizationsDelegates,
///   supportedLocales: L.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L.supportedLocales
/// property.
abstract class L {
  L(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L)!;
  }

  static const LocalizationsDelegate<L> delegate = _LDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @tabFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get tabFriends;

  /// No description provided for @tabRanks.
  ///
  /// In en, this message translates to:
  /// **'Ranks'**
  String get tabRanks;

  /// No description provided for @tabMatch.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get tabMatch;

  /// No description provided for @tabCrew.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get tabCrew;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @searchOpponent.
  ///
  /// In en, this message translates to:
  /// **'Search for opponent'**
  String get searchOpponent;

  /// No description provided for @searchOpponentHint.
  ///
  /// In en, this message translates to:
  /// **'Get matched with a lifter at your rank'**
  String get searchOpponentHint;

  /// No description provided for @challengeFriend.
  ///
  /// In en, this message translates to:
  /// **'Challenge a friend'**
  String get challengeFriend;

  /// No description provided for @trainWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Train with the camera'**
  String get trainWithCamera;

  /// No description provided for @viewRoadmap.
  ///
  /// In en, this message translates to:
  /// **'View Roadmap'**
  String get viewRoadmap;

  /// No description provided for @lpProgress.
  ///
  /// In en, this message translates to:
  /// **'{lp} / 100 LP · {left} to promotion'**
  String lpProgress(String lp, String left);

  /// No description provided for @winStreak.
  ///
  /// In en, this message translates to:
  /// **'{count} win streak'**
  String winStreak(String count);

  /// No description provided for @matchHistory.
  ///
  /// In en, this message translates to:
  /// **'Match history'**
  String get matchHistory;

  /// No description provided for @allMatches.
  ///
  /// In en, this message translates to:
  /// **'All matches'**
  String get allMatches;

  /// No description provided for @wins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get wins;

  /// No description provided for @losses.
  ///
  /// In en, this message translates to:
  /// **'Losses'**
  String get losses;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win rate'**
  String get winRate;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @totalMatches.
  ///
  /// In en, this message translates to:
  /// **'Total matches'**
  String get totalMatches;

  /// No description provided for @bestWinStreak.
  ///
  /// In en, this message translates to:
  /// **'Best win streak'**
  String get bestWinStreak;

  /// No description provided for @totalVolume.
  ///
  /// In en, this message translates to:
  /// **'Total volume lifted'**
  String get totalVolume;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @bodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get bodyweight;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @editYourStats.
  ///
  /// In en, this message translates to:
  /// **'Edit your stats'**
  String get editYourStats;

  /// No description provided for @editStatsHint.
  ///
  /// In en, this message translates to:
  /// **'Wins, volume and rank are earned — they cannot be edited.'**
  String get editStatsHint;

  /// No description provided for @changeName.
  ///
  /// In en, this message translates to:
  /// **'Change your name'**
  String get changeName;

  /// No description provided for @changeNameLast.
  ///
  /// In en, this message translates to:
  /// **'This is your last change. It cannot be undone.'**
  String get changeNameLast;

  /// No description provided for @changeNameLeft.
  ///
  /// In en, this message translates to:
  /// **'You get {total} changes in total. {left} left after this one.'**
  String changeNameLeft(String total, String left);

  /// No description provided for @changeNameUsedUp.
  ///
  /// In en, this message translates to:
  /// **'You have used both of your name changes'**
  String get changeNameUsedUp;

  /// No description provided for @yourPicture.
  ///
  /// In en, this message translates to:
  /// **'Your picture'**
  String get yourPicture;

  /// No description provided for @yourPictureHint.
  ///
  /// In en, this message translates to:
  /// **'The frame comes from your rank and changes as you climb.'**
  String get yourPictureHint;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @orPickOurs.
  ///
  /// In en, this message translates to:
  /// **'Or pick one of ours'**
  String get orPickOurs;

  /// No description provided for @awards.
  ///
  /// In en, this message translates to:
  /// **'Awards'**
  String get awards;

  /// No description provided for @yourTitles.
  ///
  /// In en, this message translates to:
  /// **'Your titles'**
  String get yourTitles;

  /// No description provided for @stillToEarn.
  ///
  /// In en, this message translates to:
  /// **'Still to earn'**
  String get stillToEarn;

  /// No description provided for @noTitlesYet.
  ///
  /// In en, this message translates to:
  /// **'None yet. The first one takes a single match.'**
  String get noTitlesYet;

  /// No description provided for @wearHint.
  ///
  /// In en, this message translates to:
  /// **'Tap one to wear it. It shows beside your name wherever people see you.'**
  String get wearHint;

  /// No description provided for @worn.
  ///
  /// In en, this message translates to:
  /// **'worn'**
  String get worn;

  /// No description provided for @titleUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Title unlocked'**
  String get titleUnlocked;

  /// No description provided for @wearIt.
  ///
  /// In en, this message translates to:
  /// **'Wear it'**
  String get wearIt;

  /// No description provided for @wearItLater.
  ///
  /// In en, this message translates to:
  /// **'Wear it later'**
  String get wearItLater;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get dayStreak;

  /// No description provided for @bestEver.
  ///
  /// In en, this message translates to:
  /// **'Best ever'**
  String get bestEver;

  /// No description provided for @restDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'Rest days left'**
  String get restDaysLeft;

  /// No description provided for @restIsTraining.
  ///
  /// In en, this message translates to:
  /// **'Rest is part of training. Two days off a week will not break your streak.'**
  String get restIsTraining;

  /// No description provided for @titlesAndStreak.
  ///
  /// In en, this message translates to:
  /// **'{owned} of {total} titles · {streak} day streak'**
  String titlesAndStreak(String owned, String total, String streak);

  /// No description provided for @crew.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get crew;

  /// No description provided for @myCrew.
  ///
  /// In en, this message translates to:
  /// **'My crew'**
  String get myCrew;

  /// No description provided for @rankings.
  ///
  /// In en, this message translates to:
  /// **'Rankings'**
  String get rankings;

  /// No description provided for @trainWithCrew.
  ///
  /// In en, this message translates to:
  /// **'Train with a crew'**
  String get trainWithCrew;

  /// No description provided for @trainWithCrewHint.
  ///
  /// In en, this message translates to:
  /// **'Up to 20 lifters under one name, chasing a weekly target together and climbing the crew table.'**
  String get trainWithCrewHint;

  /// No description provided for @createCrew.
  ///
  /// In en, this message translates to:
  /// **'Create a crew'**
  String get createCrew;

  /// No description provided for @createCrewHint.
  ///
  /// In en, this message translates to:
  /// **'Name it, pick a badge, invite your people'**
  String get createCrewHint;

  /// No description provided for @joinOpenCrew.
  ///
  /// In en, this message translates to:
  /// **'Join an open crew'**
  String get joinOpenCrew;

  /// No description provided for @joinOpenCrewHint.
  ///
  /// In en, this message translates to:
  /// **'Crews anyone can walk into'**
  String get joinOpenCrewHint;

  /// No description provided for @yourInvites.
  ///
  /// In en, this message translates to:
  /// **'Your invites'**
  String get yourInvites;

  /// No description provided for @yourInvitesHint.
  ///
  /// In en, this message translates to:
  /// **'Crews that asked for you'**
  String get yourInvitesHint;

  /// No description provided for @joinWithCode.
  ///
  /// In en, this message translates to:
  /// **'Join with a code'**
  String get joinWithCode;

  /// No description provided for @joinWithCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Six characters from a member'**
  String get joinWithCodeHint;

  /// No description provided for @topCrewsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Top crews this week'**
  String get topCrewsThisWeek;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @repsEach.
  ///
  /// In en, this message translates to:
  /// **'Reps each'**
  String get repsEach;

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// No description provided for @weeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal'**
  String get weeklyGoal;

  /// No description provided for @weeklyGoalDone.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal smashed'**
  String get weeklyGoalDone;

  /// No description provided for @goalRemaining.
  ///
  /// In en, this message translates to:
  /// **'{reps} reps to go · {days} days left'**
  String goalRemaining(String reps, String days);

  /// No description provided for @goalDoneHint.
  ///
  /// In en, this message translates to:
  /// **'Everyone gets the badge when the week closes.'**
  String get goalDoneHint;

  /// No description provided for @startCrewWar.
  ///
  /// In en, this message translates to:
  /// **'Start a crew war'**
  String get startCrewWar;

  /// No description provided for @startCrewWarHint.
  ///
  /// In en, this message translates to:
  /// **'Seven days, both crews counting. Most reps each wins.'**
  String get startCrewWarHint;

  /// No description provided for @whoIsPulling.
  ///
  /// In en, this message translates to:
  /// **'Who is pulling'**
  String get whoIsPulling;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'this week'**
  String get thisWeek;

  /// No description provided for @inviteLifters.
  ///
  /// In en, this message translates to:
  /// **'Invite lifters'**
  String get inviteLifters;

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral code'**
  String get referralCode;

  /// No description provided for @inviteLink.
  ///
  /// In en, this message translates to:
  /// **'Invite link'**
  String get inviteLink;

  /// No description provided for @leaveCrew.
  ///
  /// In en, this message translates to:
  /// **'Leave crew'**
  String get leaveCrew;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @crewTable.
  ///
  /// In en, this message translates to:
  /// **'Crew table'**
  String get crewTable;

  /// No description provided for @repsPerMember.
  ///
  /// In en, this message translates to:
  /// **'reps per member'**
  String get repsPerMember;

  /// No description provided for @seasonResets.
  ///
  /// In en, this message translates to:
  /// **'Resets in {days} days — everyone starts level'**
  String seasonResets(String days);

  /// No description provided for @rankingExplained.
  ///
  /// In en, this message translates to:
  /// **'Crews are ranked on reps per member, not the total — otherwise the biggest crew wins by size alone.'**
  String get rankingExplained;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @global.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get global;

  /// No description provided for @myCountry.
  ///
  /// In en, this message translates to:
  /// **'My country'**
  String get myCountry;

  /// No description provided for @yourFriends.
  ///
  /// In en, this message translates to:
  /// **'Your friends ({count})'**
  String yourFriends(String count);

  /// No description provided for @challenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get challenge;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pickMovement.
  ///
  /// In en, this message translates to:
  /// **'Pick a movement'**
  String get pickMovement;

  /// No description provided for @anyExercise.
  ///
  /// In en, this message translates to:
  /// **'Any exercise'**
  String get anyExercise;

  /// No description provided for @anyExerciseHint.
  ///
  /// In en, this message translates to:
  /// **'Start your set — it works the movement out as you go'**
  String get anyExerciseHint;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get reps;

  /// No description provided for @secondsHeld.
  ///
  /// In en, this message translates to:
  /// **'seconds held'**
  String get secondsHeld;

  /// No description provided for @learningMovement.
  ///
  /// In en, this message translates to:
  /// **'Learning your movement — your reps appear in a moment'**
  String get learningMovement;

  /// No description provided for @recalibrate.
  ///
  /// In en, this message translates to:
  /// **'Recalibrate'**
  String get recalibrate;

  /// No description provided for @resetCount.
  ///
  /// In en, this message translates to:
  /// **'Reset count'**
  String get resetCount;

  /// No description provided for @checksForm.
  ///
  /// In en, this message translates to:
  /// **'checks form'**
  String get checksForm;

  /// No description provided for @counts.
  ///
  /// In en, this message translates to:
  /// **'counts'**
  String get counts;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'time'**
  String get time;

  /// No description provided for @howManyReally.
  ///
  /// In en, this message translates to:
  /// **'How many did you really do?'**
  String get howManyReally;

  /// No description provided for @howManyReallyHint.
  ///
  /// In en, this message translates to:
  /// **'Your own count, not the app\'s. It is what the counter gets measured against later.'**
  String get howManyReallyHint;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSection;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get dangerZone;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Match device'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @openCrews.
  ///
  /// In en, this message translates to:
  /// **'Open crews'**
  String get openCrews;

  /// No description provided for @openCrewsHint.
  ///
  /// In en, this message translates to:
  /// **'These let anyone in. Pick one and you are in straight away.'**
  String get openCrewsHint;

  /// No description provided for @yourInvitesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Crews that asked for you by name.'**
  String get yourInvitesSubtitle;

  /// No description provided for @pickOpponent.
  ///
  /// In en, this message translates to:
  /// **'Pick your opponent'**
  String get pickOpponent;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Invite link copied'**
  String get copied;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'Season {name}'**
  String season(String name);

  /// No description provided for @challengeSent.
  ///
  /// In en, this message translates to:
  /// **'Challenge sent to {name}'**
  String challengeSent(String name);

  /// No description provided for @inviteFriendPrivate.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend to a private match'**
  String get inviteFriendPrivate;

  /// No description provided for @joinWithCodePaste.
  ///
  /// In en, this message translates to:
  /// **'Paste the six characters a member sent you.'**
  String get joinWithCodePaste;

  /// No description provided for @enterTheCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-character code'**
  String get enterTheCode;

  /// No description provided for @followingDevice.
  ///
  /// In en, this message translates to:
  /// **'Following your device right now'**
  String get followingDevice;

  /// No description provided for @weightUnitTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight unit'**
  String get weightUnitTitle;

  /// No description provided for @heightUnitTitle.
  ///
  /// In en, this message translates to:
  /// **'Height unit'**
  String get heightUnitTitle;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'Kilograms (kg)'**
  String get unitKg;

  /// No description provided for @unitLb.
  ///
  /// In en, this message translates to:
  /// **'Pounds (lb)'**
  String get unitLb;

  /// No description provided for @unitCm.
  ///
  /// In en, this message translates to:
  /// **'Centimetres (cm)'**
  String get unitCm;

  /// No description provided for @unitFt.
  ///
  /// In en, this message translates to:
  /// **'Feet & inches'**
  String get unitFt;

  /// No description provided for @visEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get visEveryone;

  /// No description provided for @visFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends only'**
  String get visFriends;

  /// No description provided for @visNobody.
  ///
  /// In en, this message translates to:
  /// **'Nobody'**
  String get visNobody;

  /// No description provided for @visEveryoneHint.
  ///
  /// In en, this message translates to:
  /// **'Anyone can open your profile'**
  String get visEveryoneHint;

  /// No description provided for @visFriendsHint.
  ///
  /// In en, this message translates to:
  /// **'Only lifters you have added'**
  String get visFriendsHint;

  /// No description provided for @visNobodyHint.
  ///
  /// In en, this message translates to:
  /// **'Your profile stays private'**
  String get visNobodyHint;

  /// No description provided for @matchInvites.
  ///
  /// In en, this message translates to:
  /// **'Match invites'**
  String get matchInvites;

  /// No description provided for @matchResults.
  ///
  /// In en, this message translates to:
  /// **'Match results'**
  String get matchResults;

  /// No description provided for @friendRequestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Friend requests'**
  String get friendRequestsLabel;

  /// No description provided for @crewActivity.
  ///
  /// In en, this message translates to:
  /// **'Crew activity'**
  String get crewActivity;

  /// No description provided for @rankChanges.
  ///
  /// In en, this message translates to:
  /// **'Rank changes'**
  String get rankChanges;

  /// No description provided for @weeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Weekly summary'**
  String get weeklySummary;

  /// No description provided for @soundLabel.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get soundLabel;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @whoCanSeeProfile.
  ///
  /// In en, this message translates to:
  /// **'Who can see my profile'**
  String get whoCanSeeProfile;

  /// No description provided for @profileVisibility.
  ///
  /// In en, this message translates to:
  /// **'Profile visibility'**
  String get profileVisibility;

  /// No description provided for @showOnLeaderboards.
  ///
  /// In en, this message translates to:
  /// **'Show me on leaderboards'**
  String get showOnLeaderboards;

  /// No description provided for @allowMatchInvites.
  ///
  /// In en, this message translates to:
  /// **'Allow match invites'**
  String get allowMatchInvites;

  /// No description provided for @allowFriendRequests.
  ///
  /// In en, this message translates to:
  /// **'Allow friend requests'**
  String get allowFriendRequests;

  /// No description provided for @showHeightWeight.
  ///
  /// In en, this message translates to:
  /// **'Show height and weight'**
  String get showHeightWeight;

  /// No description provided for @showHeightWeightHint.
  ///
  /// In en, this message translates to:
  /// **'Off keeps your body stats to yourself'**
  String get showHeightWeightHint;

  /// No description provided for @autoAcceptFriends.
  ///
  /// In en, this message translates to:
  /// **'Auto-accept from friends'**
  String get autoAcceptFriends;

  /// No description provided for @restTimerBetweenSets.
  ///
  /// In en, this message translates to:
  /// **'Rest timer between sets'**
  String get restTimerBetweenSets;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export my data'**
  String get exportData;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get clearCache;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get cacheCleared;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate OUTREPD'**
  String get rateApp;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get contactSupport;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @openSourceLicences.
  ///
  /// In en, this message translates to:
  /// **'Open source licences'**
  String get openSourceLicences;

  /// No description provided for @resetProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset my progress'**
  String get resetProgress;

  /// No description provided for @resetProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your progress?'**
  String get resetProgressTitle;

  /// No description provided for @resetProgressBody.
  ///
  /// In en, this message translates to:
  /// **'Rank, LP and match history all go back to zero. This cannot be undone.'**
  String get resetProgressBody;

  /// No description provided for @actionReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get actionReset;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Your profile, crews and every match you have lifted are removed for good.'**
  String get deleteAccountBody;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @needsServer.
  ///
  /// In en, this message translates to:
  /// **'This needs a server — not wired up yet'**
  String get needsServer;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skipToApp.
  ///
  /// In en, this message translates to:
  /// **'Skip to the app'**
  String get skipToApp;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @roadTitle.
  ///
  /// In en, this message translates to:
  /// **'Road to Legend'**
  String get roadTitle;

  /// No description provided for @allTiers.
  ///
  /// In en, this message translates to:
  /// **'All tiers'**
  String get allTiers;

  /// No description provided for @topTier.
  ///
  /// In en, this message translates to:
  /// **'Top tier'**
  String get topTier;

  /// No description provided for @lpToGo.
  ///
  /// In en, this message translates to:
  /// **'{lp} LP'**
  String lpToGo(String lp);

  /// No description provided for @unlockedEverything.
  ///
  /// In en, this message translates to:
  /// **'You have unlocked everything'**
  String get unlockedEverything;

  /// No description provided for @unlocksAt.
  ///
  /// In en, this message translates to:
  /// **'Unlocks at {tier}'**
  String unlocksAt(String tier);

  /// No description provided for @matchedSameGroup.
  ///
  /// In en, this message translates to:
  /// **'You will be matched with someone training the same group.'**
  String get matchedSameGroup;

  /// No description provided for @roomFriendly.
  ///
  /// In en, this message translates to:
  /// **'Room matches are friendly — they do not affect your rank.'**
  String get roomFriendly;

  /// No description provided for @createRoom.
  ///
  /// In en, this message translates to:
  /// **'Create a room'**
  String get createRoom;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'ENTER CODE'**
  String get enterCode;

  /// No description provided for @joinRoom.
  ///
  /// In en, this message translates to:
  /// **'Join room'**
  String get joinRoom;

  /// No description provided for @shareThisCode.
  ///
  /// In en, this message translates to:
  /// **'Share this code'**
  String get shareThisCode;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get codeCopied;

  /// No description provided for @pickMuscleAndStart.
  ///
  /// In en, this message translates to:
  /// **'Pick muscle and start'**
  String get pickMuscleAndStart;

  /// No description provided for @dontGetOutrepd.
  ///
  /// In en, this message translates to:
  /// **'Don\'t get OUTREPD!'**
  String get dontGetOutrepd;

  /// No description provided for @xOfY.
  ///
  /// In en, this message translates to:
  /// **'{a} / {b}'**
  String xOfY(String a, String b);

  /// No description provided for @tierStone.
  ///
  /// In en, this message translates to:
  /// **'Stone'**
  String get tierStone;

  /// No description provided for @tierBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get tierBronze;

  /// No description provided for @tierSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get tierSilver;

  /// No description provided for @tierGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get tierGold;

  /// No description provided for @tierPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get tierPlatinum;

  /// No description provided for @tierDiamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond'**
  String get tierDiamond;

  /// No description provided for @tierMaster.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get tierMaster;

  /// No description provided for @tierMythic.
  ///
  /// In en, this message translates to:
  /// **'Mythic'**
  String get tierMythic;

  /// No description provided for @tierLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get tierLegend;

  /// No description provided for @rewardStone.
  ///
  /// In en, this message translates to:
  /// **'Stone border frame'**
  String get rewardStone;

  /// No description provided for @rewardBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze badge'**
  String get rewardBronze;

  /// No description provided for @rewardSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver badge'**
  String get rewardSilver;

  /// No description provided for @rewardGold.
  ///
  /// In en, this message translates to:
  /// **'Gold badge'**
  String get rewardGold;

  /// No description provided for @rewardPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum badge'**
  String get rewardPlatinum;

  /// No description provided for @rewardDiamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond badge'**
  String get rewardDiamond;

  /// No description provided for @rewardMaster.
  ///
  /// In en, this message translates to:
  /// **'Master badge'**
  String get rewardMaster;

  /// No description provided for @rewardMythic.
  ///
  /// In en, this message translates to:
  /// **'Mythic badge'**
  String get rewardMythic;

  /// No description provided for @rewardLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend badge'**
  String get rewardLegend;

  /// No description provided for @shortKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get shortKg;

  /// No description provided for @shortLb.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get shortLb;

  /// No description provided for @shortCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get shortCm;

  /// No description provided for @shortFt.
  ///
  /// In en, this message translates to:
  /// **'ft'**
  String get shortFt;

  /// No description provided for @winLoss.
  ///
  /// In en, this message translates to:
  /// **'{w}W {l}L'**
  String winLoss(String w, String l);

  /// No description provided for @yearsSuffix.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get yearsSuffix;

  /// No description provided for @yourCrew.
  ///
  /// In en, this message translates to:
  /// **'Your crew'**
  String get yourCrew;

  /// No description provided for @crewName.
  ///
  /// In en, this message translates to:
  /// **'Crew name'**
  String get crewName;

  /// No description provided for @motto.
  ///
  /// In en, this message translates to:
  /// **'Motto'**
  String get motto;

  /// No description provided for @mottoHint.
  ///
  /// In en, this message translates to:
  /// **'What does this crew stand for?'**
  String get mottoHint;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @whoCanJoin.
  ///
  /// In en, this message translates to:
  /// **'Who can join'**
  String get whoCanJoin;

  /// No description provided for @minimumRank.
  ///
  /// In en, this message translates to:
  /// **'Minimum rank'**
  String get minimumRank;

  /// No description provided for @anyone.
  ///
  /// In en, this message translates to:
  /// **'Anyone'**
  String get anyone;

  /// No description provided for @emblem.
  ///
  /// In en, this message translates to:
  /// **'Emblem'**
  String get emblem;

  /// No description provided for @colour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get colour;

  /// No description provided for @createCrewButton.
  ///
  /// In en, this message translates to:
  /// **'Create crew'**
  String get createCrewButton;

  /// No description provided for @ownerNote.
  ///
  /// In en, this message translates to:
  /// **'You will be the owner. Crews hold up to 20 lifters.'**
  String get ownerNote;

  /// No description provided for @searchCountries.
  ///
  /// In en, this message translates to:
  /// **'Search countries'**
  String get searchCountries;

  /// No description provided for @noCountryMatch.
  ///
  /// In en, this message translates to:
  /// **'No country matches that'**
  String get noCountryMatch;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Give the crew a name of at least 3 characters'**
  String get nameTooShort;

  /// No description provided for @privOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get privOpen;

  /// No description provided for @privRequest.
  ///
  /// In en, this message translates to:
  /// **'Request to join'**
  String get privRequest;

  /// No description provided for @privInviteOnly.
  ///
  /// In en, this message translates to:
  /// **'Invite only'**
  String get privInviteOnly;

  /// No description provided for @privOpenHint.
  ///
  /// In en, this message translates to:
  /// **'Anyone with the code can walk straight in'**
  String get privOpenHint;

  /// No description provided for @privRequestHint.
  ///
  /// In en, this message translates to:
  /// **'People ask, an officer approves'**
  String get privRequestHint;

  /// No description provided for @privInviteOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'Members must be invited directly'**
  String get privInviteOnlyHint;

  /// No description provided for @embStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get embStrength;

  /// No description provided for @embCombat.
  ///
  /// In en, this message translates to:
  /// **'Combat'**
  String get embCombat;

  /// No description provided for @embBeasts.
  ///
  /// In en, this message translates to:
  /// **'Beasts'**
  String get embBeasts;

  /// No description provided for @embElements.
  ///
  /// In en, this message translates to:
  /// **'Elements'**
  String get embElements;

  /// No description provided for @embHonours.
  ///
  /// In en, this message translates to:
  /// **'Honours'**
  String get embHonours;

  /// No description provided for @embSymbols.
  ///
  /// In en, this message translates to:
  /// **'Symbols'**
  String get embSymbols;

  /// No description provided for @ob1Title.
  ///
  /// In en, this message translates to:
  /// **'Turn every session\ninto a battle'**
  String get ob1Title;

  /// No description provided for @ob1Body.
  ///
  /// In en, this message translates to:
  /// **'Log your workout and go head to head with someone training the same muscle group.'**
  String get ob1Body;

  /// No description provided for @ob2Title.
  ///
  /// In en, this message translates to:
  /// **'Challenge your\nfriends'**
  String get ob2Title;

  /// No description provided for @ob2Body.
  ///
  /// In en, this message translates to:
  /// **'Send a private invite and settle who really trains harder.'**
  String get ob2Body;

  /// No description provided for @ob3Title.
  ///
  /// In en, this message translates to:
  /// **'Climb the ranks'**
  String get ob3Title;

  /// No description provided for @ob3Body.
  ///
  /// In en, this message translates to:
  /// **'Every win earns LP. Push from Stone all the way to Legend.'**
  String get ob3Body;

  /// No description provided for @ob4Title.
  ///
  /// In en, this message translates to:
  /// **'Effort alone\nis hard'**
  String get ob4Title;

  /// No description provided for @ob4Body.
  ///
  /// In en, this message translates to:
  /// **'Training with no one watching makes it easy to cut the last set short.'**
  String get ob4Body;

  /// No description provided for @ob5Title.
  ///
  /// In en, this message translates to:
  /// **'Become a\nLegend'**
  String get ob5Title;

  /// No description provided for @ob5Body.
  ///
  /// In en, this message translates to:
  /// **'Consistency compounds. Show up, out-lift, rank up.'**
  String get ob5Body;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get letsGo;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @ttl_first_blood.
  ///
  /// In en, this message translates to:
  /// **'First Blood'**
  String get ttl_first_blood;

  /// No description provided for @tdesc_first_blood.
  ///
  /// In en, this message translates to:
  /// **'Finish your first match'**
  String get tdesc_first_blood;

  /// No description provided for @ttl_found_footing.
  ///
  /// In en, this message translates to:
  /// **'Found Your Footing'**
  String get ttl_found_footing;

  /// No description provided for @tdesc_found_footing.
  ///
  /// In en, this message translates to:
  /// **'Finish five matches'**
  String get tdesc_found_footing;

  /// No description provided for @ttl_regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get ttl_regular;

  /// No description provided for @tdesc_regular.
  ///
  /// In en, this message translates to:
  /// **'Twenty matches'**
  String get tdesc_regular;

  /// No description provided for @ttl_fifty.
  ///
  /// In en, this message translates to:
  /// **'Fifty Deep'**
  String get ttl_fifty;

  /// No description provided for @tdesc_fifty.
  ///
  /// In en, this message translates to:
  /// **'Fifty matches'**
  String get tdesc_fifty;

  /// No description provided for @ttl_century.
  ///
  /// In en, this message translates to:
  /// **'Century'**
  String get ttl_century;

  /// No description provided for @tdesc_century.
  ///
  /// In en, this message translates to:
  /// **'A hundred matches'**
  String get tdesc_century;

  /// No description provided for @ttl_veteran.
  ///
  /// In en, this message translates to:
  /// **'Veteran'**
  String get ttl_veteran;

  /// No description provided for @tdesc_veteran.
  ///
  /// In en, this message translates to:
  /// **'Two hundred and fifty matches'**
  String get tdesc_veteran;

  /// No description provided for @ttl_thousand_matches.
  ///
  /// In en, this message translates to:
  /// **'Old Guard'**
  String get ttl_thousand_matches;

  /// No description provided for @tdesc_thousand_matches.
  ///
  /// In en, this message translates to:
  /// **'A thousand matches'**
  String get tdesc_thousand_matches;

  /// No description provided for @ttl_first_win.
  ///
  /// In en, this message translates to:
  /// **'Winner'**
  String get ttl_first_win;

  /// No description provided for @tdesc_first_win.
  ///
  /// In en, this message translates to:
  /// **'Win a match'**
  String get tdesc_first_win;

  /// No description provided for @ttl_on_a_roll.
  ///
  /// In en, this message translates to:
  /// **'On a Roll'**
  String get ttl_on_a_roll;

  /// No description provided for @tdesc_on_a_roll.
  ///
  /// In en, this message translates to:
  /// **'Win three in a row'**
  String get tdesc_on_a_roll;

  /// No description provided for @ttl_five_straight.
  ///
  /// In en, this message translates to:
  /// **'Five Straight'**
  String get ttl_five_straight;

  /// No description provided for @tdesc_five_straight.
  ///
  /// In en, this message translates to:
  /// **'Win five in a row'**
  String get tdesc_five_straight;

  /// No description provided for @ttl_unstoppable.
  ///
  /// In en, this message translates to:
  /// **'Unstoppable'**
  String get ttl_unstoppable;

  /// No description provided for @tdesc_unstoppable.
  ///
  /// In en, this message translates to:
  /// **'Win ten in a row'**
  String get tdesc_unstoppable;

  /// No description provided for @ttl_untouchable.
  ///
  /// In en, this message translates to:
  /// **'Untouchable'**
  String get ttl_untouchable;

  /// No description provided for @tdesc_untouchable.
  ///
  /// In en, this message translates to:
  /// **'Win twenty in a row'**
  String get tdesc_untouchable;

  /// No description provided for @ttl_giant_slayer.
  ///
  /// In en, this message translates to:
  /// **'Giant Slayer'**
  String get ttl_giant_slayer;

  /// No description provided for @tdesc_giant_slayer.
  ///
  /// In en, this message translates to:
  /// **'Beat someone two tiers above you'**
  String get tdesc_giant_slayer;

  /// No description provided for @ttl_comeback.
  ///
  /// In en, this message translates to:
  /// **'Comeback'**
  String get ttl_comeback;

  /// No description provided for @tdesc_comeback.
  ///
  /// In en, this message translates to:
  /// **'Win straight after three losses'**
  String get tdesc_comeback;

  /// No description provided for @ttl_nemesis.
  ///
  /// In en, this message translates to:
  /// **'Nemesis'**
  String get ttl_nemesis;

  /// No description provided for @tdesc_nemesis.
  ///
  /// In en, this message translates to:
  /// **'Beat the same lifter five times'**
  String get tdesc_nemesis;

  /// No description provided for @ttl_hundred_reps.
  ///
  /// In en, this message translates to:
  /// **'Off the Mark'**
  String get ttl_hundred_reps;

  /// No description provided for @tdesc_hundred_reps.
  ///
  /// In en, this message translates to:
  /// **'A hundred counted reps'**
  String get tdesc_hundred_reps;

  /// No description provided for @ttl_five_hundred.
  ///
  /// In en, this message translates to:
  /// **'Warmed Up'**
  String get ttl_five_hundred;

  /// No description provided for @tdesc_five_hundred.
  ///
  /// In en, this message translates to:
  /// **'Five hundred counted reps'**
  String get tdesc_five_hundred;

  /// No description provided for @ttl_the_machine.
  ///
  /// In en, this message translates to:
  /// **'The Machine'**
  String get ttl_the_machine;

  /// No description provided for @tdesc_the_machine.
  ///
  /// In en, this message translates to:
  /// **'A thousand counted reps'**
  String get tdesc_the_machine;

  /// No description provided for @ttl_five_thousand.
  ///
  /// In en, this message translates to:
  /// **'Relentless'**
  String get ttl_five_thousand;

  /// No description provided for @tdesc_five_thousand.
  ///
  /// In en, this message translates to:
  /// **'Five thousand counted reps'**
  String get tdesc_five_thousand;

  /// No description provided for @ttl_ten_thousand.
  ///
  /// In en, this message translates to:
  /// **'Ten Thousand'**
  String get ttl_ten_thousand;

  /// No description provided for @tdesc_ten_thousand.
  ///
  /// In en, this message translates to:
  /// **'Ten thousand counted reps'**
  String get tdesc_ten_thousand;

  /// No description provided for @ttl_fifty_thousand.
  ///
  /// In en, this message translates to:
  /// **'Beyond Counting'**
  String get ttl_fifty_thousand;

  /// No description provided for @tdesc_fifty_thousand.
  ///
  /// In en, this message translates to:
  /// **'Fifty thousand counted reps'**
  String get tdesc_fifty_thousand;

  /// No description provided for @ttl_first_tonne.
  ///
  /// In en, this message translates to:
  /// **'A Tonne'**
  String get ttl_first_tonne;

  /// No description provided for @tdesc_first_tonne.
  ///
  /// In en, this message translates to:
  /// **'Move a thousand kilos in total'**
  String get tdesc_first_tonne;

  /// No description provided for @ttl_ten_tonnes.
  ///
  /// In en, this message translates to:
  /// **'Ten Tonnes'**
  String get ttl_ten_tonnes;

  /// No description provided for @tdesc_ten_tonnes.
  ///
  /// In en, this message translates to:
  /// **'Move ten thousand kilos'**
  String get tdesc_ten_tonnes;

  /// No description provided for @ttl_six_figures.
  ///
  /// In en, this message translates to:
  /// **'Six Figures'**
  String get ttl_six_figures;

  /// No description provided for @tdesc_six_figures.
  ///
  /// In en, this message translates to:
  /// **'Move a hundred thousand kilos'**
  String get tdesc_six_figures;

  /// No description provided for @ttl_half_million.
  ///
  /// In en, this message translates to:
  /// **'Half a Million'**
  String get ttl_half_million;

  /// No description provided for @tdesc_half_million.
  ///
  /// In en, this message translates to:
  /// **'Move five hundred thousand kilos'**
  String get tdesc_half_million;

  /// No description provided for @ttl_million_kg.
  ///
  /// In en, this message translates to:
  /// **'Million Kilo Club'**
  String get ttl_million_kg;

  /// No description provided for @tdesc_million_kg.
  ///
  /// In en, this message translates to:
  /// **'Move a million kilos'**
  String get tdesc_million_kg;

  /// No description provided for @ttl_two_days.
  ///
  /// In en, this message translates to:
  /// **'Back Again'**
  String get ttl_two_days;

  /// No description provided for @tdesc_two_days.
  ///
  /// In en, this message translates to:
  /// **'Train two days running'**
  String get tdesc_two_days;

  /// No description provided for @ttl_no_days_off.
  ///
  /// In en, this message translates to:
  /// **'No Days Off'**
  String get ttl_no_days_off;

  /// No description provided for @tdesc_no_days_off.
  ///
  /// In en, this message translates to:
  /// **'Train seven days running'**
  String get tdesc_no_days_off;

  /// No description provided for @ttl_fortnight.
  ///
  /// In en, this message translates to:
  /// **'Fortnight'**
  String get ttl_fortnight;

  /// No description provided for @tdesc_fortnight.
  ///
  /// In en, this message translates to:
  /// **'A fourteen day streak'**
  String get tdesc_fortnight;

  /// No description provided for @ttl_unbroken.
  ///
  /// In en, this message translates to:
  /// **'Unbroken'**
  String get ttl_unbroken;

  /// No description provided for @tdesc_unbroken.
  ///
  /// In en, this message translates to:
  /// **'A thirty day streak'**
  String get tdesc_unbroken;

  /// No description provided for @ttl_sixty_days.
  ///
  /// In en, this message translates to:
  /// **'Habit'**
  String get ttl_sixty_days;

  /// No description provided for @tdesc_sixty_days.
  ///
  /// In en, this message translates to:
  /// **'A sixty day streak'**
  String get tdesc_sixty_days;

  /// No description provided for @ttl_hundred_days.
  ///
  /// In en, this message translates to:
  /// **'Hundred Days'**
  String get ttl_hundred_days;

  /// No description provided for @tdesc_hundred_days.
  ///
  /// In en, this message translates to:
  /// **'A hundred day streak'**
  String get tdesc_hundred_days;

  /// No description provided for @ttl_year_round.
  ///
  /// In en, this message translates to:
  /// **'Year Round'**
  String get ttl_year_round;

  /// No description provided for @tdesc_year_round.
  ///
  /// In en, this message translates to:
  /// **'A three hundred and sixty five day streak'**
  String get tdesc_year_round;

  /// No description provided for @ttl_perfect_week.
  ///
  /// In en, this message translates to:
  /// **'Perfect Week'**
  String get ttl_perfect_week;

  /// No description provided for @tdesc_perfect_week.
  ///
  /// In en, this message translates to:
  /// **'Train every day of one week'**
  String get tdesc_perfect_week;

  /// No description provided for @ttl_perfect_month.
  ///
  /// In en, this message translates to:
  /// **'Perfect Month'**
  String get ttl_perfect_month;

  /// No description provided for @tdesc_perfect_month.
  ///
  /// In en, this message translates to:
  /// **'Four perfect weeks'**
  String get tdesc_perfect_month;

  /// No description provided for @ttl_bronze_tier.
  ///
  /// In en, this message translates to:
  /// **'Out of the Stone'**
  String get ttl_bronze_tier;

  /// No description provided for @tdesc_bronze_tier.
  ///
  /// In en, this message translates to:
  /// **'Reach Bronze'**
  String get tdesc_bronze_tier;

  /// No description provided for @ttl_silver_tier.
  ///
  /// In en, this message translates to:
  /// **'Silverside'**
  String get ttl_silver_tier;

  /// No description provided for @tdesc_silver_tier.
  ///
  /// In en, this message translates to:
  /// **'Reach Silver'**
  String get tdesc_silver_tier;

  /// No description provided for @ttl_golden_era.
  ///
  /// In en, this message translates to:
  /// **'Golden Era'**
  String get ttl_golden_era;

  /// No description provided for @tdesc_golden_era.
  ///
  /// In en, this message translates to:
  /// **'Reach Gold'**
  String get tdesc_golden_era;

  /// No description provided for @ttl_platinum_tier.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get ttl_platinum_tier;

  /// No description provided for @tdesc_platinum_tier.
  ///
  /// In en, this message translates to:
  /// **'Reach Platinum'**
  String get tdesc_platinum_tier;

  /// No description provided for @ttl_diamond_tier.
  ///
  /// In en, this message translates to:
  /// **'Diamond Hands'**
  String get ttl_diamond_tier;

  /// No description provided for @tdesc_diamond_tier.
  ///
  /// In en, this message translates to:
  /// **'Reach Diamond'**
  String get tdesc_diamond_tier;

  /// No description provided for @ttl_master_tier.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get ttl_master_tier;

  /// No description provided for @tdesc_master_tier.
  ///
  /// In en, this message translates to:
  /// **'Reach Master'**
  String get tdesc_master_tier;

  /// No description provided for @ttl_mythic_tier.
  ///
  /// In en, this message translates to:
  /// **'Mythic'**
  String get ttl_mythic_tier;

  /// No description provided for @tdesc_mythic_tier.
  ///
  /// In en, this message translates to:
  /// **'Reach Mythic'**
  String get tdesc_mythic_tier;

  /// No description provided for @ttl_legend_tier.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get ttl_legend_tier;

  /// No description provided for @tdesc_legend_tier.
  ///
  /// In en, this message translates to:
  /// **'Reach Legend'**
  String get tdesc_legend_tier;

  /// No description provided for @ttl_clean_hands.
  ///
  /// In en, this message translates to:
  /// **'Clean Hands'**
  String get ttl_clean_hands;

  /// No description provided for @tdesc_clean_hands.
  ///
  /// In en, this message translates to:
  /// **'A full set with every rep counted'**
  String get tdesc_clean_hands;

  /// No description provided for @ttl_spotless.
  ///
  /// In en, this message translates to:
  /// **'Spotless'**
  String get ttl_spotless;

  /// No description provided for @tdesc_spotless.
  ///
  /// In en, this message translates to:
  /// **'Ten clean sets'**
  String get tdesc_spotless;

  /// No description provided for @ttl_textbook.
  ///
  /// In en, this message translates to:
  /// **'Textbook'**
  String get ttl_textbook;

  /// No description provided for @tdesc_textbook.
  ///
  /// In en, this message translates to:
  /// **'Fifty clean sets'**
  String get tdesc_textbook;

  /// No description provided for @ttl_iron_hold.
  ///
  /// In en, this message translates to:
  /// **'Iron Hold'**
  String get ttl_iron_hold;

  /// No description provided for @tdesc_iron_hold.
  ///
  /// In en, this message translates to:
  /// **'Hold a plank for two minutes'**
  String get tdesc_iron_hold;

  /// No description provided for @ttl_statue.
  ///
  /// In en, this message translates to:
  /// **'Statue'**
  String get ttl_statue;

  /// No description provided for @tdesc_statue.
  ///
  /// In en, this message translates to:
  /// **'Hold a plank for five minutes'**
  String get tdesc_statue;

  /// No description provided for @ttl_all_rounder.
  ///
  /// In en, this message translates to:
  /// **'All Rounder'**
  String get ttl_all_rounder;

  /// No description provided for @tdesc_all_rounder.
  ///
  /// In en, this message translates to:
  /// **'Count five different exercises'**
  String get tdesc_all_rounder;

  /// No description provided for @ttl_explorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get ttl_explorer;

  /// No description provided for @tdesc_explorer.
  ///
  /// In en, this message translates to:
  /// **'Count fifteen different exercises'**
  String get tdesc_explorer;

  /// No description provided for @ttl_encyclopedia.
  ///
  /// In en, this message translates to:
  /// **'Encyclopedia'**
  String get ttl_encyclopedia;

  /// No description provided for @tdesc_encyclopedia.
  ///
  /// In en, this message translates to:
  /// **'Count forty different exercises'**
  String get tdesc_encyclopedia;

  /// No description provided for @ttl_early_bird.
  ///
  /// In en, this message translates to:
  /// **'Early Shift'**
  String get ttl_early_bird;

  /// No description provided for @tdesc_early_bird.
  ///
  /// In en, this message translates to:
  /// **'Ten sessions before seven in the morning'**
  String get tdesc_early_bird;

  /// No description provided for @ttl_sunrise_club.
  ///
  /// In en, this message translates to:
  /// **'Sunrise Club'**
  String get ttl_sunrise_club;

  /// No description provided for @tdesc_sunrise_club.
  ///
  /// In en, this message translates to:
  /// **'Fifty sessions before seven'**
  String get tdesc_sunrise_club;

  /// No description provided for @ttl_night_owl.
  ///
  /// In en, this message translates to:
  /// **'Night Shift'**
  String get ttl_night_owl;

  /// No description provided for @tdesc_night_owl.
  ///
  /// In en, this message translates to:
  /// **'Ten sessions after ten at night'**
  String get tdesc_night_owl;

  /// No description provided for @ttl_graveyard.
  ///
  /// In en, this message translates to:
  /// **'Graveyard Shift'**
  String get ttl_graveyard;

  /// No description provided for @tdesc_graveyard.
  ///
  /// In en, this message translates to:
  /// **'Fifty sessions after ten'**
  String get tdesc_graveyard;

  /// No description provided for @ttl_joined_up.
  ///
  /// In en, this message translates to:
  /// **'Joined Up'**
  String get ttl_joined_up;

  /// No description provided for @tdesc_joined_up.
  ///
  /// In en, this message translates to:
  /// **'Be in a crew'**
  String get tdesc_joined_up;

  /// No description provided for @ttl_backbone.
  ///
  /// In en, this message translates to:
  /// **'Backbone'**
  String get ttl_backbone;

  /// No description provided for @tdesc_backbone.
  ///
  /// In en, this message translates to:
  /// **'Top your crew four weeks running'**
  String get tdesc_backbone;

  /// No description provided for @ttl_cornerstone.
  ///
  /// In en, this message translates to:
  /// **'Cornerstone'**
  String get ttl_cornerstone;

  /// No description provided for @tdesc_cornerstone.
  ///
  /// In en, this message translates to:
  /// **'Top your crew twelve weeks running'**
  String get tdesc_cornerstone;

  /// No description provided for @ttl_not_alone.
  ///
  /// In en, this message translates to:
  /// **'Not Alone'**
  String get ttl_not_alone;

  /// No description provided for @tdesc_not_alone.
  ///
  /// In en, this message translates to:
  /// **'Add your first friend'**
  String get tdesc_not_alone;

  /// No description provided for @ttl_well_connected.
  ///
  /// In en, this message translates to:
  /// **'Well Connected'**
  String get ttl_well_connected;

  /// No description provided for @tdesc_well_connected.
  ///
  /// In en, this message translates to:
  /// **'Ten friends'**
  String get tdesc_well_connected;

  /// No description provided for @ttl_the_gym_knows.
  ///
  /// In en, this message translates to:
  /// **'The Gym Knows You'**
  String get ttl_the_gym_knows;

  /// No description provided for @tdesc_the_gym_knows.
  ///
  /// In en, this message translates to:
  /// **'Fifty friends'**
  String get tdesc_the_gym_knows;

  /// No description provided for @finish2.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish2;

  /// No description provided for @qExperience.
  ///
  /// In en, this message translates to:
  /// **'How experienced are you\nwith working out?'**
  String get qExperience;

  /// No description provided for @expBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner – Tried it before'**
  String get expBeginner;

  /// No description provided for @expIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate – Regular training'**
  String get expIntermediate;

  /// No description provided for @expAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced – Years of experience'**
  String get expAdvanced;

  /// No description provided for @qGoal.
  ///
  /// In en, this message translates to:
  /// **'What\'s your top\nfitness goal?'**
  String get qGoal;

  /// No description provided for @goalStronger.
  ///
  /// In en, this message translates to:
  /// **'Become stronger'**
  String get goalStronger;

  /// No description provided for @goalConsistent.
  ///
  /// In en, this message translates to:
  /// **'Become more consistent'**
  String get goalConsistent;

  /// No description provided for @goalLean.
  ///
  /// In en, this message translates to:
  /// **'Lose weight and get lean'**
  String get goalLean;

  /// No description provided for @goalMass.
  ///
  /// In en, this message translates to:
  /// **'Build muscle mass'**
  String get goalMass;

  /// No description provided for @aboutYou.
  ///
  /// In en, this message translates to:
  /// **'This journey is all about you...'**
  String get aboutYou;

  /// No description provided for @qThinkAbout.
  ///
  /// In en, this message translates to:
  /// **'How often do you think\nabout getting in shape?'**
  String get qThinkAbout;

  /// No description provided for @freqNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get freqNever;

  /// No description provided for @freqSometimes.
  ///
  /// In en, this message translates to:
  /// **'Sometimes'**
  String get freqSometimes;

  /// No description provided for @freqOften.
  ///
  /// In en, this message translates to:
  /// **'Often'**
  String get freqOften;

  /// No description provided for @freqAllTime.
  ///
  /// In en, this message translates to:
  /// **'All The Time'**
  String get freqAllTime;

  /// No description provided for @qEnergy.
  ///
  /// In en, this message translates to:
  /// **'How are your energy levels\nduring workouts?'**
  String get qEnergy;

  /// No description provided for @energyLow.
  ///
  /// In en, this message translates to:
  /// **'Low energy, I feel drained all day'**
  String get energyLow;

  /// No description provided for @energyDrops.
  ///
  /// In en, this message translates to:
  /// **'Performance drops mid-session'**
  String get energyDrops;

  /// No description provided for @energyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard to push through the last set'**
  String get energyHard;

  /// No description provided for @energyHigh.
  ///
  /// In en, this message translates to:
  /// **'High and steady from start to finish'**
  String get energyHigh;

  /// No description provided for @stProgress.
  ///
  /// In en, this message translates to:
  /// **'Sometimes, it\'s hard to notice progress when I workout'**
  String get stProgress;

  /// No description provided for @stEffortTitle.
  ///
  /// In en, this message translates to:
  /// **'Effort no one sees\nis easy to quit'**
  String get stEffortTitle;

  /// No description provided for @stEffortBody.
  ///
  /// In en, this message translates to:
  /// **'When there\'s no one to prove yourself against, progress feels slow and effort feels pointless'**
  String get stEffortBody;

  /// No description provided for @stAloneTitle.
  ///
  /// In en, this message translates to:
  /// **'Training alone\nis boring'**
  String get stAloneTitle;

  /// No description provided for @stAloneBody.
  ///
  /// In en, this message translates to:
  /// **'No one\'s watching. No one\'s counting. It\'s easy to skip a rep, or the whole set'**
  String get stAloneBody;

  /// No description provided for @qName.
  ///
  /// In en, this message translates to:
  /// **'What should we\ncall you?'**
  String get qName;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'At least 3 characters. This is what rivals will see.'**
  String get nameHint;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Alright! Lets get\nsome basic info'**
  String get basicInfo;

  /// No description provided for @qAge.
  ///
  /// In en, this message translates to:
  /// **'How old are you?'**
  String get qAge;

  /// No description provided for @qWeight.
  ///
  /// In en, this message translates to:
  /// **'What\'s your\ncurrent weight?'**
  String get qWeight;

  /// No description provided for @weightWhy.
  ///
  /// In en, this message translates to:
  /// **'Body weight is essential to calculate your rank.'**
  String get weightWhy;

  /// No description provided for @privateNote.
  ///
  /// In en, this message translates to:
  /// **'Your information is private and will not be shared with anyone.'**
  String get privateNote;

  /// No description provided for @qHeight.
  ///
  /// In en, this message translates to:
  /// **'How tall are you?'**
  String get qHeight;

  /// No description provided for @qRelate.
  ///
  /// In en, this message translates to:
  /// **'Do you relate to the\nstatement below?'**
  String get qRelate;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @grindTitle.
  ///
  /// In en, this message translates to:
  /// **'The grind hits different\nwith a rival'**
  String get grindTitle;

  /// No description provided for @grindBody.
  ///
  /// In en, this message translates to:
  /// **'Every match puts you against a real opponent, put in the work, and prove who trained harder.'**
  String get grindBody;

  /// No description provided for @allSet.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get allSet;

  /// No description provided for @welcomeLifter.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}. Time to find your first rival.'**
  String welcomeLifter(String name);

  /// No description provided for @lifter.
  ///
  /// In en, this message translates to:
  /// **'lifter'**
  String get lifter;

  /// No description provided for @enterApp.
  ///
  /// In en, this message translates to:
  /// **'Enter OUTREPD'**
  String get enterApp;

  /// No description provided for @commitTitle.
  ///
  /// In en, this message translates to:
  /// **'Now let\'s make a commitment\nto your fitness journey'**
  String get commitTitle;

  /// No description provided for @holdLogo.
  ///
  /// In en, this message translates to:
  /// **'Hold the logo to confirm you\'re ready'**
  String get holdLogo;

  /// No description provided for @expNone.
  ///
  /// In en, this message translates to:
  /// **'I\'ve never worked out'**
  String get expNone;

  /// No description provided for @iAm.
  ///
  /// In en, this message translates to:
  /// **'I am...'**
  String get iAm;

  /// No description provided for @finishMatchQ.
  ///
  /// In en, this message translates to:
  /// **'Finish match?'**
  String get finishMatchQ;

  /// No description provided for @finishMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Your volume will be locked in and compared with your opponent.'**
  String get finishMatchBody;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get keepGoing;

  /// No description provided for @forfeitQ.
  ///
  /// In en, this message translates to:
  /// **'Forfeit match?'**
  String get forfeitQ;

  /// No description provided for @forfeitBody.
  ///
  /// In en, this message translates to:
  /// **'You will lose LP if you leave now.'**
  String get forfeitBody;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @forfeit.
  ///
  /// In en, this message translates to:
  /// **'Forfeit'**
  String get forfeit;

  /// No description provided for @pickExercises.
  ///
  /// In en, this message translates to:
  /// **'Pick the exercises you will train'**
  String get pickExercises;

  /// No description provided for @matchingWith.
  ///
  /// In en, this message translates to:
  /// **'Matching you with a lifter at your rank · {muscle}'**
  String matchingWith(String muscle);

  /// No description provided for @getReady.
  ///
  /// In en, this message translates to:
  /// **'GET READY'**
  String get getReady;

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'TIME LEFT'**
  String get timeLeft;

  /// No description provided for @vsName.
  ///
  /// In en, this message translates to:
  /// **'vs {name}'**
  String vsName(String name);

  /// No description provided for @kgTotalVolume.
  ///
  /// In en, this message translates to:
  /// **'{unit} total volume'**
  String kgTotalVolume(String unit);

  /// No description provided for @finishMatch.
  ///
  /// In en, this message translates to:
  /// **'FINISH MATCH'**
  String get finishMatch;

  /// No description provided for @kgHint.
  ///
  /// In en, this message translates to:
  /// **'KG'**
  String get kgHint;

  /// No description provided for @repsHint.
  ///
  /// In en, this message translates to:
  /// **'REPS'**
  String get repsHint;

  /// No description provided for @addSet.
  ///
  /// In en, this message translates to:
  /// **'ADD SET'**
  String get addSet;

  /// No description provided for @matchComplete.
  ///
  /// In en, this message translates to:
  /// **'MATCH COMPLETE'**
  String get matchComplete;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'YOU'**
  String get you;

  /// No description provided for @vs.
  ///
  /// In en, this message translates to:
  /// **'VS'**
  String get vs;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'BACK TO HOME'**
  String get backToHome;

  /// No description provided for @mgChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get mgChest;

  /// No description provided for @mgBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get mgBack;

  /// No description provided for @mgLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get mgLegs;

  /// No description provided for @mgShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get mgShoulders;

  /// No description provided for @mgArms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get mgArms;

  /// No description provided for @mgCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get mgCore;

  /// No description provided for @achRivalry.
  ///
  /// In en, this message translates to:
  /// **'Rivalry'**
  String get achRivalry;

  /// No description provided for @achRivalryHint.
  ///
  /// In en, this message translates to:
  /// **'Beat the same opponent 3 times'**
  String get achRivalryHint;

  /// No description provided for @nWonTitle.
  ///
  /// In en, this message translates to:
  /// **'You won!'**
  String get nWonTitle;

  /// No description provided for @nWonBody.
  ///
  /// In en, this message translates to:
  /// **'You beat {name} on {muscle} day'**
  String nWonBody(String name, String muscle);

  /// No description provided for @nFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'New friend request'**
  String get nFriendTitle;

  /// No description provided for @nFriendBody.
  ///
  /// In en, this message translates to:
  /// **'{name} wants to connect'**
  String nFriendBody(String name);

  /// No description provided for @nAchTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievement unlocked'**
  String get nAchTitle;

  /// No description provided for @nAchBody.
  ///
  /// In en, this message translates to:
  /// **'{title} — {hint}'**
  String nAchBody(String title, String hint);

  /// No description provided for @nRankTitle.
  ///
  /// In en, this message translates to:
  /// **'Rank up!'**
  String get nRankTitle;

  /// No description provided for @nRankBody.
  ///
  /// In en, this message translates to:
  /// **'You reached {rank}'**
  String nRankBody(String rank);

  /// No description provided for @nameTooShortInline.
  ///
  /// In en, this message translates to:
  /// **'Pick a name of at least 3 characters'**
  String get nameTooShortInline;

  /// No description provided for @whyName.
  ///
  /// In en, this message translates to:
  /// **'Rivals will see this beside every result'**
  String get whyName;

  /// No description provided for @whyExperience.
  ///
  /// In en, this message translates to:
  /// **'We match you against people at your level'**
  String get whyExperience;

  /// No description provided for @whyGoal.
  ///
  /// In en, this message translates to:
  /// **'Your first suggested exercises come from this'**
  String get whyGoal;

  /// No description provided for @whyAge.
  ///
  /// In en, this message translates to:
  /// **'Age affects the strength standards you are measured against'**
  String get whyAge;

  /// No description provided for @whyWeight.
  ///
  /// In en, this message translates to:
  /// **'Rank compares lifts relative to bodyweight, not raw kilos'**
  String get whyWeight;

  /// No description provided for @whyHeight.
  ///
  /// In en, this message translates to:
  /// **'Used with your weight to set fair standards'**
  String get whyHeight;

  /// No description provided for @whyHabits.
  ///
  /// In en, this message translates to:
  /// **'This shapes the reminders and the weekly target we suggest'**
  String get whyHabits;

  /// No description provided for @transitionPartOfIt.
  ///
  /// In en, this message translates to:
  /// **'...so let\'s make sure you\'re truly part of it!'**
  String get transitionPartOfIt;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @usernamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get usernamePlaceholder;

  /// No description provided for @stRoutine.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know which body part really needs work so I usually follow the same routine'**
  String get stRoutine;

  /// No description provided for @shortIn.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get shortIn;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{n} days ago'**
  String daysAgo(String n);

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{n} weeks ago'**
  String weeksAgo(String n);

  /// No description provided for @membersCount.
  ///
  /// In en, this message translates to:
  /// **'{n} members'**
  String membersCount(String n);

  /// No description provided for @eachCount.
  ///
  /// In en, this message translates to:
  /// **'{n} each'**
  String eachCount(String n);

  /// No description provided for @lpAmount.
  ///
  /// In en, this message translates to:
  /// **'{n} LP'**
  String lpAmount(String n);

  /// No description provided for @countWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Count with camera'**
  String get countWithCamera;

  /// No description provided for @youWin.
  ///
  /// In en, this message translates to:
  /// **'YOU WIN!'**
  String get youWin;

  /// No description provided for @defeated.
  ///
  /// In en, this message translates to:
  /// **'DEFEATED'**
  String get defeated;
}

class _LDelegate extends LocalizationsDelegate<L> {
  const _LDelegate();

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(lookupL(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_LDelegate old) => false;
}

L lookupL(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return LAr();
    case 'de':
      return LDe();
    case 'en':
      return LEn();
    case 'es':
      return LEs();
    case 'fr':
      return LFr();
    case 'hi':
      return LHi();
    case 'id':
      return LId();
    case 'it':
      return LIt();
    case 'ja':
      return LJa();
    case 'ko':
      return LKo();
    case 'pt':
      return LPt();
    case 'ru':
      return LRu();
    case 'tr':
      return LTr();
    case 'zh':
      return LZh();
  }

  throw FlutterError(
    'L.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
