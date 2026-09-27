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

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @codeHint.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get codeHint;

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

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTitle;

  /// No description provided for @signInBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in with the email and password on your account.'**
  String get signInBody;

  /// No description provided for @signInAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInAction;

  /// No description provided for @switchToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get switchToSignIn;

  /// No description provided for @switchToSignUp.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account'**
  String get switchToSignUp;

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

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

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

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameHint;

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

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @logInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to keep your rank.'**
  String get logInSubtitle;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for {email}, a reset link is on its way.'**
  String resetPasswordSent(String email);

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

  /// No description provided for @socialLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t finish signing in. Try again.'**
  String get socialLinkFailed;

  /// No description provided for @showLabel.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get showLabel;

  /// No description provided for @hideLabel.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hideLabel;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password for your account.'**
  String get resetPasswordBody;

  /// No description provided for @setPasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Set password'**
  String get setPasswordAction;

  /// No description provided for @wrongEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password.'**
  String get wrongEmailOrPassword;

  /// No description provided for @enterCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCodeTitle;

  /// No description provided for @codeInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent to {email}.'**
  String codeInstructions(String email);

  /// No description provided for @verifyAction.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyAction;

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

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

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

  /// No description provided for @simulatedOpponent.
  ///
  /// In en, this message translates to:
  /// **'No one else was ready — this is a practice pace'**
  String get simulatedOpponent;

  /// No description provided for @changeUsername.
  ///
  /// In en, this message translates to:
  /// **'Change username'**
  String get changeUsername;

  /// No description provided for @usernameInvalidLength.
  ///
  /// In en, this message translates to:
  /// **'4 to 20 characters, letters and numbers only'**
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

  /// No description provided for @challengeSent.
  ///
  /// In en, this message translates to:
  /// **'Challenge sent to {name}'**
  String challengeSent(String name);

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
  /// **'This needs a server — not wired up yet'**
  String get needsServer;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @roadTitle.
  ///
  /// In en, this message translates to:
  /// **'Road to Master'**
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

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addFriend;

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

  /// No description provided for @local.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get local;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @seasonTab.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get seasonTab;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All-time'**
  String get allTime;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

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

  /// No description provided for @findPeople.
  ///
  /// In en, this message translates to:
  /// **'Find people'**
  String get findPeople;

  /// No description provided for @noRankYet.
  ///
  /// In en, this message translates to:
  /// **'No rank yet'**
  String get noRankYet;

  /// No description provided for @placementsForFirstTier.
  ///
  /// In en, this message translates to:
  /// **'Finish {count} placement duels to earn your first tier.'**
  String placementsForFirstTier(String count);

  /// No description provided for @startPlacements.
  ///
  /// In en, this message translates to:
  /// **'Start placements'**
  String get startPlacements;

  /// No description provided for @unranked.
  ///
  /// In en, this message translates to:
  /// **'Unranked'**
  String get unranked;

  /// No description provided for @placementsTerms.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} · {seconds} seconds each'**
  String placementsTerms(String done, String total, String seconds);

  /// No description provided for @placementsLeft.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} · {left} more to get your tier'**
  String placementsLeft(String done, String total, String left);

  /// No description provided for @placementsForTier.
  ///
  /// In en, this message translates to:
  /// **'Finish {count} placement duels to see where you land.'**
  String placementsForTier(String count);

  /// No description provided for @placementsDoneCount.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String placementsDoneCount(String done, String total);

  /// No description provided for @practiceFirst.
  ///
  /// In en, this message translates to:
  /// **'Practice first'**
  String get practiceFirst;

  /// No description provided for @nextPlacement.
  ///
  /// In en, this message translates to:
  /// **'Next placement'**
  String get nextPlacement;

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

  /// No description provided for @opponentDisconnected.
  ///
  /// In en, this message translates to:
  /// **'{name} disconnected'**
  String opponentDisconnected(String name);

  /// No description provided for @forfeitNoMargin.
  ///
  /// In en, this message translates to:
  /// **'Forfeit · margin not counted'**
  String get forfeitNoMargin;

  /// No description provided for @findAnotherMatch.
  ///
  /// In en, this message translates to:
  /// **'Find another match'**
  String get findAnotherMatch;

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

  /// No description provided for @lpSwing.
  ///
  /// In en, this message translates to:
  /// **'+{gain} / −{loss} LP'**
  String lpSwing(String gain, String loss);

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

  /// No description provided for @yourRankCard.
  ///
  /// In en, this message translates to:
  /// **'Your rank card'**
  String get yourRankCard;

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

  /// No description provided for @obHowTitle.
  ///
  /// In en, this message translates to:
  /// **'Three things, then you’re in.'**
  String get obHowTitle;

  /// No description provided for @obHow1.
  ///
  /// In en, this message translates to:
  /// **'Prop your phone on the floor'**
  String get obHow1;

  /// No description provided for @obHow1Body.
  ///
  /// In en, this message translates to:
  /// **'Lean it against a wall, a metre in front of you.'**
  String get obHow1Body;

  /// No description provided for @obHow2.
  ///
  /// In en, this message translates to:
  /// **'The camera counts your reps'**
  String get obHow2;

  /// No description provided for @obHow2Body.
  ///
  /// In en, this message translates to:
  /// **'Every rep is checked for depth. Half reps don’t count.'**
  String get obHow2Body;

  /// No description provided for @obHow3.
  ///
  /// In en, this message translates to:
  /// **'Sixty seconds against someone'**
  String get obHow3;

  /// No description provided for @obHow3Body.
  ///
  /// In en, this message translates to:
  /// **'Win to climb. Lose and you drop. Same rules for everyone.'**
  String get obHow3Body;

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
  /// **'Body tracking runs on this device. No video is uploaded unless you choose to post it.'**
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

  /// No description provided for @obOneMetre.
  ///
  /// In en, this message translates to:
  /// **'~1 m'**
  String get obOneMetre;

  /// No description provided for @obFullBody.
  ///
  /// In en, this message translates to:
  /// **'full body in frame'**
  String get obFullBody;

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

  /// No description provided for @obFramingAnkles.
  ///
  /// In en, this message translates to:
  /// **'Ankles'**
  String get obFramingAnkles;

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

  /// No description provided for @obCreateAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Create an account to keep your reps, your rank and your record.'**
  String get obCreateAccountBody;

  /// No description provided for @obSaveProgress.
  ///
  /// In en, this message translates to:
  /// **'Save my progress'**
  String get obSaveProgress;

  /// No description provided for @obSaveYourReps.
  ///
  /// In en, this message translates to:
  /// **'Save your {count} reps'**
  String obSaveYourReps(String count);

  /// No description provided for @obOneTap.
  ///
  /// In en, this message translates to:
  /// **'An email and a password — that\'s all it takes.'**
  String get obOneTap;

  /// No description provided for @obContinueApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get obContinueApple;

  /// No description provided for @obContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get obContinueGoogle;

  /// No description provided for @obContinueEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get obContinueEmail;

  /// No description provided for @obSignInFootnote.
  ///
  /// In en, this message translates to:
  /// **'We only use this to keep your account. We never post anything.'**
  String get obSignInFootnote;

  /// No description provided for @obPickName.
  ///
  /// In en, this message translates to:
  /// **'Pick a name'**
  String get obPickName;

  /// No description provided for @obPickNameBody.
  ///
  /// In en, this message translates to:
  /// **'This is what opponents see. You can change it later.'**
  String get obPickNameBody;

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

  /// No description provided for @obYourAvatar.
  ///
  /// In en, this message translates to:
  /// **'Your avatar'**
  String get obYourAvatar;

  /// No description provided for @obAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get obAddPhoto;

  /// No description provided for @obNotifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Know when you’re challenged'**
  String get obNotifyTitle;

  /// No description provided for @obNotifyChallenged.
  ///
  /// In en, this message translates to:
  /// **'Someone challenged you'**
  String get obNotifyChallenged;

  /// No description provided for @obNotifyStreak.
  ///
  /// In en, this message translates to:
  /// **'Your streak is about to break'**
  String get obNotifyStreak;

  /// No description provided for @obNotifyPassed.
  ///
  /// In en, this message translates to:
  /// **'A friend passed you on the board'**
  String get obNotifyPassed;

  /// No description provided for @obTurnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get obTurnOn;

  /// No description provided for @obPlacementsBody.
  ///
  /// In en, this message translates to:
  /// **'Five duels decide your starting tier. Nothing counts against you yet.'**
  String get obPlacementsBody;

  /// No description provided for @obFindFirstOpponent.
  ///
  /// In en, this message translates to:
  /// **'Find my first opponent'**
  String get obFindFirstOpponent;

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

  /// No description provided for @obWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get obWelcomeBack;

  /// No description provided for @obWelcomeBackBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your email and password.'**
  String get obWelcomeBackBody;

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
  /// **'Every time you confirm a count after a duel, that set is measured against what you said it was. The number appears here.'**
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

  /// No description provided for @lpRowWin.
  ///
  /// In en, this message translates to:
  /// **'Win'**
  String get lpRowWin;

  /// No description provided for @lpRowLoss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get lpRowLoss;

  /// No description provided for @lpRowOpponent.
  ///
  /// In en, this message translates to:
  /// **'Opponent\'s rank'**
  String get lpRowOpponent;

  /// No description provided for @lpRowMargin.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get lpRowMargin;

  /// No description provided for @lpRowDepth.
  ///
  /// In en, this message translates to:
  /// **'Depth'**
  String get lpRowDepth;

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
