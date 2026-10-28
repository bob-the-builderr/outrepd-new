import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @challengeFriend.
  ///
  /// In en, this message translates to:
  /// **'Challenge a friend'**
  String get challengeFriend;

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

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @duelSection.
  ///
  /// In en, this message translates to:
  /// **'Duel'**
  String get duelSection;

  /// No description provided for @hapticsEachRep.
  ///
  /// In en, this message translates to:
  /// **'Haptics on each rep'**
  String get hapticsEachRep;

  /// No description provided for @showSkeleton.
  ///
  /// In en, this message translates to:
  /// **'Show skeleton overlay'**
  String get showSkeleton;

  /// No description provided for @showSkeletonHint.
  ///
  /// In en, this message translates to:
  /// **'How you can tell the camera is seeing you'**
  String get showSkeletonHint;

  /// No description provided for @manageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Manage notifications'**
  String get manageNotifications;

  /// No description provided for @switchesOn.
  ///
  /// In en, this message translates to:
  /// **'{on} of {all} on'**
  String switchesOn(String on, String all);

  /// No description provided for @whoCanChallenge.
  ///
  /// In en, this message translates to:
  /// **'Who can challenge me'**
  String get whoCanChallenge;

  /// No description provided for @blockedAccounts.
  ///
  /// In en, this message translates to:
  /// **'Blocked accounts'**
  String get blockedAccounts;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get reportProblem;

  /// No description provided for @onDeviceNote.
  ///
  /// In en, this message translates to:
  /// **'Pose detection runs on this phone. No video or pose data is ever uploaded.'**
  String get onDeviceNote;

  /// No description provided for @visibilitySection.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibilitySection;

  /// No description provided for @showMyCountry.
  ///
  /// In en, this message translates to:
  /// **'Show my country'**
  String get showMyCountry;

  /// No description provided for @showMyCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Off takes you off the country board'**
  String get showMyCountryHint;

  /// No description provided for @safetySection.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get safetySection;

  /// No description provided for @socialSection.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get socialSection;

  /// No description provided for @noticeRaced.
  ///
  /// In en, this message translates to:
  /// **'Someone raced my set'**
  String get noticeRaced;

  /// No description provided for @noticeRacedHint.
  ///
  /// In en, this message translates to:
  /// **'The only way to find out a duel happened'**
  String get noticeRacedHint;

  /// No description provided for @noticeFriendOk.
  ///
  /// In en, this message translates to:
  /// **'A request I sent was accepted'**
  String get noticeFriendOk;

  /// No description provided for @noticesStoredNote.
  ///
  /// In en, this message translates to:
  /// **'Turning one off means it is never stored — not stored and hidden.'**
  String get noticesStoredNote;

  /// No description provided for @notSaved.
  ///
  /// In en, this message translates to:
  /// **'Not saved'**
  String get notSaved;

  /// No description provided for @blockedIntro.
  ///
  /// In en, this message translates to:
  /// **'A blocked account can\'t challenge you, find you, or send you a request. They aren\'t told.'**
  String get blockedIntro;

  /// No description provided for @blockedWhen.
  ///
  /// In en, this message translates to:
  /// **'Blocked {when}'**
  String blockedWhen(String when);

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @noBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Nobody blocked'**
  String get noBlockedTitle;

  /// No description provided for @noBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'You can block somebody from their profile or a report.'**
  String get noBlockedBody;

  /// No description provided for @whatHappened.
  ///
  /// In en, this message translates to:
  /// **'What happened'**
  String get whatHappened;

  /// No description provided for @reasonCheating.
  ///
  /// In en, this message translates to:
  /// **'Cheating or fake reps'**
  String get reasonCheating;

  /// No description provided for @reasonHarassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment or abuse'**
  String get reasonHarassment;

  /// No description provided for @reasonContent.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate content'**
  String get reasonContent;

  /// No description provided for @reasonImpersonation.
  ///
  /// In en, this message translates to:
  /// **'Impersonation'**
  String get reasonImpersonation;

  /// No description provided for @reasonOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get reasonOther;

  /// No description provided for @addDetails.
  ///
  /// In en, this message translates to:
  /// **'Add details (optional)'**
  String get addDetails;

  /// No description provided for @alsoBlock.
  ///
  /// In en, this message translates to:
  /// **'Also block this account'**
  String get alsoBlock;

  /// No description provided for @sendReport.
  ///
  /// In en, this message translates to:
  /// **'Send report'**
  String get sendReport;

  /// No description provided for @reportSent.
  ///
  /// In en, this message translates to:
  /// **'Report sent'**
  String get reportSent;

  /// No description provided for @reportingThisAccount.
  ///
  /// In en, this message translates to:
  /// **'Reporting this account'**
  String get reportingThisAccount;

  /// No description provided for @exportIntro.
  ///
  /// In en, this message translates to:
  /// **'We\'ll email a file with everything the server holds about you. It usually takes a minute.'**
  String get exportIntro;

  /// No description provided for @whatsIncluded.
  ///
  /// In en, this message translates to:
  /// **'What\'s included'**
  String get whatsIncluded;

  /// No description provided for @incProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile and rank'**
  String get incProfile;

  /// No description provided for @incSets.
  ///
  /// In en, this message translates to:
  /// **'Every set and rep count'**
  String get incSets;

  /// No description provided for @incDuels.
  ///
  /// In en, this message translates to:
  /// **'Duel history and LP changes'**
  String get incDuels;

  /// No description provided for @incFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends and blocked accounts'**
  String get incFriends;

  /// No description provided for @incNotices.
  ///
  /// In en, this message translates to:
  /// **'Notifications you were sent'**
  String get incNotices;

  /// No description provided for @noLandmarksNote.
  ///
  /// In en, this message translates to:
  /// **'Pose landmarks are not in it, and never were. The camera reads them on your phone and they are not sent anywhere.'**
  String get noLandmarksNote;

  /// No description provided for @sendItTo.
  ///
  /// In en, this message translates to:
  /// **'Send it to'**
  String get sendItTo;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountTitle;

  /// No description provided for @createAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Add an email and password so this account is never just one phone away from gone.'**
  String get createAccountBody;

  /// No description provided for @createAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountAction;

  /// No description provided for @emailTakenSwitchToSignIn.
  ///
  /// In en, this message translates to:
  /// **'That email already has an account — sign in instead.'**
  String get emailTakenSwitchToSignIn;

  /// No description provided for @emailSignUpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Check the email and password — six characters minimum.'**
  String get emailSignUpInvalid;

  /// No description provided for @tooManyCodes.
  ///
  /// In en, this message translates to:
  /// **'Too many codes sent — wait a few minutes and try again.'**
  String get tooManyCodes;

  /// No description provided for @sendCodeAction.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCodeAction;

  /// No description provided for @noAccountForEmail.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find an account with that email.'**
  String get noAccountForEmail;

  /// No description provided for @authEntryTagline.
  ///
  /// In en, this message translates to:
  /// **'Push. Compete. Climb the ladder.'**
  String get authEntryTagline;

  /// No description provided for @signUpWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign up with email'**
  String get signUpWithEmail;

  /// No description provided for @alreadyHaveAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccountQuestion;

  /// No description provided for @logInAction.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logInAction;

  /// No description provided for @createYourAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Takes less than a minute.'**
  String get createAccountSubtitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @logInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to keep your rank.'**
  String get logInSubtitle;

  /// No description provided for @checkYourEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmailTitle;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {email}.'**
  String codeSentTo(String email);

  /// No description provided for @didntGetIt.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get it?'**
  String get didntGetIt;

  /// No description provided for @resendInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend in {time}'**
  String resendInSeconds(String time);

  /// No description provided for @wrongEmailGoBack.
  ///
  /// In en, this message translates to:
  /// **'Wrong email? Go back'**
  String get wrongEmailGoBack;

  /// No description provided for @usernameTaken.
  ///
  /// In en, this message translates to:
  /// **'That username is taken.'**
  String get usernameTaken;

  /// No description provided for @wrongCode.
  ///
  /// In en, this message translates to:
  /// **'That code\'s wrong or expired.'**
  String get wrongCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @codeResent.
  ///
  /// In en, this message translates to:
  /// **'Sent a new code.'**
  String get codeResent;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String signedInAs(String email);

  /// No description provided for @addressNotKept.
  ///
  /// In en, this message translates to:
  /// **'The address is used once and not stored — this account has no email on it.'**
  String get addressNotKept;

  /// No description provided for @requestMyData.
  ///
  /// In en, this message translates to:
  /// **'Email my data'**
  String get requestMyData;

  /// No description provided for @exportSent.
  ///
  /// In en, this message translates to:
  /// **'Sent to {address}'**
  String exportSent(String address);

  /// No description provided for @deleteIntro.
  ///
  /// In en, this message translates to:
  /// **'This erases everything permanently. It cannot be undone and we cannot restore it.'**
  String get deleteIntro;

  /// No description provided for @rankLabel.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rankLabel;

  /// No description provided for @wantCopyFirst.
  ///
  /// In en, this message translates to:
  /// **'Want a copy first?'**
  String get wantCopyFirst;

  /// No description provided for @wantCopyBody.
  ///
  /// In en, this message translates to:
  /// **'Download your data before deleting. After this, it\'s gone.'**
  String get wantCopyBody;

  /// No description provided for @typeToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type {word} to confirm'**
  String typeToConfirm(String word);

  /// No description provided for @deleteWord.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteWord;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deletePermanently;

  /// No description provided for @keepMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Keep my account'**
  String get keepMyAccount;

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

  /// No description provided for @couldNotUsePicture.
  ///
  /// In en, this message translates to:
  /// **'Could not use that picture'**
  String get couldNotUsePicture;

  /// No description provided for @couldNotSyncAvatar.
  ///
  /// In en, this message translates to:
  /// **'Your picture is saved, but it hasn\'t synced yet'**
  String get couldNotSyncAvatar;

  /// No description provided for @couldNotShareCard.
  ///
  /// In en, this message translates to:
  /// **'Could not share this card'**
  String get couldNotShareCard;

  /// No description provided for @couldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open that link'**
  String get couldNotOpenLink;

  /// No description provided for @couldNotCheckUsername.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check that name — try again'**
  String get couldNotCheckUsername;

  /// No description provided for @changeUsername.
  ///
  /// In en, this message translates to:
  /// **'Change username'**
  String get changeUsername;

  /// No description provided for @usernameInvalidLength.
  ///
  /// In en, this message translates to:
  /// **'4 to 20 characters: letters, numbers and _ only'**
  String get usernameInvalidLength;

  /// No description provided for @usernameChanged.
  ///
  /// In en, this message translates to:
  /// **'Username changed'**
  String get usernameChanged;

  /// No description provided for @usernameAlreadyChangedBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already used your one username change — every account gets exactly one.'**
  String get usernameAlreadyChangedBody;

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

  /// No description provided for @global.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get global;

  /// No description provided for @topPlayers.
  ///
  /// In en, this message translates to:
  /// **'Top Players'**
  String get topPlayers;

  /// No description provided for @yourTier.
  ///
  /// In en, this message translates to:
  /// **'Your Tier'**
  String get yourTier;

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

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

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

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

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

  /// No description provided for @friendRequestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Friend requests'**
  String get friendRequestsLabel;

  /// No description provided for @showOnLeaderboards.
  ///
  /// In en, this message translates to:
  /// **'Show me on leaderboards'**
  String get showOnLeaderboards;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export my data'**
  String get exportData;

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

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @needsServer.
  ///
  /// In en, this message translates to:
  /// **'Couldn't connect. Check your internet and try again.'**
  String get needsServer;

  /// No description provided for @roomFriendly.
  ///
  /// In en, this message translates to:
  /// **'Room matches are friendly — they do not affect your rank.'**
  String get roomFriendly;

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

  /// No description provided for @xOfY.
  ///
  /// In en, this message translates to:
  /// **'{a} / {b}'**
  String xOfY(String a, String b);

  /// No description provided for @tierIron.
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get tierIron;

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

  /// No description provided for @winLoss.
  ///
  /// In en, this message translates to:
  /// **'{w}W {l}L'**
  String winLoss(String w, String l);

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
  /// **'Out of the Iron'**
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

  /// No description provided for @forfeit.
  ///
  /// In en, this message translates to:
  /// **'Forfeit'**
  String get forfeit;

  /// No description provided for @getReady.
  ///
  /// In en, this message translates to:
  /// **'GET READY'**
  String get getReady;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
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

  /// No description provided for @nRacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your set was raced'**
  String get nRacedTitle;

  /// No description provided for @nRacedHeld.
  ///
  /// In en, this message translates to:
  /// **'{name} raced your set and fell short, {yours}–{theirs}'**
  String nRacedHeld(String name, String yours, String theirs);

  /// No description provided for @nRacedBeaten.
  ///
  /// In en, this message translates to:
  /// **'{name} raced your set and won, {theirs}–{yours}'**
  String nRacedBeaten(String name, String theirs, String yours);

  /// No description provided for @nFriendOkTitle.
  ///
  /// In en, this message translates to:
  /// **'Friend request accepted'**
  String get nFriendOkTitle;

  /// No description provided for @nFriendOkBody.
  ///
  /// In en, this message translates to:
  /// **'{name} accepted your request'**
  String nFriendOkBody(String name);

  /// No description provided for @nFriendBody.
  ///
  /// In en, this message translates to:
  /// **'{name} wants to connect'**
  String nFriendBody(String name);

  /// No description provided for @nChallengedTitle.
  ///
  /// In en, this message translates to:
  /// **'Rematch'**
  String get nChallengedTitle;

  /// No description provided for @nChallengedBody.
  ///
  /// In en, this message translates to:
  /// **'{name} wants a rematch'**
  String nChallengedBody(String name);

  /// No description provided for @challengeSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge sent'**
  String get challengeSentTitle;

  /// No description provided for @challengeSentBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll let {name} know. Come back once they\'ve raced it.'**
  String challengeSentBody(String name);

  /// No description provided for @challengeNotSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send that'**
  String get challengeNotSentTitle;

  /// No description provided for @challengeNotSentBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again from the match tab.'**
  String get challengeNotSentBody;

  /// No description provided for @challengeGoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge is gone'**
  String get challengeGoneTitle;

  /// No description provided for @challengeGoneBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s already been raced, or it was withdrawn.'**
  String get challengeGoneBody;

  /// No description provided for @repsRecordedLine.
  ///
  /// In en, this message translates to:
  /// **'{reps} reps recorded'**
  String repsRecordedLine(String reps);

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
  /// **'{n}d ago'**
  String daysAgo(String n);

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{n} weeks ago'**
  String weeksAgo(String n);

  /// No description provided for @lpAmount.
  ///
  /// In en, this message translates to:
  /// **'{n} LP'**
  String lpAmount(String n);

  /// No description provided for @lpUnit.
  ///
  /// In en, this message translates to:
  /// **'LP'**
  String get lpUnit;

  /// No description provided for @trueCountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 12'**
  String get trueCountHint;

  /// No description provided for @couldNotSaveSession.
  ///
  /// In en, this message translates to:
  /// **'Could not save the session'**
  String get couldNotSaveSession;

  /// No description provided for @lpOutOf.
  ///
  /// In en, this message translates to:
  /// **'/ {total} LP'**
  String lpOutOf(String total);

  /// No description provided for @noFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'No friends yet'**
  String get noFriendsTitle;

  /// No description provided for @noFriendsBody.
  ///
  /// In en, this message translates to:
  /// **'Duels hit different against someone you know.'**
  String get noFriendsBody;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent to {name}'**
  String requestSent(String name);

  /// No description provided for @nowFriends.
  ///
  /// In en, this message translates to:
  /// **'You and {name} are friends now'**
  String nowFriends(String name);

  /// No description provided for @noOneFound.
  ///
  /// In en, this message translates to:
  /// **'Nobody goes by that name'**
  String get noOneFound;

  /// No description provided for @noMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches yet'**
  String get noMatchesTitle;

  /// No description provided for @noMatchesBody.
  ///
  /// In en, this message translates to:
  /// **'Your first one shows up here, win or lose.'**
  String get noMatchesBody;

  /// No description provided for @noNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing new'**
  String get noNotificationsTitle;

  /// No description provided for @noNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Match invites, results and friend requests land here.'**
  String get noNotificationsBody;

  /// No description provided for @countedThat.
  ///
  /// In en, this message translates to:
  /// **'Counted that round'**
  String get countedThat;

  /// No description provided for @thatIsRight.
  ///
  /// In en, this message translates to:
  /// **'That\'s right'**
  String get thatIsRight;

  /// No description provided for @useMyCount.
  ///
  /// In en, this message translates to:
  /// **'Use my count'**
  String get useMyCount;

  /// No description provided for @confirmHint.
  ///
  /// In en, this message translates to:
  /// **'Change it if the camera got it wrong.'**
  String get confirmHint;

  /// No description provided for @unsureMovement.
  ///
  /// In en, this message translates to:
  /// **'Not sure this was the right movement — check the number.'**
  String get unsureMovement;

  /// No description provided for @noRanksYet.
  ///
  /// In en, this message translates to:
  /// **'No ranks yet'**
  String get noRanksYet;

  /// No description provided for @noRanksYetBody.
  ///
  /// In en, this message translates to:
  /// **'Play a duel and the board fills in.'**
  String get noRanksYetBody;

  /// No description provided for @ranksTitle.
  ///
  /// In en, this message translates to:
  /// **'Ranks'**
  String get ranksTitle;

  /// No description provided for @totalReps.
  ///
  /// In en, this message translates to:
  /// **'Total reps'**
  String get totalReps;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @wonVs.
  ///
  /// In en, this message translates to:
  /// **'Won vs {name}'**
  String wonVs(String name);

  /// No description provided for @lostVs.
  ///
  /// In en, this message translates to:
  /// **'Lost vs {name}'**
  String lostVs(String name);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{n}h ago'**
  String hoursAgo(String n);

  /// No description provided for @toNextTier.
  ///
  /// In en, this message translates to:
  /// **'{n} to {tier}'**
  String toNextTier(String n, String tier);

  /// No description provided for @noMatchesYet.
  ///
  /// In en, this message translates to:
  /// **'No duels yet'**
  String get noMatchesYet;

  /// No description provided for @noMatchesYetBody.
  ///
  /// In en, this message translates to:
  /// **'Your first one shows up here, win or lose.'**
  String get noMatchesYetBody;

  /// No description provided for @searchByUsername.
  ///
  /// In en, this message translates to:
  /// **'Search by username'**
  String get searchByUsername;

  /// No description provided for @incomingRequests.
  ///
  /// In en, this message translates to:
  /// **'Incoming requests'**
  String get incomingRequests;

  /// No description provided for @noRequestsWaiting.
  ///
  /// In en, this message translates to:
  /// **'No requests waiting right now'**
  String get noRequestsWaiting;

  /// No description provided for @addFriendAction.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriendAction;

  /// No description provided for @addFriendHint.
  ///
  /// In en, this message translates to:
  /// **'Enter their username, or the #code from their profile.'**
  String get addFriendHint;

  /// No description provided for @usernameOrCode.
  ///
  /// In en, this message translates to:
  /// **'Username or #code'**
  String get usernameOrCode;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get sendRequest;

  /// No description provided for @onlineNowCount.
  ///
  /// In en, this message translates to:
  /// **'Online now · {count}'**
  String onlineNowCount(String count);

  /// No description provided for @offlineCount.
  ///
  /// In en, this message translates to:
  /// **'Offline · {count}'**
  String offlineCount(String count);

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @headToHeadTitle.
  ///
  /// In en, this message translates to:
  /// **'Head to head'**
  String get headToHeadTitle;

  /// No description provided for @vsYouCaption.
  ///
  /// In en, this message translates to:
  /// **'vs you'**
  String get vsYouCaption;

  /// No description provided for @h2hYou.
  ///
  /// In en, this message translates to:
  /// **'you'**
  String get h2hYou;

  /// No description provided for @h2hThem.
  ///
  /// In en, this message translates to:
  /// **'them'**
  String get h2hThem;

  /// No description provided for @headToHead.
  ///
  /// In en, this message translates to:
  /// **'{wins}W {losses}L vs you'**
  String headToHead(String wins, String losses);

  /// No description provided for @neverPlayedYou.
  ///
  /// In en, this message translates to:
  /// **'Never played you'**
  String get neverPlayedYou;

  /// No description provided for @noHistoryWithThem.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t raced {username} yet.'**
  String noHistoryWithThem(String username);

  /// No description provided for @lastDuelScore.
  ///
  /// In en, this message translates to:
  /// **'Last time: {yourReps}–{theirReps}, {when}.'**
  String lastDuelScore(String yourReps, String theirReps, String when);

  /// No description provided for @yourBestVsThemLine.
  ///
  /// In en, this message translates to:
  /// **'Your best against them is {reps}.'**
  String yourBestVsThemLine(String reps);

  /// No description provided for @viewFullProfile.
  ///
  /// In en, this message translates to:
  /// **'View full profile'**
  String get viewFullProfile;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @blockRowBody.
  ///
  /// In en, this message translates to:
  /// **'They can\'t challenge you or see your profile'**
  String get blockRowBody;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @reportRowBody.
  ///
  /// In en, this message translates to:
  /// **'Reviewed within 24 hours'**
  String get reportRowBody;

  /// No description provided for @muteChallenges.
  ///
  /// In en, this message translates to:
  /// **'Mute challenges from {username}'**
  String muteChallenges(String username);

  /// No description provided for @blockedLifter.
  ///
  /// In en, this message translates to:
  /// **'Blocked {username}'**
  String blockedLifter(String username);

  /// No description provided for @mutedLifter.
  ///
  /// In en, this message translates to:
  /// **'Muted {username}'**
  String mutedLifter(String username);

  /// No description provided for @addFriendButton.
  ///
  /// In en, this message translates to:
  /// **'Add friend'**
  String get addFriendButton;

  /// No description provided for @alreadyFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get alreadyFriends;

  /// No description provided for @couldNotLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this profile'**
  String get couldNotLoadProfile;

  /// No description provided for @noFriendsMatch.
  ///
  /// In en, this message translates to:
  /// **'Nobody by that name'**
  String get noFriendsMatch;

  /// No description provided for @yourClimb.
  ///
  /// In en, this message translates to:
  /// **'Your climb'**
  String get yourClimb;

  /// No description provided for @floorKept.
  ///
  /// In en, this message translates to:
  /// **'{tier} is yours. You can\'t drop below {rank}.'**
  String floorKept(String tier, String rank);

  /// No description provided for @dayStreakCount.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String dayStreakCount(String count);

  /// No description provided for @findMatch.
  ///
  /// In en, this message translates to:
  /// **'Find a match'**
  String get findMatch;

  /// No description provided for @rankedTerms.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds · ranked'**
  String rankedTerms(String seconds);

  /// No description provided for @practiceTerms.
  ///
  /// In en, this message translates to:
  /// **'Practice — no rank, no opponent'**
  String get practiceTerms;

  /// No description provided for @practiceComplete.
  ///
  /// In en, this message translates to:
  /// **'PRACTICE COMPLETE'**
  String get practiceComplete;

  /// No description provided for @noRankYet.
  ///
  /// In en, this message translates to:
  /// **'No rank yet'**
  String get noRankYet;

  /// No description provided for @unranked.
  ///
  /// In en, this message translates to:
  /// **'Unranked'**
  String get unranked;

  /// No description provided for @practiceFirst.
  ///
  /// In en, this message translates to:
  /// **'Practice first'**
  String get practiceFirst;

  /// No description provided for @noConnection.
  ///
  /// In en, this message translates to:
  /// **'No connection'**
  String get noConnection;

  /// No description provided for @practiceOffline.
  ///
  /// In en, this message translates to:
  /// **'Practice offline'**
  String get practiceOffline;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @youWonPlain.
  ///
  /// In en, this message translates to:
  /// **'You won'**
  String get youWonPlain;

  /// No description provided for @cameraNeededTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera access needed'**
  String get cameraNeededTitle;

  /// No description provided for @cameraNeededBody.
  ///
  /// In en, this message translates to:
  /// **'outrepd counts your reps by watching your body move. Pose detection runs on your device and nothing is uploaded.'**
  String get cameraNeededBody;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @allowCamera.
  ///
  /// In en, this message translates to:
  /// **'Allow camera'**
  String get allowCamera;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @noCameraTitle.
  ///
  /// In en, this message translates to:
  /// **'No camera found'**
  String get noCameraTitle;

  /// No description provided for @noCameraBody.
  ///
  /// In en, this message translates to:
  /// **'Reps are counted from the camera, so this device cannot score a duel. Everything else still works.'**
  String get noCameraBody;

  /// No description provided for @noConnectionBody.
  ///
  /// In en, this message translates to:
  /// **'You need a connection to duel. Practice still works offline and your reps will sync later.'**
  String get noConnectionBody;

  /// No description provided for @getBackInFrame.
  ///
  /// In en, this message translates to:
  /// **'Get back in frame'**
  String get getBackInFrame;

  /// No description provided for @clockStillRunning.
  ///
  /// In en, this message translates to:
  /// **'The clock is still running. Reps are not counting.'**
  String get clockStillRunning;

  /// No description provided for @giveUp.
  ///
  /// In en, this message translates to:
  /// **'Give up'**
  String get giveUp;

  /// No description provided for @lpMovesWithGap.
  ///
  /// In en, this message translates to:
  /// **'LP moves with the rep gap — win by more, gain more'**
  String get lpMovesWithGap;

  /// No description provided for @searchingForOpponent.
  ///
  /// In en, this message translates to:
  /// **'Searching for an opponent'**
  String get searchingForOpponent;

  /// No description provided for @getIntoPosition.
  ///
  /// In en, this message translates to:
  /// **'Get into position'**
  String get getIntoPosition;

  /// No description provided for @framingHint.
  ///
  /// In en, this message translates to:
  /// **'Wrists and ankles must be in frame'**
  String get framingHint;

  /// No description provided for @goUp.
  ///
  /// In en, this message translates to:
  /// **'Go up'**
  String get goUp;

  /// No description provided for @goDown.
  ///
  /// In en, this message translates to:
  /// **'Go down'**
  String get goDown;

  /// No description provided for @bestSet.
  ///
  /// In en, this message translates to:
  /// **'Best set'**
  String get bestSet;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// No description provided for @repsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reps'**
  String repsCount(String count);

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @shareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share profile'**
  String get shareProfile;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @duelMeOnOutrepd.
  ///
  /// In en, this message translates to:
  /// **'Duel me on outrepd'**
  String get duelMeOnOutrepd;

  /// No description provided for @shareStory.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get shareStory;

  /// No description provided for @sharePost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get sharePost;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyLink;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @currentRankLabel.
  ///
  /// In en, this message translates to:
  /// **'Current rank'**
  String get currentRankLabel;

  /// No description provided for @winInitial.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get winInitial;

  /// No description provided for @lossInitial.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get lossInitial;

  /// No description provided for @dayInitial.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get dayInitial;

  /// No description provided for @rankPosition.
  ///
  /// In en, this message translates to:
  /// **'#{n}'**
  String rankPosition(String n);

  /// No description provided for @obTagline.
  ///
  /// In en, this message translates to:
  /// **'Push-up battles. Your phone counts. Someone else is counting too.'**
  String get obTagline;

  /// No description provided for @obGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get obGetStarted;

  /// No description provided for @obHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get obHaveAccount;

  /// No description provided for @obTwoThings.
  ///
  /// In en, this message translates to:
  /// **'Two quick things.'**
  String get obTwoThings;

  /// No description provided for @obAgeQuestion.
  ///
  /// In en, this message translates to:
  /// **'How old are you?'**
  String get obAgeQuestion;

  /// No description provided for @obUnder16.
  ///
  /// In en, this message translates to:
  /// **'Under 16'**
  String get obUnder16;

  /// No description provided for @obOver16.
  ///
  /// In en, this message translates to:
  /// **'16 or over'**
  String get obOver16;

  /// No description provided for @obHealthConsent.
  ///
  /// In en, this message translates to:
  /// **'I understand outrepd counts reps and does not give medical or training advice. I’ll stop if something hurts.'**
  String get obHealthConsent;

  /// No description provided for @obTermsIntro.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the'**
  String get obTermsIntro;

  /// No description provided for @obTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get obTerms;

  /// No description provided for @obAnd.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get obAnd;

  /// No description provided for @obPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get obPrivacy;

  /// No description provided for @obUnder16Blocked.
  ///
  /// In en, this message translates to:
  /// **'outrepd is for 16 and over. Come back when you get there — the push-ups will still be here.'**
  String get obUnder16Blocked;

  /// No description provided for @obCameraTitle.
  ///
  /// In en, this message translates to:
  /// **'outrepd needs your camera'**
  String get obCameraTitle;

  /// No description provided for @obCameraBody.
  ///
  /// In en, this message translates to:
  /// **'It watches your body move to count reps. There is no other way to do it.'**
  String get obCameraBody;

  /// No description provided for @obCameraPrivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing leaves your phone'**
  String get obCameraPrivateTitle;

  /// No description provided for @obCameraPrivateBody.
  ///
  /// In en, this message translates to:
  /// **'Body tracking runs on this device. No video is ever saved or uploaded.'**
  String get obCameraPrivateBody;

  /// No description provided for @obWhyNeeded.
  ///
  /// In en, this message translates to:
  /// **'Why is this needed?'**
  String get obWhyNeeded;

  /// No description provided for @obPlacementTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your phone on the floor'**
  String get obPlacementTitle;

  /// No description provided for @obPlacementBody.
  ///
  /// In en, this message translates to:
  /// **'Lean it against a wall about a metre in front of you.'**
  String get obPlacementBody;

  /// No description provided for @obCheckHandsFeet.
  ///
  /// In en, this message translates to:
  /// **'Hands and feet both visible'**
  String get obCheckHandsFeet;

  /// No description provided for @obCheckFacing.
  ///
  /// In en, this message translates to:
  /// **'Facing the phone, not sideways'**
  String get obCheckFacing;

  /// No description provided for @obCheckLight.
  ///
  /// In en, this message translates to:
  /// **'Room light on'**
  String get obCheckLight;

  /// No description provided for @obImSetUp.
  ///
  /// In en, this message translates to:
  /// **'I’m set up'**
  String get obImSetUp;

  /// No description provided for @obFramingTitle.
  ///
  /// In en, this message translates to:
  /// **'Get into a push-up position'**
  String get obFramingTitle;

  /// No description provided for @obFramingShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders and hips'**
  String get obFramingShoulders;

  /// No description provided for @obFramingWrists.
  ///
  /// In en, this message translates to:
  /// **'Wrists'**
  String get obFramingWrists;

  /// No description provided for @obLooksGood.
  ///
  /// In en, this message translates to:
  /// **'Looks good'**
  String get obLooksGood;

  /// No description provided for @obCalibrating.
  ///
  /// In en, this message translates to:
  /// **'Calibrating'**
  String get obCalibrating;

  /// No description provided for @obOneMoreRep.
  ///
  /// In en, this message translates to:
  /// **'One more to learn your range'**
  String get obOneMoreRep;

  /// No description provided for @obCalibrationHint.
  ///
  /// In en, this message translates to:
  /// **'Do three push-ups at your normal depth'**
  String get obCalibrationHint;

  /// No description provided for @obCalibrated.
  ///
  /// In en, this message translates to:
  /// **'Calibrated.'**
  String get obCalibrated;

  /// No description provided for @obCalibratedBody.
  ///
  /// In en, this message translates to:
  /// **'outrepd knows your range now. Depth is measured against you, not a fixed number.'**
  String get obCalibratedBody;

  /// No description provided for @obRepsCounted.
  ///
  /// In en, this message translates to:
  /// **'Reps counted'**
  String get obRepsCounted;

  /// No description provided for @obAverageDepth.
  ///
  /// In en, this message translates to:
  /// **'Average depth'**
  String get obAverageDepth;

  /// No description provided for @obForm.
  ///
  /// In en, this message translates to:
  /// **'Form'**
  String get obForm;

  /// No description provided for @obFormClean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get obFormClean;

  /// No description provided for @obAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get obAvailable;

  /// No description provided for @obTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get obTaken;

  /// No description provided for @obGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get obGotIt;

  /// No description provided for @obFormMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get obFormMixed;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @counterAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Counter accuracy'**
  String get counterAccuracy;

  /// No description provided for @counterAccuracyCaption.
  ///
  /// In en, this message translates to:
  /// **'How close the camera gets'**
  String get counterAccuracyCaption;

  /// No description provided for @measuredOverSets.
  ///
  /// In en, this message translates to:
  /// **'Measured over {count} sets'**
  String measuredOverSets(String count);

  /// No description provided for @accExact.
  ///
  /// In en, this message translates to:
  /// **'Exact'**
  String get accExact;

  /// No description provided for @accWithinOne.
  ///
  /// In en, this message translates to:
  /// **'Within 1 rep'**
  String get accWithinOne;

  /// No description provided for @accAverageMiss.
  ///
  /// In en, this message translates to:
  /// **'Average miss'**
  String get accAverageMiss;

  /// No description provided for @accTendsTo.
  ///
  /// In en, this message translates to:
  /// **'Tends to'**
  String get accTendsTo;

  /// No description provided for @accCountsHigh.
  ///
  /// In en, this message translates to:
  /// **'count high'**
  String get accCountsHigh;

  /// No description provided for @accCountsLow.
  ///
  /// In en, this message translates to:
  /// **'count low'**
  String get accCountsLow;

  /// No description provided for @accCountsEven.
  ///
  /// In en, this message translates to:
  /// **'neither high nor low'**
  String get accCountsEven;

  /// No description provided for @accWorstMiss.
  ///
  /// In en, this message translates to:
  /// **'Worst miss'**
  String get accWorstMiss;

  /// No description provided for @accNothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing measured yet'**
  String get accNothingYet;

  /// No description provided for @accNothingYetBody.
  ///
  /// In en, this message translates to:
  /// **'Every time you confirm a count after a practice set, that set is measured against what you said it was. The number appears here.'**
  String get accNothingYetBody;

  /// No description provided for @accNeedMore.
  ///
  /// In en, this message translates to:
  /// **'Early days. About {count} more sets before this number means much.'**
  String accNeedMore(String count);

  /// No description provided for @accRecentSets.
  ///
  /// In en, this message translates to:
  /// **'Recent sets'**
  String get accRecentSets;

  /// No description provided for @accCameraSaid.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get accCameraSaid;

  /// No description provided for @accYouSaid.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get accYouSaid;

  /// No description provided for @accHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'These come from you, on this phone. Nothing is sent anywhere.'**
  String get accHowItWorks;

  /// No description provided for @levelNumber.
  ///
  /// In en, this message translates to:
  /// **'Level {n}'**
  String levelNumber(String n);

  /// No description provided for @youLostPlain.
  ///
  /// In en, this message translates to:
  /// **'You lost'**
  String get youLostPlain;

  /// No description provided for @rematch.
  ///
  /// In en, this message translates to:
  /// **'Rematch'**
  String get rematch;

  /// No description provided for @shareAction.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareAction;

  /// No description provided for @doneAction.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneAction;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @promotedLabel.
  ///
  /// In en, this message translates to:
  /// **'Promoted'**
  String get promotedLabel;

  /// No description provided for @highestReached.
  ///
  /// In en, this message translates to:
  /// **'Highest you\'ve reached'**
  String get highestReached;

  /// No description provided for @repsOff.
  ///
  /// In en, this message translates to:
  /// **'{n} reps off.'**
  String repsOff(String n);

  /// No description provided for @closestYet.
  ///
  /// In en, this message translates to:
  /// **'Closest match yet.'**
  String get closestYet;

  /// No description provided for @repsAhead.
  ///
  /// In en, this message translates to:
  /// **'{n} reps ahead.'**
  String repsAhead(String n);

  /// No description provided for @winnerLabel.
  ///
  /// In en, this message translates to:
  /// **'Winner'**
  String get winnerLabel;

  /// No description provided for @newPersonalBest.
  ///
  /// In en, this message translates to:
  /// **'New personal best'**
  String get newPersonalBest;

  /// No description provided for @cantReachServer.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the server. Check your connection and try again.'**
  String get cantReachServer;

  /// No description provided for @pushUpsInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Push-ups in {seconds} seconds'**
  String pushUpsInSeconds(String seconds);

  /// No description provided for @beatOpponent.
  ///
  /// In en, this message translates to:
  /// **'Beat {name} {score}'**
  String beatOpponent(String name, String score);

  /// No description provided for @lostToOpponent.
  ///
  /// In en, this message translates to:
  /// **'Lost to {name} {score}'**
  String lostToOpponent(String name, String score);

  /// No description provided for @thinkYouCanBeatMe.
  ///
  /// In en, this message translates to:
  /// **'Think you can beat me?'**
  String get thinkYouCanBeatMe;

  /// Shown when the server refuses a username as abusive or as passing for the app itself.
  ///
  /// In en, this message translates to:
  /// **'That name isn\'t allowed. Try another one.'**
  String get usernameNotAllowed;

  /// No description provided for @yourBest.
  ///
  /// In en, this message translates to:
  /// **'Your best'**
  String get yourBest;

  /// No description provided for @theClock.
  ///
  /// In en, this message translates to:
  /// **'The clock'**
  String get theClock;

  /// No description provided for @nobodyFreeRaceBest.
  ///
  /// In en, this message translates to:
  /// **'Nobody near your rank is free right now. Race your best instead. This one doesn\'t move your rank.'**
  String get nobodyFreeRaceBest;

  /// No description provided for @nobodyFreeFirstScore.
  ///
  /// In en, this message translates to:
  /// **'Nobody near your rank is free right now. Set your first score. This one doesn\'t move your rank.'**
  String get nobodyFreeFirstScore;

  /// No description provided for @bestStillIs.
  ///
  /// In en, this message translates to:
  /// **'Your best is still {count}'**
  String bestStillIs(String count);

  /// No description provided for @setInPoolTitle.
  ///
  /// In en, this message translates to:
  /// **'Your set is in the pool'**
  String get setInPoolTitle;

  /// No description provided for @setInPoolBody.
  ///
  /// In en, this message translates to:
  /// **'The next lifter near your rank races it. You\'ll see who won in Notifications, and your rank moves then.'**
  String get setInPoolBody;

  /// No description provided for @obWhyNeededBody.
  ///
  /// In en, this message translates to:
  /// **'Each rep is judged by how low you go and how high you come back up, and only the camera can see that. Without it there is no count, and without a count there is no duel. The camera is only on during a set.'**
  String get obWhyNeededBody;

  /// No description provided for @obWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get obWelcomeBack;

  /// No description provided for @obTitlesHeading.
  ///
  /// In en, this message translates to:
  /// **'{count} titles to earn'**
  String obTitlesHeading(String count);

  /// No description provided for @obTitlesBody.
  ///
  /// In en, this message translates to:
  /// **'For wins, streaks, clean sets, early mornings and more. Wear one under your name.'**
  String get obTitlesBody;

  /// No description provided for @obFriendsHeading.
  ///
  /// In en, this message translates to:
  /// **'Settle it with friends'**
  String get obFriendsHeading;

  /// No description provided for @obFriendsBody.
  ///
  /// In en, this message translates to:
  /// **'Friends add you with this code. Challenge them whenever you like, and the score between you is kept.'**
  String get obFriendsBody;

  /// No description provided for @obLetsGo.
  ///
  /// In en, this message translates to:
  /// **'Let’s go'**
  String get obLetsGo;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Climb from Iron to Master'**
  String get paywallTitle;

  /// No description provided for @paywallPerkDuels.
  ///
  /// In en, this message translates to:
  /// **'Camera-judged duels'**
  String get paywallPerkDuels;

  /// No description provided for @paywallPerkLadder.
  ///
  /// In en, this message translates to:
  /// **'Live ranked ladder'**
  String get paywallPerkLadder;

  /// No description provided for @paywallPerkFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends and challenges'**
  String get paywallPerkFriends;

  /// No description provided for @paywallPerkHistory.
  ///
  /// In en, this message translates to:
  /// **'Every rep of every match'**
  String get paywallPerkHistory;

  /// No description provided for @paywallYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get paywallYearly;

  /// No description provided for @paywallWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get paywallWeekly;

  /// No description provided for @paywallPerWeek.
  ///
  /// In en, this message translates to:
  /// **'{price}/week'**
  String paywallPerWeek(String price);

  /// No description provided for @paywallEveryWeek.
  ///
  /// In en, this message translates to:
  /// **'per week'**
  String get paywallEveryWeek;

  /// No description provided for @paywallSave.
  ///
  /// In en, this message translates to:
  /// **'Save {percent}%'**
  String paywallSave(String percent);

  /// No description provided for @paywallStart.
  ///
  /// In en, this message translates to:
  /// **'Start climbing'**
  String get paywallStart;

  /// No description provided for @paywallRenewsPlay.
  ///
  /// In en, this message translates to:
  /// **'Renews automatically until you cancel. Cancel anytime in Google Play.'**
  String get paywallRenewsPlay;

  /// No description provided for @paywallRenewsApple.
  ///
  /// In en, this message translates to:
  /// **'Renews automatically until you cancel. Cancel anytime in your Apple account settings.'**
  String get paywallRenewsApple;

  /// No description provided for @paywallRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get paywallRestore;

  /// No description provided for @paywallTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get paywallTerms;

  /// No description provided for @paywallPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get paywallPrivacy;

  /// No description provided for @paywallLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the plans. Check your connection and try again.'**
  String get paywallLoadFailed;

  /// No description provided for @paywallBuyFailed.
  ///
  /// In en, this message translates to:
  /// **'The purchase didn\'t go through. Try again.'**
  String get paywallBuyFailed;

  /// No description provided for @paywallPending.
  ///
  /// In en, this message translates to:
  /// **'Your payment is pending. Everything unlocks as soon as the store confirms it.'**
  String get paywallPending;

  /// No description provided for @paywallNothingToRestore.
  ///
  /// In en, this message translates to:
  /// **'No subscription found to restore.'**
  String get paywallNothingToRestore;

  /// No description provided for @paywallRestored.
  ///
  /// In en, this message translates to:
  /// **'Subscription restored'**
  String get paywallRestored;

  /// No description provided for @paywallSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String paywallSignedInAs(String email);

  /// No description provided for @deleteKeepsSubscription.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account doesn\'t cancel your subscription: the store bills it, not outrepd. Cancel it first in Google Play or in your Apple account settings.'**
  String get deleteKeepsSubscription;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutQuestion;

  /// No description provided for @signOutBody.
  ///
  /// In en, this message translates to:
  /// **'Your account stays as it is, with its rank, history and subscription. Sign back in any time with your email.'**
  String get signOutBody;

  /// No description provided for @shareVictory.
  ///
  /// In en, this message translates to:
  /// **'VICTORY'**
  String get shareVictory;

  /// No description provided for @shareRematch.
  ///
  /// In en, this message translates to:
  /// **'REMATCH?'**
  String get shareRematch;

  /// No description provided for @friendCodeInvite.
  ///
  /// In en, this message translates to:
  /// **'Duel me on outrepd. Add me with my friend code {code}\nhttps://outrepd.com'**
  String friendCodeInvite(String code);

  /// No description provided for @soundsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get soundsLabel;

  /// No description provided for @soundsHint.
  ///
  /// In en, this message translates to:
  /// **'A beep for 3, 2, 1, a tick for each rep, and the end of the round. Plays over your music.'**
  String get soundsHint;

  /// No description provided for @phoneSection.
  ///
  /// In en, this message translates to:
  /// **'On this phone'**
  String get phoneSection;

  /// No description provided for @allowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get allowNotifications;

  /// No description provided for @allowNotificationsHint.
  ///
  /// In en, this message translates to:
  /// **'They\'re off for OUTREPD in your phone\'s settings, so nothing below can reach you.'**
  String get allowNotificationsHint;

  /// No description provided for @remindersSection.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get remindersSection;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get dailyReminder;

  /// No description provided for @dailyReminderHint.
  ///
  /// In en, this message translates to:
  /// **'Only on days you haven\'t trained yet.'**
  String get dailyReminderHint;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get reminderTime;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for today\'s push-ups'**
  String get reminderTitle;

  /// No description provided for @reminderStreakBody.
  ///
  /// In en, this message translates to:
  /// **'Keep your {count}-day streak going. One set is enough.'**
  String reminderStreakBody(String count);

  /// No description provided for @channelMatches.
  ///
  /// In en, this message translates to:
  /// **'Matches and friends'**
  String get channelMatches;

  /// No description provided for @channelReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get channelReminders;

  /// No description provided for @liveTag.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get liveTag;

  /// No description provided for @reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting'**
  String get reconnecting;

  /// No description provided for @rankedLive.
  ///
  /// In en, this message translates to:
  /// **'Ranked · live'**
  String get rankedLive;

  /// No description provided for @lookingForLive.
  ///
  /// In en, this message translates to:
  /// **'Looking for a live opponent'**
  String get lookingForLive;

  /// No description provided for @ofTime.
  ///
  /// In en, this message translates to:
  /// **'of {time}'**
  String ofTime(String time);

  /// No description provided for @liveFallbackAt.
  ///
  /// In en, this message translates to:
  /// **'At {time} you race a saved set instead'**
  String liveFallbackAt(String time);

  /// No description provided for @liveFoundBody.
  ///
  /// In en, this message translates to:
  /// **'{name} is on the camera now. Same clock, same start.'**
  String liveFoundBody(String name);

  /// No description provided for @nobodyLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Nobody\'s live right now'**
  String get nobodyLiveTitle;

  /// No description provided for @nobodyLiveBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll race a saved set instead'**
  String get nobodyLiveBody;

  /// No description provided for @didRepsIn.
  ///
  /// In en, this message translates to:
  /// **'Did {reps} in 60 seconds'**
  String didRepsIn(String reps);

  /// No description provided for @sameRankPoints.
  ///
  /// In en, this message translates to:
  /// **'Same rank points as a live match'**
  String get sameRankPoints;

  /// No description provided for @raceIt.
  ///
  /// In en, this message translates to:
  /// **'Race it'**
  String get raceIt;

  /// No description provided for @onlineNow.
  ///
  /// In en, this message translates to:
  /// **'Online now'**
  String get onlineNow;

  /// No description provided for @friendlyNoRank.
  ///
  /// In en, this message translates to:
  /// **'Friendly · no rank'**
  String get friendlyNoRank;

  /// No description provided for @waitingForName.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name}'**
  String waitingForName(String name);

  /// No description provided for @weSentThemANotice.
  ///
  /// In en, this message translates to:
  /// **'We sent them a notification'**
  String get weSentThemANotice;

  /// No description provided for @untilInviteRunsOut.
  ///
  /// In en, this message translates to:
  /// **'until the invite runs out'**
  String get untilInviteRunsOut;

  /// No description provided for @cancelInvite.
  ///
  /// In en, this message translates to:
  /// **'Cancel invite'**
  String get cancelInvite;

  /// No description provided for @inviteDeclined.
  ///
  /// In en, this message translates to:
  /// **'{name} said not now'**
  String inviteDeclined(String name);

  /// No description provided for @inviteRanOut.
  ///
  /// In en, this message translates to:
  /// **'The invite ran out'**
  String get inviteRanOut;

  /// No description provided for @inviteAgain.
  ///
  /// In en, this message translates to:
  /// **'Invite again'**
  String get inviteAgain;

  /// No description provided for @liveInviteFrom.
  ///
  /// In en, this message translates to:
  /// **'{name} is live'**
  String liveInviteFrom(String name);

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'{time} left'**
  String timeLeft(String time);

  /// No description provided for @joinLive.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get joinLive;

  /// No description provided for @nLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Live invite'**
  String get nLiveTitle;

  /// No description provided for @nLiveBody.
  ///
  /// In en, this message translates to:
  /// **'{name} wants to go live'**
  String nLiveBody(String name);

  /// No description provided for @inviteGone.
  ///
  /// In en, this message translates to:
  /// **'That invite has run out'**
  String get inviteGone;

  /// No description provided for @opponentDropped.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s connection dropped. Keep going: the round finishes on the clock.'**
  String opponentDropped(String name);

  /// No description provided for @opponentGaveUp.
  ///
  /// In en, this message translates to:
  /// **'{name} gave up. Finish the round to take the win.'**
  String opponentGaveUp(String name);

  /// No description provided for @calledOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Match called off'**
  String get calledOffTitle;

  /// No description provided for @calledOffBody.
  ///
  /// In en, this message translates to:
  /// **'{name} didn\'t get into position in time. Nothing was recorded.'**
  String calledOffBody(String name);

  /// No description provided for @waitingForFinal.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name}\'s final count…'**
  String waitingForFinal(String name);

  /// No description provided for @wantsToBeFriends.
  ///
  /// In en, this message translates to:
  /// **'wants to be friends'**
  String get wantsToBeFriends;

  /// No description provided for @giveUpQuestion.
  ///
  /// In en, this message translates to:
  /// **'Give up this round?'**
  String get giveUpQuestion;

  /// No description provided for @giveUpBody.
  ///
  /// In en, this message translates to:
  /// **'It counts as a loss, whatever your count is now.'**
  String get giveUpBody;

  /// No description provided for @waitingToJoin.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name} to join'**
  String waitingToJoin(String name);

  /// No description provided for @removeFriend.
  ///
  /// In en, this message translates to:
  /// **'Remove friend'**
  String get removeFriend;

  /// No description provided for @removeFriendBody.
  ///
  /// In en, this message translates to:
  /// **'They aren\'t told, and you can add each other again'**
  String get removeFriendBody;

  /// No description provided for @removeFriendQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove {username} from your friends?'**
  String removeFriendQuestion(String username);

  /// No description provided for @removeAction.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeAction;

  /// No description provided for @removedFriend.
  ///
  /// In en, this message translates to:
  /// **'Removed {username} from your friends'**
  String removedFriend(String username);

  /// No description provided for @noticeChallenged.
  ///
  /// In en, this message translates to:
  /// **'Someone challenged me to a rematch'**
  String get noticeChallenged;

  /// No description provided for @noticeLiveInvite.
  ///
  /// In en, this message translates to:
  /// **'A friend asked me to go live'**
  String get noticeLiveInvite;

  /// No description provided for @trialToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get trialToday;

  /// No description provided for @trialTodayBody.
  ///
  /// In en, this message translates to:
  /// **'Every duel, live and ranked, unlocked.'**
  String get trialTodayBody;

  /// No description provided for @trialDay.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String trialDay(String day);

  /// No description provided for @trialReminderBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you the day before your trial ends.'**
  String get trialReminderBody;

  /// No description provided for @trialEndBody.
  ///
  /// In en, this message translates to:
  /// **'Your plan starts. Cancel any time before and you pay nothing.'**
  String get trialEndBody;

  /// No description provided for @trialTag.
  ///
  /// In en, this message translates to:
  /// **'{days} days free'**
  String trialTag(String days);

  /// No description provided for @trialCta.
  ///
  /// In en, this message translates to:
  /// **'Start my {days}-day free trial'**
  String trialCta(String days);

  /// No description provided for @trialThenYearly.
  ///
  /// In en, this message translates to:
  /// **'No payment now · then {price}/year'**
  String trialThenYearly(String price);

  /// No description provided for @trialThenWeekly.
  ///
  /// In en, this message translates to:
  /// **'No payment now · then {price}/week'**
  String trialThenWeekly(String price);

  /// No description provided for @trialEndsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your free trial ends tomorrow'**
  String get trialEndsTitle;

  /// No description provided for @trialEndsBody.
  ///
  /// In en, this message translates to:
  /// **'Keep climbing, or cancel before then in your subscription settings.'**
  String get trialEndsBody;

  /// No description provided for @obIdeaTitle.
  ///
  /// In en, this message translates to:
  /// **'60 seconds. One opponent.'**
  String get obIdeaTitle;

  /// No description provided for @obIdeaRival.
  ///
  /// In en, this message translates to:
  /// **'A real person, live or their recorded set'**
  String get obIdeaRival;

  /// No description provided for @obIdeaCamera.
  ///
  /// In en, this message translates to:
  /// **'Your camera counts every rep, on your phone'**
  String get obIdeaCamera;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @shortDays.
  ///
  /// In en, this message translates to:
  /// **'{n}d'**
  String shortDays(String n);

  /// No description provided for @shortHours.
  ///
  /// In en, this message translates to:
  /// **'{n}h'**
  String shortHours(String n);

  /// No description provided for @awardChampion.
  ///
  /// In en, this message translates to:
  /// **'Champion'**
  String get awardChampion;

  /// No description provided for @awardPodium.
  ///
  /// In en, this message translates to:
  /// **'Podium'**
  String get awardPodium;

  /// No description provided for @awardTop10.
  ///
  /// In en, this message translates to:
  /// **'Top 10'**
  String get awardTop10;

  /// No description provided for @awardRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get awardRegular;

  /// No description provided for @monthToTop10.
  ///
  /// In en, this message translates to:
  /// **'{lp} LP to the top 10'**
  String monthToTop10(String lp);

  /// No description provided for @monthIfEndedNow.
  ///
  /// In en, this message translates to:
  /// **'{award} if the month ended now'**
  String monthIfEndedNow(String award);

  /// No description provided for @monthJoinHint.
  ///
  /// In en, this message translates to:
  /// **'Play a ranked duel to get on this month\'s board'**
  String get monthJoinHint;

  /// No description provided for @monthRegularProgress.
  ///
  /// In en, this message translates to:
  /// **'Regular badge · {progress} ranked duels'**
  String monthRegularProgress(String progress);

  /// No description provided for @monthRegularEarned.
  ///
  /// In en, this message translates to:
  /// **'Regular badge earned this month'**
  String get monthRegularEarned;

  /// No description provided for @monthEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'A fresh month'**
  String get monthEmptyTitle;

  /// No description provided for @monthEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Nobody has won LP this month yet. Win the first ranked duel and you lead.'**
  String get monthEmptyBody;

  /// No description provided for @rankedDuelsCount.
  ///
  /// In en, this message translates to:
  /// **'{n} ranked duels'**
  String rankedDuelsCount(String n);

  /// No description provided for @monthlyAwards.
  ///
  /// In en, this message translates to:
  /// **'Monthly awards'**
  String get monthlyAwards;

  /// No description provided for @seasonOver.
  ///
  /// In en, this message translates to:
  /// **'Season over'**
  String get seasonOver;

  /// No description provided for @seasonOverBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s on your profile now. The new month starts from zero.'**
  String get seasonOverBody;

  /// No description provided for @seasonPlayCta.
  ///
  /// In en, this message translates to:
  /// **'Play the new month'**
  String get seasonPlayCta;

  /// No description provided for @rematchLive.
  ///
  /// In en, this message translates to:
  /// **'Rematch live'**
  String get rematchLive;

  /// No description provided for @rematchWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name}'**
  String rematchWaiting(String name);

  /// No description provided for @rematchAsked.
  ///
  /// In en, this message translates to:
  /// **'{name} wants a rematch'**
  String rematchAsked(String name);

  /// No description provided for @rematchGone.
  ///
  /// In en, this message translates to:
  /// **'No rematch this time'**
  String get rematchGone;

  /// No description provided for @twoRankedADay.
  ///
  /// In en, this message translates to:
  /// **'Friendly · 2 ranked a day with the same lifter'**
  String get twoRankedADay;

  /// No description provided for @monthMove.
  ///
  /// In en, this message translates to:
  /// **'This month · {move}'**
  String monthMove(String move);

  /// No description provided for @promotedFrom.
  ///
  /// In en, this message translates to:
  /// **'from {rank}'**
  String promotedFrom(String rank);

  /// No description provided for @liveOnlineNow.
  ///
  /// In en, this message translates to:
  /// **'{n} online now'**
  String liveOnlineNow(String n);

  /// No description provided for @liveSearchingNow.
  ///
  /// In en, this message translates to:
  /// **'{n} searching'**
  String liveSearchingNow(String n);

  /// No description provided for @dailyGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s goal'**
  String get dailyGoalTitle;

  /// No description provided for @dailyGoalDone.
  ///
  /// In en, this message translates to:
  /// **'Done for today'**
  String get dailyGoalDone;

  /// No description provided for @dailyGoalProgress.
  ///
  /// In en, this message translates to:
  /// **'{progress} push-ups'**
  String dailyGoalProgress(String progress);

  /// No description provided for @dailyGoalLeft.
  ///
  /// In en, this message translates to:
  /// **'{n} to go'**
  String dailyGoalLeft(String n);

  /// No description provided for @dailyGoalChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get dailyGoalChange;

  /// No description provided for @dailyGoalPick.
  ///
  /// In en, this message translates to:
  /// **'Your daily goal'**
  String get dailyGoalPick;

  /// No description provided for @dailyGoalOption.
  ///
  /// In en, this message translates to:
  /// **'{n} push-ups a day'**
  String dailyGoalOption(String n);

  /// No description provided for @widgetGoalOf.
  ///
  /// In en, this message translates to:
  /// **'of {goal} today'**
  String widgetGoalOf(String goal);

  /// No description provided for @saveToAppleHealth.
  ///
  /// In en, this message translates to:
  /// **'Save workouts to Apple Health'**
  String get saveToAppleHealth;

  /// No description provided for @saveToHealthConnect.
  ///
  /// In en, this message translates to:
  /// **'Save workouts to Health Connect'**
  String get saveToHealthConnect;

  /// No description provided for @saveToHealthHint.
  ///
  /// In en, this message translates to:
  /// **'Every set you lift is added as a strength workout. Nothing is read back.'**
  String get saveToHealthHint;

  /// No description provided for @healthNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Not allowed yet. You can allow it in your phone\'s health settings.'**
  String get healthNotAllowed;

  /// No description provided for @reminderLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} push-ups left for today\'s goal.'**
  String reminderLeft(String count);

  /// No description provided for @liveInviteHint.
  ///
  /// In en, this message translates to:
  /// **'Online friends can join right away. The rest get a notice and a minute to join.'**
  String get liveInviteHint;

  /// No description provided for @requestSentShort.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get requestSentShort;

  /// No description provided for @healthWorksWith.
  ///
  /// In en, this message translates to:
  /// **'OUTREPD works with {health}'**
  String healthWorksWith(String health);

  /// No description provided for @healthCardBody.
  ///
  /// In en, this message translates to:
  /// **'Every set you finish is saved to {health} as a strength workout. OUTREPD never reads your health data.'**
  String healthCardBody(String health);

  /// No description provided for @savedToHealth.
  ///
  /// In en, this message translates to:
  /// **'Saved to {health}'**
  String savedToHealth(String health);

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Too short: at least 4 characters'**
  String get usernameTooShort;

  /// No description provided for @usernameBadCharacters.
  ///
  /// In en, this message translates to:
  /// **'Only letters, numbers and _'**
  String get usernameBadCharacters;

  /// No description provided for @usernameNeedsLetter.
  ///
  /// In en, this message translates to:
  /// **'Add at least one letter or number'**
  String get usernameNeedsLetter;

  /// No description provided for @usernameChangeAgainOn.
  ///
  /// In en, this message translates to:
  /// **'You can change it again on {date}'**
  String usernameChangeAgainOn(String date);

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @socialSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn't sign in. Try again.'**
  String get socialSignInFailed;

  /// No description provided for @chooseUsernameTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your username'**
  String get chooseUsernameTitle;

  /// No description provided for @chooseUsernameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'It's how other lifters find you and see you on the boards.'**
  String get chooseUsernameSubtitle;

  /// No description provided for @authHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'OUT-REP ANYONE.'**
  String get authHeroTitle;

  /// No description provided for @authHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Live push-up duels, counted by your camera.'**
  String get authHeroSubtitle;

  /// No description provided for @createAccountPitch.
  ///
  /// In en, this message translates to:
  /// **'Your rank, your duels, on every phone.'**
  String get createAccountPitch;

  /// No description provided for @usernameSpacesHint.
  ///
  /// In en, this message translates to:
  /// **'Spaces become _'**
  String get usernameSpacesHint;

  /// No description provided for @emailCodeNote.
  ///
  /// In en, this message translates to:
  /// **'We'll email you a 6-digit code. No password.'**
  String get emailCodeNote;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get continueWithEmail;

  /// No description provided for @thisSeason.
  ///
  /// In en, this message translates to:
  /// **'This Season'**
  String get thisSeason;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @weekStartsAgain.
  ///
  /// In en, this message translates to:
  /// **'Starts again every Monday'**
  String get weekStartsAgain;

  /// No description provided for @lengthWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get lengthWeek;

  /// No description provided for @lengthMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get lengthMonth;

  /// No description provided for @weekJoinHint.
  ///
  /// In en, this message translates to:
  /// **'Win a ranked duel this week to get on the board'**
  String get weekJoinHint;

  /// No description provided for @weekInTop3.
  ///
  /// In en, this message translates to:
  /// **'In the top 3 this week'**
  String get weekInTop3;

  /// No description provided for @weekToTop3.
  ///
  /// In en, this message translates to:
  /// **'{n} LP to the top 3'**
  String weekToTop3(String n);

  /// No description provided for @boardActiveNote.
  ///
  /// In en, this message translates to:
  /// **'Players active in the last 30 days'**
  String get boardActiveNote;

  /// No description provided for @boardTieNote.
  ///
  /// In en, this message translates to:
  /// **'ties: more wins first'**
  String get boardTieNote;

  /// No description provided for @lpBreakdown.
  ///
  /// In en, this message translates to:
  /// **'{reps} for the reps · {adjust} for a {rank} opponent'**
  String lpBreakdown(String reps, String adjust, String rank);

  /// No description provided for @levelShort.
  ///
  /// In en, this message translates to:
  /// **'Lv {n}'**
  String levelShort(String n);

  /// No description provided for @xpOf.
  ///
  /// In en, this message translates to:
  /// **'{into} / {span} XP'**
  String xpOf(String into, String span);

  /// No description provided for @xpToLevel.
  ///
  /// In en, this message translates to:
  /// **'{n} XP to Level {level}'**
  String xpToLevel(String n, String level);

  /// No description provided for @xpHow.
  ///
  /// In en, this message translates to:
  /// **'{rep} XP a rep, {match} a match'**
  String xpHow(String rep, String match);

  /// No description provided for @xpGained.
  ///
  /// In en, this message translates to:
  /// **'+{n} XP'**
  String xpGained(String n);

  /// No description provided for @xpForReps.
  ///
  /// In en, this message translates to:
  /// **'{n} for the reps'**
  String xpForReps(String n);

  /// No description provided for @xpForMatch.
  ///
  /// In en, this message translates to:
  /// **'{n} for the match'**
  String xpForMatch(String n);

  /// No description provided for @levelUp.
  ///
  /// In en, this message translates to:
  /// **'Level up'**
  String get levelUp;

  /// No description provided for @levelUpBody.
  ///
  /// In en, this message translates to:
  /// **'Every rep counts. Keep going.'**
  String get levelUpBody;

  /// No description provided for @giveUpAhead.
  ///
  /// In en, this message translates to:
  /// **'You're {n} ahead'**
  String giveUpAhead(String n);

  /// No description provided for @giveUpBehind.
  ///
  /// In en, this message translates to:
  /// **'You're {n} behind'**
  String giveUpBehind(String n);

  /// No description provided for @giveUpTied.
  ///
  /// In en, this message translates to:
  /// **'Tied'**
  String get giveUpTied;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get keepGoing;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @lastN.
  ///
  /// In en, this message translates to:
  /// **'Last {n}'**
  String lastN(String n);

  /// No description provided for @firstMatchForTier.
  ///
  /// In en, this message translates to:
  /// **'Play your first match to get on the ladder. Everyone starts at Iron V.'**
  String get firstMatchForTier;

  /// No description provided for @firstMatchForBoard.
  ///
  /// In en, this message translates to:
  /// **'Play your first match to get on the board. Everyone starts at Iron V.'**
  String get firstMatchForBoard;

  /// No description provided for @playFirstMatch.
  ///
  /// In en, this message translates to:
  /// **'Play first match'**
  String get playFirstMatch;

  /// No description provided for @firstMatchTerms.
  ///
  /// In en, this message translates to:
  /// **'One match · {seconds} seconds'**
  String firstMatchTerms(String seconds);

  /// No description provided for @placedLabel.
  ///
  /// In en, this message translates to:
  /// **'You're on the ladder'**
  String get placedLabel;

  /// No description provided for @placedBody.
  ///
  /// In en, this message translates to:
  /// **'Everyone starts here. Only wins move you up.'**
  String get placedBody;

  /// No description provided for @placedHow.
  ///
  /// In en, this message translates to:
  /// **'Win matches to earn LP. Beat someone ranked higher for more.'**
  String get placedHow;

  /// No description provided for @levelBesideName.
  ///
  /// In en, this message translates to:
  /// **'Beside your name, everywhere'**
  String get levelBesideName;

  /// No description provided for @weekRaceTitle.
  ///
  /// In en, this message translates to:
  /// **'This week's race'**
  String get weekRaceTitle;

  /// No description provided for @streakDoneToday.
  ///
  /// In en, this message translates to:
  /// **'done today'**
  String get streakDoneToday;

  /// No description provided for @streakTrainToday.
  ///
  /// In en, this message translates to:
  /// **'train today to add a day'**
  String get streakTrainToday;

  /// No description provided for @raceChartTitle.
  ///
  /// In en, this message translates to:
  /// **'How the minute went'**
  String get raceChartTitle;

  /// No description provided for @raceYouLead.
  ///
  /// In en, this message translates to:
  /// **'{time} · you took the lead'**
  String raceYouLead(String time);

  /// No description provided for @raceTheyLead.
  ///
  /// In en, this message translates to:
  /// **'{time} · {name} took the lead'**
  String raceTheyLead(String time, String name);

  /// No description provided for @bringFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'Bring a friend'**
  String get bringFriendTitle;

  /// No description provided for @bringFriendBody.
  ///
  /// In en, this message translates to:
  /// **'Send your link. It opens your profile, where they can add you.'**
  String get bringFriendBody;

  /// No description provided for @bringFriendShare.
  ///
  /// In en, this message translates to:
  /// **'Share my link'**
  String get bringFriendShare;

  /// No description provided for @bringFriendShareText.
  ///
  /// In en, this message translates to:
  /// **'Race me at push-ups on OUTREPD. 60 seconds, live, and the camera counts.'**
  String get bringFriendShareText;

  /// No description provided for @orFriendCode.
  ///
  /// In en, this message translates to:
  /// **'or friend code {code}'**
  String orFriendCode(String code);

  /// No description provided for @countryPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Your country'**
  String get countryPickerTitle;

  /// No description provided for @countrySearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get countrySearch;

  /// No description provided for @countryFromPhone.
  ///
  /// In en, this message translates to:
  /// **'From your phone'**
  String get countryFromPhone;

  /// No description provided for @countryAll.
  ///
  /// In en, this message translates to:
  /// **'All countries'**
  String get countryAll;

  /// No description provided for @countryChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose your country'**
  String get countryChoose;

  /// No description provided for @countryChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get countryChange;

  /// No description provided for @countryForBoard.
  ///
  /// In en, this message translates to:
  /// **'For your country's leaderboard'**
  String get countryForBoard;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @countryChanged.
  ///
  /// In en, this message translates to:
  /// **'Country changed'**
  String get countryChanged;

  /// No description provided for @countryEvery14.
  ///
  /// In en, this message translates to:
  /// **'Once every 14 days, like your name'**
  String get countryEvery14;

  /// No description provided for @countryNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Couldn't save your country. Try again.'**
  String get countryNotSaved;

  /// No description provided for @adventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get adventure;

  /// No description provided for @stageNumber.
  ///
  /// In en, this message translates to:
  /// **'Level {n}'**
  String stageNumber(String n);

  /// No description provided for @adventureLevelIn.
  ///
  /// In en, this message translates to:
  /// **'Level {level} · {world}'**
  String adventureLevelIn(String level, String world);

  /// No description provided for @adventureClearedOf.
  ///
  /// In en, this message translates to:
  /// **'{cleared} of {total} cleared · no rank'**
  String adventureClearedOf(String cleared, String total);

  /// No description provided for @worldIron.
  ///
  /// In en, this message translates to:
  /// **'Iron Mines'**
  String get worldIron;

  /// No description provided for @worldBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze Dunes'**
  String get worldBronze;

  /// No description provided for @worldSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver Peaks'**
  String get worldSilver;

  /// No description provided for @worldGold.
  ///
  /// In en, this message translates to:
  /// **'Gold Citadel'**
  String get worldGold;

  /// No description provided for @worldPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum Glacier'**
  String get worldPlatinum;

  /// No description provided for @worldDiamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond Caverns'**
  String get worldDiamond;

  /// No description provided for @worldMaster.
  ///
  /// In en, this message translates to:
  /// **'Master’s Throne'**
  String get worldMaster;

  /// No description provided for @worldNumber.
  ///
  /// In en, this message translates to:
  /// **'World {n}'**
  String worldNumber(String n);

  /// No description provided for @fightLevel.
  ///
  /// In en, this message translates to:
  /// **'Fight level {level}'**
  String fightLevel(String level);

  /// No description provided for @levelHpLine.
  ///
  /// In en, this message translates to:
  /// **'HP {hp} · about {reps} push-ups'**
  String levelHpLine(String hp, String reps);

  /// No description provided for @hpShort.
  ///
  /// In en, this message translates to:
  /// **'HP'**
  String get hpShort;

  /// No description provided for @comboTag.
  ///
  /// In en, this message translates to:
  /// **'COMBO ×{n}'**
  String comboTag(String n);

  /// No description provided for @levelCleared.
  ///
  /// In en, this message translates to:
  /// **'CLEARED'**
  String get levelCleared;

  /// No description provided for @outOfTime.
  ///
  /// In en, this message translates to:
  /// **'OUT OF TIME'**
  String get outOfTime;

  /// No description provided for @statPushUps.
  ///
  /// In en, this message translates to:
  /// **'push-ups'**
  String get statPushUps;

  /// No description provided for @statTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get statTimeLeft;

  /// No description provided for @statHpLeft.
  ///
  /// In en, this message translates to:
  /// **'HP left'**
  String get statHpLeft;

  /// No description provided for @statXp.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get statXp;

  /// No description provided for @secondStarHint.
  ///
  /// In en, this message translates to:
  /// **'Finish with {seconds} seconds left for the second star'**
  String secondStarHint(String seconds);

  /// No description provided for @thirdStarHint.
  ///
  /// In en, this message translates to:
  /// **'Finish with {seconds} seconds left for the third star'**
  String thirdStarHint(String seconds);

  /// No description provided for @fightLostHint.
  ///
  /// In en, this message translates to:
  /// **'Win earlier levels again for more stars: they unlock stronger weapons.'**
  String get fightLostHint;

  /// No description provided for @nextLevel.
  ///
  /// In en, this message translates to:
  /// **'Next level'**
  String get nextLevel;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @adventureMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get adventureMap;

  /// No description provided for @nextKicker.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get nextKicker;

  /// No description provided for @nextLevelLine.
  ///
  /// In en, this message translates to:
  /// **'Level {level} · HP {hp}'**
  String nextLevelLine(String level, String hp);

  /// No description provided for @armory.
  ///
  /// In en, this message translates to:
  /// **'Armory'**
  String get armory;

  /// No description provided for @armoryBody.
  ///
  /// In en, this message translates to:
  /// **'Stars unlock weapons. Every push-up hits with the best one you have.'**
  String get armoryBody;

  /// No description provided for @equipped.
  ///
  /// In en, this message translates to:
  /// **'EQUIPPED'**
  String get equipped;

  /// No description provided for @perPushUp.
  ///
  /// In en, this message translates to:
  /// **'{damage} per push-up'**
  String perPushUp(String damage);

  /// No description provided for @damagePerPushUp.
  ///
  /// In en, this message translates to:
  /// **'{damage} damage per push-up'**
  String damagePerPushUp(String damage);

  /// No description provided for @wasWith.
  ///
  /// In en, this message translates to:
  /// **'was {damage} with {weapon}'**
  String wasWith(String damage, String weapon);

  /// No description provided for @moreStars.
  ///
  /// In en, this message translates to:
  /// **'{count} more stars'**
  String moreStars(String count);

  /// No description provided for @newWeapon.
  ///
  /// In en, this message translates to:
  /// **'New weapon'**
  String get newWeapon;

  /// No description provided for @starsKicker.
  ///
  /// In en, this message translates to:
  /// **'{count} STARS'**
  String starsKicker(String count);

  /// No description provided for @weaponGauntlets.
  ///
  /// In en, this message translates to:
  /// **'Iron Gauntlets'**
  String get weaponGauntlets;

  /// No description provided for @weaponKnuckles.
  ///
  /// In en, this message translates to:
  /// **'Bronze Knuckles'**
  String get weaponKnuckles;

  /// No description provided for @weaponFang.
  ///
  /// In en, this message translates to:
  /// **'Silver Fang'**
  String get weaponFang;

  /// No description provided for @weaponHammer.
  ///
  /// In en, this message translates to:
  /// **'Gold Hammer'**
  String get weaponHammer;

  /// No description provided for @weaponAxe.
  ///
  /// In en, this message translates to:
  /// **'Platinum Axe'**
  String get weaponAxe;

  /// No description provided for @weaponSpear.
  ///
  /// In en, this message translates to:
  /// **'Diamond Spear'**
  String get weaponSpear;

  /// No description provided for @weaponSword.
  ///
  /// In en, this message translates to:
  /// **'Master Sword'**
  String get weaponSword;

  /// No description provided for @weaponCrownbreaker.
  ///
  /// In en, this message translates to:
  /// **'Crownbreaker'**
  String get weaponCrownbreaker;

  /// No description provided for @clearFirst.
  ///
  /// In en, this message translates to:
  /// **'Win level {level} first'**
  String clearFirst(String level);

  /// No description provided for @needsWeapon.
  ///
  /// In en, this message translates to:
  /// **'Needs {weapon}'**
  String needsWeapon(String weapon);

  /// No description provided for @hurtOnlyBy.
  ///
  /// In en, this message translates to:
  /// **'Only {weapon} or better can hurt it'**
  String hurtOnlyBy(String weapon);

  /// No description provided for @worldNeedsWeapon.
  ///
  /// In en, this message translates to:
  /// **'{world} needs {weapon} · {count} more stars'**
  String worldNeedsWeapon(String world, String weapon, String count);

  /// No description provided for @rematchOpponentLeft.
  ///
  /// In en, this message translates to:
  /// **'{name} left · no rematch this time'**
  String rematchOpponentLeft(String name);

  /// No description provided for @obNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get obNext;

  /// No description provided for @obRaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Race a real person.'**
  String get obRaceTitle;

  /// No description provided for @obRaceBody.
  ///
  /// In en, this message translates to:
  /// **'Most reps in 60 seconds wins. Live, on their own phone — or their recorded set when nobody is online.'**
  String get obRaceBody;

  /// No description provided for @obRepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Only full reps count.'**
  String get obRepsTitle;

  /// No description provided for @obRepsBody.
  ///
  /// In en, this message translates to:
  /// **'Your camera watches how low you go and how high you come back.'**
  String get obRepsBody;

  /// No description provided for @obRepsDown.
  ///
  /// In en, this message translates to:
  /// **'Down past the gold line'**
  String get obRepsDown;

  /// No description provided for @obRepsUp.
  ///
  /// In en, this message translates to:
  /// **'Back up past the top line'**
  String get obRepsUp;

  /// No description provided for @obRepsBoth.
  ///
  /// In en, this message translates to:
  /// **'Both, with your hands on the floor. A half rep is not a rep — on your phone or theirs.'**
  String get obRepsBoth;

  /// No description provided for @obClimbTitle.
  ///
  /// In en, this message translates to:
  /// **'Climb to Master.'**
  String get obClimbTitle;

  /// No description provided for @obClimbBody.
  ///
  /// In en, this message translates to:
  /// **'Win to move up the ladder: seven tiers, five steps each.'**
  String get obClimbBody;

  /// No description provided for @obAdventureTitle.
  ///
  /// In en, this message translates to:
  /// **'Training alone?'**
  String get obAdventureTitle;

  /// No description provided for @obAdventureBody.
  ///
  /// In en, this message translates to:
  /// **'Adventure has 140 levels of push-up fights, each harder than the last.'**
  String get obAdventureBody;

  /// No description provided for @obCountedHere.
  ///
  /// In en, this message translates to:
  /// **'Counted on this phone'**
  String get obCountedHere;

  /// No description provided for @obGoldLine.
  ///
  /// In en, this message translates to:
  /// **'gold line'**
  String get obGoldLine;

  /// No description provided for @obCalibrationRule.
  ///
  /// In en, this message translates to:
  /// **'Down past the {gold}, back up past the top one'**
  String obCalibrationRule(String gold);

  /// No description provided for @proTitleTop.
  ///
  /// In en, this message translates to:
  /// **'No ads.'**
  String get proTitleTop;

  /// No description provided for @proTitleBottom.
  ///
  /// In en, this message translates to:
  /// **'Just push-ups.'**
  String get proTitleBottom;

  /// No description provided for @proBody.
  ///
  /// In en, this message translates to:
  /// **'Every match stays free. Pro takes the ads out of all of them.'**
  String get proBody;

  /// No description provided for @proThanks.
  ///
  /// In en, this message translates to:
  /// **'Ads are off. Thanks for going Pro.'**
  String get proThanks;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get removeAds;

  /// No description provided for @adNotice.
  ///
  /// In en, this message translates to:
  /// **'An ad plays when you leave'**
  String get adNotice;

  /// No description provided for @adAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Ads keep outrepd free'**
  String get adAskTitle;

  /// No description provided for @adAskBody.
  ///
  /// In en, this message translates to:
  /// **'Next, your iPhone asks whether apps may use your activity to choose ads. Say yes and the ads fit you better; say no and you still get ads, just less relevant ones.'**
  String get adAskBody;

  /// No description provided for @adAskCamera.
  ///
  /// In en, this message translates to:
  /// **'Your camera is never part of it: body tracking stays on this phone, whatever you choose.'**
  String get adAskCamera;

  /// No description provided for @adAskRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove ads instead'**
  String get adAskRemove;

  /// No description provided for @monsterIronColossus.
  ///
  /// In en, this message translates to:
  /// **'Iron Colossus'**
  String get monsterIronColossus;

  /// No description provided for @monsterScarab.
  ///
  /// In en, this message translates to:
  /// **'Scarab'**
  String get monsterScarab;

  /// No description provided for @monsterScarabPharaoh.
  ///
  /// In en, this message translates to:
  /// **'Scarab Pharaoh'**
  String get monsterScarabPharaoh;

  /// No description provided for @monsterYeti.
  ///
  /// In en, this message translates to:
  /// **'Yeti'**
  String get monsterYeti;

  /// No description provided for @monsterFrostYeti.
  ///
  /// In en, this message translates to:
  /// **'Frost Yeti'**
  String get monsterFrostYeti;

  /// No description provided for @monsterYetiChieftain.
  ///
  /// In en, this message translates to:
  /// **'Yeti Chieftain'**
  String get monsterYetiChieftain;

  /// No description provided for @monsterGoldSoldier.
  ///
  /// In en, this message translates to:
  /// **'Gold Soldier'**
  String get monsterGoldSoldier;

  /// No description provided for @monsterGoldKnight.
  ///
  /// In en, this message translates to:
  /// **'Gold Knight'**
  String get monsterGoldKnight;

  /// No description provided for @monsterGoldKing.
  ///
  /// In en, this message translates to:
  /// **'Gold King'**
  String get monsterGoldKing;

  /// No description provided for @monsterWisp.
  ///
  /// In en, this message translates to:
  /// **'Wisp'**
  String get monsterWisp;

  /// No description provided for @monsterWraith.
  ///
  /// In en, this message translates to:
  /// **'Wraith'**
  String get monsterWraith;

  /// No description provided for @monsterFrostLich.
  ///
  /// In en, this message translates to:
  /// **'Frost Lich'**
  String get monsterFrostLich;

  /// No description provided for @monsterCrystalDrake.
  ///
  /// In en, this message translates to:
  /// **'Crystal Drake'**
  String get monsterCrystalDrake;

  /// No description provided for @monsterCrystalDragon.
  ///
  /// In en, this message translates to:
  /// **'Crystal Dragon'**
  String get monsterCrystalDragon;

  /// No description provided for @monsterDiamondWyrm.
  ///
  /// In en, this message translates to:
  /// **'Diamond Wyrm'**
  String get monsterDiamondWyrm;

  /// No description provided for @monsterShadowGuard.
  ///
  /// In en, this message translates to:
  /// **'Shadow Guard'**
  String get monsterShadowGuard;

  /// No description provided for @monsterShadowKnight.
  ///
  /// In en, this message translates to:
  /// **'Shadow Knight'**
  String get monsterShadowKnight;

  /// No description provided for @monsterTheMaster.
  ///
  /// In en, this message translates to:
  /// **'The Master'**
  String get monsterTheMaster;

  /// No description provided for @monsterPebbleGolem.
  ///
  /// In en, this message translates to:
  /// **'Pebble Golem'**
  String get monsterPebbleGolem;

  /// No description provided for @monsterStoneGolem.
  ///
  /// In en, this message translates to:
  /// **'Stone Golem'**
  String get monsterStoneGolem;

  /// No description provided for @monsterOreGolem.
  ///
  /// In en, this message translates to:
  /// **'Ore Golem'**
  String get monsterOreGolem;

  /// No description provided for @monsterMinerGolem.
  ///
  /// In en, this message translates to:
  /// **'Miner Golem'**
  String get monsterMinerGolem;

  /// No description provided for @monsterScarabGrub.
  ///
  /// In en, this message translates to:
  /// **'Scarab Grub'**
  String get monsterScarabGrub;

  /// No description provided for @monsterHornedScarab.
  ///
  /// In en, this message translates to:
  /// **'Horned Scarab'**
  String get monsterHornedScarab;

  /// No description provided for @monsterScarabWarrior.
  ///
  /// In en, this message translates to:
  /// **'Scarab Warrior'**
  String get monsterScarabWarrior;

  /// No description provided for @monsterYetiCub.
  ///
  /// In en, this message translates to:
  /// **'Yeti Cub'**
  String get monsterYetiCub;

  /// No description provided for @monsterHornedYeti.
  ///
  /// In en, this message translates to:
  /// **'Horned Yeti'**
  String get monsterHornedYeti;

  /// No description provided for @monsterGoldRecruit.
  ///
  /// In en, this message translates to:
  /// **'Gold Recruit'**
  String get monsterGoldRecruit;

  /// No description provided for @monsterGoldGuard.
  ///
  /// In en, this message translates to:
  /// **'Gold Guard'**
  String get monsterGoldGuard;

  /// No description provided for @monsterShade.
  ///
  /// In en, this message translates to:
  /// **'Shade'**
  String get monsterShade;

  /// No description provided for @monsterIceSpecter.
  ///
  /// In en, this message translates to:
  /// **'Ice Specter'**
  String get monsterIceSpecter;

  /// No description provided for @monsterCrystalHatchling.
  ///
  /// In en, this message translates to:
  /// **'Crystal Hatchling'**
  String get monsterCrystalHatchling;

  /// No description provided for @monsterCrystalWhelp.
  ///
  /// In en, this message translates to:
  /// **'Crystal Whelp'**
  String get monsterCrystalWhelp;

  /// No description provided for @monsterShadowSquire.
  ///
  /// In en, this message translates to:
  /// **'Shadow Squire'**
  String get monsterShadowSquire;

  /// No description provided for @monsterShadowLord.
  ///
  /// In en, this message translates to:
  /// **'Shadow Lord'**
  String get monsterShadowLord;

  /// No description provided for @monsterWarden.
  ///
  /// In en, this message translates to:
  /// **'{name} Warden'**
  String monsterWarden(String name);

  /// No description provided for @obPhoneSees.
  ///
  /// In en, this message translates to:
  /// **'What your phone should see'**
  String get obPhoneSees;

  /// No description provided for @obPhoneSeesBody.
  ///
  /// In en, this message translates to:
  /// **'From the top of your head to your hands, about a metre away, in a push-up.'**
  String get obPhoneSeesBody;
}

class _LDelegate extends LocalizationsDelegate<L> {
  const _LDelegate();

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(lookupL(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
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
