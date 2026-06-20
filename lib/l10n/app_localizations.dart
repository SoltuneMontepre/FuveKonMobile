import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @supportLabel.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportLabel;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please select a language to continue'**
  String get languageSubtitle;

  /// No description provided for @languageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVietnamese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @themeSwitchToLight.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get themeSwitchToLight;

  /// No description provided for @themeSwitchToDark.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get themeSwitchToDark;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Where event communities and art connect'**
  String get splashTagline;

  /// No description provided for @startupHydrationFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the server'**
  String get startupHydrationFailedTitle;

  /// No description provided for @startupHydrationFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection or API settings, then try again.'**
  String get startupHydrationFailedBody;

  /// No description provided for @startupRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get startupRetry;

  /// No description provided for @brandTagline.
  ///
  /// In en, this message translates to:
  /// **'Professional event information portal'**
  String get brandTagline;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email or phone'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @loginOrDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get loginOrDivider;

  /// No description provided for @loginGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get loginGoogle;

  /// No description provided for @authGoogleNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In is not configured. Add GOOGLE_CLIENT_ID to .env and restart the app.'**
  String get authGoogleNotConfigured;

  /// No description provided for @authGoogleUnsupportedPlatform.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In is not supported on Linux/Windows. Run the app on Android, iOS, Web (Chrome), or macOS.'**
  String get authGoogleUnsupportedPlatform;

  /// No description provided for @authGoogleLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again or use email and password.'**
  String get authGoogleLoginFailed;

  /// No description provided for @authGoogleDeveloperError.
  ///
  /// In en, this message translates to:
  /// **'Google OAuth is misconfigured on Android. In Google Cloud Console, create an Android OAuth client for package com.example.fuvekonmobile and add your debug keystore SHA-1 (Android Studio → Gradle → signingReport).'**
  String get authGoogleDeveloperError;

  /// No description provided for @authGoogleIdTokenMissing.
  ///
  /// In en, this message translates to:
  /// **'Google did not return an ID token. Check GOOGLE_CLIENT_ID (Web client) in .env and the Android OAuth client in Google Cloud.'**
  String get authGoogleIdTokenMissing;

  /// No description provided for @authGoogleRegistrationDetailsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please complete registration with your profile details.'**
  String get authGoogleRegistrationDetailsRequired;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginNoAccount;

  /// No description provided for @loginRegisterLink.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get loginRegisterLink;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone number to receive password reset instructions.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordEmailHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. user@example.com'**
  String get forgotPasswordEmailHint;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send password reset link'**
  String get forgotPasswordSubmit;

  /// No description provided for @forgotPasswordBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get forgotPasswordBackToLogin;

  /// No description provided for @forgotPasswordSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'If an account exists, a password reset link has been sent to your email.'**
  String get forgotPasswordSuccessMessage;

  /// No description provided for @forgotPasswordSentHint.
  ///
  /// In en, this message translates to:
  /// **'Please check your inbox and follow the instructions.'**
  String get forgotPasswordSentHint;

  /// No description provided for @forgotPasswordFailureMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not send reset email. Please try again.'**
  String get forgotPasswordFailureMessage;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password for your account.'**
  String get resetPasswordSubtitle;

  /// No description provided for @resetPasswordNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get resetPasswordNewLabel;

  /// No description provided for @resetPasswordNewHint.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get resetPasswordNewHint;

  /// No description provided for @resetPasswordConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get resetPasswordConfirmLabel;

  /// No description provided for @resetPasswordConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get resetPasswordConfirmHint;

  /// No description provided for @resetPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordSubmit;

  /// No description provided for @resetPasswordBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get resetPasswordBackToLogin;

  /// No description provided for @resetPasswordSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully. You can sign in now.'**
  String get resetPasswordSuccessMessage;

  /// No description provided for @resetPasswordFailureMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not reset password. The link may have expired.'**
  String get resetPasswordFailureMessage;

  /// No description provided for @resetPasswordInvalidLink.
  ///
  /// In en, this message translates to:
  /// **'This reset link is invalid or expired. Please request a new one.'**
  String get resetPasswordInvalidLink;

  /// No description provided for @resetPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get resetPasswordMinLength;

  /// No description provided for @resetPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get resetPasswordMismatch;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your event management journey'**
  String get registerSubtitle;

  /// No description provided for @registerFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get registerFullNameLabel;

  /// No description provided for @registerFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get registerFullNameHint;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'example@domain.com'**
  String get registerEmailHint;

  /// No description provided for @registerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get registerPhoneLabel;

  /// No description provided for @registerPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get registerPhoneHint;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get registerPasswordHint;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get registerConfirmPasswordHint;

  /// No description provided for @registerTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get registerTermsPrefix;

  /// No description provided for @registerTermsTos.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get registerTermsTos;

  /// No description provided for @registerTermsAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get registerTermsAnd;

  /// No description provided for @registerTermsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get registerTermsPrivacy;

  /// No description provided for @registerTermsSuffix.
  ///
  /// In en, this message translates to:
  /// **' of FUVEKON.'**
  String get registerTermsSuffix;

  /// No description provided for @registerSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerSubmit;

  /// No description provided for @registerHasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get registerHasAccount;

  /// No description provided for @registerLoginLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get registerLoginLink;

  /// No description provided for @registerSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Account created. Please check your email for a verification code.'**
  String get registerSuccessMessage;

  /// No description provided for @registerFailureMessage.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registerFailureMessage;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter email or phone'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordMin.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validationPasswordMin;

  /// No description provided for @validationFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get validationFullNameRequired;

  /// No description provided for @validationFullNameMin.
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 2 characters'**
  String get validationFullNameMin;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get validationPhoneInvalid;

  /// No description provided for @validationConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get validationConfirmPasswordRequired;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMismatch;

  /// No description provided for @validationTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms to continue'**
  String get validationTermsRequired;

  /// No description provided for @introBadge.
  ///
  /// In en, this message translates to:
  /// **'INTRODUCTION'**
  String get introBadge;

  /// No description provided for @introHeroLine1.
  ///
  /// In en, this message translates to:
  /// **'Discover\n'**
  String get introHeroLine1;

  /// No description provided for @introHeroBrand.
  ///
  /// In en, this message translates to:
  /// **'FUVEKON'**
  String get introHeroBrand;

  /// No description provided for @introHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The premier Anime culture festival and professional event management platform.'**
  String get introHeroSubtitle;

  /// No description provided for @introWhatIsTitle.
  ///
  /// In en, this message translates to:
  /// **'What is FUVEKON?'**
  String get introWhatIsTitle;

  /// No description provided for @introWhatIsBody.
  ///
  /// In en, this message translates to:
  /// **'FUVEKON is a unique intersection of Anime culture aesthetics and a professional event management platform.'**
  String get introWhatIsBody;

  /// No description provided for @introAudienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Who is it for?'**
  String get introAudienceTitle;

  /// No description provided for @introAudienceArtistTitle.
  ///
  /// In en, this message translates to:
  /// **'Artists & Creators'**
  String get introAudienceArtistTitle;

  /// No description provided for @introAudienceArtistBody.
  ///
  /// In en, this message translates to:
  /// **'Connect and showcase your work.'**
  String get introAudienceArtistBody;

  /// No description provided for @introAudienceFanTitle.
  ///
  /// In en, this message translates to:
  /// **'Fans'**
  String get introAudienceFanTitle;

  /// No description provided for @introAudienceFanBody.
  ///
  /// In en, this message translates to:
  /// **'Experience a distinctive cultural space.'**
  String get introAudienceFanBody;

  /// No description provided for @introAudienceOrganizerTitle.
  ///
  /// In en, this message translates to:
  /// **'Event organizers'**
  String get introAudienceOrganizerTitle;

  /// No description provided for @introAudienceOrganizerBody.
  ///
  /// In en, this message translates to:
  /// **'Find collaboration opportunities and a professional management platform.'**
  String get introAudienceOrganizerBody;

  /// No description provided for @introViewRules.
  ///
  /// In en, this message translates to:
  /// **'View event rules'**
  String get introViewRules;

  /// No description provided for @introViewFaq.
  ///
  /// In en, this message translates to:
  /// **'View FAQ'**
  String get introViewFaq;

  /// No description provided for @navIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get navIntroduction;

  /// No description provided for @navArtbook.
  ///
  /// In en, this message translates to:
  /// **'Conbook'**
  String get navArtbook;

  /// No description provided for @navFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get navFaq;

  /// No description provided for @navRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get navRules;

  /// No description provided for @navLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get navLogin;

  /// No description provided for @navLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get navLogout;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @navMyTickets.
  ///
  /// In en, this message translates to:
  /// **'My tickets'**
  String get navMyTickets;

  /// No description provided for @scheduleMyItinerary.
  ///
  /// In en, this message translates to:
  /// **'My itinerary'**
  String get scheduleMyItinerary;

  /// No description provided for @scheduleViewMap.
  ///
  /// In en, this message translates to:
  /// **'Venue map'**
  String get scheduleViewMap;

  /// No description provided for @scheduleActivityDetail.
  ///
  /// In en, this message translates to:
  /// **'Activity detail'**
  String get scheduleActivityDetail;

  /// No description provided for @scheduleEventDetail.
  ///
  /// In en, this message translates to:
  /// **'Event detail'**
  String get scheduleEventDetail;

  /// No description provided for @scheduleVenueDetail.
  ///
  /// In en, this message translates to:
  /// **'Venue detail'**
  String get scheduleVenueDetail;

  /// No description provided for @scheduleDayFilter.
  ///
  /// In en, this message translates to:
  /// **'Select day'**
  String get scheduleDayFilter;

  /// No description provided for @scheduleActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get scheduleActivities;

  /// No description provided for @scheduleNoActivities.
  ///
  /// In en, this message translates to:
  /// **'No activities on this day'**
  String get scheduleNoActivities;

  /// No description provided for @scheduleBookmark.
  ///
  /// In en, this message translates to:
  /// **'Add to my itinerary'**
  String get scheduleBookmark;

  /// No description provided for @scheduleBookmarked.
  ///
  /// In en, this message translates to:
  /// **'Saved to itinerary'**
  String get scheduleBookmarked;

  /// No description provided for @scheduleAddedToItinerary.
  ///
  /// In en, this message translates to:
  /// **'Added to your itinerary'**
  String get scheduleAddedToItinerary;

  /// No description provided for @scheduleConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule conflict'**
  String get scheduleConflictTitle;

  /// No description provided for @scheduleConflictMessage.
  ///
  /// In en, this message translates to:
  /// **'This activity overlaps with \"{title}\" in your itinerary. Replace it?'**
  String scheduleConflictMessage(String title);

  /// No description provided for @scheduleConflictReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get scheduleConflictReplace;

  /// No description provided for @scheduleConflictCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get scheduleConflictCancel;

  /// No description provided for @scheduleEmptyItinerary.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get scheduleEmptyItinerary;

  /// No description provided for @scheduleEmptyItineraryHint.
  ///
  /// In en, this message translates to:
  /// **'Bookmark panels, talent shows, or workshops from the master schedule.'**
  String get scheduleEmptyItineraryHint;

  /// No description provided for @scheduleRemoveBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove from itinerary'**
  String get scheduleRemoveBookmark;

  /// No description provided for @scheduleTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get scheduleTime;

  /// No description provided for @scheduleLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get scheduleLocation;

  /// No description provided for @scheduleSpeakers.
  ///
  /// In en, this message translates to:
  /// **'Speakers'**
  String get scheduleSpeakers;

  /// No description provided for @scheduleDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get scheduleDescription;

  /// No description provided for @scheduleVenues.
  ///
  /// In en, this message translates to:
  /// **'Venues'**
  String get scheduleVenues;

  /// No description provided for @scheduleLocations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get scheduleLocations;

  /// No description provided for @scheduleKindPanel.
  ///
  /// In en, this message translates to:
  /// **'Panel'**
  String get scheduleKindPanel;

  /// No description provided for @scheduleKindTalent.
  ///
  /// In en, this message translates to:
  /// **'Talent'**
  String get scheduleKindTalent;

  /// No description provided for @scheduleKindWorkshop.
  ///
  /// In en, this message translates to:
  /// **'Workshop'**
  String get scheduleKindWorkshop;

  /// No description provided for @scheduleKindCeremony.
  ///
  /// In en, this message translates to:
  /// **'Ceremony'**
  String get scheduleKindCeremony;

  /// No description provided for @scheduleKindOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get scheduleKindOther;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @navSwitchToAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin mode'**
  String get navSwitchToAdmin;

  /// No description provided for @navSwitchToUser.
  ///
  /// In en, this message translates to:
  /// **'User mode'**
  String get navSwitchToUser;

  /// No description provided for @myTicketsFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get myTicketsFilterActive;

  /// No description provided for @myTicketsFilterUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get myTicketsFilterUsed;

  /// No description provided for @myTicketsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get myTicketsFilterAll;

  /// No description provided for @myTicketsStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get myTicketsStatusActive;

  /// No description provided for @myTicketsStatusUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get myTicketsStatusUsed;

  /// No description provided for @myTicketsViewTicket.
  ///
  /// In en, this message translates to:
  /// **'View ticket →'**
  String get myTicketsViewTicket;

  /// No description provided for @myTicketsPayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now →'**
  String get myTicketsPayNow;

  /// No description provided for @myTicketsEventDateRange.
  ///
  /// In en, this message translates to:
  /// **'Oct 20–22, 2024'**
  String get myTicketsEventDateRange;

  /// No description provided for @myTicketsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have a ticket'**
  String get myTicketsEmptyTitle;

  /// No description provided for @myTicketsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Buy a ticket to attend the event.'**
  String get myTicketsEmptySubtitle;

  /// No description provided for @myTicketsEmptyFilter.
  ///
  /// In en, this message translates to:
  /// **'No tickets in this tab'**
  String get myTicketsEmptyFilter;

  /// No description provided for @myTicketsBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse ticket tiers'**
  String get myTicketsBrowse;

  /// No description provided for @eTicketEventLabel.
  ///
  /// In en, this message translates to:
  /// **'EVENT'**
  String get eTicketEventLabel;

  /// No description provided for @eTicketValid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get eTicketValid;

  /// No description provided for @eTicketOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get eTicketOwner;

  /// No description provided for @eTicketTier.
  ///
  /// In en, this message translates to:
  /// **'Tier'**
  String get eTicketTier;

  /// No description provided for @eTicketDay.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get eTicketDay;

  /// No description provided for @eTicketScanHint.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code at the entrance'**
  String get eTicketScanHint;

  /// No description provided for @eTicketCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Ticket code'**
  String get eTicketCodeLabel;

  /// No description provided for @eTicketBenefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'{tier} ticket benefits'**
  String eTicketBenefitsTitle(String tier);

  /// No description provided for @eTicketUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade ticket'**
  String get eTicketUpgrade;

  /// No description provided for @eTicketSaveWallet.
  ///
  /// In en, this message translates to:
  /// **'Save to Apple/Google Wallet'**
  String get eTicketSaveWallet;

  /// No description provided for @eTicketWalletSoon.
  ///
  /// In en, this message translates to:
  /// **'Wallet save coming soon.'**
  String get eTicketWalletSoon;

  /// No description provided for @ticketUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade ticket tier'**
  String get ticketUpgradeTitle;

  /// No description provided for @ticketUpgradeCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'YOUR CURRENT TICKET'**
  String get ticketUpgradeCurrentLabel;

  /// No description provided for @ticketUpgradeOptionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Upgrade options'**
  String get ticketUpgradeOptionsLabel;

  /// No description provided for @ticketUpgradeExtraBenefits.
  ///
  /// In en, this message translates to:
  /// **'ADDITIONAL BENEFITS'**
  String get ticketUpgradeExtraBenefits;

  /// No description provided for @ticketUpgradeTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'TOTAL ADDITIONAL PAYMENT'**
  String get ticketUpgradeTotalLabel;

  /// No description provided for @ticketUpgradeContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue upgrade'**
  String get ticketUpgradeContinue;

  /// No description provided for @ticketUpgradeInfoNote.
  ///
  /// In en, this message translates to:
  /// **'Upgrading your ticket will be processed and confirmed within 24 business hours.'**
  String get ticketUpgradeInfoNote;

  /// No description provided for @ticketUpgradeNoTicket.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have a ticket to upgrade.'**
  String get ticketUpgradeNoTicket;

  /// No description provided for @ticketUpgradeMaxTier.
  ///
  /// In en, this message translates to:
  /// **'You are already on the highest tier ({tier}).'**
  String ticketUpgradeMaxTier(String tier);

  /// No description provided for @authHomeUpcomingBadge.
  ///
  /// In en, this message translates to:
  /// **'Upcoming events'**
  String get authHomeUpcomingBadge;

  /// No description provided for @authHomeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Anime Culture Exchange Festival'**
  String get authHomeHeroTitle;

  /// No description provided for @authHomeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover art spaces and unique experiences.'**
  String get authHomeHeroSubtitle;

  /// No description provided for @authHomeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search events, artists...'**
  String get authHomeSearchHint;

  /// No description provided for @authHomeFeaturedTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured events'**
  String get authHomeFeaturedTitle;

  /// No description provided for @authHomeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get authHomeSeeAll;

  /// No description provided for @authHomeHotBadge.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get authHomeHotBadge;

  /// No description provided for @authHomeFeaturedEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Contemporary Art Exhibition'**
  String get authHomeFeaturedEventTitle;

  /// No description provided for @authHomeFeaturedEventDate.
  ///
  /// In en, this message translates to:
  /// **'October 20, 2023'**
  String get authHomeFeaturedEventDate;

  /// No description provided for @authHomeFeaturedEventLocation.
  ///
  /// In en, this message translates to:
  /// **'SECC Center'**
  String get authHomeFeaturedEventLocation;

  /// No description provided for @authHomeBuyTicket.
  ///
  /// In en, this message translates to:
  /// **'Buy tickets'**
  String get authHomeBuyTicket;

  /// No description provided for @authHomeViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get authHomeViewDetails;

  /// No description provided for @authHomeViewTickets.
  ///
  /// In en, this message translates to:
  /// **'View tickets'**
  String get authHomeViewTickets;

  /// No description provided for @authHomeNotificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No new notifications yet.'**
  String get authHomeNotificationsEmpty;

  /// No description provided for @authHomeBentoTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get authHomeBentoTitle;

  /// No description provided for @authHomeMyTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'My tickets'**
  String get authHomeMyTicketTitle;

  /// No description provided for @authHomeMyTicketSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View e-ticket & QR'**
  String get authHomeMyTicketSubtitle;

  /// No description provided for @authHomeTodayScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s schedule'**
  String get authHomeTodayScheduleTitle;

  /// No description provided for @authHomeTodaySchedulePreview.
  ///
  /// In en, this message translates to:
  /// **'Panel Voice Actor · 2:00 PM'**
  String get authHomeTodaySchedulePreview;

  /// No description provided for @authHomeBuyTicketBanner.
  ///
  /// In en, this message translates to:
  /// **'Buy FUVEKON tickets'**
  String get authHomeBuyTicketBanner;

  /// No description provided for @authHomeBuyTicketBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Early bird now open'**
  String get authHomeBuyTicketBannerSubtitle;

  /// No description provided for @authHomeShortcutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get authHomeShortcutsTitle;

  /// No description provided for @authHomeShortcutArtbook.
  ///
  /// In en, this message translates to:
  /// **'Artbook'**
  String get authHomeShortcutArtbook;

  /// No description provided for @authHomeShortcutLostFound.
  ///
  /// In en, this message translates to:
  /// **'L&F'**
  String get authHomeShortcutLostFound;

  /// No description provided for @landingBadge.
  ///
  /// In en, this message translates to:
  /// **'TOP EVENT'**
  String get landingBadge;

  /// No description provided for @landingHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Anime Event'**
  String get landingHeroTitle;

  /// No description provided for @landingHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Experience a unique cultural space with smart ticket management and scheduling. Join now so you don\'t miss the most wonderful moments.'**
  String get landingHeroBody;

  /// No description provided for @landingRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get landingRegister;

  /// No description provided for @landingViewTickets.
  ///
  /// In en, this message translates to:
  /// **'View tickets'**
  String get landingViewTickets;

  /// No description provided for @exploreTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore ticket types'**
  String get exploreTicketsTitle;

  /// No description provided for @exploreTicketsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the experience that suits you best at the exhibition.'**
  String get exploreTicketsSubtitle;

  /// No description provided for @exploreTicketsFooterInfo.
  ///
  /// In en, this message translates to:
  /// **'You can browse ticket details first. To purchase, please register or sign in.'**
  String get exploreTicketsFooterInfo;

  /// No description provided for @exploreTicketsRegisterCta.
  ///
  /// In en, this message translates to:
  /// **'Register to buy tickets'**
  String get exploreTicketsRegisterCta;

  /// No description provided for @exploreTicketsBuyCta.
  ///
  /// In en, this message translates to:
  /// **'Buy tickets now'**
  String get exploreTicketsBuyCta;

  /// No description provided for @exploreTicketsLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get exploreTicketsLoginPrompt;

  /// No description provided for @exploreTicketsLoginLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in now'**
  String get exploreTicketsLoginLink;

  /// No description provided for @exploreTicketsPopularBadge.
  ///
  /// In en, this message translates to:
  /// **'Most popular'**
  String get exploreTicketsPopularBadge;

  /// No description provided for @exploreTicketsSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold out'**
  String get exploreTicketsSoldOut;

  /// No description provided for @exploreTicketsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No ticket tiers are available yet.'**
  String get exploreTicketsEmpty;

  /// No description provided for @exploreTicketsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get exploreTicketsRetry;

  /// No description provided for @ticketDetailBenefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Included benefits'**
  String get ticketDetailBenefitsTitle;

  /// No description provided for @ticketDetailCompareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare with {standardTier}'**
  String ticketDetailCompareTitle(String standardTier);

  /// No description provided for @ticketDetailTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get ticketDetailTotal;

  /// No description provided for @ticketDetailCompareAccess.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get ticketDetailCompareAccess;

  /// No description provided for @ticketDetailCompareCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get ticketDetailCompareCheckIn;

  /// No description provided for @ticketDetailComparePriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get ticketDetailComparePriority;

  /// No description provided for @ticketDetailCompareShared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get ticketDetailCompareShared;

  /// No description provided for @ticketDetailCompareBadge.
  ///
  /// In en, this message translates to:
  /// **'Badge'**
  String get ticketDetailCompareBadge;

  /// No description provided for @ticketDetailCompareCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get ticketDetailCompareCustom;

  /// No description provided for @ticketDetailCompareNormal.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get ticketDetailCompareNormal;

  /// No description provided for @ticketDetailCompareGifts.
  ///
  /// In en, this message translates to:
  /// **'Extra gifts'**
  String get ticketDetailCompareGifts;

  /// No description provided for @landingExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Perfect Experience'**
  String get landingExperienceTitle;

  /// No description provided for @landingExperienceBody.
  ///
  /// In en, this message translates to:
  /// **'Manage your journey at the event with ease.'**
  String get landingExperienceBody;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Event rules'**
  String get rulesTitle;

  /// No description provided for @rulesIntro.
  ///
  /// In en, this message translates to:
  /// **'Please read the following rules carefully to ensure a safe, professional, and memorable convention for everyone.'**
  String get rulesIntro;

  /// No description provided for @rulesAttendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance rules'**
  String get rulesAttendanceTitle;

  /// No description provided for @rulesAttendance1.
  ///
  /// In en, this message translates to:
  /// **'Present a valid ticket at the entrance.'**
  String get rulesAttendance1;

  /// No description provided for @rulesAttendance2.
  ///
  /// In en, this message translates to:
  /// **'No weapons or flammable materials.'**
  String get rulesAttendance2;

  /// No description provided for @rulesAttendance3.
  ///
  /// In en, this message translates to:
  /// **'Respect shared spaces.'**
  String get rulesAttendance3;

  /// No description provided for @rulesCosplayTitle.
  ///
  /// In en, this message translates to:
  /// **'Cosplay guidelines'**
  String get rulesCosplayTitle;

  /// No description provided for @rulesCosplay1.
  ///
  /// In en, this message translates to:
  /// **'Costumes must be appropriate and respectful.'**
  String get rulesCosplay1;

  /// No description provided for @rulesCosplay2.
  ///
  /// In en, this message translates to:
  /// **'Props must not be sharp or dangerous.'**
  String get rulesCosplay2;

  /// No description provided for @rulesCosplay3.
  ///
  /// In en, this message translates to:
  /// **'Use designated changing areas only.'**
  String get rulesCosplay3;

  /// No description provided for @rulesBoothTitle.
  ///
  /// In en, this message translates to:
  /// **'Vendor booth rules'**
  String get rulesBoothTitle;

  /// No description provided for @rulesBooth1.
  ///
  /// In en, this message translates to:
  /// **'Sell only registered product categories.'**
  String get rulesBooth1;

  /// No description provided for @rulesBooth2.
  ///
  /// In en, this message translates to:
  /// **'Do not block walkways.'**
  String get rulesBooth2;

  /// No description provided for @rulesBooth3.
  ///
  /// In en, this message translates to:
  /// **'Keep your booth area clean.'**
  String get rulesBooth3;

  /// No description provided for @rulesConductTitle.
  ///
  /// In en, this message translates to:
  /// **'Code of conduct'**
  String get rulesConductTitle;

  /// No description provided for @rulesConduct1.
  ///
  /// In en, this message translates to:
  /// **'Harassment of any kind is strictly prohibited.'**
  String get rulesConduct1;

  /// No description provided for @rulesConduct2.
  ///
  /// In en, this message translates to:
  /// **'No littering.'**
  String get rulesConduct2;

  /// No description provided for @rulesConduct3.
  ///
  /// In en, this message translates to:
  /// **'Follow staff instructions.'**
  String get rulesConduct3;

  /// No description provided for @rulesAgreeCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I have read, understood, and agree to the rules above.'**
  String get rulesAgreeCheckbox;

  /// No description provided for @rulesConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm agreement'**
  String get rulesConfirmButton;

  /// No description provided for @faqPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get faqPageTitle;

  /// No description provided for @faqPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quickly find answers to your questions.'**
  String get faqPageSubtitle;

  /// No description provided for @faqSearchHint.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for?'**
  String get faqSearchHint;

  /// No description provided for @faqNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matching results found.'**
  String get faqNoResults;

  /// No description provided for @faqNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Need more help? '**
  String get faqNeedHelp;

  /// No description provided for @faqContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us →'**
  String get faqContactUs;

  /// No description provided for @faqCatTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get faqCatTickets;

  /// No description provided for @faqTicketsQ1.
  ///
  /// In en, this message translates to:
  /// **'Where can I buy tickets?'**
  String get faqTicketsQ1;

  /// No description provided for @faqTicketsA1.
  ///
  /// In en, this message translates to:
  /// **'Go to Tickets in the FUVEKON app, choose a tier, and complete payment as instructed. Each account can only hold one active ticket at a time.'**
  String get faqTicketsA1;

  /// No description provided for @faqTicketsQ2.
  ///
  /// In en, this message translates to:
  /// **'What ticket tiers are available?'**
  String get faqTicketsQ2;

  /// No description provided for @faqTicketsA2.
  ///
  /// In en, this message translates to:
  /// **'The organizing committee publishes tiers (Standard, VIP, etc.) with corresponding benefits in the app. Price and quantity may change each sales wave.'**
  String get faqTicketsA2;

  /// No description provided for @faqTicketsQ3.
  ///
  /// In en, this message translates to:
  /// **'How do I pay for tickets?'**
  String get faqTicketsQ3;

  /// No description provided for @faqTicketsA3.
  ///
  /// In en, this message translates to:
  /// **'After booking, transfer via bank QR or PayPal as instructed, then tap \"I have paid\". The committee will verify and approve your ticket as soon as possible.'**
  String get faqTicketsA3;

  /// No description provided for @faqTicketsQ4.
  ///
  /// In en, this message translates to:
  /// **'Are e-tickets valid?'**
  String get faqTicketsQ4;

  /// No description provided for @faqTicketsA4.
  ///
  /// In en, this message translates to:
  /// **'Yes. Once approved, your check-in QR and digital badge are sent by email and shown in the app. Present the QR at the gate.'**
  String get faqTicketsA4;

  /// No description provided for @faqTicketsQ5.
  ///
  /// In en, this message translates to:
  /// **'Can I upgrade my ticket?'**
  String get faqTicketsQ5;

  /// No description provided for @faqTicketsA5.
  ///
  /// In en, this message translates to:
  /// **'Yes. Approved ticket holders can upgrade by paying the difference. Upgrades also require payment verification before taking effect.'**
  String get faqTicketsA5;

  /// No description provided for @faqTicketsQ6.
  ///
  /// In en, this message translates to:
  /// **'Can I get a refund?'**
  String get faqTicketsQ6;

  /// No description provided for @faqTicketsA6.
  ///
  /// In en, this message translates to:
  /// **'Purchased tickets are non-refundable unless the committee announces otherwise (e.g. event cancellation or major changes).'**
  String get faqTicketsA6;

  /// No description provided for @faqCatRegister.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get faqCatRegister;

  /// No description provided for @faqRegisterQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I create an account?'**
  String get faqRegisterQ1;

  /// No description provided for @faqRegisterA1.
  ///
  /// In en, this message translates to:
  /// **'Choose Register on the sign-in screen, enter email and password, then verify the OTP sent to your email to activate your account.'**
  String get faqRegisterA1;

  /// No description provided for @faqRegisterQ2.
  ///
  /// In en, this message translates to:
  /// **'Can I sign in with Google?'**
  String get faqRegisterQ2;

  /// No description provided for @faqRegisterA2.
  ///
  /// In en, this message translates to:
  /// **'Yes. FUVEKON supports quick sign-in with Google. First-time sign-in may require completing your profile.'**
  String get faqRegisterA2;

  /// No description provided for @faqRegisterQ3.
  ///
  /// In en, this message translates to:
  /// **'Why do I need to verify email?'**
  String get faqRegisterQ3;

  /// No description provided for @faqRegisterA3.
  ///
  /// In en, this message translates to:
  /// **'Email verification protects your account and unlocks profile editing, ticket purchase, and panel/talent/dealer registration after verification.'**
  String get faqRegisterA3;

  /// No description provided for @faqRegisterQ4.
  ///
  /// In en, this message translates to:
  /// **'What if I forgot my password?'**
  String get faqRegisterQ4;

  /// No description provided for @faqRegisterA4.
  ///
  /// In en, this message translates to:
  /// **'Choose Forgot password on the sign-in screen, enter your registered email, and follow the link/OTP to set a new password.'**
  String get faqRegisterA4;

  /// No description provided for @faqRegisterQ5.
  ///
  /// In en, this message translates to:
  /// **'I didn\'t receive the OTP code?'**
  String get faqRegisterQ5;

  /// No description provided for @faqRegisterA5.
  ///
  /// In en, this message translates to:
  /// **'Check your spam folder. If still missing, use Resend OTP in the app or contact contact@fuvekon.vn.'**
  String get faqRegisterA5;

  /// No description provided for @faqCatDealer.
  ///
  /// In en, this message translates to:
  /// **'Dealer'**
  String get faqCatDealer;

  /// No description provided for @faqDealerQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I register a booth?'**
  String get faqDealerQ1;

  /// No description provided for @faqDealerA1.
  ///
  /// In en, this message translates to:
  /// **'Go to Dealer in the app, read booth rules, fill out the form, and upload up to 5 price sheets. Your application will be reviewed.'**
  String get faqDealerA1;

  /// No description provided for @faqDealerQ2.
  ///
  /// In en, this message translates to:
  /// **'What are the requirements to become a Dealer?'**
  String get faqDealerQ2;

  /// No description provided for @faqDealerA2.
  ///
  /// In en, this message translates to:
  /// **'You need a verified email account and must comply with product and copyright rules. See Dealer in the app for details.'**
  String get faqDealerA2;

  /// No description provided for @faqDealerQ3.
  ///
  /// In en, this message translates to:
  /// **'How much does a booth cost?'**
  String get faqDealerQ3;

  /// No description provided for @faqDealerA3.
  ///
  /// In en, this message translates to:
  /// **'Fees depend on booth type, size, and location. The committee sends cost details after approving your application.'**
  String get faqDealerA3;

  /// No description provided for @faqDealerQ4.
  ///
  /// In en, this message translates to:
  /// **'How do I add booth staff?'**
  String get faqDealerQ4;

  /// No description provided for @faqDealerA4.
  ///
  /// In en, this message translates to:
  /// **'The booth owner creates an invite code in the app. Staff enter it under Join booth to be added.'**
  String get faqDealerA4;

  /// No description provided for @faqDealerQ5.
  ///
  /// In en, this message translates to:
  /// **'How long until I know the result?'**
  String get faqDealerQ5;

  /// No description provided for @faqDealerA5.
  ///
  /// In en, this message translates to:
  /// **'Review usually takes 3–7 business days. You\'ll be notified by email and in the app when approved or rejected.'**
  String get faqDealerA5;

  /// No description provided for @faqCatTalent.
  ///
  /// In en, this message translates to:
  /// **'Talent Show'**
  String get faqCatTalent;

  /// No description provided for @faqTalentQ1.
  ///
  /// In en, this message translates to:
  /// **'Who can apply to perform?'**
  String get faqTalentQ1;

  /// No description provided for @faqTalentA1.
  ///
  /// In en, this message translates to:
  /// **'Artists, cosplayers, singers, dancers, and creators can submit via Talent in the app.'**
  String get faqTalentA1;

  /// No description provided for @faqTalentQ2.
  ///
  /// In en, this message translates to:
  /// **'Do I need an event ticket?'**
  String get faqTalentQ2;

  /// No description provided for @faqTalentA2.
  ///
  /// In en, this message translates to:
  /// **'Yes. You need an approved ticket and a verified email account before submitting a talent application.'**
  String get faqTalentA2;

  /// No description provided for @faqTalentQ3.
  ///
  /// In en, this message translates to:
  /// **'What does a talent application need?'**
  String get faqTalentQ3;

  /// No description provided for @faqTalentA3.
  ///
  /// In en, this message translates to:
  /// **'Self-introduction, planned performance description, reference photos/videos, and contact info. The full form is in the app.'**
  String get faqTalentA3;

  /// No description provided for @faqTalentQ4.
  ///
  /// In en, this message translates to:
  /// **'What is the application deadline?'**
  String get faqTalentQ4;

  /// No description provided for @faqTalentA4.
  ///
  /// In en, this message translates to:
  /// **'Deadlines are announced on the app, website, and official fanpage. Apply early so the committee can schedule performances.'**
  String get faqTalentA4;

  /// No description provided for @faqCatPanel.
  ///
  /// In en, this message translates to:
  /// **'Panel'**
  String get faqCatPanel;

  /// No description provided for @faqPanelQ1.
  ///
  /// In en, this message translates to:
  /// **'What is a panel?'**
  String get faqPanelQ1;

  /// No description provided for @faqPanelA1.
  ///
  /// In en, this message translates to:
  /// **'A panel is a themed discussion or Q&A session with guests, speakers, and fans at the event.'**
  String get faqPanelA1;

  /// No description provided for @faqPanelQ2.
  ///
  /// In en, this message translates to:
  /// **'How do I register a panel?'**
  String get faqPanelQ2;

  /// No description provided for @faqPanelA2.
  ///
  /// In en, this message translates to:
  /// **'Go to Panel, submit your topic proposal, speaker info, and planned content. The committee will review and schedule if suitable.'**
  String get faqPanelA2;

  /// No description provided for @faqPanelQ3.
  ///
  /// In en, this message translates to:
  /// **'Do I need a ticket to register a panel?'**
  String get faqPanelQ3;

  /// No description provided for @faqPanelA3.
  ///
  /// In en, this message translates to:
  /// **'Yes. Applicants need an approved active ticket and verified email, similar to talent registration.'**
  String get faqPanelA3;

  /// No description provided for @faqPanelQ4.
  ///
  /// In en, this message translates to:
  /// **'When is the panel schedule published?'**
  String get faqPanelQ4;

  /// No description provided for @faqPanelA4.
  ///
  /// In en, this message translates to:
  /// **'The official schedule is posted under Schedule after applications are reviewed. You can bookmark items for reminders.'**
  String get faqPanelA4;

  /// No description provided for @faqCatSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get faqCatSchedule;

  /// No description provided for @faqScheduleQ1.
  ///
  /// In en, this message translates to:
  /// **'Where can I view the schedule?'**
  String get faqScheduleQ1;

  /// No description provided for @faqScheduleA1.
  ///
  /// In en, this message translates to:
  /// **'Schedule in the app shows all activities by day, time slot, and stage/area.'**
  String get faqScheduleA1;

  /// No description provided for @faqScheduleQ2.
  ///
  /// In en, this message translates to:
  /// **'Can the schedule change?'**
  String get faqScheduleQ2;

  /// No description provided for @faqScheduleA2.
  ///
  /// In en, this message translates to:
  /// **'The committee may adjust the schedule for operational reasons. Updates appear in the app and notifications if you bookmarked an item.'**
  String get faqScheduleA2;

  /// No description provided for @faqScheduleQ3.
  ///
  /// In en, this message translates to:
  /// **'What is My Schedule?'**
  String get faqScheduleQ3;

  /// No description provided for @faqScheduleA3.
  ///
  /// In en, this message translates to:
  /// **'Bookmark panels, talent shows, or workshops to view on your personal timeline and get reminders 10–15 minutes ahead.'**
  String get faqScheduleA3;

  /// No description provided for @faqScheduleQ4.
  ///
  /// In en, this message translates to:
  /// **'How many days is the event?'**
  String get faqScheduleQ4;

  /// No description provided for @faqScheduleA4.
  ///
  /// In en, this message translates to:
  /// **'Official dates and venue are announced on the event page and Introduction in the app.'**
  String get faqScheduleA4;

  /// No description provided for @faqCatLostFound.
  ///
  /// In en, this message translates to:
  /// **'Lost & Found'**
  String get faqCatLostFound;

  /// No description provided for @faqLostFoundQ1.
  ///
  /// In en, this message translates to:
  /// **'I lost something at the event?'**
  String get faqLostFoundQ1;

  /// No description provided for @faqLostFoundA1.
  ///
  /// In en, this message translates to:
  /// **'Visit the Lost & Found desk at the venue or report a loss in the app (description, photo, time, and approximate location).'**
  String get faqLostFoundA1;

  /// No description provided for @faqLostFoundQ2.
  ///
  /// In en, this message translates to:
  /// **'Where can I see found items?'**
  String get faqLostFoundQ2;

  /// No description provided for @faqLostFoundA2.
  ///
  /// In en, this message translates to:
  /// **'The public Lost & Found board in the app lists recorded items (sensitive identifying details are hidden to prevent fraud).'**
  String get faqLostFoundA2;

  /// No description provided for @faqLostFoundQ3.
  ///
  /// In en, this message translates to:
  /// **'How do I claim a lost item?'**
  String get faqLostFoundQ3;

  /// No description provided for @faqLostFoundA3.
  ///
  /// In en, this message translates to:
  /// **'Bring ID to the support desk, describe the item and when it was lost. Staff will verify and return it if it matches.'**
  String get faqLostFoundA3;

  /// No description provided for @faqLostFoundQ4.
  ///
  /// In en, this message translates to:
  /// **'How long until a lost item is processed?'**
  String get faqLostFoundQ4;

  /// No description provided for @faqLostFoundA4.
  ///
  /// In en, this message translates to:
  /// **'Staff update status (Lost / Found / Claimed) in the system. Track progress in the app or contact the desk.'**
  String get faqLostFoundA4;

  /// No description provided for @artbookTitle.
  ///
  /// In en, this message translates to:
  /// **'FUVEKON Conbook'**
  String get artbookTitle;

  /// No description provided for @artbookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Artistic Journey — 2024'**
  String get artbookSubtitle;

  /// No description provided for @artbookDescription.
  ///
  /// In en, this message translates to:
  /// **'A collection of over 50 artworks from the FUVEKON creative community, printed on premium art paper.'**
  String get artbookDescription;

  /// No description provided for @artbookPageCount.
  ///
  /// In en, this message translates to:
  /// **'120 Pages'**
  String get artbookPageCount;

  /// No description provided for @artbookPaperType.
  ///
  /// In en, this message translates to:
  /// **'150gsm Couche paper'**
  String get artbookPaperType;

  /// No description provided for @artbookSubmitCta.
  ///
  /// In en, this message translates to:
  /// **'Submit artwork for Conbook'**
  String get artbookSubmitCta;

  /// No description provided for @artbookSubmitBack.
  ///
  /// In en, this message translates to:
  /// **'GO BACK'**
  String get artbookSubmitBack;

  /// No description provided for @artbookSubmitTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit Conbook'**
  String get artbookSubmitTitle;

  /// No description provided for @artbookSubmitIntro.
  ///
  /// In en, this message translates to:
  /// **'A place to celebrate outstanding works. Send your masterpiece for the organizing committee to review for the FUVEKON Conbook.'**
  String get artbookSubmitIntro;

  /// No description provided for @artbookFormSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Artwork information'**
  String get artbookFormSectionTitle;

  /// No description provided for @artbookFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Artwork title'**
  String get artbookFieldTitle;

  /// No description provided for @artbookFieldTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Autumn daydream'**
  String get artbookFieldTitleHint;

  /// No description provided for @artbookFieldAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author / Pen name'**
  String get artbookFieldAuthor;

  /// No description provided for @artbookFieldAuthorHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your pen name'**
  String get artbookFieldAuthorHint;

  /// No description provided for @artbookFieldGenre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get artbookFieldGenre;

  /// No description provided for @artbookFieldGenreHint.
  ///
  /// In en, this message translates to:
  /// **'Select a genre'**
  String get artbookFieldGenreHint;

  /// No description provided for @artbookFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Idea description (optional)'**
  String get artbookFieldDescription;

  /// No description provided for @artbookFieldDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Share the story behind your artwork...'**
  String get artbookFieldDescriptionHint;

  /// No description provided for @artbookFieldPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio link'**
  String get artbookFieldPortfolio;

  /// No description provided for @artbookFieldPortfolioHint.
  ///
  /// In en, this message translates to:
  /// **'https://'**
  String get artbookFieldPortfolioHint;

  /// No description provided for @artbookFieldPreview.
  ///
  /// In en, this message translates to:
  /// **'Artwork preview'**
  String get artbookFieldPreview;

  /// No description provided for @artbookFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get artbookFieldRequired;

  /// No description provided for @artbookUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'Drag and drop or click to upload'**
  String get artbookUploadLabel;

  /// No description provided for @artbookUploadHint.
  ///
  /// In en, this message translates to:
  /// **'Supports JPG, PNG, PDF. Max 20MB.'**
  String get artbookUploadHint;

  /// No description provided for @artbookPreviewRequired.
  ///
  /// In en, this message translates to:
  /// **'Please upload an artwork preview'**
  String get artbookPreviewRequired;

  /// No description provided for @artbookSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit artwork for Conbook'**
  String get artbookSubmitButton;

  /// No description provided for @artbookRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Submission rules'**
  String get artbookRulesTitle;

  /// No description provided for @artbookRuleSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'SIZE'**
  String get artbookRuleSizeTitle;

  /// No description provided for @artbookRuleSizeBody.
  ///
  /// In en, this message translates to:
  /// **'A4 (210 x 297mm) with a 5mm safety margin.'**
  String get artbookRuleSizeBody;

  /// No description provided for @artbookRuleFormatTitle.
  ///
  /// In en, this message translates to:
  /// **'FORMAT'**
  String get artbookRuleFormatTitle;

  /// No description provided for @artbookRuleFormatBody.
  ///
  /// In en, this message translates to:
  /// **'CMYK color mode, minimum 300dpi.'**
  String get artbookRuleFormatBody;

  /// No description provided for @artbookRuleCopyrightTitle.
  ///
  /// In en, this message translates to:
  /// **'COPYRIGHT'**
  String get artbookRuleCopyrightTitle;

  /// No description provided for @artbookRuleCopyrightBody.
  ///
  /// In en, this message translates to:
  /// **'Must be original work that has never been commercially published.'**
  String get artbookRuleCopyrightBody;

  /// No description provided for @artbookDeadline.
  ///
  /// In en, this message translates to:
  /// **'Submission deadline: November 20, 2023'**
  String get artbookDeadline;

  /// No description provided for @artbookLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to submit your Conbook artwork'**
  String get artbookLoginRequired;

  /// No description provided for @artbookSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Artwork submitted successfully!'**
  String get artbookSubmitSuccess;

  /// No description provided for @artbookSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not submit artwork. Please try again.'**
  String get artbookSubmitFailed;

  /// No description provided for @artbookGenreIllustration.
  ///
  /// In en, this message translates to:
  /// **'Illustration'**
  String get artbookGenreIllustration;

  /// No description provided for @artbookGenreComic.
  ///
  /// In en, this message translates to:
  /// **'Comic'**
  String get artbookGenreComic;

  /// No description provided for @artbookGenrePhoto.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get artbookGenrePhoto;

  /// No description provided for @artbookGenreDigital.
  ///
  /// In en, this message translates to:
  /// **'Digital art'**
  String get artbookGenreDigital;

  /// No description provided for @artbookGenreOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get artbookGenreOther;

  /// No description provided for @adminCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminCancel;

  /// No description provided for @adminSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get adminSave;

  /// No description provided for @adminSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get adminSaveChanges;

  /// No description provided for @adminDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get adminDelete;

  /// No description provided for @adminEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get adminEdit;

  /// No description provided for @adminRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get adminRetry;

  /// No description provided for @adminConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get adminConfirm;

  /// No description provided for @adminBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get adminBack;

  /// No description provided for @adminCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminCancelAction;

  /// No description provided for @adminAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get adminAdd;

  /// No description provided for @adminCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get adminCreate;

  /// No description provided for @adminViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get adminViewAll;

  /// No description provided for @adminUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully.'**
  String get adminUpdateSuccess;

  /// No description provided for @adminErrorWithDetail.
  ///
  /// In en, this message translates to:
  /// **'Error: {detail}'**
  String adminErrorWithDetail(String detail);

  /// No description provided for @adminCannotUndo.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get adminCannotUndo;

  /// No description provided for @adminYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get adminYes;

  /// No description provided for @adminNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get adminNo;

  /// No description provided for @adminAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminAll;

  /// No description provided for @adminNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get adminNone;

  /// No description provided for @adminFieldStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminFieldStatus;

  /// No description provided for @adminFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get adminFieldDescription;

  /// No description provided for @adminFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get adminFieldTitle;

  /// No description provided for @adminStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminStatusPending;

  /// No description provided for @adminStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get adminStatusApproved;

  /// No description provided for @adminStatusRequireChanges.
  ///
  /// In en, this message translates to:
  /// **'Needs changes'**
  String get adminStatusRequireChanges;

  /// No description provided for @adminStatusDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get adminStatusDenied;

  /// No description provided for @adminApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get adminApprove;

  /// No description provided for @adminRequireChanges.
  ///
  /// In en, this message translates to:
  /// **'Request changes'**
  String get adminRequireChanges;

  /// No description provided for @adminDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get adminDeny;

  /// No description provided for @adminMarkPending.
  ///
  /// In en, this message translates to:
  /// **'Mark pending again'**
  String get adminMarkPending;

  /// No description provided for @adminMarkPendingReturn.
  ///
  /// In en, this message translates to:
  /// **'Return to pending'**
  String get adminMarkPendingReturn;

  /// No description provided for @adminDenyReason.
  ///
  /// In en, this message translates to:
  /// **'Denial reason'**
  String get adminDenyReason;

  /// No description provided for @adminDenyReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Enter denial reason...'**
  String get adminDenyReasonHint;

  /// No description provided for @adminEmptyList.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get adminEmptyList;

  /// No description provided for @adminEmptyTabList.
  ///
  /// In en, this message translates to:
  /// **'The {tab} list is empty.'**
  String adminEmptyTabList(String tab);

  /// No description provided for @adminNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get adminNavHome;

  /// No description provided for @adminNavStats.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get adminNavStats;

  /// No description provided for @adminNavScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get adminNavScan;

  /// No description provided for @adminNavHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get adminNavHistory;

  /// No description provided for @adminNavLostFound.
  ///
  /// In en, this message translates to:
  /// **'Lost & Found'**
  String get adminNavLostFound;

  /// No description provided for @adminNavSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get adminNavSystem;

  /// No description provided for @adminBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'FUVEKON Admin'**
  String get adminBrandTitle;

  /// No description provided for @adminFieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get adminFieldEmail;

  /// No description provided for @adminFieldFursona.
  ///
  /// In en, this message translates to:
  /// **'Fursona'**
  String get adminFieldFursona;

  /// No description provided for @adminFieldFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get adminFieldFirstName;

  /// No description provided for @adminFieldLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get adminFieldLastName;

  /// No description provided for @adminFieldCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get adminFieldCountry;

  /// No description provided for @adminFieldIdCard.
  ///
  /// In en, this message translates to:
  /// **'ID card'**
  String get adminFieldIdCard;

  /// No description provided for @adminFieldDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get adminFieldDisplayName;

  /// No description provided for @adminFieldRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get adminFieldRole;

  /// No description provided for @adminFieldVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get adminFieldVerified;

  /// No description provided for @adminFieldVerifiedYes.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get adminFieldVerifiedYes;

  /// No description provided for @adminFieldVerifiedNo.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get adminFieldVerifiedNo;

  /// No description provided for @adminFieldHasTicket.
  ///
  /// In en, this message translates to:
  /// **'Has ticket'**
  String get adminFieldHasTicket;

  /// No description provided for @adminFieldAvatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get adminFieldAvatar;

  /// No description provided for @adminFieldCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get adminFieldCreatedAt;

  /// No description provided for @adminFieldLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get adminFieldLastUpdated;

  /// No description provided for @adminFieldDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get adminFieldDateOfBirth;

  /// No description provided for @adminFieldPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get adminFieldPermissions;

  /// No description provided for @adminFieldDealer.
  ///
  /// In en, this message translates to:
  /// **'Dealer'**
  String get adminFieldDealer;

  /// No description provided for @adminFieldAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get adminFieldAccount;

  /// No description provided for @adminFieldUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get adminFieldUser;

  /// No description provided for @adminFieldBoothName.
  ///
  /// In en, this message translates to:
  /// **'Booth name'**
  String get adminFieldBoothName;

  /// No description provided for @adminFieldBoothCode.
  ///
  /// In en, this message translates to:
  /// **'Booth code'**
  String get adminFieldBoothCode;

  /// No description provided for @adminFieldPriceSheet.
  ///
  /// In en, this message translates to:
  /// **'Price sheet'**
  String get adminFieldPriceSheet;

  /// No description provided for @adminFieldPriceSheetN.
  ///
  /// In en, this message translates to:
  /// **'Price sheet {n}'**
  String adminFieldPriceSheetN(int n);

  /// No description provided for @adminFieldRegisteredAt.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get adminFieldRegisteredAt;

  /// No description provided for @adminFieldNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get adminFieldNickname;

  /// No description provided for @adminFieldGenre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get adminFieldGenre;

  /// No description provided for @adminFieldParticipantCount.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get adminFieldParticipantCount;

  /// No description provided for @adminFieldDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get adminFieldDuration;

  /// No description provided for @adminFieldTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Time slot'**
  String get adminFieldTimeSlot;

  /// No description provided for @adminFieldIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get adminFieldIntroduction;

  /// No description provided for @adminFieldSubmittedAt.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get adminFieldSubmittedAt;

  /// No description provided for @adminFieldHandle.
  ///
  /// In en, this message translates to:
  /// **'Handle'**
  String get adminFieldHandle;

  /// No description provided for @adminFieldConbookImage.
  ///
  /// In en, this message translates to:
  /// **'Conbook image'**
  String get adminFieldConbookImage;

  /// No description provided for @adminFieldTicketCode.
  ///
  /// In en, this message translates to:
  /// **'Ticket code'**
  String get adminFieldTicketCode;

  /// No description provided for @adminFieldTicketNumber.
  ///
  /// In en, this message translates to:
  /// **'Ticket number'**
  String get adminFieldTicketNumber;

  /// No description provided for @adminFieldTier.
  ///
  /// In en, this message translates to:
  /// **'Ticket tier'**
  String get adminFieldTier;

  /// No description provided for @adminFieldTierCode.
  ///
  /// In en, this message translates to:
  /// **'Tier code'**
  String get adminFieldTierCode;

  /// No description provided for @adminFieldBadgeName.
  ///
  /// In en, this message translates to:
  /// **'Badge name'**
  String get adminFieldBadgeName;

  /// No description provided for @adminFieldFursuiter.
  ///
  /// In en, this message translates to:
  /// **'Fursuiter'**
  String get adminFieldFursuiter;

  /// No description provided for @adminFieldFursuitStaff.
  ///
  /// In en, this message translates to:
  /// **'Fursuit staff'**
  String get adminFieldFursuitStaff;

  /// No description provided for @adminFieldTshirtSize.
  ///
  /// In en, this message translates to:
  /// **'T-shirt size'**
  String get adminFieldTshirtSize;

  /// No description provided for @adminFieldCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get adminFieldCheckIn;

  /// No description provided for @adminFieldBadgeImage.
  ///
  /// In en, this message translates to:
  /// **'Badge image'**
  String get adminFieldBadgeImage;

  /// No description provided for @adminFieldNamecard.
  ///
  /// In en, this message translates to:
  /// **'Namecard'**
  String get adminFieldNamecard;

  /// No description provided for @adminFieldApprovedAt.
  ///
  /// In en, this message translates to:
  /// **'Approved at'**
  String get adminFieldApprovedAt;

  /// No description provided for @adminFieldDeniedAt.
  ///
  /// In en, this message translates to:
  /// **'Denied at'**
  String get adminFieldDeniedAt;

  /// No description provided for @adminFieldItemCode.
  ///
  /// In en, this message translates to:
  /// **'Item code'**
  String get adminFieldItemCode;

  /// No description provided for @adminFieldType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get adminFieldType;

  /// No description provided for @adminFieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get adminFieldLocation;

  /// No description provided for @adminFieldContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get adminFieldContact;

  /// No description provided for @adminFieldImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get adminFieldImage;

  /// No description provided for @adminFieldStaffNotes.
  ///
  /// In en, this message translates to:
  /// **'Staff notes'**
  String get adminFieldStaffNotes;

  /// No description provided for @adminFieldRecipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get adminFieldRecipient;

  /// No description provided for @adminFieldRecipientIdCard.
  ///
  /// In en, this message translates to:
  /// **'Recipient ID'**
  String get adminFieldRecipientIdCard;

  /// No description provided for @adminFieldRecipientPhone.
  ///
  /// In en, this message translates to:
  /// **'Recipient phone'**
  String get adminFieldRecipientPhone;

  /// No description provided for @adminFieldReturnedAt.
  ///
  /// In en, this message translates to:
  /// **'Returned at'**
  String get adminFieldReturnedAt;

  /// No description provided for @adminFieldUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get adminFieldUpdatedAt;

  /// No description provided for @adminRoleAdminLabel.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get adminRoleAdminLabel;

  /// No description provided for @adminRoleDealerLabel.
  ///
  /// In en, this message translates to:
  /// **'Dealer'**
  String get adminRoleDealerLabel;

  /// No description provided for @adminRoleStaffLabel.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get adminRoleStaffLabel;

  /// No description provided for @adminRoleUserLabel.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get adminRoleUserLabel;

  /// No description provided for @adminRoleCodeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminRoleCodeAdmin;

  /// No description provided for @adminRoleCodeDealer.
  ///
  /// In en, this message translates to:
  /// **'Dealer'**
  String get adminRoleCodeDealer;

  /// No description provided for @adminRoleCodeStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get adminRoleCodeStaff;

  /// No description provided for @adminRoleCodeAttendee.
  ///
  /// In en, this message translates to:
  /// **'Attendee'**
  String get adminRoleCodeAttendee;

  /// No description provided for @adminRoleExhibitor.
  ///
  /// In en, this message translates to:
  /// **'Exhibitor'**
  String get adminRoleExhibitor;

  /// No description provided for @adminRoleStaffSupport.
  ///
  /// In en, this message translates to:
  /// **'Support staff'**
  String get adminRoleStaffSupport;

  /// No description provided for @adminRoleAttendee.
  ///
  /// In en, this message translates to:
  /// **'Attendee'**
  String get adminRoleAttendee;

  /// No description provided for @adminPermissionManageTickets.
  ///
  /// In en, this message translates to:
  /// **'Manage tickets'**
  String get adminPermissionManageTickets;

  /// No description provided for @adminPermissionScanTickets.
  ///
  /// In en, this message translates to:
  /// **'Scan tickets'**
  String get adminPermissionScanTickets;

  /// No description provided for @adminPermissionApproveProfiles.
  ///
  /// In en, this message translates to:
  /// **'Approve profiles'**
  String get adminPermissionApproveProfiles;

  /// No description provided for @adminPermissionSendNotifications.
  ///
  /// In en, this message translates to:
  /// **'Send notifications'**
  String get adminPermissionSendNotifications;

  /// No description provided for @adminPermissionViewDashboard.
  ///
  /// In en, this message translates to:
  /// **'View dashboard'**
  String get adminPermissionViewDashboard;

  /// No description provided for @adminPermissionManageUsers.
  ///
  /// In en, this message translates to:
  /// **'Manage users'**
  String get adminPermissionManageUsers;

  /// No description provided for @adminUserActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminUserActive;

  /// No description provided for @adminUserBlacklisted.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted'**
  String get adminUserBlacklisted;

  /// No description provided for @adminUserBannedFromTickets.
  ///
  /// In en, this message translates to:
  /// **'Banned from buying tickets'**
  String get adminUserBannedFromTickets;

  /// No description provided for @adminBanReason.
  ///
  /// In en, this message translates to:
  /// **'Ban reason'**
  String get adminBanReason;

  /// No description provided for @adminBanDate.
  ///
  /// In en, this message translates to:
  /// **'Ban date'**
  String get adminBanDate;

  /// No description provided for @adminDenialCount.
  ///
  /// In en, this message translates to:
  /// **'Ticket denial count'**
  String get adminDenialCount;

  /// No description provided for @adminAccountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get adminAccountDeleted;

  /// No description provided for @adminTicketStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get adminTicketStatusPending;

  /// No description provided for @adminTicketStatusAwaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get adminTicketStatusAwaitingApproval;

  /// No description provided for @adminTicketStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get adminTicketStatusApproved;

  /// No description provided for @adminTicketStatusDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get adminTicketStatusDenied;

  /// No description provided for @adminTicketStatusAdminGranted.
  ///
  /// In en, this message translates to:
  /// **'Granted by admin'**
  String get adminTicketStatusAdminGranted;

  /// No description provided for @adminCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get adminCheckedIn;

  /// No description provided for @adminNotCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Not checked in'**
  String get adminNotCheckedIn;

  /// No description provided for @adminLostFoundTypeLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get adminLostFoundTypeLost;

  /// No description provided for @adminLostFoundTypeFound.
  ///
  /// In en, this message translates to:
  /// **'Found'**
  String get adminLostFoundTypeFound;

  /// No description provided for @adminLostFoundStatusClaimed.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get adminLostFoundStatusClaimed;

  /// No description provided for @adminLostFoundStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get adminLostFoundStatusResolved;

  /// No description provided for @adminLostFoundStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get adminLostFoundStatusOpen;

  /// No description provided for @adminDealerBoothCode.
  ///
  /// In en, this message translates to:
  /// **'Booth code: {code}'**
  String adminDealerBoothCode(String code);

  /// No description provided for @adminDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String adminDurationMinutes(int minutes);

  /// No description provided for @adminErrorLoadUsers.
  ///
  /// In en, this message translates to:
  /// **'Could not load users.'**
  String get adminErrorLoadUsers;

  /// No description provided for @adminErrorLoadBlacklistedUsers.
  ///
  /// In en, this message translates to:
  /// **'Could not load blacklisted users.'**
  String get adminErrorLoadBlacklistedUsers;

  /// No description provided for @adminErrorLoadDealers.
  ///
  /// In en, this message translates to:
  /// **'Could not load dealers.'**
  String get adminErrorLoadDealers;

  /// No description provided for @adminErrorLoadDealer.
  ///
  /// In en, this message translates to:
  /// **'Could not load dealer details.'**
  String get adminErrorLoadDealer;

  /// No description provided for @adminErrorLoadPanels.
  ///
  /// In en, this message translates to:
  /// **'Could not load panels.'**
  String get adminErrorLoadPanels;

  /// No description provided for @adminErrorLoadConbook.
  ///
  /// In en, this message translates to:
  /// **'Could not load conbook submissions.'**
  String get adminErrorLoadConbook;

  /// No description provided for @adminErrorLoadSchedules.
  ///
  /// In en, this message translates to:
  /// **'Could not load schedules.'**
  String get adminErrorLoadSchedules;

  /// No description provided for @adminErrorLoadSchedule.
  ///
  /// In en, this message translates to:
  /// **'Could not load schedule.'**
  String get adminErrorLoadSchedule;

  /// No description provided for @adminErrorLoadTickets.
  ///
  /// In en, this message translates to:
  /// **'Could not load tickets.'**
  String get adminErrorLoadTickets;

  /// No description provided for @adminErrorLoadTiers.
  ///
  /// In en, this message translates to:
  /// **'Could not load ticket tiers.'**
  String get adminErrorLoadTiers;

  /// No description provided for @adminErrorLoadTicket.
  ///
  /// In en, this message translates to:
  /// **'Could not load ticket details.'**
  String get adminErrorLoadTicket;

  /// No description provided for @adminErrorLoadTicketStats.
  ///
  /// In en, this message translates to:
  /// **'Could not load ticket statistics.'**
  String get adminErrorLoadTicketStats;

  /// No description provided for @adminErrorLoadLostFound.
  ///
  /// In en, this message translates to:
  /// **'Could not load lost & found items.'**
  String get adminErrorLoadLostFound;

  /// No description provided for @adminErrorUpdateEventSettings.
  ///
  /// In en, this message translates to:
  /// **'Could not update event settings.'**
  String get adminErrorUpdateEventSettings;

  /// No description provided for @adminScanInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid ticket code.'**
  String get adminScanInvalidCode;

  /// No description provided for @adminScanNotApproved.
  ///
  /// In en, this message translates to:
  /// **'Ticket is not approved or was denied.'**
  String get adminScanNotApproved;

  /// No description provided for @adminScanAlreadyCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Ticket was already checked in.'**
  String get adminScanAlreadyCheckedIn;

  /// No description provided for @adminScanConfirmBeforeCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Confirm ticket details before check-in.'**
  String get adminScanConfirmBeforeCheckIn;

  /// No description provided for @adminScanCheckInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check-in successful.'**
  String get adminScanCheckInSuccess;

  /// No description provided for @adminUserDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'User details'**
  String get adminUserDetailTitle;

  /// No description provided for @adminDeleteUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete user?'**
  String get adminDeleteUserTitle;

  /// No description provided for @adminDeleteUserBody.
  ///
  /// In en, this message translates to:
  /// **'The account will be soft-deleted and cannot sign in again.'**
  String get adminDeleteUserBody;

  /// No description provided for @adminBanTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ban from buying tickets'**
  String get adminBanTicketsTitle;

  /// No description provided for @adminBanReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Ban reason'**
  String get adminBanReasonLabel;

  /// No description provided for @adminBanReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Enter reason for banning this user...'**
  String get adminBanReasonHint;

  /// No description provided for @adminBanAction.
  ///
  /// In en, this message translates to:
  /// **'Ban'**
  String get adminBanAction;

  /// No description provided for @adminBanReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a ban reason.'**
  String get adminBanReasonRequired;

  /// No description provided for @adminQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get adminQuickActions;

  /// No description provided for @adminRecentHistory.
  ///
  /// In en, this message translates to:
  /// **'Recent history'**
  String get adminRecentHistory;

  /// No description provided for @adminDetailInfo.
  ///
  /// In en, this message translates to:
  /// **'Detailed information'**
  String get adminDetailInfo;

  /// No description provided for @adminDetailInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Profile, permissions, and account status'**
  String get adminDetailInfoSubtitle;

  /// No description provided for @adminVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get adminVerify;

  /// No description provided for @adminPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get adminPermissions;

  /// No description provided for @adminUnban.
  ///
  /// In en, this message translates to:
  /// **'Remove ban'**
  String get adminUnban;

  /// No description provided for @adminBanTickets.
  ///
  /// In en, this message translates to:
  /// **'Ban from buying tickets'**
  String get adminBanTickets;

  /// No description provided for @adminDeleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete user'**
  String get adminDeleteUser;

  /// No description provided for @adminTimelineBanned.
  ///
  /// In en, this message translates to:
  /// **'Banned from buying tickets'**
  String get adminTimelineBanned;

  /// No description provided for @adminTimelineHasTicket.
  ///
  /// In en, this message translates to:
  /// **'Has event ticket'**
  String get adminTimelineHasTicket;

  /// No description provided for @adminTimelineVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get adminTimelineVerified;

  /// No description provided for @adminTimelineCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created'**
  String get adminTimelineCreated;

  /// No description provided for @adminTagBanned.
  ///
  /// In en, this message translates to:
  /// **'BANNED'**
  String get adminTagBanned;

  /// No description provided for @adminTagVerified.
  ///
  /// In en, this message translates to:
  /// **'VERIFIED'**
  String get adminTagVerified;

  /// No description provided for @adminTagNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get adminTagNew;

  /// No description provided for @adminUsersTitle.
  ///
  /// In en, this message translates to:
  /// **'User management'**
  String get adminUsersTitle;

  /// No description provided for @adminUsersTabBlacklisted.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted'**
  String get adminUsersTabBlacklisted;

  /// No description provided for @adminUsersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search email, name, fursona...'**
  String get adminUsersSearchHint;

  /// No description provided for @adminUsersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No users'**
  String get adminUsersEmpty;

  /// No description provided for @adminUsersEmptyBlacklisted.
  ///
  /// In en, this message translates to:
  /// **'No blacklisted users.'**
  String get adminUsersEmptyBlacklisted;

  /// No description provided for @adminUsersEmptySearch.
  ///
  /// In en, this message translates to:
  /// **'No users match your search.'**
  String get adminUsersEmptySearch;

  /// No description provided for @adminTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ticket management'**
  String get adminTicketsTitle;

  /// No description provided for @adminTicketsTabTiers.
  ///
  /// In en, this message translates to:
  /// **'Tiers'**
  String get adminTicketsTabTiers;

  /// No description provided for @adminTicketsTabList.
  ///
  /// In en, this message translates to:
  /// **'Ticket list'**
  String get adminTicketsTabList;

  /// No description provided for @adminTicketsNewTier.
  ///
  /// In en, this message translates to:
  /// **'New tier'**
  String get adminTicketsNewTier;

  /// No description provided for @adminTicketsCreateTier.
  ///
  /// In en, this message translates to:
  /// **'Create tier'**
  String get adminTicketsCreateTier;

  /// No description provided for @adminTicketsPendingOver24h.
  ///
  /// In en, this message translates to:
  /// **'Pending > 24 hours'**
  String get adminTicketsPendingOver24h;

  /// No description provided for @adminTicketsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search code, email, name...'**
  String get adminTicketsSearchHint;

  /// No description provided for @adminTicketsDisableSales.
  ///
  /// In en, this message translates to:
  /// **'Disable sales'**
  String get adminTicketsDisableSales;

  /// No description provided for @adminTicketsEnableSales.
  ///
  /// In en, this message translates to:
  /// **'Enable sales'**
  String get adminTicketsEnableSales;

  /// No description provided for @adminTicketsHideStore.
  ///
  /// In en, this message translates to:
  /// **'Hide from store'**
  String get adminTicketsHideStore;

  /// No description provided for @adminTicketsShowStore.
  ///
  /// In en, this message translates to:
  /// **'Show on store'**
  String get adminTicketsShowStore;

  /// No description provided for @adminTicketsDeleteTier.
  ///
  /// In en, this message translates to:
  /// **'Delete tier'**
  String get adminTicketsDeleteTier;

  /// No description provided for @adminTicketsStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get adminTicketsStock;

  /// No description provided for @adminTicketsBenefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get adminTicketsBenefits;

  /// No description provided for @adminTicketsSelling.
  ///
  /// In en, this message translates to:
  /// **'Selling'**
  String get adminTicketsSelling;

  /// No description provided for @adminTicketsSalesOff.
  ///
  /// In en, this message translates to:
  /// **'Sales off'**
  String get adminTicketsSalesOff;

  /// No description provided for @adminTicketsStoreVisible.
  ///
  /// In en, this message translates to:
  /// **'Visible'**
  String get adminTicketsStoreVisible;

  /// No description provided for @adminTicketsStoreHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get adminTicketsStoreHidden;

  /// No description provided for @adminTicketsDeleteTierTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete tier?'**
  String get adminTicketsDeleteTierTitle;

  /// No description provided for @adminTicketsDeleteTierBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes the tier and cannot be undone.'**
  String get adminTicketsDeleteTierBody;

  /// No description provided for @adminTicketsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tickets'**
  String get adminTicketsEmpty;

  /// No description provided for @adminTicketsEmptyTiers.
  ///
  /// In en, this message translates to:
  /// **'No ticket tiers yet.'**
  String get adminTicketsEmptyTiers;

  /// No description provided for @adminTierEditCreate.
  ///
  /// In en, this message translates to:
  /// **'Create ticket tier'**
  String get adminTierEditCreate;

  /// No description provided for @adminTierEditEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit ticket tier'**
  String get adminTierEditEdit;

  /// No description provided for @adminTierNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Tier name'**
  String get adminTierNameLabel;

  /// No description provided for @adminTierPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (VND)'**
  String get adminTierPriceLabel;

  /// No description provided for @adminTierStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get adminTierStockLabel;

  /// No description provided for @adminTierDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Tier description'**
  String get adminTierDescriptionLabel;

  /// No description provided for @adminTierBenefitsList.
  ///
  /// In en, this message translates to:
  /// **'Benefits list'**
  String get adminTierBenefitsList;

  /// No description provided for @adminTierAddBenefit.
  ///
  /// In en, this message translates to:
  /// **'Add benefit'**
  String get adminTierAddBenefit;

  /// No description provided for @adminTierSalesStatus.
  ///
  /// In en, this message translates to:
  /// **'Sales status'**
  String get adminTierSalesStatus;

  /// No description provided for @adminTierPreview.
  ///
  /// In en, this message translates to:
  /// **'Display preview'**
  String get adminTierPreview;

  /// No description provided for @adminTierCreated.
  ///
  /// In en, this message translates to:
  /// **'Tier created.'**
  String get adminTierCreated;

  /// No description provided for @adminTierUpdated.
  ///
  /// In en, this message translates to:
  /// **'Tier updated.'**
  String get adminTierUpdated;

  /// No description provided for @adminSchedulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule management'**
  String get adminSchedulesTitle;

  /// No description provided for @adminSchedulesCreate.
  ///
  /// In en, this message translates to:
  /// **'Create schedule'**
  String get adminSchedulesCreate;

  /// No description provided for @adminSchedulesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No schedules yet'**
  String get adminSchedulesEmpty;

  /// No description provided for @adminSchedulesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit schedule'**
  String get adminSchedulesEdit;

  /// No description provided for @adminSchedulesCreateNew.
  ///
  /// In en, this message translates to:
  /// **'Create new schedule'**
  String get adminSchedulesCreateNew;

  /// No description provided for @adminSchedulesNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Schedule name'**
  String get adminSchedulesNameLabel;

  /// No description provided for @adminScheduleEndAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time.'**
  String get adminScheduleEndAfterStart;

  /// No description provided for @adminScheduleDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete schedule?'**
  String get adminScheduleDeleteTitle;

  /// No description provided for @adminScheduleDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'All items in this schedule will be deleted.'**
  String get adminScheduleDeleteBody;

  /// No description provided for @adminScheduleDeleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete schedule item?'**
  String get adminScheduleDeleteItemTitle;

  /// No description provided for @adminScheduleDeleteItemBody.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"?'**
  String adminScheduleDeleteItemBody(String title);

  /// No description provided for @adminScheduleEditMenu.
  ///
  /// In en, this message translates to:
  /// **'Edit schedule'**
  String get adminScheduleEditMenu;

  /// No description provided for @adminScheduleDeleteMenu.
  ///
  /// In en, this message translates to:
  /// **'Delete schedule'**
  String get adminScheduleDeleteMenu;

  /// No description provided for @adminScheduleNoItems.
  ///
  /// In en, this message translates to:
  /// **'No schedule items yet'**
  String get adminScheduleNoItems;

  /// No description provided for @adminScheduleEditItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get adminScheduleEditItem;

  /// No description provided for @adminScheduleAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add schedule item'**
  String get adminScheduleAddItem;

  /// No description provided for @adminScheduleOverlapBadge.
  ///
  /// In en, this message translates to:
  /// **'Location overlap'**
  String get adminScheduleOverlapBadge;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Event overview'**
  String get adminDashboardTitle;

  /// No description provided for @adminDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days'**
  String get adminDashboardSubtitle;

  /// No description provided for @adminDashboardTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get adminDashboardTickets;

  /// No description provided for @adminDashboardByTier.
  ///
  /// In en, this message translates to:
  /// **'By tier'**
  String get adminDashboardByTier;

  /// No description provided for @adminDashboardRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get adminDashboardRevenue;

  /// No description provided for @adminDashboardUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get adminDashboardUsers;

  /// No description provided for @adminDashboardDealers.
  ///
  /// In en, this message translates to:
  /// **'Dealers'**
  String get adminDashboardDealers;

  /// No description provided for @adminDashboardTotalTickets.
  ///
  /// In en, this message translates to:
  /// **'Total tickets'**
  String get adminDashboardTotalTickets;

  /// No description provided for @adminDashboardApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get adminDashboardApproved;

  /// No description provided for @adminDashboardPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminDashboardPending;

  /// No description provided for @adminDashboardDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get adminDashboardDenied;

  /// No description provided for @adminDashboardSold.
  ///
  /// In en, this message translates to:
  /// **'Sold {sold} / {total}'**
  String adminDashboardSold(int sold, int total);

  /// No description provided for @adminDashboardRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String adminDashboardRemaining(int count);

  /// No description provided for @adminDashboardUsersByCountry.
  ///
  /// In en, this message translates to:
  /// **'Users by country'**
  String get adminDashboardUsersByCountry;

  /// No description provided for @adminDashboardUnknownCountry.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get adminDashboardUnknownCountry;

  /// No description provided for @adminDashboardUsersByCountryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No country data yet'**
  String get adminDashboardUsersByCountryEmpty;

  /// No description provided for @adminDashboardUsersByCountryMore.
  ///
  /// In en, this message translates to:
  /// **'+{count} more countries'**
  String adminDashboardUsersByCountryMore(int count);

  /// No description provided for @adminConbookTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Conbook'**
  String get adminConbookTitle;

  /// No description provided for @adminConbookApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve conbook'**
  String get adminConbookApprove;

  /// No description provided for @adminConbookDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny conbook'**
  String get adminConbookDeny;

  /// No description provided for @adminPanelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Panel management'**
  String get adminPanelsTitle;

  /// No description provided for @adminPanelsApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve panel'**
  String get adminPanelsApprove;

  /// No description provided for @adminPanelsDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny panel'**
  String get adminPanelsDeny;

  /// No description provided for @adminDealersTitle.
  ///
  /// In en, this message translates to:
  /// **'Dealer management'**
  String get adminDealersTitle;

  /// No description provided for @adminDealersApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve booth'**
  String get adminDealersApprove;

  /// No description provided for @adminDealersDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny registration'**
  String get adminDealersDeny;

  /// No description provided for @adminDealerDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Booth details'**
  String get adminDealerDetailTitle;

  /// No description provided for @adminDealerInfo.
  ///
  /// In en, this message translates to:
  /// **'Booth information'**
  String get adminDealerInfo;

  /// No description provided for @adminDealerPriceSheets.
  ///
  /// In en, this message translates to:
  /// **'Price sheets'**
  String get adminDealerPriceSheets;

  /// No description provided for @adminDealerStaff.
  ///
  /// In en, this message translates to:
  /// **'Booth staff'**
  String get adminDealerStaff;

  /// No description provided for @adminDealerNoStaff.
  ///
  /// In en, this message translates to:
  /// **'No staff members yet.'**
  String get adminDealerNoStaff;

  /// No description provided for @adminDealerActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get adminDealerActions;

  /// No description provided for @adminDealerOwner.
  ///
  /// In en, this message translates to:
  /// **'Booth owner'**
  String get adminDealerOwner;

  /// No description provided for @adminDealerJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined:'**
  String get adminDealerJoined;

  /// No description provided for @adminLostFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Lost & Found management'**
  String get adminLostFoundTitle;

  /// No description provided for @adminLostFoundSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search title, code, location...'**
  String get adminLostFoundSearchHint;

  /// No description provided for @adminLostFoundEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get adminLostFoundEmpty;

  /// No description provided for @adminLostFoundDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Item details'**
  String get adminLostFoundDetailTitle;

  /// No description provided for @adminLostFoundRecipientClaimed.
  ///
  /// In en, this message translates to:
  /// **'Recipient (claimed)'**
  String get adminLostFoundRecipientClaimed;

  /// No description provided for @adminLostFoundNoClaim.
  ///
  /// In en, this message translates to:
  /// **'No active claim for this item.'**
  String get adminLostFoundNoClaim;

  /// No description provided for @adminLostFoundConfirmReturn.
  ///
  /// In en, this message translates to:
  /// **'Confirm return'**
  String get adminLostFoundConfirmReturn;

  /// No description provided for @adminLostFoundMarkResolved.
  ///
  /// In en, this message translates to:
  /// **'Mark as resolved'**
  String get adminLostFoundMarkResolved;

  /// No description provided for @adminLostFoundDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete item?'**
  String get adminLostFoundDeleteTitle;

  /// No description provided for @adminLostFoundReturnTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm return'**
  String get adminLostFoundReturnTitle;

  /// No description provided for @adminLostFoundReturnSuccess.
  ///
  /// In en, this message translates to:
  /// **'Return confirmed successfully.'**
  String get adminLostFoundReturnSuccess;

  /// No description provided for @adminLostFoundVerifyDescription.
  ///
  /// In en, this message translates to:
  /// **'Description matches item'**
  String get adminLostFoundVerifyDescription;

  /// No description provided for @adminLostFoundVerifyOwnership.
  ///
  /// In en, this message translates to:
  /// **'Ownership evidence provided'**
  String get adminLostFoundVerifyOwnership;

  /// No description provided for @adminLostFoundVerifyIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity verified'**
  String get adminLostFoundVerifyIdentity;

  /// No description provided for @adminLostFoundAuditNote.
  ///
  /// In en, this message translates to:
  /// **'This action will be logged in the system audit log.'**
  String get adminLostFoundAuditNote;

  /// No description provided for @adminScanHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan history'**
  String get adminScanHistoryTitle;

  /// No description provided for @adminScanHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No scans recorded yet.'**
  String get adminScanHistoryEmpty;

  /// No description provided for @adminScanOutcomeValid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get adminScanOutcomeValid;

  /// No description provided for @adminScanOutcomeReused.
  ///
  /// In en, this message translates to:
  /// **'Reused'**
  String get adminScanOutcomeReused;

  /// No description provided for @adminScanOutcomeRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get adminScanOutcomeRejected;

  /// No description provided for @adminUserEditPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get adminUserEditPermissions;

  /// No description provided for @adminUserEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit user'**
  String get adminUserEditTitle;

  /// No description provided for @adminUserEditPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get adminUserEditPersonalInfo;

  /// No description provided for @adminUserEditAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account status'**
  String get adminUserEditAccountStatus;

  /// No description provided for @adminUserEditRoles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get adminUserEditRoles;

  /// No description provided for @adminUserEditPermissionGroup.
  ///
  /// In en, this message translates to:
  /// **'Permission group'**
  String get adminUserEditPermissionGroup;

  /// No description provided for @adminUserEditVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get adminUserEditVerified;

  /// No description provided for @adminUserEditVerifiedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Email has been verified'**
  String get adminUserEditVerifiedSubtitle;

  /// No description provided for @adminUserEditAdminNote.
  ///
  /// In en, this message translates to:
  /// **'Administrators have all permissions.'**
  String get adminUserEditAdminNote;

  /// No description provided for @adminUserTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'User tickets'**
  String get adminUserTicketsTitle;

  /// No description provided for @adminUserTicketsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Grant, approve, edit, or delete tickets'**
  String get adminUserTicketsSubtitle;

  /// No description provided for @adminUserTicketsNoTiers.
  ///
  /// In en, this message translates to:
  /// **'No ticket tiers available to grant.'**
  String get adminUserTicketsNoTiers;

  /// No description provided for @adminUserTicketsGrant.
  ///
  /// In en, this message translates to:
  /// **'Grant ticket'**
  String get adminUserTicketsGrant;

  /// No description provided for @adminUserTicketsGrantSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ticket granted to user.'**
  String get adminUserTicketsGrantSuccess;

  /// No description provided for @adminUserTicketsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete ticket?'**
  String get adminUserTicketsDeleteTitle;

  /// No description provided for @adminUserTicketsDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Delete ticket {code}? This cannot be undone.'**
  String adminUserTicketsDeleteBody(String code);

  /// No description provided for @adminUserTicketsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Ticket deleted.'**
  String get adminUserTicketsDeleted;

  /// No description provided for @adminUserTicketsApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve ticket'**
  String get adminUserTicketsApprove;

  /// No description provided for @adminUserTicketsApproveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ticket approved.'**
  String get adminUserTicketsApproveSuccess;

  /// No description provided for @adminUserTicketsDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny ticket'**
  String get adminUserTicketsDeny;

  /// No description provided for @adminUserTicketsDenySuccess.
  ///
  /// In en, this message translates to:
  /// **'Ticket denied.'**
  String get adminUserTicketsDenySuccess;

  /// No description provided for @adminUserTicketsResendQr.
  ///
  /// In en, this message translates to:
  /// **'Resend QR email'**
  String get adminUserTicketsResendQr;

  /// No description provided for @adminUserTicketsResendQrSuccess.
  ///
  /// In en, this message translates to:
  /// **'QR email resent.'**
  String get adminUserTicketsResendQrSuccess;

  /// No description provided for @adminUserTicketsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit ticket'**
  String get adminUserTicketsEdit;

  /// No description provided for @adminUserTicketsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete ticket'**
  String get adminUserTicketsDelete;

  /// No description provided for @adminUserTicketsEmpty.
  ///
  /// In en, this message translates to:
  /// **'User has no tickets.'**
  String get adminUserTicketsEmpty;

  /// No description provided for @adminUserTicketsGrantDialog.
  ///
  /// In en, this message translates to:
  /// **'Grant ticket'**
  String get adminUserTicketsGrantDialog;

  /// No description provided for @adminUserTicketsTierLabel.
  ///
  /// In en, this message translates to:
  /// **'Ticket tier'**
  String get adminUserTicketsTierLabel;

  /// No description provided for @adminUserTicketsEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit ticket'**
  String get adminUserTicketsEditTitle;

  /// No description provided for @adminUserTicketsNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get adminUserTicketsNotSelected;

  /// No description provided for @adminSectionOnSite.
  ///
  /// In en, this message translates to:
  /// **'On-site operations'**
  String get adminSectionOnSite;

  /// No description provided for @adminSectionOnSiteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in, scan history, and lost & found.'**
  String get adminSectionOnSiteSubtitle;

  /// No description provided for @adminSectionEvent.
  ///
  /// In en, this message translates to:
  /// **'Event management'**
  String get adminSectionEvent;

  /// No description provided for @adminSectionEventSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tickets, configuration, and event operations.'**
  String get adminSectionEventSubtitle;

  /// No description provided for @adminSectionContent.
  ///
  /// In en, this message translates to:
  /// **'Content review'**
  String get adminSectionContent;

  /// No description provided for @adminSectionContentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Conbook, panels, and dealer booths.'**
  String get adminSectionContentSubtitle;

  /// No description provided for @adminSectionUsersReports.
  ///
  /// In en, this message translates to:
  /// **'Users & reports'**
  String get adminSectionUsersReports;

  /// No description provided for @adminSectionUsersReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts and ticket sales data.'**
  String get adminSectionUsersReportsSubtitle;

  /// No description provided for @adminSectionOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get adminSectionOther;

  /// No description provided for @adminSectionOtherSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Schedules, notifications, and system.'**
  String get adminSectionOtherSubtitle;

  /// No description provided for @adminMenuScanTicket.
  ///
  /// In en, this message translates to:
  /// **'Scan ticket'**
  String get adminMenuScanTicket;

  /// No description provided for @adminMenuScanHistory.
  ///
  /// In en, this message translates to:
  /// **'Scan history'**
  String get adminMenuScanHistory;

  /// No description provided for @adminMenuLostFound.
  ///
  /// In en, this message translates to:
  /// **'Lost & Found'**
  String get adminMenuLostFound;

  /// No description provided for @adminMenuTickets.
  ///
  /// In en, this message translates to:
  /// **'Ticket management'**
  String get adminMenuTickets;

  /// No description provided for @adminMenuConbook.
  ///
  /// In en, this message translates to:
  /// **'Review Conbook'**
  String get adminMenuConbook;

  /// No description provided for @adminMenuPanels.
  ///
  /// In en, this message translates to:
  /// **'Panel management'**
  String get adminMenuPanels;

  /// No description provided for @adminMenuDealers.
  ///
  /// In en, this message translates to:
  /// **'Dealer management'**
  String get adminMenuDealers;

  /// No description provided for @adminMenuUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get adminMenuUsers;

  /// No description provided for @adminMenuStats.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get adminMenuStats;

  /// No description provided for @adminMenuNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get adminMenuNotifications;

  /// No description provided for @adminNotificationCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Send notification'**
  String get adminNotificationCreateTitle;

  /// No description provided for @adminNotificationCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an in-app notification for a user. Optionally send push and email.'**
  String get adminNotificationCreateSubtitle;

  /// No description provided for @adminNotificationRecipientLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get adminNotificationRecipientLabel;

  /// No description provided for @adminNotificationSearchUserHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email'**
  String get adminNotificationSearchUserHint;

  /// No description provided for @adminNotificationSelectUserRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a recipient user.'**
  String get adminNotificationSelectUserRequired;

  /// No description provided for @adminNotificationTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get adminNotificationTitleLabel;

  /// No description provided for @adminNotificationTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required.'**
  String get adminNotificationTitleRequired;

  /// No description provided for @adminNotificationBodyLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get adminNotificationBodyLabel;

  /// No description provided for @adminNotificationKindLabel.
  ///
  /// In en, this message translates to:
  /// **'Kind (optional)'**
  String get adminNotificationKindLabel;

  /// No description provided for @adminNotificationKindHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. announcement'**
  String get adminNotificationKindHint;

  /// No description provided for @adminNotificationSendPush.
  ///
  /// In en, this message translates to:
  /// **'Send push notification'**
  String get adminNotificationSendPush;

  /// No description provided for @adminNotificationSendPushHint.
  ///
  /// In en, this message translates to:
  /// **'Deliver via FCM to registered mobile devices.'**
  String get adminNotificationSendPushHint;

  /// No description provided for @adminNotificationSendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send email'**
  String get adminNotificationSendEmail;

  /// No description provided for @adminNotificationSendEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email the same title and message to the user.'**
  String get adminNotificationSendEmailHint;

  /// No description provided for @adminNotificationSend.
  ///
  /// In en, this message translates to:
  /// **'Send notification'**
  String get adminNotificationSend;

  /// No description provided for @adminNotificationSendAction.
  ///
  /// In en, this message translates to:
  /// **'Notify'**
  String get adminNotificationSendAction;

  /// No description provided for @adminNotificationCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Notification created.'**
  String get adminNotificationCreateSuccess;

  /// No description provided for @adminNotificationPushSent.
  ///
  /// In en, this message translates to:
  /// **'Push delivered to {count, plural, =0 {no devices} =1 {1 device} other {{count} devices}}.'**
  String adminNotificationPushSent(int count);

  /// No description provided for @adminNotificationPushFailed.
  ///
  /// In en, this message translates to:
  /// **'Push failed: {error}'**
  String adminNotificationPushFailed(String error);

  /// No description provided for @adminNotificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Email sent.'**
  String get adminNotificationEmailSent;

  /// No description provided for @adminNotificationEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'Email failed: {error}'**
  String adminNotificationEmailFailed(String error);

  /// No description provided for @adminMenuSchedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get adminMenuSchedules;

  /// No description provided for @adminEventSchedulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule management'**
  String get adminEventSchedulesTitle;

  /// No description provided for @adminEventSchedulesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Schedules by day and time slot.'**
  String get adminEventSchedulesSubtitle;

  /// No description provided for @adminEventSchedulesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No schedules yet'**
  String get adminEventSchedulesEmpty;

  /// No description provided for @adminEventSchedulesCreate.
  ///
  /// In en, this message translates to:
  /// **'Create new schedule'**
  String get adminEventSchedulesCreate;

  /// No description provided for @adminEventSchedulesCreateShort.
  ///
  /// In en, this message translates to:
  /// **'Create schedule'**
  String get adminEventSchedulesCreateShort;

  /// No description provided for @adminEventSchedulesNoTime.
  ///
  /// In en, this message translates to:
  /// **'No time set'**
  String get adminEventSchedulesNoTime;

  /// No description provided for @adminEventSchedulesFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get adminEventSchedulesFrom;

  /// No description provided for @adminEventSchedulesTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get adminEventSchedulesTo;

  /// No description provided for @adminEventSchedulesDaysItems.
  ///
  /// In en, this message translates to:
  /// **'{days} days · {items} items'**
  String adminEventSchedulesDaysItems(int days, int items);

  /// No description provided for @adminEventControlsTitle.
  ///
  /// In en, this message translates to:
  /// **'Event controls'**
  String get adminEventControlsTitle;

  /// No description provided for @adminSystemStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'System status'**
  String get adminSystemStatusTitle;

  /// No description provided for @adminSystemStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor core services in real time.'**
  String get adminSystemStatusSubtitle;

  /// No description provided for @adminSystemHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get adminSystemHealthy;

  /// No description provided for @adminSystemWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get adminSystemWarning;

  /// No description provided for @adminSystemError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get adminSystemError;

  /// No description provided for @adminSystemUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get adminSystemUnknown;

  /// No description provided for @adminStaffReadySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to serve attendees at the event.'**
  String get adminStaffReadySubtitle;

  /// No description provided for @adminStaffCheckInGate.
  ///
  /// In en, this message translates to:
  /// **'Gate check-in'**
  String get adminStaffCheckInGate;

  /// No description provided for @adminStaffReadyBadge.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get adminStaffReadyBadge;

  /// No description provided for @adminStaffScanHint.
  ///
  /// In en, this message translates to:
  /// **'Scan ticket QR codes to check in attendees.'**
  String get adminStaffScanHint;

  /// No description provided for @adminStaffGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get adminStaffGreetingMorning;

  /// No description provided for @adminStaffGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon,'**
  String get adminStaffGreetingAfternoon;

  /// No description provided for @adminStaffGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening,'**
  String get adminStaffGreetingEvening;

  /// No description provided for @adminStaffShiftStats.
  ///
  /// In en, this message translates to:
  /// **'Shift statistics'**
  String get adminStaffShiftStats;

  /// No description provided for @adminStaffShiftNoData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get adminStaffShiftNoData;

  /// No description provided for @adminStaffShiftUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated at'**
  String get adminStaffShiftUpdatedAt;

  /// No description provided for @adminStaffShiftScannedToday.
  ///
  /// In en, this message translates to:
  /// **'Tickets scanned today'**
  String get adminStaffShiftScannedToday;

  /// No description provided for @adminStaffTrafficWarning.
  ///
  /// In en, this message translates to:
  /// **'TRAFFIC WARNING'**
  String get adminStaffTrafficWarning;

  /// No description provided for @adminSalesTimelineDefault.
  ///
  /// In en, this message translates to:
  /// **'Daily ticket sales'**
  String get adminSalesTimelineDefault;

  /// No description provided for @adminQrContinueScan.
  ///
  /// In en, this message translates to:
  /// **'Continue scanning'**
  String get adminQrContinueScan;

  /// No description provided for @adminQrProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing ticket...'**
  String get adminQrProcessing;

  /// No description provided for @adminQrAlignFrame.
  ///
  /// In en, this message translates to:
  /// **'Align the ticket QR code in the frame'**
  String get adminQrAlignFrame;

  /// No description provided for @adminQrManualEntry.
  ///
  /// In en, this message translates to:
  /// **'Enter code manually'**
  String get adminQrManualEntry;

  /// No description provided for @adminQrCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get adminQrCheckIn;

  /// No description provided for @adminQrEnterCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter ticket code'**
  String get adminQrEnterCodeTitle;

  /// No description provided for @adminQrTicketInfo.
  ///
  /// In en, this message translates to:
  /// **'Ticket information'**
  String get adminQrTicketInfo;

  /// No description provided for @adminQrGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get adminQrGuest;

  /// No description provided for @adminQrNoTicketImage.
  ///
  /// In en, this message translates to:
  /// **'No ticket image'**
  String get adminQrNoTicketImage;

  /// No description provided for @adminQrReadyCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Ready to check in'**
  String get adminQrReadyCheckIn;

  /// No description provided for @adminQrConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get adminQrConnecting;

  /// No description provided for @adminQrScanNow.
  ///
  /// In en, this message translates to:
  /// **'SCAN TICKET NOW'**
  String get adminQrScanNow;

  /// No description provided for @adminTierBadgeSoldOut.
  ///
  /// In en, this message translates to:
  /// **'SOLD OUT'**
  String get adminTierBadgeSoldOut;

  /// No description provided for @adminTierBadgePaused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get adminTierBadgePaused;

  /// No description provided for @adminTierBadgeSelling.
  ///
  /// In en, this message translates to:
  /// **'SELLING'**
  String get adminTierBadgeSelling;

  /// No description provided for @adminTierViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View ticket details →'**
  String get adminTierViewDetails;

  /// No description provided for @adminTierLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get adminTierLowStock;

  /// No description provided for @adminPlaceholderDashboardUsers.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Users'**
  String get adminPlaceholderDashboardUsers;

  /// No description provided for @adminPlaceholderDashboardUsersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'User analytics and breakdowns.'**
  String get adminPlaceholderDashboardUsersSubtitle;

  /// No description provided for @adminPlaceholderTalent.
  ///
  /// In en, this message translates to:
  /// **'Talent Management'**
  String get adminPlaceholderTalent;

  /// No description provided for @adminPlaceholderTalentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review and manage talent applications.'**
  String get adminPlaceholderTalentSubtitle;

  /// No description provided for @adminTierUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ticket tier updated successfully.'**
  String get adminTierUpdateSuccess;

  /// No description provided for @adminLostFoundFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Record lost & found item'**
  String get adminLostFoundFormTitle;

  /// No description provided for @adminLostFoundFormType.
  ///
  /// In en, this message translates to:
  /// **'Item type'**
  String get adminLostFoundFormType;

  /// No description provided for @adminLostFoundFormTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get adminLostFoundFormTitleLabel;

  /// No description provided for @adminLostFoundFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get adminLostFoundFormDescription;

  /// No description provided for @adminLostFoundFormLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get adminLostFoundFormLocation;

  /// No description provided for @adminLostFoundFormContact.
  ///
  /// In en, this message translates to:
  /// **'Contact info'**
  String get adminLostFoundFormContact;

  /// No description provided for @adminLostFoundFormNotes.
  ///
  /// In en, this message translates to:
  /// **'Staff notes'**
  String get adminLostFoundFormNotes;

  /// No description provided for @adminLostFoundFormImage.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get adminLostFoundFormImage;

  /// No description provided for @adminLostFoundFormRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get adminLostFoundFormRequired;

  /// No description provided for @adminRoleCurrent.
  ///
  /// In en, this message translates to:
  /// **'{role} Current'**
  String adminRoleCurrent(String role);

  /// No description provided for @adminStatusPillDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get adminStatusPillDeleted;

  /// No description provided for @adminStatusPillBlacklisted.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted'**
  String get adminStatusPillBlacklisted;

  /// No description provided for @adminStatusPillActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminStatusPillActive;

  /// No description provided for @adminTimelineBannedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Account restricted from buying tickets.'**
  String get adminTimelineBannedSubtitle;

  /// No description provided for @adminTimelineHasTicketSubtitle.
  ///
  /// In en, this message translates to:
  /// **'User registered or was granted a ticket.'**
  String get adminTimelineHasTicketSubtitle;

  /// No description provided for @adminTimelineVerifiedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Account identity has been verified.'**
  String get adminTimelineVerifiedSubtitle;

  /// No description provided for @adminTimelineCreatedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Registered on the system.'**
  String get adminTimelineCreatedSubtitle;

  /// No description provided for @adminTagTicket.
  ///
  /// In en, this message translates to:
  /// **'TICKET'**
  String get adminTagTicket;

  /// No description provided for @adminEventCount.
  ///
  /// In en, this message translates to:
  /// **'{count} events'**
  String adminEventCount(int count);

  /// No description provided for @adminLostFoundEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a lost or found item.'**
  String get adminLostFoundEmptySubtitle;

  /// No description provided for @adminUserEditPersonalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update the user\'s profile and contact details.'**
  String get adminUserEditPersonalSubtitle;

  /// No description provided for @adminUserTicketsManage.
  ///
  /// In en, this message translates to:
  /// **'Manage ticket'**
  String get adminUserTicketsManage;

  /// No description provided for @adminLostFoundFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit lost & found item'**
  String get adminLostFoundFormEditTitle;

  /// No description provided for @adminLostFoundFormAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get adminLostFoundFormAddItem;

  /// No description provided for @adminLostFoundItemInfo.
  ///
  /// In en, this message translates to:
  /// **'Item information'**
  String get adminLostFoundItemInfo;

  /// No description provided for @adminLostFoundRecipientInfo.
  ///
  /// In en, this message translates to:
  /// **'Recipient information'**
  String get adminLostFoundRecipientInfo;

  /// No description provided for @adminLostFoundUserConfirmed.
  ///
  /// In en, this message translates to:
  /// **'The user confirmed this is their item.'**
  String get adminLostFoundUserConfirmed;

  /// No description provided for @adminLostFoundVerifyChecklist.
  ///
  /// In en, this message translates to:
  /// **'Verification checklist'**
  String get adminLostFoundVerifyChecklist;

  /// No description provided for @adminLostFoundReturnNoClaim.
  ///
  /// In en, this message translates to:
  /// **'No user has claimed this item yet.'**
  String get adminLostFoundReturnNoClaim;

  /// No description provided for @adminLostFoundReturnCannot.
  ///
  /// In en, this message translates to:
  /// **'This item cannot be returned.'**
  String get adminLostFoundReturnCannot;

  /// No description provided for @adminLostFoundReturnNoRecipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient information not found.'**
  String get adminLostFoundReturnNoRecipient;

  /// No description provided for @adminLostFoundVerifyRequired.
  ///
  /// In en, this message translates to:
  /// **'Complete the verification checklist before confirming.'**
  String get adminLostFoundVerifyRequired;

  /// No description provided for @adminLostFoundUserNote.
  ///
  /// In en, this message translates to:
  /// **'Note from user'**
  String get adminLostFoundUserNote;

  /// No description provided for @adminDealerStaffCount.
  ///
  /// In en, this message translates to:
  /// **'Booth staff ({count})'**
  String adminDealerStaffCount(int count);

  /// No description provided for @adminDealerPriceSheetsCount.
  ///
  /// In en, this message translates to:
  /// **'Price sheets ({count})'**
  String adminDealerPriceSheetsCount(int count);

  /// No description provided for @adminEventControlsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable ticket sales and registration channels.'**
  String get adminEventControlsSubtitle;

  /// No description provided for @adminEventToggleTicketSales.
  ///
  /// In en, this message translates to:
  /// **'Ticket sales'**
  String get adminEventToggleTicketSales;

  /// No description provided for @adminEventToggleTicketSalesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow users to purchase and upgrade event tickets.'**
  String get adminEventToggleTicketSalesSubtitle;

  /// No description provided for @adminEventTogglePanelRegistration.
  ///
  /// In en, this message translates to:
  /// **'Panel registration'**
  String get adminEventTogglePanelRegistration;

  /// No description provided for @adminEventTogglePanelRegistrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow panel registration in the app.'**
  String get adminEventTogglePanelRegistrationSubtitle;

  /// No description provided for @adminEventToggleTalentRegistration.
  ///
  /// In en, this message translates to:
  /// **'Talent registration'**
  String get adminEventToggleTalentRegistration;

  /// No description provided for @adminEventToggleTalentRegistrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow talent registration in the app.'**
  String get adminEventToggleTalentRegistrationSubtitle;

  /// No description provided for @adminEventToggleDealerRegistration.
  ///
  /// In en, this message translates to:
  /// **'Dealer registration'**
  String get adminEventToggleDealerRegistration;

  /// No description provided for @adminEventToggleDealerRegistrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow dealer booth registration in the app.'**
  String get adminEventToggleDealerRegistrationSubtitle;

  /// No description provided for @adminTicketsTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminTicketsTabAll;

  /// No description provided for @adminTicketsTabPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get adminTicketsTabPendingReview;

  /// No description provided for @adminTicketsTabApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get adminTicketsTabApproved;

  /// No description provided for @adminTicketsTabDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get adminTicketsTabDenied;

  /// No description provided for @adminTicketsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'No tickets match the current filters.'**
  String get adminTicketsEmptySubtitle;

  /// No description provided for @adminTicketsEmptyTiersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first tier to start selling.'**
  String get adminTicketsEmptyTiersSubtitle;

  /// No description provided for @adminTicketsEmptyFilter.
  ///
  /// In en, this message translates to:
  /// **'No tiers in the \"{filter}\" filter.'**
  String adminTicketsEmptyFilter(String filter);

  /// No description provided for @adminTicketsDeleteTierBodyNamed.
  ///
  /// In en, this message translates to:
  /// **'Deleting \"{name}\" permanently removes this tier and all sold tickets in it. This cannot be undone.'**
  String adminTicketsDeleteTierBodyNamed(String name);

  /// No description provided for @adminTicketsStockSoldOut.
  ///
  /// In en, this message translates to:
  /// **' (sold out)'**
  String get adminTicketsStockSoldOut;

  /// No description provided for @adminTierFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminTierFilterAll;

  /// No description provided for @adminTierFilterSelling.
  ///
  /// In en, this message translates to:
  /// **'Selling'**
  String get adminTierFilterSelling;

  /// No description provided for @adminTierFilterPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get adminTierFilterPaused;

  /// No description provided for @adminTierFilterSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold out'**
  String get adminTierFilterSoldOut;

  /// No description provided for @adminTierStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total tickets'**
  String get adminTierStatTotal;

  /// No description provided for @adminTierStatSold.
  ///
  /// In en, this message translates to:
  /// **'Tickets sold'**
  String get adminTierStatSold;

  /// No description provided for @adminTierStatRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get adminTierStatRemaining;

  /// No description provided for @adminTierStatApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved tickets'**
  String get adminTierStatApproved;

  /// No description provided for @adminTierSoldCount.
  ///
  /// In en, this message translates to:
  /// **'Sold: {sold} / {total}'**
  String adminTierSoldCount(int sold, int total);

  /// No description provided for @adminTierNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a tier name'**
  String get adminTierNameRequired;

  /// No description provided for @adminTierMaxChars255.
  ///
  /// In en, this message translates to:
  /// **'Maximum 255 characters'**
  String get adminTierMaxChars255;

  /// No description provided for @adminTierEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get adminTierEnterPrice;

  /// No description provided for @adminTierInvalidPrice.
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get adminTierInvalidPrice;

  /// No description provided for @adminTierEnterStockQty.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get adminTierEnterStockQty;

  /// No description provided for @adminTierInvalidStock.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get adminTierInvalidStock;

  /// No description provided for @adminTierBenefitHint.
  ///
  /// In en, this message translates to:
  /// **'Enter benefit...'**
  String get adminTierBenefitHint;

  /// No description provided for @adminTierDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Brief description of audience and perks...'**
  String get adminTierDescriptionHint;

  /// No description provided for @adminTierNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. VIP Pass - Early Bird'**
  String get adminTierNameHint;

  /// No description provided for @adminTierAllowPurchaseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow users to purchase this tier'**
  String get adminTierAllowPurchaseSubtitle;

  /// No description provided for @adminTierSaveCreate.
  ///
  /// In en, this message translates to:
  /// **'Create tier'**
  String get adminTierSaveCreate;

  /// No description provided for @adminTierSaveEdit.
  ///
  /// In en, this message translates to:
  /// **'Save tier'**
  String get adminTierSaveEdit;

  /// No description provided for @adminTierDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get adminTierDiscard;

  /// No description provided for @adminTierSystemWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'System warning'**
  String get adminTierSystemWarningTitle;

  /// No description provided for @adminTierSystemWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Changes may affect users who already purchased tickets. Review carefully before saving.'**
  String get adminTierSystemWarningBody;

  /// No description provided for @adminTierPreviewNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tier name'**
  String get adminTierPreviewNamePlaceholder;

  /// No description provided for @adminSchedulesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create schedules by day and time slot.'**
  String get adminSchedulesEmptySubtitle;

  /// No description provided for @adminSchedulesDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String adminSchedulesDaysCount(int count);

  /// No description provided for @adminSchedulesItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String adminSchedulesItemsCount(int count);

  /// No description provided for @adminScheduleDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get adminScheduleDefaultTitle;

  /// No description provided for @adminScheduleSelectDay.
  ///
  /// In en, this message translates to:
  /// **'Select a day to view the schedule.'**
  String get adminScheduleSelectDay;

  /// No description provided for @adminScheduleEmptyDayOnDate.
  ///
  /// In en, this message translates to:
  /// **'No items on {date}.'**
  String adminScheduleEmptyDayOnDate(String date);

  /// No description provided for @adminScheduleOverlapSchedule.
  ///
  /// In en, this message translates to:
  /// **' (schedule conflict)'**
  String get adminScheduleOverlapSchedule;

  /// No description provided for @adminScheduleItemTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get adminScheduleItemTitleLabel;

  /// No description provided for @adminScheduleItemDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Speaker / description (optional)'**
  String get adminScheduleItemDescriptionLabel;

  /// No description provided for @adminScheduleItemCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category (optional)'**
  String get adminScheduleItemCategoryLabel;

  /// No description provided for @adminScheduleItemCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Panel, Workshop...'**
  String get adminScheduleItemCategoryHint;

  /// No description provided for @adminScheduleItemLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location (optional)'**
  String get adminScheduleItemLocationLabel;

  /// No description provided for @adminScheduleItemLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Hall A, Main stage...'**
  String get adminScheduleItemLocationHint;

  /// No description provided for @adminScheduleStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get adminScheduleStartLabel;

  /// No description provided for @adminScheduleEndLabel.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get adminScheduleEndLabel;

  /// No description provided for @adminScheduleTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title.'**
  String get adminScheduleTitleRequired;

  /// No description provided for @adminSchedulesNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name.'**
  String get adminSchedulesNameRequired;

  /// No description provided for @adminDashboardLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load analytics'**
  String get adminDashboardLoadFailed;

  /// No description provided for @adminDashboardLoadFailedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please try again later.'**
  String get adminDashboardLoadFailedSubtitle;

  /// No description provided for @adminChartPeriod7Days.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get adminChartPeriod7Days;

  /// No description provided for @adminChartPeriod30Days.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get adminChartPeriod30Days;

  /// No description provided for @adminChartPeriod90Days.
  ///
  /// In en, this message translates to:
  /// **'90 days'**
  String get adminChartPeriod90Days;

  /// No description provided for @adminStaffReadyConnected.
  ///
  /// In en, this message translates to:
  /// **'System connected and ready to scan tickets.'**
  String get adminStaffReadyConnected;

  /// No description provided for @adminStaffConnectingHint.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment.'**
  String get adminStaffConnectingHint;

  /// No description provided for @adminStaffTrafficWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Dealer Area A is overloaded (90%). Redirect foot traffic.'**
  String get adminStaffTrafficWarningBody;

  /// No description provided for @adminQrCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan tickets. Enable it in Settings.'**
  String get adminQrCameraPermission;

  /// No description provided for @adminQrUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This device does not support QR scanning.'**
  String get adminQrUnsupported;

  /// No description provided for @adminQrCameraOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open camera.'**
  String get adminQrCameraOpenFailed;

  /// No description provided for @adminQrTicketLabel.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get adminQrTicketLabel;

  /// No description provided for @adminQrGuestLabel.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get adminQrGuestLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
