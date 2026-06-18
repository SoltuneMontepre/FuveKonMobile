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
  String get navNotifications => 'Notifications';

  @override
  String get navAccount => 'Account';

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
  String get authHomeNotificationsEmpty => 'No new notifications yet.';

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
}
