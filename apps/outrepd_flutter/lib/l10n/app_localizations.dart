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
  String lpProgress(int lp, int left);

  /// No description provided for @winStreak.
  ///
  /// In en, this message translates to:
  /// **'{count} win streak'**
  String winStreak(int count);

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
  String changeNameLeft(int total, int left);

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
  String titlesAndStreak(int owned, int total, int streak);

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
  String goalRemaining(int reps, int days);

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
  String seasonResets(int days);

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
  String yourFriends(int count);

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
  String lpToGo(int lp);

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
  String xOfY(int a, int b);

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
  String winLoss(int w, int l);

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
