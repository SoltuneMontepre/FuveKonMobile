// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get continueButton => 'Continue';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get supportLabel => 'Support';

  @override
  String get languageTitle => 'Choose language';

  @override
  String get languageSubtitle => 'Please select a language to continue';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageEnglish => 'English';

  @override
  String get themeSwitchToLight => 'Light mode';

  @override
  String get themeSwitchToDark => 'Dark mode';

  @override
  String get splashTagline => 'Where event communities and art connect';

  @override
  String get startupHydrationFailedTitle => 'Could not connect to the server';

  @override
  String get startupHydrationFailedBody =>
      'Check your internet connection or API settings, then try again.';

  @override
  String get startupRetry => 'Try again';

  @override
  String get brandTagline => 'Professional event information portal';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginEmailLabel => 'Email or phone number';

  @override
  String get loginEmailHint => 'Enter email or phone';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginOrDivider => 'OR';

  @override
  String get loginGoogle => 'Sign in with Google';

  @override
  String get authGoogleNotConfigured =>
      'Google Sign-In is not configured. Add GOOGLE_CLIENT_ID to .env and restart the app.';

  @override
  String get authGoogleUnsupportedPlatform =>
      'Google Sign-In is not supported on Linux/Windows. Run the app on Android, iOS, Web (Chrome), or macOS.';

  @override
  String get authGoogleLoginFailed =>
      'Google sign-in failed. Please try again or use email and password.';

  @override
  String get authGoogleDeveloperError =>
      'Google OAuth is misconfigured on Android. In Google Cloud Console, create an Android OAuth client for package com.example.fuvekonmobile and add your debug keystore SHA-1 (Android Studio → Gradle → signingReport).';

  @override
  String get authGoogleIdTokenMissing =>
      'Google did not return an ID token. Check GOOGLE_CLIENT_ID (Web client) in .env and the Android OAuth client in Google Cloud.';

  @override
  String get authGoogleRegistrationDetailsRequired =>
      'Please complete registration with your profile details.';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginRegisterLink => 'Register';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email or phone number to receive password reset instructions.';

  @override
  String get forgotPasswordEmailHint => 'e.g. user@example.com';

  @override
  String get forgotPasswordSubmit => 'Send password reset link';

  @override
  String get forgotPasswordBackToLogin => 'Back to sign in';

  @override
  String get forgotPasswordSuccessMessage =>
      'If an account exists, a password reset link has been sent to your email.';

  @override
  String get forgotPasswordSentHint =>
      'Please check your inbox and follow the instructions.';

  @override
  String get forgotPasswordFailureMessage =>
      'Could not send reset email. Please try again.';

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get resetPasswordSubtitle => 'Enter a new password for your account.';

  @override
  String get resetPasswordNewLabel => 'New password';

  @override
  String get resetPasswordNewHint => 'At least 8 characters';

  @override
  String get resetPasswordConfirmLabel => 'Confirm password';

  @override
  String get resetPasswordConfirmHint => 'Re-enter new password';

  @override
  String get resetPasswordSubmit => 'Reset password';

  @override
  String get resetPasswordBackToLogin => 'Back to sign in';

  @override
  String get resetPasswordSuccessMessage =>
      'Password reset successfully. You can sign in now.';

  @override
  String get resetPasswordFailureMessage =>
      'Could not reset password. The link may have expired.';

  @override
  String get resetPasswordInvalidLink =>
      'This reset link is invalid or expired. Please request a new one.';

  @override
  String get resetPasswordMinLength => 'Password must be at least 8 characters';

  @override
  String get resetPasswordMismatch => 'Passwords do not match';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Start your event management journey';

  @override
  String get registerFullNameLabel => 'Full name';

  @override
  String get registerFullNameHint => 'Enter your full name';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerEmailHint => 'example@domain.com';

  @override
  String get registerPhoneLabel => 'Phone number';

  @override
  String get registerPhoneHint => 'Enter phone number';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerPasswordHint => 'Create a password';

  @override
  String get registerConfirmPasswordLabel => 'Confirm password';

  @override
  String get registerConfirmPasswordHint => 'Re-enter password';

  @override
  String get registerTermsPrefix => 'I agree to the ';

  @override
  String get registerTermsTos => 'Terms of Service';

  @override
  String get registerTermsAnd => ' and ';

  @override
  String get registerTermsPrivacy => 'Privacy Policy';

  @override
  String get registerTermsSuffix => ' of FUVEKON.';

  @override
  String get registerSubmit => 'Create account';

  @override
  String get registerHasAccount => 'Already have an account?';

  @override
  String get registerLoginLink => 'Sign in';

  @override
  String get registerSuccessMessage =>
      'Account created. Please check your email for a verification code.';

  @override
  String get registerFailureMessage => 'Registration failed. Please try again.';

  @override
  String get validationEmailRequired => 'Please enter email or phone';

  @override
  String get validationEmailInvalid => 'Invalid email address';

  @override
  String get validationPasswordRequired => 'Please enter your password';

  @override
  String get validationPasswordMin => 'Password must be at least 6 characters';

  @override
  String get validationFullNameRequired => 'Please enter your full name';

  @override
  String get validationFullNameMin => 'Full name must be at least 2 characters';

  @override
  String get validationPhoneRequired => 'Please enter your phone number';

  @override
  String get validationPhoneInvalid => 'Invalid phone number';

  @override
  String get validationConfirmPasswordRequired =>
      'Please confirm your password';

  @override
  String get validationPasswordMismatch => 'Passwords do not match';

  @override
  String get validationTermsRequired => 'Please accept the terms to continue';

  @override
  String get introBadge => 'INTRODUCTION';

  @override
  String get introHeroLine1 => 'Discover\n';

  @override
  String get introHeroBrand => 'FUVEKON';

  @override
  String get introHeroSubtitle =>
      'The premier Anime culture festival and professional event management platform.';

  @override
  String get introWhatIsTitle => 'What is FUVEKON?';

  @override
  String get introWhatIsBody =>
      'FUVEKON is a unique intersection of Anime culture aesthetics and a professional event management platform.';

  @override
  String get introAudienceTitle => 'Who is it for?';

  @override
  String get introAudienceArtistTitle => 'Artists & Creators';

  @override
  String get introAudienceArtistBody => 'Connect and showcase your work.';

  @override
  String get introAudienceFanTitle => 'Fans';

  @override
  String get introAudienceFanBody => 'Experience a distinctive cultural space.';

  @override
  String get introAudienceOrganizerTitle => 'Event organizers';

  @override
  String get introAudienceOrganizerBody =>
      'Find collaboration opportunities and a professional management platform.';

  @override
  String get introViewRules => 'View event rules';

  @override
  String get introViewFaq => 'View FAQ';

  @override
  String get navIntroduction => 'Introduction';

  @override
  String get navArtbook => 'Conbook';

  @override
  String get navFaq => 'FAQ';

  @override
  String get navRules => 'Rules';

  @override
  String get navLogin => 'Sign in';

  @override
  String get navLogout => 'Sign out';

  @override
  String get navHome => 'Home';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navMyTickets => 'My tickets';

  @override
  String get scheduleMyItinerary => 'My itinerary';

  @override
  String get scheduleViewMap => 'Venue map';

  @override
  String get scheduleActivityDetail => 'Activity detail';

  @override
  String get scheduleEventDetail => 'Event detail';

  @override
  String get scheduleVenueDetail => 'Venue detail';

  @override
  String get scheduleDayFilter => 'Select day';

  @override
  String get scheduleActivities => 'Activities';

  @override
  String get scheduleNoActivities => 'No activities on this day';

  @override
  String get scheduleBookmark => 'Add to my itinerary';

  @override
  String get scheduleBookmarked => 'Saved to itinerary';

  @override
  String get scheduleAddedToItinerary => 'Added to your itinerary';

  @override
  String get scheduleConflictTitle => 'Schedule conflict';

  @override
  String scheduleConflictMessage(String title) {
    return 'This activity overlaps with \"$title\" in your itinerary. Replace it?';
  }

  @override
  String get scheduleConflictReplace => 'Replace';

  @override
  String get scheduleConflictCancel => 'Cancel';

  @override
  String get scheduleEmptyItinerary => 'Nothing saved yet';

  @override
  String get scheduleEmptyItineraryHint =>
      'Bookmark panels, talent shows, or workshops from the master schedule.';

  @override
  String get scheduleRemoveBookmark => 'Remove from itinerary';

  @override
  String get scheduleTime => 'Time';

  @override
  String get scheduleLocation => 'Location';

  @override
  String get scheduleSpeakers => 'Speakers';

  @override
  String get scheduleDescription => 'Description';

  @override
  String get scheduleVenues => 'Venues';

  @override
  String get scheduleLocations => 'Locations';

  @override
  String get scheduleKindPanel => 'Panel';

  @override
  String get scheduleKindTalent => 'Talent';

  @override
  String get scheduleKindWorkshop => 'Workshop';

  @override
  String get scheduleKindCeremony => 'Ceremony';

  @override
  String get scheduleKindOther => 'Other';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get navAccount => 'Account';

  @override
  String get navSwitchToAdmin => 'Admin mode';

  @override
  String get navSwitchToUser => 'User mode';

  @override
  String get myTicketsFilterActive => 'Active';

  @override
  String get myTicketsFilterUsed => 'Used';

  @override
  String get myTicketsFilterAll => 'All';

  @override
  String get myTicketsStatusActive => 'Active';

  @override
  String get myTicketsStatusUsed => 'Used';

  @override
  String get myTicketsViewTicket => 'View ticket →';

  @override
  String get myTicketsPayNow => 'Pay now →';

  @override
  String get myTicketsEventDateRange => 'Oct 20–22, 2024';

  @override
  String get myTicketsEmptyTitle => 'You don\'t have a ticket';

  @override
  String get myTicketsEmptySubtitle => 'Buy a ticket to attend the event.';

  @override
  String get myTicketsEmptyFilter => 'No tickets in this tab';

  @override
  String get myTicketsBrowse => 'Browse ticket tiers';

  @override
  String get eTicketEventLabel => 'EVENT';

  @override
  String get eTicketValid => 'Valid';

  @override
  String get eTicketOwner => 'Owner';

  @override
  String get eTicketTier => 'Tier';

  @override
  String get eTicketDay => 'Date';

  @override
  String get eTicketScanHint => 'Scan the QR code at the entrance';

  @override
  String get eTicketCodeLabel => 'Ticket code';

  @override
  String eTicketBenefitsTitle(String tier) {
    return '$tier ticket benefits';
  }

  @override
  String get eTicketUpgrade => 'Upgrade ticket';

  @override
  String get eTicketSaveWallet => 'Save to Apple/Google Wallet';

  @override
  String get eTicketWalletSoon => 'Wallet save coming soon.';

  @override
  String get ticketUpgradeTitle => 'Upgrade ticket tier';

  @override
  String get ticketUpgradeCurrentLabel => 'YOUR CURRENT TICKET';

  @override
  String get ticketUpgradeOptionsLabel => 'Upgrade options';

  @override
  String get ticketUpgradeExtraBenefits => 'ADDITIONAL BENEFITS';

  @override
  String get ticketUpgradeTotalLabel => 'TOTAL ADDITIONAL PAYMENT';

  @override
  String get ticketUpgradeContinue => 'Continue upgrade';

  @override
  String get ticketUpgradeInfoNote =>
      'Upgrading your ticket will be processed and confirmed within 24 business hours.';

  @override
  String get ticketUpgradeNoTicket => 'You don\'t have a ticket to upgrade.';

  @override
  String ticketUpgradeMaxTier(String tier) {
    return 'You are already on the highest tier ($tier).';
  }

  @override
  String get authHomeUpcomingBadge => 'Upcoming events';

  @override
  String get authHomeHeroTitle => 'Anime Culture Exchange Festival';

  @override
  String get authHomeHeroSubtitle =>
      'Discover art spaces and unique experiences.';

  @override
  String get authHomeSearchHint => 'Search events, artists...';

  @override
  String get authHomeFeaturedTitle => 'Featured events';

  @override
  String get authHomeSeeAll => 'See all';

  @override
  String get authHomeHotBadge => 'Hot';

  @override
  String get authHomeFeaturedEventTitle => 'Contemporary Art Exhibition';

  @override
  String get authHomeFeaturedEventDate => 'October 20, 2023';

  @override
  String get authHomeFeaturedEventLocation => 'SECC Center';

  @override
  String get authHomeBuyTicket => 'Buy tickets';

  @override
  String get authHomeViewDetails => 'View details';

  @override
  String get authHomeViewTickets => 'View tickets';

  @override
  String get authHomeNotificationsEmpty => 'No new notifications yet.';

  @override
  String get authHomeBentoTitle => 'Overview';

  @override
  String get authHomeMyTicketTitle => 'My tickets';

  @override
  String get authHomeMyTicketSubtitle => 'View e-ticket & QR';

  @override
  String get authHomeTodayScheduleTitle => 'Today\'s schedule';

  @override
  String get authHomeTodaySchedulePreview => 'Panel Voice Actor · 2:00 PM';

  @override
  String get authHomeBuyTicketBanner => 'Buy FUVEKON tickets';

  @override
  String get authHomeBuyTicketBannerSubtitle => 'Early bird now open';

  @override
  String get authHomeShortcutsTitle => 'Shortcuts';

  @override
  String get authHomeShortcutArtbook => 'Artbook';

  @override
  String get authHomeShortcutLostFound => 'L&F';

  @override
  String get landingBadge => 'TOP EVENT';

  @override
  String get landingHeroTitle => 'Anime Event';

  @override
  String get landingHeroBody =>
      'Experience a unique cultural space with smart ticket management and scheduling. Join now so you don\'t miss the most wonderful moments.';

  @override
  String get landingRegister => 'Register';

  @override
  String get landingViewTickets => 'View tickets';

  @override
  String get exploreTicketsTitle => 'Explore ticket types';

  @override
  String get exploreTicketsSubtitle =>
      'Choose the experience that suits you best at the exhibition.';

  @override
  String get exploreTicketsFooterInfo =>
      'You can browse ticket details first. To purchase, please register or sign in.';

  @override
  String get exploreTicketsRegisterCta => 'Register to buy tickets';

  @override
  String get exploreTicketsBuyCta => 'Buy tickets now';

  @override
  String get exploreTicketsLoginPrompt => 'Already have an account?';

  @override
  String get exploreTicketsLoginLink => 'Sign in now';

  @override
  String get exploreTicketsPopularBadge => 'Most popular';

  @override
  String get exploreTicketsSoldOut => 'Sold out';

  @override
  String get exploreTicketsEmpty => 'No ticket tiers are available yet.';

  @override
  String get exploreTicketsRetry => 'Retry';

  @override
  String get ticketDetailBenefitsTitle => 'Included benefits';

  @override
  String ticketDetailCompareTitle(String standardTier) {
    return 'Compare with $standardTier';
  }

  @override
  String get ticketDetailTotal => 'Total';

  @override
  String get ticketDetailCompareAccess => 'Access';

  @override
  String get ticketDetailCompareCheckIn => 'Check-in';

  @override
  String get ticketDetailComparePriority => 'Priority';

  @override
  String get ticketDetailCompareShared => 'Shared';

  @override
  String get ticketDetailCompareBadge => 'Badge';

  @override
  String get ticketDetailCompareCustom => 'Custom';

  @override
  String get ticketDetailCompareNormal => 'Standard';

  @override
  String get ticketDetailCompareGifts => 'Extra gifts';

  @override
  String get landingExperienceTitle => 'Perfect Experience';

  @override
  String get landingExperienceBody =>
      'Manage your journey at the event with ease.';

  @override
  String get rulesTitle => 'Event rules';

  @override
  String get rulesIntro =>
      'Please read the following rules carefully to ensure a safe, professional, and memorable convention for everyone.';

  @override
  String get rulesAttendanceTitle => 'Attendance rules';

  @override
  String get rulesAttendance1 => 'Present a valid ticket at the entrance.';

  @override
  String get rulesAttendance2 => 'No weapons or flammable materials.';

  @override
  String get rulesAttendance3 => 'Respect shared spaces.';

  @override
  String get rulesCosplayTitle => 'Cosplay guidelines';

  @override
  String get rulesCosplay1 => 'Costumes must be appropriate and respectful.';

  @override
  String get rulesCosplay2 => 'Props must not be sharp or dangerous.';

  @override
  String get rulesCosplay3 => 'Use designated changing areas only.';

  @override
  String get rulesBoothTitle => 'Vendor booth rules';

  @override
  String get rulesBooth1 => 'Sell only registered product categories.';

  @override
  String get rulesBooth2 => 'Do not block walkways.';

  @override
  String get rulesBooth3 => 'Keep your booth area clean.';

  @override
  String get rulesConductTitle => 'Code of conduct';

  @override
  String get rulesConduct1 => 'Harassment of any kind is strictly prohibited.';

  @override
  String get rulesConduct2 => 'No littering.';

  @override
  String get rulesConduct3 => 'Follow staff instructions.';

  @override
  String get rulesAgreeCheckbox =>
      'I have read, understood, and agree to the rules above.';

  @override
  String get rulesConfirmButton => 'Confirm agreement';

  @override
  String get faqPageTitle => 'Frequently asked questions';

  @override
  String get faqPageSubtitle => 'Quickly find answers to your questions.';

  @override
  String get faqSearchHint => 'What are you looking for?';

  @override
  String get faqNoResults => 'No matching results found.';

  @override
  String get faqNeedHelp => 'Need more help? ';

  @override
  String get faqContactUs => 'Contact us →';

  @override
  String get faqCatTickets => 'Tickets';

  @override
  String get faqTicketsQ1 => 'Where can I buy tickets?';

  @override
  String get faqTicketsA1 =>
      'Go to Tickets in the FUVEKON app, choose a tier, and complete payment as instructed. Each account can only hold one active ticket at a time.';

  @override
  String get faqTicketsQ2 => 'What ticket tiers are available?';

  @override
  String get faqTicketsA2 =>
      'The organizing committee publishes tiers (Standard, VIP, etc.) with corresponding benefits in the app. Price and quantity may change each sales wave.';

  @override
  String get faqTicketsQ3 => 'How do I pay for tickets?';

  @override
  String get faqTicketsA3 =>
      'After booking, transfer via bank QR or PayPal as instructed, then tap \"I have paid\". The committee will verify and approve your ticket as soon as possible.';

  @override
  String get faqTicketsQ4 => 'Are e-tickets valid?';

  @override
  String get faqTicketsA4 =>
      'Yes. Once approved, your check-in QR and digital badge are sent by email and shown in the app. Present the QR at the gate.';

  @override
  String get faqTicketsQ5 => 'Can I upgrade my ticket?';

  @override
  String get faqTicketsA5 =>
      'Yes. Approved ticket holders can upgrade by paying the difference. Upgrades also require payment verification before taking effect.';

  @override
  String get faqTicketsQ6 => 'Can I get a refund?';

  @override
  String get faqTicketsA6 =>
      'Purchased tickets are non-refundable unless the committee announces otherwise (e.g. event cancellation or major changes).';

  @override
  String get faqCatRegister => 'Registration';

  @override
  String get faqRegisterQ1 => 'How do I create an account?';

  @override
  String get faqRegisterA1 =>
      'Choose Register on the sign-in screen, enter email and password, then verify the OTP sent to your email to activate your account.';

  @override
  String get faqRegisterQ2 => 'Can I sign in with Google?';

  @override
  String get faqRegisterA2 =>
      'Yes. FUVEKON supports quick sign-in with Google. First-time sign-in may require completing your profile.';

  @override
  String get faqRegisterQ3 => 'Why do I need to verify email?';

  @override
  String get faqRegisterA3 =>
      'Email verification protects your account and unlocks profile editing, ticket purchase, and panel/talent/dealer registration after verification.';

  @override
  String get faqRegisterQ4 => 'What if I forgot my password?';

  @override
  String get faqRegisterA4 =>
      'Choose Forgot password on the sign-in screen, enter your registered email, and follow the link/OTP to set a new password.';

  @override
  String get faqRegisterQ5 => 'I didn\'t receive the OTP code?';

  @override
  String get faqRegisterA5 =>
      'Check your spam folder. If still missing, use Resend OTP in the app or contact contact@fuvekon.vn.';

  @override
  String get faqCatDealer => 'Dealer';

  @override
  String get faqDealerQ1 => 'How do I register a booth?';

  @override
  String get faqDealerA1 =>
      'Go to Dealer in the app, read booth rules, fill out the form, and upload up to 5 price sheets. Your application will be reviewed.';

  @override
  String get faqDealerQ2 => 'What are the requirements to become a Dealer?';

  @override
  String get faqDealerA2 =>
      'You need a verified email account and must comply with product and copyright rules. See Dealer in the app for details.';

  @override
  String get faqDealerQ3 => 'How much does a booth cost?';

  @override
  String get faqDealerA3 =>
      'Fees depend on booth type, size, and location. The committee sends cost details after approving your application.';

  @override
  String get faqDealerQ4 => 'How do I add booth staff?';

  @override
  String get faqDealerA4 =>
      'The booth owner creates an invite code in the app. Staff enter it under Join booth to be added.';

  @override
  String get faqDealerQ5 => 'How long until I know the result?';

  @override
  String get faqDealerA5 =>
      'Review usually takes 3–7 business days. You\'ll be notified by email and in the app when approved or rejected.';

  @override
  String get faqCatTalent => 'Talent Show';

  @override
  String get faqTalentQ1 => 'Who can apply to perform?';

  @override
  String get faqTalentA1 =>
      'Artists, cosplayers, singers, dancers, and creators can submit via Talent in the app.';

  @override
  String get faqTalentQ2 => 'Do I need an event ticket?';

  @override
  String get faqTalentA2 =>
      'Yes. You need an approved ticket and a verified email account before submitting a talent application.';

  @override
  String get faqTalentQ3 => 'What does a talent application need?';

  @override
  String get faqTalentA3 =>
      'Self-introduction, planned performance description, reference photos/videos, and contact info. The full form is in the app.';

  @override
  String get faqTalentQ4 => 'What is the application deadline?';

  @override
  String get faqTalentA4 =>
      'Deadlines are announced on the app, website, and official fanpage. Apply early so the committee can schedule performances.';

  @override
  String get faqCatPanel => 'Panel';

  @override
  String get faqPanelQ1 => 'What is a panel?';

  @override
  String get faqPanelA1 =>
      'A panel is a themed discussion or Q&A session with guests, speakers, and fans at the event.';

  @override
  String get faqPanelQ2 => 'How do I register a panel?';

  @override
  String get faqPanelA2 =>
      'Go to Panel, submit your topic proposal, speaker info, and planned content. The committee will review and schedule if suitable.';

  @override
  String get faqPanelQ3 => 'Do I need a ticket to register a panel?';

  @override
  String get faqPanelA3 =>
      'Yes. Applicants need an approved active ticket and verified email, similar to talent registration.';

  @override
  String get faqPanelQ4 => 'When is the panel schedule published?';

  @override
  String get faqPanelA4 =>
      'The official schedule is posted under Schedule after applications are reviewed. You can bookmark items for reminders.';

  @override
  String get faqCatSchedule => 'Schedule';

  @override
  String get faqScheduleQ1 => 'Where can I view the schedule?';

  @override
  String get faqScheduleA1 =>
      'Schedule in the app shows all activities by day, time slot, and stage/area.';

  @override
  String get faqScheduleQ2 => 'Can the schedule change?';

  @override
  String get faqScheduleA2 =>
      'The committee may adjust the schedule for operational reasons. Updates appear in the app and notifications if you bookmarked an item.';

  @override
  String get faqScheduleQ3 => 'What is My Schedule?';

  @override
  String get faqScheduleA3 =>
      'Bookmark panels, talent shows, or workshops to view on your personal timeline and get reminders 10–15 minutes ahead.';

  @override
  String get faqScheduleQ4 => 'How many days is the event?';

  @override
  String get faqScheduleA4 =>
      'Official dates and venue are announced on the event page and Introduction in the app.';

  @override
  String get faqCatLostFound => 'Lost & Found';

  @override
  String get faqLostFoundQ1 => 'I lost something at the event?';

  @override
  String get faqLostFoundA1 =>
      'Visit the Lost & Found desk at the venue or report a loss in the app (description, photo, time, and approximate location).';

  @override
  String get faqLostFoundQ2 => 'Where can I see found items?';

  @override
  String get faqLostFoundA2 =>
      'The public Lost & Found board in the app lists recorded items (sensitive identifying details are hidden to prevent fraud).';

  @override
  String get faqLostFoundQ3 => 'How do I claim a lost item?';

  @override
  String get faqLostFoundA3 =>
      'Bring ID to the support desk, describe the item and when it was lost. Staff will verify and return it if it matches.';

  @override
  String get faqLostFoundQ4 => 'How long until a lost item is processed?';

  @override
  String get faqLostFoundA4 =>
      'Staff update status (Lost / Found / Claimed) in the system. Track progress in the app or contact the desk.';

  @override
  String get artbookTitle => 'FUVEKON Conbook';

  @override
  String get artbookSubtitle => 'Artistic Journey — 2024';

  @override
  String get artbookDescription =>
      'A collection of over 50 artworks from the FUVEKON creative community, printed on premium art paper.';

  @override
  String get artbookPageCount => '120 Pages';

  @override
  String get artbookPaperType => '150gsm Couche paper';

  @override
  String get artbookSubmitCta => 'Submit artwork for Conbook';

  @override
  String get artbookSubmitBack => 'GO BACK';

  @override
  String get artbookSubmitTitle => 'Submit Conbook';

  @override
  String get artbookSubmitIntro =>
      'A place to celebrate outstanding works. Send your masterpiece for the organizing committee to review for the FUVEKON Conbook.';

  @override
  String get artbookFormSectionTitle => 'Artwork information';

  @override
  String get artbookFieldTitle => 'Artwork title';

  @override
  String get artbookFieldTitleHint => 'e.g. Autumn daydream';

  @override
  String get artbookFieldAuthor => 'Author / Pen name';

  @override
  String get artbookFieldAuthorHint => 'Enter your pen name';

  @override
  String get artbookFieldGenre => 'Genre';

  @override
  String get artbookFieldGenreHint => 'Select a genre';

  @override
  String get artbookFieldDescription => 'Idea description (optional)';

  @override
  String get artbookFieldDescriptionHint =>
      'Share the story behind your artwork...';

  @override
  String get artbookFieldPortfolio => 'Portfolio link';

  @override
  String get artbookFieldPortfolioHint => 'https://';

  @override
  String get artbookFieldPreview => 'Artwork preview';

  @override
  String get artbookFieldRequired => 'This field is required';

  @override
  String get artbookUploadLabel => 'Drag and drop or click to upload';

  @override
  String get artbookUploadHint => 'Supports JPG, PNG, PDF. Max 20MB.';

  @override
  String get artbookPreviewRequired => 'Please upload an artwork preview';

  @override
  String get artbookSubmitButton => 'Submit artwork for Conbook';

  @override
  String get artbookRulesTitle => 'Submission rules';

  @override
  String get artbookRuleSizeTitle => 'SIZE';

  @override
  String get artbookRuleSizeBody =>
      'A4 (210 x 297mm) with a 5mm safety margin.';

  @override
  String get artbookRuleFormatTitle => 'FORMAT';

  @override
  String get artbookRuleFormatBody => 'CMYK color mode, minimum 300dpi.';

  @override
  String get artbookRuleCopyrightTitle => 'COPYRIGHT';

  @override
  String get artbookRuleCopyrightBody =>
      'Must be original work that has never been commercially published.';

  @override
  String get artbookDeadline => 'Submission deadline: November 20, 2023';

  @override
  String get artbookLoginRequired =>
      'Please sign in to submit your Conbook artwork';

  @override
  String get artbookSubmitSuccess => 'Artwork submitted successfully!';

  @override
  String get artbookSubmitFailed =>
      'Could not submit artwork. Please try again.';

  @override
  String get artbookGenreIllustration => 'Illustration';

  @override
  String get artbookGenreComic => 'Comic';

  @override
  String get artbookGenrePhoto => 'Photography';

  @override
  String get artbookGenreDigital => 'Digital art';

  @override
  String get artbookGenreOther => 'Other';

  @override
  String get adminCancel => 'Cancel';

  @override
  String get adminSave => 'Save';

  @override
  String get adminSaveChanges => 'Save changes';

  @override
  String get adminDelete => 'Delete';

  @override
  String get adminEdit => 'Edit';

  @override
  String get adminRetry => 'Retry';

  @override
  String get adminConfirm => 'Confirm';

  @override
  String get adminBack => 'Go back';

  @override
  String get adminCancelAction => 'Cancel';

  @override
  String get adminAdd => 'Add';

  @override
  String get adminCreate => 'Create';

  @override
  String get adminViewAll => 'View all';

  @override
  String get adminUpdateSuccess => 'Updated successfully.';

  @override
  String adminErrorWithDetail(String detail) {
    return 'Error: $detail';
  }

  @override
  String get adminCannotUndo => 'This action cannot be undone.';

  @override
  String get adminYes => 'Yes';

  @override
  String get adminNo => 'No';

  @override
  String get adminAll => 'All';

  @override
  String get adminNone => 'None';

  @override
  String get adminFieldStatus => 'Status';

  @override
  String get adminFieldDescription => 'Description';

  @override
  String get adminFieldTitle => 'Title';

  @override
  String get adminStatusPending => 'Pending';

  @override
  String get adminStatusApproved => 'Approved';

  @override
  String get adminStatusRequireChanges => 'Needs changes';

  @override
  String get adminStatusDenied => 'Denied';

  @override
  String get adminApprove => 'Approve';

  @override
  String get adminRequireChanges => 'Request changes';

  @override
  String get adminDeny => 'Deny';

  @override
  String get adminMarkPending => 'Mark pending again';

  @override
  String get adminMarkPendingReturn => 'Return to pending';

  @override
  String get adminDenyReason => 'Denial reason';

  @override
  String get adminDenyReasonHint => 'Enter denial reason...';

  @override
  String get adminEmptyList => 'No items';

  @override
  String adminEmptyTabList(String tab) {
    return 'The $tab list is empty.';
  }

  @override
  String get adminNavHome => 'Home';

  @override
  String get adminNavStats => 'Analytics';

  @override
  String get adminNavScan => 'Scan';

  @override
  String get adminNavHistory => 'History';

  @override
  String get adminNavLostFound => 'Lost & Found';

  @override
  String get adminNavSystem => 'System';

  @override
  String get adminBrandTitle => 'FUVEKON Admin';

  @override
  String get adminFieldEmail => 'Email';

  @override
  String get adminFieldFursona => 'Fursona';

  @override
  String get adminFieldFirstName => 'First name';

  @override
  String get adminFieldLastName => 'Last name';

  @override
  String get adminFieldCountry => 'Country';

  @override
  String get adminFieldIdCard => 'ID card';

  @override
  String get adminFieldDisplayName => 'Display name';

  @override
  String get adminFieldRole => 'Role';

  @override
  String get adminFieldVerified => 'Verified';

  @override
  String get adminFieldVerifiedYes => 'Verified';

  @override
  String get adminFieldVerifiedNo => 'Not verified';

  @override
  String get adminFieldHasTicket => 'Has ticket';

  @override
  String get adminFieldAvatar => 'Avatar';

  @override
  String get adminFieldCreatedAt => 'Created';

  @override
  String get adminFieldLastUpdated => 'Last updated';

  @override
  String get adminFieldDateOfBirth => 'Date of birth';

  @override
  String get adminFieldPermissions => 'Permissions';

  @override
  String get adminFieldDealer => 'Dealer';

  @override
  String get adminFieldAccount => 'Account';

  @override
  String get adminFieldUser => 'User';

  @override
  String get adminFieldBoothName => 'Booth name';

  @override
  String get adminFieldBoothCode => 'Booth code';

  @override
  String get adminFieldPriceSheet => 'Price sheet';

  @override
  String adminFieldPriceSheetN(int n) {
    return 'Price sheet $n';
  }

  @override
  String get adminFieldRegisteredAt => 'Registered';

  @override
  String get adminFieldNickname => 'Nickname';

  @override
  String get adminFieldGenre => 'Genre';

  @override
  String get adminFieldParticipantCount => 'Participants';

  @override
  String get adminFieldDuration => 'Duration';

  @override
  String get adminFieldTimeSlot => 'Time slot';

  @override
  String get adminFieldIntroduction => 'Introduction';

  @override
  String get adminFieldSubmittedAt => 'Submitted';

  @override
  String get adminFieldHandle => 'Handle';

  @override
  String get adminFieldConbookImage => 'Conbook image';

  @override
  String get adminFieldTicketCode => 'Ticket code';

  @override
  String get adminFieldTicketNumber => 'Ticket number';

  @override
  String get adminFieldTier => 'Ticket tier';

  @override
  String get adminFieldTierCode => 'Tier code';

  @override
  String get adminFieldBadgeName => 'Badge name';

  @override
  String get adminFieldFursuiter => 'Fursuiter';

  @override
  String get adminFieldFursuitStaff => 'Fursuit staff';

  @override
  String get adminFieldTshirtSize => 'T-shirt size';

  @override
  String get adminFieldCheckIn => 'Check-in';

  @override
  String get adminFieldBadgeImage => 'Badge image';

  @override
  String get adminFieldNamecard => 'Namecard';

  @override
  String get adminFieldApprovedAt => 'Approved at';

  @override
  String get adminFieldDeniedAt => 'Denied at';

  @override
  String get adminFieldItemCode => 'Item code';

  @override
  String get adminFieldType => 'Type';

  @override
  String get adminFieldLocation => 'Location';

  @override
  String get adminFieldContact => 'Contact';

  @override
  String get adminFieldImage => 'Image';

  @override
  String get adminFieldStaffNotes => 'Staff notes';

  @override
  String get adminFieldRecipient => 'Recipient';

  @override
  String get adminFieldRecipientIdCard => 'Recipient ID';

  @override
  String get adminFieldRecipientPhone => 'Recipient phone';

  @override
  String get adminFieldReturnedAt => 'Returned at';

  @override
  String get adminFieldUpdatedAt => 'Updated';

  @override
  String get adminRoleAdminLabel => 'Administrator';

  @override
  String get adminRoleDealerLabel => 'Dealer';

  @override
  String get adminRoleStaffLabel => 'Staff';

  @override
  String get adminRoleUserLabel => 'User';

  @override
  String get adminRoleCodeAdmin => 'Admin';

  @override
  String get adminRoleCodeDealer => 'Dealer';

  @override
  String get adminRoleCodeStaff => 'Staff';

  @override
  String get adminRoleCodeAttendee => 'Attendee';

  @override
  String get adminRoleExhibitor => 'Exhibitor';

  @override
  String get adminRoleStaffSupport => 'Support staff';

  @override
  String get adminRoleAttendee => 'Attendee';

  @override
  String get adminPermissionManageTickets => 'Manage tickets';

  @override
  String get adminPermissionScanTickets => 'Scan tickets';

  @override
  String get adminPermissionApproveProfiles => 'Approve profiles';

  @override
  String get adminPermissionSendNotifications => 'Send notifications';

  @override
  String get adminPermissionViewDashboard => 'View dashboard';

  @override
  String get adminPermissionManageUsers => 'Manage users';

  @override
  String get adminUserActive => 'Active';

  @override
  String get adminUserBlacklisted => 'Blacklisted';

  @override
  String get adminUserBannedFromTickets => 'Banned from buying tickets';

  @override
  String get adminBanReason => 'Ban reason';

  @override
  String get adminBanDate => 'Ban date';

  @override
  String get adminDenialCount => 'Ticket denial count';

  @override
  String get adminAccountDeleted => 'Deleted';

  @override
  String get adminTicketStatusPending => 'Awaiting payment';

  @override
  String get adminTicketStatusAwaitingApproval => 'Awaiting approval';

  @override
  String get adminTicketStatusApproved => 'Approved';

  @override
  String get adminTicketStatusDenied => 'Denied';

  @override
  String get adminTicketStatusAdminGranted => 'Granted by admin';

  @override
  String get adminCheckedIn => 'Checked in';

  @override
  String get adminNotCheckedIn => 'Not checked in';

  @override
  String get adminLostFoundTypeLost => 'Lost';

  @override
  String get adminLostFoundTypeFound => 'Found';

  @override
  String get adminLostFoundStatusClaimed => 'Claimed';

  @override
  String get adminLostFoundStatusResolved => 'Resolved';

  @override
  String get adminLostFoundStatusOpen => 'Open';

  @override
  String adminDealerBoothCode(String code) {
    return 'Booth code: $code';
  }

  @override
  String adminDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get adminErrorLoadUsers => 'Could not load users.';

  @override
  String get adminErrorLoadBlacklistedUsers =>
      'Could not load blacklisted users.';

  @override
  String get adminErrorLoadDealers => 'Could not load dealers.';

  @override
  String get adminErrorLoadDealer => 'Could not load dealer details.';

  @override
  String get adminErrorLoadPanels => 'Could not load panels.';

  @override
  String get adminErrorLoadConbook => 'Could not load conbook submissions.';

  @override
  String get adminErrorLoadSchedules => 'Could not load schedules.';

  @override
  String get adminErrorLoadSchedule => 'Could not load schedule.';

  @override
  String get adminErrorLoadTickets => 'Could not load tickets.';

  @override
  String get adminErrorLoadTiers => 'Could not load ticket tiers.';

  @override
  String get adminErrorLoadTicket => 'Could not load ticket details.';

  @override
  String get adminErrorLoadTicketStats => 'Could not load ticket statistics.';

  @override
  String get adminErrorLoadLostFound => 'Could not load lost & found items.';

  @override
  String get adminErrorUpdateEventSettings =>
      'Could not update event settings.';

  @override
  String get adminScanInvalidCode => 'Invalid ticket code.';

  @override
  String get adminScanNotApproved => 'Ticket is not approved or was denied.';

  @override
  String get adminScanAlreadyCheckedIn => 'Ticket was already checked in.';

  @override
  String get adminScanConfirmBeforeCheckIn =>
      'Confirm ticket details before check-in.';

  @override
  String get adminScanCheckInSuccess => 'Check-in successful.';

  @override
  String get adminUserDetailTitle => 'User details';

  @override
  String get adminDeleteUserTitle => 'Delete user?';

  @override
  String get adminDeleteUserBody =>
      'The account will be soft-deleted and cannot sign in again.';

  @override
  String get adminBanTicketsTitle => 'Ban from buying tickets';

  @override
  String get adminBanReasonLabel => 'Ban reason';

  @override
  String get adminBanReasonHint => 'Enter reason for banning this user...';

  @override
  String get adminBanAction => 'Ban';

  @override
  String get adminBanReasonRequired => 'Please enter a ban reason.';

  @override
  String get adminQuickActions => 'Quick actions';

  @override
  String get adminRecentHistory => 'Recent history';

  @override
  String get adminDetailInfo => 'Detailed information';

  @override
  String get adminDetailInfoSubtitle =>
      'Profile, permissions, and account status';

  @override
  String get adminVerify => 'Verify';

  @override
  String get adminPermissions => 'Permissions';

  @override
  String get adminUnban => 'Remove ban';

  @override
  String get adminBanTickets => 'Ban from buying tickets';

  @override
  String get adminDeleteUser => 'Delete user';

  @override
  String get adminTimelineBanned => 'Banned from buying tickets';

  @override
  String get adminTimelineHasTicket => 'Has event ticket';

  @override
  String get adminTimelineVerified => 'Verified';

  @override
  String get adminTimelineCreated => 'Account created';

  @override
  String get adminTagBanned => 'BANNED';

  @override
  String get adminTagVerified => 'VERIFIED';

  @override
  String get adminTagNew => 'NEW';

  @override
  String get adminUsersTitle => 'User management';

  @override
  String get adminUsersTabBlacklisted => 'Blacklisted';

  @override
  String get adminUsersSearchHint => 'Search email, name, fursona...';

  @override
  String get adminUsersEmpty => 'No users';

  @override
  String get adminUsersEmptyBlacklisted => 'No blacklisted users.';

  @override
  String get adminUsersEmptySearch => 'No users match your search.';

  @override
  String get adminTicketsTitle => 'Ticket management';

  @override
  String get adminTicketsTabTiers => 'Tiers';

  @override
  String get adminTicketsTabList => 'Ticket list';

  @override
  String get adminTicketsNewTier => 'New tier';

  @override
  String get adminTicketsCreateTier => 'Create tier';

  @override
  String get adminTicketsPendingOver24h => 'Pending > 24 hours';

  @override
  String get adminTicketsSearchHint => 'Search code, email, name...';

  @override
  String get adminTicketsDisableSales => 'Disable sales';

  @override
  String get adminTicketsEnableSales => 'Enable sales';

  @override
  String get adminTicketsHideStore => 'Hide from store';

  @override
  String get adminTicketsShowStore => 'Show on store';

  @override
  String get adminTicketsDeleteTier => 'Delete tier';

  @override
  String get adminTicketsStock => 'Stock';

  @override
  String get adminTicketsBenefits => 'Benefits';

  @override
  String get adminTicketsSelling => 'Selling';

  @override
  String get adminTicketsSalesOff => 'Sales off';

  @override
  String get adminTicketsStoreVisible => 'Visible';

  @override
  String get adminTicketsStoreHidden => 'Hidden';

  @override
  String get adminTicketsDeleteTierTitle => 'Delete tier?';

  @override
  String get adminTicketsDeleteTierBody =>
      'This permanently deletes the tier and cannot be undone.';

  @override
  String get adminTicketsEmpty => 'No tickets';

  @override
  String get adminTicketsEmptyTiers => 'No ticket tiers yet.';

  @override
  String get adminTierEditCreate => 'Create ticket tier';

  @override
  String get adminTierEditEdit => 'Edit ticket tier';

  @override
  String get adminTierNameLabel => 'Tier name';

  @override
  String get adminTierPriceLabel => 'Price (VND)';

  @override
  String get adminTierStockLabel => 'Quantity';

  @override
  String get adminTierDescriptionLabel => 'Tier description';

  @override
  String get adminTierBenefitsList => 'Benefits list';

  @override
  String get adminTierAddBenefit => 'Add benefit';

  @override
  String get adminTierSalesStatus => 'Sales status';

  @override
  String get adminTierPreview => 'Display preview';

  @override
  String get adminTierCreated => 'Tier created.';

  @override
  String get adminTierUpdated => 'Tier updated.';

  @override
  String get adminSchedulesTitle => 'Schedule management';

  @override
  String get adminSchedulesCreate => 'Create schedule';

  @override
  String get adminSchedulesEmpty => 'No schedules yet';

  @override
  String get adminSchedulesEdit => 'Edit schedule';

  @override
  String get adminSchedulesCreateNew => 'Create new schedule';

  @override
  String get adminSchedulesNameLabel => 'Schedule name';

  @override
  String get adminScheduleEndAfterStart => 'End time must be after start time.';

  @override
  String get adminScheduleDeleteTitle => 'Delete schedule?';

  @override
  String get adminScheduleDeleteBody =>
      'All items in this schedule will be deleted.';

  @override
  String get adminScheduleDeleteItemTitle => 'Delete schedule item?';

  @override
  String adminScheduleDeleteItemBody(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get adminScheduleEditMenu => 'Edit schedule';

  @override
  String get adminScheduleDeleteMenu => 'Delete schedule';

  @override
  String get adminScheduleNoItems => 'No schedule items yet';

  @override
  String get adminScheduleEditItem => 'Edit item';

  @override
  String get adminScheduleAddItem => 'Add schedule item';

  @override
  String get adminScheduleOverlapBadge => 'Location overlap';

  @override
  String get adminDashboardTitle => 'Event overview';

  @override
  String get adminDashboardSubtitle => 'Last 90 days';

  @override
  String get adminDashboardTickets => 'Tickets';

  @override
  String get adminDashboardByTier => 'By tier';

  @override
  String get adminDashboardRevenue => 'Revenue';

  @override
  String get adminDashboardUsers => 'Users';

  @override
  String get adminDashboardDealers => 'Dealers';

  @override
  String get adminDashboardTotalTickets => 'Total tickets';

  @override
  String get adminDashboardApproved => 'Approved';

  @override
  String get adminDashboardPending => 'Pending';

  @override
  String get adminDashboardDenied => 'Denied';

  @override
  String adminDashboardSold(int sold, int total) {
    return 'Sold $sold / $total';
  }

  @override
  String adminDashboardRemaining(int count) {
    return '$count left';
  }

  @override
  String get adminDashboardUsersByCountry => 'Users by country';

  @override
  String get adminDashboardUnknownCountry => 'Unknown';

  @override
  String get adminDashboardUsersByCountryEmpty => 'No country data yet';

  @override
  String adminDashboardUsersByCountryMore(int count) {
    return '+$count more countries';
  }

  @override
  String get adminConbookTitle => 'Review Conbook';

  @override
  String get adminConbookApprove => 'Approve conbook';

  @override
  String get adminConbookDeny => 'Deny conbook';

  @override
  String get adminPanelsTitle => 'Panel management';

  @override
  String get adminPanelsApprove => 'Approve panel';

  @override
  String get adminPanelsDeny => 'Deny panel';

  @override
  String get adminDealersTitle => 'Dealer management';

  @override
  String get adminDealersApprove => 'Approve booth';

  @override
  String get adminDealersDeny => 'Deny registration';

  @override
  String get adminDealerDetailTitle => 'Booth details';

  @override
  String get adminDealerInfo => 'Booth information';

  @override
  String get adminDealerPriceSheets => 'Price sheets';

  @override
  String get adminDealerStaff => 'Booth staff';

  @override
  String get adminDealerNoStaff => 'No staff members yet.';

  @override
  String get adminDealerActions => 'Actions';

  @override
  String get adminDealerOwner => 'Booth owner';

  @override
  String get adminDealerJoined => 'Joined:';

  @override
  String get adminLostFoundTitle => 'Lost & Found management';

  @override
  String get adminLostFoundSearchHint => 'Search title, code, location...';

  @override
  String get adminLostFoundEmpty => 'No items';

  @override
  String get adminLostFoundDetailTitle => 'Item details';

  @override
  String get adminLostFoundRecipientClaimed => 'Recipient (claimed)';

  @override
  String get adminLostFoundNoClaim => 'No active claim for this item.';

  @override
  String get adminLostFoundConfirmReturn => 'Confirm return';

  @override
  String get adminLostFoundMarkResolved => 'Mark as resolved';

  @override
  String get adminLostFoundDeleteTitle => 'Delete item?';

  @override
  String get adminLostFoundReturnTitle => 'Confirm return';

  @override
  String get adminLostFoundReturnSuccess => 'Return confirmed successfully.';

  @override
  String get adminLostFoundVerifyDescription => 'Description matches item';

  @override
  String get adminLostFoundVerifyOwnership => 'Ownership evidence provided';

  @override
  String get adminLostFoundVerifyIdentity => 'Identity verified';

  @override
  String get adminLostFoundAuditNote =>
      'This action will be logged in the system audit log.';

  @override
  String get adminScanHistoryTitle => 'Scan history';

  @override
  String get adminScanHistoryEmpty => 'No scans recorded yet.';

  @override
  String get adminScanOutcomeValid => 'Valid';

  @override
  String get adminScanOutcomeReused => 'Reused';

  @override
  String get adminScanOutcomeRejected => 'Rejected';

  @override
  String get adminUserEditPermissions => 'Permissions';

  @override
  String get adminUserEditTitle => 'Edit user';

  @override
  String get adminUserEditPersonalInfo => 'Personal information';

  @override
  String get adminUserEditAccountStatus => 'Account status';

  @override
  String get adminUserEditRoles => 'Roles';

  @override
  String get adminUserEditPermissionGroup => 'Permission group';

  @override
  String get adminUserEditVerified => 'Verified';

  @override
  String get adminUserEditVerifiedSubtitle => 'Email has been verified';

  @override
  String get adminUserEditAdminNote => 'Administrators have all permissions.';

  @override
  String get adminUserTicketsTitle => 'User tickets';

  @override
  String get adminUserTicketsSubtitle =>
      'Grant, approve, edit, or delete tickets';

  @override
  String get adminUserTicketsNoTiers => 'No ticket tiers available to grant.';

  @override
  String get adminUserTicketsGrant => 'Grant ticket';

  @override
  String get adminUserTicketsGrantSuccess => 'Ticket granted to user.';

  @override
  String get adminUserTicketsDeleteTitle => 'Delete ticket?';

  @override
  String adminUserTicketsDeleteBody(String code) {
    return 'Delete ticket $code? This cannot be undone.';
  }

  @override
  String get adminUserTicketsDeleted => 'Ticket deleted.';

  @override
  String get adminUserTicketsApprove => 'Approve ticket';

  @override
  String get adminUserTicketsApproveSuccess => 'Ticket approved.';

  @override
  String get adminUserTicketsDeny => 'Deny ticket';

  @override
  String get adminUserTicketsDenySuccess => 'Ticket denied.';

  @override
  String get adminUserTicketsResendQr => 'Resend QR email';

  @override
  String get adminUserTicketsResendQrSuccess => 'QR email resent.';

  @override
  String get adminUserTicketsEdit => 'Edit ticket';

  @override
  String get adminUserTicketsDelete => 'Delete ticket';

  @override
  String get adminUserTicketsEmpty => 'User has no tickets.';

  @override
  String get adminUserTicketsGrantDialog => 'Grant ticket';

  @override
  String get adminUserTicketsTierLabel => 'Ticket tier';

  @override
  String get adminUserTicketsEditTitle => 'Edit ticket';

  @override
  String get adminUserTicketsNotSelected => 'Not selected';

  @override
  String get adminSectionOnSite => 'On-site operations';

  @override
  String get adminSectionOnSiteSubtitle =>
      'Check-in, scan history, and lost & found.';

  @override
  String get adminSectionEvent => 'Event management';

  @override
  String get adminSectionEventSubtitle =>
      'Tickets, configuration, and event operations.';

  @override
  String get adminSectionContent => 'Content review';

  @override
  String get adminSectionContentSubtitle =>
      'Conbook, panels, and dealer booths.';

  @override
  String get adminSectionUsersReports => 'Users & reports';

  @override
  String get adminSectionUsersReportsSubtitle =>
      'Accounts and ticket sales data.';

  @override
  String get adminSectionOther => 'Other';

  @override
  String get adminSectionOtherSubtitle =>
      'Schedules, notifications, and system.';

  @override
  String get adminMenuScanTicket => 'Scan ticket';

  @override
  String get adminMenuScanHistory => 'Scan history';

  @override
  String get adminMenuLostFound => 'Lost & Found';

  @override
  String get adminMenuTickets => 'Ticket management';

  @override
  String get adminMenuConbook => 'Review Conbook';

  @override
  String get adminMenuPanels => 'Panel management';

  @override
  String get adminMenuDealers => 'Dealer management';

  @override
  String get adminMenuUsers => 'Users';

  @override
  String get adminMenuStats => 'Analytics';

  @override
  String get adminMenuNotifications => 'Notifications';

  @override
  String get adminNotificationCreateTitle => 'Send notification';

  @override
  String get adminNotificationCreateSubtitle =>
      'Create an in-app notification for a user. Optionally send push and email.';

  @override
  String get adminNotificationRecipientLabel => 'Recipient';

  @override
  String get adminNotificationSearchUserHint => 'Search by name or email';

  @override
  String get adminNotificationSelectUserRequired => 'Select a recipient user.';

  @override
  String get adminNotificationTitleLabel => 'Title';

  @override
  String get adminNotificationTitleRequired => 'Title is required.';

  @override
  String get adminNotificationBodyLabel => 'Message';

  @override
  String get adminNotificationKindLabel => 'Kind (optional)';

  @override
  String get adminNotificationKindHint => 'e.g. announcement';

  @override
  String get adminNotificationSendPush => 'Send push notification';

  @override
  String get adminNotificationSendPushHint =>
      'Deliver via FCM to registered mobile devices.';

  @override
  String get adminNotificationSendEmail => 'Send email';

  @override
  String get adminNotificationSendEmailHint =>
      'Email the same title and message to the user.';

  @override
  String get adminNotificationSend => 'Send notification';

  @override
  String get adminNotificationSendAction => 'Notify';

  @override
  String get adminNotificationCreateSuccess => 'Notification created.';

  @override
  String adminNotificationPushSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count devices',
      one: '1 device',
      zero: 'no devices',
    );
    return 'Push delivered to $_temp0.';
  }

  @override
  String adminNotificationPushFailed(String error) {
    return 'Push failed: $error';
  }

  @override
  String get adminNotificationEmailSent => 'Email sent.';

  @override
  String adminNotificationEmailFailed(String error) {
    return 'Email failed: $error';
  }

  @override
  String get adminMenuSchedules => 'Schedules';

  @override
  String get adminEventSchedulesTitle => 'Schedule management';

  @override
  String get adminEventSchedulesSubtitle => 'Schedules by day and time slot.';

  @override
  String get adminEventSchedulesEmpty => 'No schedules yet';

  @override
  String get adminEventSchedulesCreate => 'Create new schedule';

  @override
  String get adminEventSchedulesCreateShort => 'Create schedule';

  @override
  String get adminEventSchedulesNoTime => 'No time set';

  @override
  String get adminEventSchedulesFrom => 'From';

  @override
  String get adminEventSchedulesTo => 'To';

  @override
  String adminEventSchedulesDaysItems(int days, int items) {
    return '$days days · $items items';
  }

  @override
  String get adminEventControlsTitle => 'Event controls';

  @override
  String get adminSystemStatusTitle => 'System status';

  @override
  String get adminSystemStatusSubtitle => 'Monitor core services in real time.';

  @override
  String get adminSystemHealthy => 'Healthy';

  @override
  String get adminSystemWarning => 'Warning';

  @override
  String get adminSystemError => 'Error';

  @override
  String get adminSystemUnknown => 'Unknown';

  @override
  String get adminStaffReadySubtitle =>
      'Ready to serve attendees at the event.';

  @override
  String get adminStaffCheckInGate => 'Gate check-in';

  @override
  String get adminStaffReadyBadge => 'Ready';

  @override
  String get adminStaffScanHint =>
      'Scan ticket QR codes to check in attendees.';

  @override
  String get adminStaffGreetingMorning => 'Good morning,';

  @override
  String get adminStaffGreetingAfternoon => 'Good afternoon,';

  @override
  String get adminStaffGreetingEvening => 'Good evening,';

  @override
  String get adminStaffShiftStats => 'Shift statistics';

  @override
  String get adminStaffShiftNoData => 'No data yet';

  @override
  String get adminStaffShiftUpdatedAt => 'Updated at';

  @override
  String get adminStaffShiftScannedToday => 'Tickets scanned today';

  @override
  String get adminStaffTrafficWarning => 'TRAFFIC WARNING';

  @override
  String get adminSalesTimelineDefault => 'Daily ticket sales';

  @override
  String get adminQrContinueScan => 'Continue scanning';

  @override
  String get adminQrProcessing => 'Processing ticket...';

  @override
  String get adminQrAlignFrame => 'Align the ticket QR code in the frame';

  @override
  String get adminQrManualEntry => 'Enter code manually';

  @override
  String get adminQrCheckIn => 'Check-in';

  @override
  String get adminQrEnterCodeTitle => 'Enter ticket code';

  @override
  String get adminQrTicketInfo => 'Ticket information';

  @override
  String get adminQrGuest => 'Guest';

  @override
  String get adminQrNoTicketImage => 'No ticket image';

  @override
  String get adminQrReadyCheckIn => 'Ready to check in';

  @override
  String get adminQrConnecting => 'Connecting...';

  @override
  String get adminQrScanNow => 'SCAN TICKET NOW';

  @override
  String get adminTierBadgeSoldOut => 'SOLD OUT';

  @override
  String get adminTierBadgePaused => 'PAUSED';

  @override
  String get adminTierBadgeSelling => 'SELLING';

  @override
  String get adminTierViewDetails => 'View ticket details →';

  @override
  String get adminTierLowStock => 'Low stock';

  @override
  String get adminPlaceholderDashboardUsers => 'Dashboard Users';

  @override
  String get adminPlaceholderDashboardUsersSubtitle =>
      'User analytics and breakdowns.';

  @override
  String get adminPlaceholderTalent => 'Talent Management';

  @override
  String get adminPlaceholderTalentSubtitle =>
      'Review and manage talent applications.';

  @override
  String get adminTierUpdateSuccess => 'Ticket tier updated successfully.';

  @override
  String get adminLostFoundFormTitle => 'Record lost & found item';

  @override
  String get adminLostFoundFormType => 'Item type';

  @override
  String get adminLostFoundFormTitleLabel => 'Title';

  @override
  String get adminLostFoundFormDescription => 'Description';

  @override
  String get adminLostFoundFormLocation => 'Location';

  @override
  String get adminLostFoundFormContact => 'Contact info';

  @override
  String get adminLostFoundFormNotes => 'Staff notes';

  @override
  String get adminLostFoundFormImage => 'Photo';

  @override
  String get adminLostFoundFormRequired => 'This field is required';

  @override
  String adminRoleCurrent(String role) {
    return '$role Current';
  }

  @override
  String get adminStatusPillDeleted => 'Deleted';

  @override
  String get adminStatusPillBlacklisted => 'Blacklisted';

  @override
  String get adminStatusPillActive => 'Active';

  @override
  String get adminTimelineBannedSubtitle =>
      'Account restricted from buying tickets.';

  @override
  String get adminTimelineHasTicketSubtitle =>
      'User registered or was granted a ticket.';

  @override
  String get adminTimelineVerifiedSubtitle =>
      'Account identity has been verified.';

  @override
  String get adminTimelineCreatedSubtitle => 'Registered on the system.';

  @override
  String get adminTagTicket => 'TICKET';

  @override
  String adminEventCount(int count) {
    return '$count events';
  }

  @override
  String get adminLostFoundEmptySubtitle =>
      'Tap + to add a lost or found item.';

  @override
  String get adminUserEditPersonalSubtitle =>
      'Update the user\'s profile and contact details.';

  @override
  String get adminUserTicketsManage => 'Manage ticket';

  @override
  String get adminLostFoundFormEditTitle => 'Edit lost & found item';

  @override
  String get adminLostFoundFormAddItem => 'Add item';

  @override
  String get adminLostFoundItemInfo => 'Item information';

  @override
  String get adminLostFoundRecipientInfo => 'Recipient information';

  @override
  String get adminLostFoundUserConfirmed =>
      'The user confirmed this is their item.';

  @override
  String get adminLostFoundVerifyChecklist => 'Verification checklist';

  @override
  String get adminLostFoundReturnNoClaim =>
      'No user has claimed this item yet.';

  @override
  String get adminLostFoundReturnCannot => 'This item cannot be returned.';

  @override
  String get adminLostFoundReturnNoRecipient =>
      'Recipient information not found.';

  @override
  String get adminLostFoundVerifyRequired =>
      'Complete the verification checklist before confirming.';

  @override
  String get adminLostFoundUserNote => 'Note from user';

  @override
  String adminDealerStaffCount(int count) {
    return 'Booth staff ($count)';
  }

  @override
  String adminDealerPriceSheetsCount(int count) {
    return 'Price sheets ($count)';
  }

  @override
  String get adminEventControlsSubtitle =>
      'Enable or disable ticket sales and registration channels.';

  @override
  String get adminEventToggleTicketSales => 'Ticket sales';

  @override
  String get adminEventToggleTicketSalesSubtitle =>
      'Allow users to purchase and upgrade event tickets.';

  @override
  String get adminEventTogglePanelRegistration => 'Panel registration';

  @override
  String get adminEventTogglePanelRegistrationSubtitle =>
      'Allow panel registration in the app.';

  @override
  String get adminEventToggleTalentRegistration => 'Talent registration';

  @override
  String get adminEventToggleTalentRegistrationSubtitle =>
      'Allow talent registration in the app.';

  @override
  String get adminEventToggleDealerRegistration => 'Dealer registration';

  @override
  String get adminEventToggleDealerRegistrationSubtitle =>
      'Allow dealer booth registration in the app.';

  @override
  String get adminTicketsTabAll => 'All';

  @override
  String get adminTicketsTabPendingReview => 'Pending review';

  @override
  String get adminTicketsTabApproved => 'Approved';

  @override
  String get adminTicketsTabDenied => 'Denied';

  @override
  String get adminTicketsEmptySubtitle =>
      'No tickets match the current filters.';

  @override
  String get adminTicketsEmptyTiersSubtitle =>
      'Create your first tier to start selling.';

  @override
  String adminTicketsEmptyFilter(String filter) {
    return 'No tiers in the \"$filter\" filter.';
  }

  @override
  String adminTicketsDeleteTierBodyNamed(String name) {
    return 'Deleting \"$name\" permanently removes this tier and all sold tickets in it. This cannot be undone.';
  }

  @override
  String get adminTicketsStockSoldOut => ' (sold out)';

  @override
  String get adminTierFilterAll => 'All';

  @override
  String get adminTierFilterSelling => 'Selling';

  @override
  String get adminTierFilterPaused => 'Paused';

  @override
  String get adminTierFilterSoldOut => 'Sold out';

  @override
  String get adminTierStatTotal => 'Total tickets';

  @override
  String get adminTierStatSold => 'Tickets sold';

  @override
  String get adminTierStatRemaining => 'Remaining';

  @override
  String get adminTierStatApproved => 'Approved tickets';

  @override
  String adminTierSoldCount(int sold, int total) {
    return 'Sold: $sold / $total';
  }

  @override
  String get adminTierNameRequired => 'Please enter a tier name';

  @override
  String get adminTierMaxChars255 => 'Maximum 255 characters';

  @override
  String get adminTierEnterPrice => 'Enter price';

  @override
  String get adminTierInvalidPrice => 'Invalid price';

  @override
  String get adminTierEnterStockQty => 'Enter quantity';

  @override
  String get adminTierInvalidStock => 'Invalid quantity';

  @override
  String get adminTierBenefitHint => 'Enter benefit...';

  @override
  String get adminTierDescriptionHint =>
      'Brief description of audience and perks...';

  @override
  String get adminTierNameHint => 'e.g. VIP Pass - Early Bird';

  @override
  String get adminTierAllowPurchaseSubtitle =>
      'Allow users to purchase this tier';

  @override
  String get adminTierSaveCreate => 'Create tier';

  @override
  String get adminTierSaveEdit => 'Save tier';

  @override
  String get adminTierDiscard => 'Discard';

  @override
  String get adminTierSystemWarningTitle => 'System warning';

  @override
  String get adminTierSystemWarningBody =>
      'Changes may affect users who already purchased tickets. Review carefully before saving.';

  @override
  String get adminTierPreviewNamePlaceholder => 'Tier name';

  @override
  String get adminSchedulesEmptySubtitle =>
      'Create schedules by day and time slot.';

  @override
  String adminSchedulesDaysCount(int count) {
    return '$count days';
  }

  @override
  String adminSchedulesItemsCount(int count) {
    return '$count items';
  }

  @override
  String get adminScheduleDefaultTitle => 'Schedule';

  @override
  String get adminScheduleSelectDay => 'Select a day to view the schedule.';

  @override
  String adminScheduleEmptyDayOnDate(String date) {
    return 'No items on $date.';
  }

  @override
  String get adminScheduleOverlapSchedule => ' (schedule conflict)';

  @override
  String get adminScheduleItemTitleLabel => 'Title';

  @override
  String get adminScheduleItemDescriptionLabel =>
      'Speaker / description (optional)';

  @override
  String get adminScheduleItemCategoryLabel => 'Category (optional)';

  @override
  String get adminScheduleItemCategoryHint => 'Panel, Workshop...';

  @override
  String get adminScheduleItemLocationLabel => 'Location (optional)';

  @override
  String get adminScheduleItemLocationHint => 'Hall A, Main stage...';

  @override
  String get adminScheduleStartLabel => 'Start';

  @override
  String get adminScheduleEndLabel => 'End';

  @override
  String get adminScheduleTitleRequired => 'Please enter a title.';

  @override
  String get adminSchedulesNameRequired => 'Please enter a name.';

  @override
  String get adminDashboardLoadFailed => 'Could not load analytics';

  @override
  String get adminDashboardLoadFailedSubtitle => 'Please try again later.';

  @override
  String get adminChartPeriod7Days => '7 days';

  @override
  String get adminChartPeriod30Days => '30 days';

  @override
  String get adminChartPeriod90Days => '90 days';

  @override
  String get adminStaffReadyConnected =>
      'System connected and ready to scan tickets.';

  @override
  String get adminStaffConnectingHint => 'Please wait a moment.';

  @override
  String get adminStaffTrafficWarningBody =>
      'Dealer Area A is overloaded (90%). Redirect foot traffic.';

  @override
  String get adminQrCameraPermission =>
      'Camera permission is required to scan tickets. Enable it in Settings.';

  @override
  String get adminQrUnsupported => 'This device does not support QR scanning.';

  @override
  String get adminQrCameraOpenFailed => 'Could not open camera.';

  @override
  String get adminQrTicketLabel => 'Ticket';

  @override
  String get adminQrGuestLabel => 'Guest';
}
