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
