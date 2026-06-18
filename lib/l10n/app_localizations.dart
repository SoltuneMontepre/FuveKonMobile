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
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get continueButton;

  /// No description provided for @versionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản {version}'**
  String versionLabel(String version);

  /// No description provided for @supportLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ'**
  String get supportLabel;

  /// No description provided for @languageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ngôn ngữ để tiếp tục'**
  String get languageSubtitle;

  /// No description provided for @languageVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVietnamese;

  /// No description provided for @languageEnglish.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @themeSwitchToLight.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ sáng'**
  String get themeSwitchToLight;

  /// No description provided for @themeSwitchToDark.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ tối'**
  String get themeSwitchToDark;

  /// No description provided for @splashTagline.
  ///
  /// In vi, this message translates to:
  /// **'Nơi kết nối cộng đồng sự kiện và nghệ thuật'**
  String get splashTagline;

  /// No description provided for @brandTagline.
  ///
  /// In vi, this message translates to:
  /// **'Cổng thông tin sự kiện chuyên nghiệp'**
  String get brandTagline;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get loginTitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc Số điện thoại'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email hoặc SĐT'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get loginPasswordLabel;

  /// No description provided for @loginForgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get loginForgotPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get loginSubmit;

  /// No description provided for @loginOrDivider.
  ///
  /// In vi, this message translates to:
  /// **'HOẶC'**
  String get loginOrDivider;

  /// No description provided for @loginGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập với Google'**
  String get loginGoogle;

  /// No description provided for @authGoogleNotConfigured.
  ///
  /// In vi, this message translates to:
  /// **'Chưa cấu hình Google Sign-In. Thêm GOOGLE_CLIENT_ID vào file .env rồi khởi động lại app.'**
  String get authGoogleNotConfigured;

  /// No description provided for @authGoogleUnsupportedPlatform.
  ///
  /// In vi, this message translates to:
  /// **'Google Sign-In chưa hỗ trợ trên Linux/Windows. Hãy chạy app trên Android, iOS, Web (Chrome) hoặc macOS.'**
  String get authGoogleUnsupportedPlatform;

  /// No description provided for @authGoogleLoginFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập Google thất bại. Vui lòng thử lại hoặc dùng email/mật khẩu.'**
  String get authGoogleLoginFailed;

  /// No description provided for @authGoogleDeveloperError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi cấu hình Google OAuth trên Android. Trong Google Cloud Console, tạo OAuth client Android với package com.example.fuvekonmobile và thêm SHA-1 của debug keystore (Android Studio → Gradle → signingReport).'**
  String get authGoogleDeveloperError;

  /// No description provided for @authGoogleIdTokenMissing.
  ///
  /// In vi, this message translates to:
  /// **'Google không trả về ID token. Kiểm tra GOOGLE_CLIENT_ID (Web client) trong .env và OAuth client Android trên Google Cloud.'**
  String get authGoogleIdTokenMissing;

  /// No description provided for @authGoogleRegistrationDetailsRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng hoàn tất đăng ký với thông tin cá nhân.'**
  String get authGoogleRegistrationDetailsRequired;

  /// No description provided for @loginNoAccount.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản?'**
  String get loginNoAccount;

  /// No description provided for @loginRegisterLink.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get loginRegisterLink;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email hoặc số điện thoại để nhận hướng dẫn đặt lại mật khẩu.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: user@example.com'**
  String get forgotPasswordEmailHint;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Gửi liên kết đặt lại mật khẩu'**
  String get forgotPasswordSubmit;

  /// No description provided for @forgotPasswordBackToLogin.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại đăng nhập'**
  String get forgotPasswordBackToLogin;

  /// No description provided for @forgotPasswordSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Nếu tài khoản tồn tại, liên kết đặt lại mật khẩu đã được gửi tới email của bạn.'**
  String get forgotPasswordSuccessMessage;

  /// No description provided for @forgotPasswordSentHint.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng kiểm tra hộp thư và làm theo hướng dẫn.'**
  String get forgotPasswordSentHint;

  /// No description provided for @forgotPasswordFailureMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi email đặt lại mật khẩu. Vui lòng thử lại.'**
  String get forgotPasswordFailureMessage;

  /// No description provided for @registerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu hành trình quản lý sự kiện của bạn'**
  String get registerSubtitle;

  /// No description provided for @registerFullNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get registerFullNameLabel;

  /// No description provided for @registerFullNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập họ và tên'**
  String get registerFullNameHint;

  /// No description provided for @registerEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'example@domain.com'**
  String get registerEmailHint;

  /// No description provided for @registerPhoneLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get registerPhoneLabel;

  /// No description provided for @registerPhoneHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập số điện thoại'**
  String get registerPhoneHint;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mật khẩu'**
  String get registerPasswordHint;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerConfirmPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại mật khẩu'**
  String get registerConfirmPasswordHint;

  /// No description provided for @registerTermsPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đồng ý với '**
  String get registerTermsPrefix;

  /// No description provided for @registerTermsTos.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản dịch vụ'**
  String get registerTermsTos;

  /// No description provided for @registerTermsAnd.
  ///
  /// In vi, this message translates to:
  /// **' và '**
  String get registerTermsAnd;

  /// No description provided for @registerTermsPrivacy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách bảo mật'**
  String get registerTermsPrivacy;

  /// No description provided for @registerTermsSuffix.
  ///
  /// In vi, this message translates to:
  /// **' của FUVEKON.'**
  String get registerTermsSuffix;

  /// No description provided for @registerSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get registerSubmit;

  /// No description provided for @registerHasAccount.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản?'**
  String get registerHasAccount;

  /// No description provided for @registerLoginLink.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get registerLoginLink;

  /// No description provided for @registerSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản thành công. Vui lòng kiểm tra email để nhận mã xác minh.'**
  String get registerSuccessMessage;

  /// No description provided for @registerFailureMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thất bại. Vui lòng thử lại.'**
  String get registerFailureMessage;

  /// No description provided for @validationEmailRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email hoặc SĐT'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordMin.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu tối thiểu 6 ký tự'**
  String get validationPasswordMin;

  /// No description provided for @validationFullNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập họ và tên'**
  String get validationFullNameRequired;

  /// No description provided for @validationFullNameMin.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên phải có ít nhất 2 ký tự'**
  String get validationFullNameMin;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số điện thoại'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại không hợp lệ'**
  String get validationPhoneInvalid;

  /// No description provided for @validationConfirmPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng xác nhận mật khẩu'**
  String get validationConfirmPasswordRequired;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu không khớp'**
  String get validationPasswordMismatch;

  /// No description provided for @validationTermsRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đồng ý với điều khoản để tiếp tục'**
  String get validationTermsRequired;

  /// No description provided for @introBadge.
  ///
  /// In vi, this message translates to:
  /// **'GIỚI THIỆU'**
  String get introBadge;

  /// No description provided for @introHeroLine1.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá\n'**
  String get introHeroLine1;

  /// No description provided for @introHeroBrand.
  ///
  /// In vi, this message translates to:
  /// **'FUVEKON'**
  String get introHeroBrand;

  /// No description provided for @introHeroSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Lễ hội văn hóa Anime và quản lý sự kiện chuyên nghiệp hàng đầu.'**
  String get introHeroSubtitle;

  /// No description provided for @introWhatIsTitle.
  ///
  /// In vi, this message translates to:
  /// **'FUVEKON là gì?'**
  String get introWhatIsTitle;

  /// No description provided for @introWhatIsBody.
  ///
  /// In vi, this message translates to:
  /// **'FUVEKON là điểm giao thoa độc đáo giữa thẩm mỹ văn hóa Anime và nền tảng quản lý sự kiện chuyên nghiệp.'**
  String get introWhatIsBody;

  /// No description provided for @introAudienceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Dành cho ai?'**
  String get introAudienceTitle;

  /// No description provided for @introAudienceArtistTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nghệ sĩ & Creator'**
  String get introAudienceArtistTitle;

  /// No description provided for @introAudienceArtistBody.
  ///
  /// In vi, this message translates to:
  /// **'Giao lưu và trưng bày tác phẩm.'**
  String get introAudienceArtistBody;

  /// No description provided for @introAudienceFanTitle.
  ///
  /// In vi, this message translates to:
  /// **'Fan hâm mộ'**
  String get introAudienceFanTitle;

  /// No description provided for @introAudienceFanBody.
  ///
  /// In vi, this message translates to:
  /// **'Trải nghiệm không gian văn hóa đặc sắc.'**
  String get introAudienceFanBody;

  /// No description provided for @introAudienceOrganizerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhà tổ chức sự kiện'**
  String get introAudienceOrganizerTitle;

  /// No description provided for @introAudienceOrganizerBody.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm cơ hội hợp tác và nền tảng quản lý chuyên nghiệp.'**
  String get introAudienceOrganizerBody;

  /// No description provided for @introViewRules.
  ///
  /// In vi, this message translates to:
  /// **'Xem nội quy'**
  String get introViewRules;

  /// No description provided for @introViewFaq.
  ///
  /// In vi, this message translates to:
  /// **'Xem FAQ'**
  String get introViewFaq;

  /// No description provided for @navIntroduction.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu'**
  String get navIntroduction;

  /// No description provided for @navArtbook.
  ///
  /// In vi, this message translates to:
  /// **'Conbook'**
  String get navArtbook;

  /// No description provided for @navFaq.
  ///
  /// In vi, this message translates to:
  /// **'FAQ'**
  String get navFaq;

  /// No description provided for @navRules.
  ///
  /// In vi, this message translates to:
  /// **'Nội quy'**
  String get navRules;

  /// No description provided for @navLogin.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get navLogin;

  /// No description provided for @navLogout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get navLogout;

  /// No description provided for @navHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get navHome;

  /// No description provided for @navSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch trình'**
  String get navSchedule;

  /// No description provided for @navMyTickets.
  ///
  /// In vi, this message translates to:
  /// **'Vé của tôi'**
  String get navMyTickets;

  /// No description provided for @navNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get navNotifications;

  /// No description provided for @navAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get navAccount;

  /// No description provided for @authHomeUpcomingBadge.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện sắp diễn ra'**
  String get authHomeUpcomingBadge;

  /// No description provided for @authHomeHeroTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lễ Hội Giao Lưu Văn Hóa Anime'**
  String get authHomeHeroTitle;

  /// No description provided for @authHomeHeroSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá không gian nghệ thuật và trải nghiệm độc đáo.'**
  String get authHomeHeroSubtitle;

  /// No description provided for @authHomeSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm sự kiện, nghệ sĩ...'**
  String get authHomeSearchHint;

  /// No description provided for @authHomeFeaturedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện nổi bật'**
  String get authHomeFeaturedTitle;

  /// No description provided for @authHomeSeeAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get authHomeSeeAll;

  /// No description provided for @authHomeHotBadge.
  ///
  /// In vi, this message translates to:
  /// **'Hot'**
  String get authHomeHotBadge;

  /// No description provided for @authHomeFeaturedEventTitle.
  ///
  /// In vi, this message translates to:
  /// **'Triển Lãm Nghệ Thuật Đương Đại'**
  String get authHomeFeaturedEventTitle;

  /// No description provided for @authHomeFeaturedEventDate.
  ///
  /// In vi, this message translates to:
  /// **'20 Tháng 10, 2023'**
  String get authHomeFeaturedEventDate;

  /// No description provided for @authHomeFeaturedEventLocation.
  ///
  /// In vi, this message translates to:
  /// **'Trung Tâm SECC'**
  String get authHomeFeaturedEventLocation;

  /// No description provided for @authHomeBuyTicket.
  ///
  /// In vi, this message translates to:
  /// **'Mua vé'**
  String get authHomeBuyTicket;

  /// No description provided for @authHomeNotificationsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông báo mới.'**
  String get authHomeNotificationsEmpty;

  /// No description provided for @landingBadge.
  ///
  /// In vi, this message translates to:
  /// **'SỰ KIỆN HÀNG ĐẦU'**
  String get landingBadge;

  /// No description provided for @landingHeroTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện Anime'**
  String get landingHeroTitle;

  /// No description provided for @landingHeroBody.
  ///
  /// In vi, this message translates to:
  /// **'Trải nghiệm không gian văn hóa độc bản với hệ thống quản lý vé và lịch trình thông minh. Tham gia ngay để không bỏ lỡ những khoảnh khắc tuyệt vời nhất.'**
  String get landingHeroBody;

  /// No description provided for @landingRegister.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get landingRegister;

  /// No description provided for @landingViewTickets.
  ///
  /// In vi, this message translates to:
  /// **'Xem vé'**
  String get landingViewTickets;

  /// No description provided for @exploreTicketsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá các loại vé'**
  String get exploreTicketsTitle;

  /// No description provided for @exploreTicketsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Lựa chọn trải nghiệm phù hợp nhất với bạn tại triển lãm.'**
  String get exploreTicketsSubtitle;

  /// No description provided for @exploreTicketsFooterInfo.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể xem thông tin vé trước. Để mua vé, vui lòng đăng ký hoặc đăng nhập.'**
  String get exploreTicketsFooterInfo;

  /// No description provided for @exploreTicketsRegisterCta.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký để mua vé'**
  String get exploreTicketsRegisterCta;

  /// No description provided for @exploreTicketsBuyCta.
  ///
  /// In vi, this message translates to:
  /// **'Mua vé ngay'**
  String get exploreTicketsBuyCta;

  /// No description provided for @exploreTicketsLoginPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản?'**
  String get exploreTicketsLoginPrompt;

  /// No description provided for @exploreTicketsLoginLink.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập ngay'**
  String get exploreTicketsLoginLink;

  /// No description provided for @exploreTicketsPopularBadge.
  ///
  /// In vi, this message translates to:
  /// **'Phổ biến nhất'**
  String get exploreTicketsPopularBadge;

  /// No description provided for @exploreTicketsSoldOut.
  ///
  /// In vi, this message translates to:
  /// **'Hết vé'**
  String get exploreTicketsSoldOut;

  /// No description provided for @exploreTicketsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Hiện chưa có hạng vé nào.'**
  String get exploreTicketsEmpty;

  /// No description provided for @exploreTicketsRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get exploreTicketsRetry;

  /// No description provided for @ticketDetailBenefitsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quyền lợi đi kèm'**
  String get ticketDetailBenefitsTitle;

  /// No description provided for @ticketDetailCompareTitle.
  ///
  /// In vi, this message translates to:
  /// **'So sánh với {standardTier}'**
  String ticketDetailCompareTitle(String standardTier);

  /// No description provided for @ticketDetailTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng cộng'**
  String get ticketDetailTotal;

  /// No description provided for @ticketDetailCompareAccess.
  ///
  /// In vi, this message translates to:
  /// **'Quyền truy cập'**
  String get ticketDetailCompareAccess;

  /// No description provided for @ticketDetailCompareCheckIn.
  ///
  /// In vi, this message translates to:
  /// **'Check-in'**
  String get ticketDetailCompareCheckIn;

  /// No description provided for @ticketDetailComparePriority.
  ///
  /// In vi, this message translates to:
  /// **'Ưu tiên'**
  String get ticketDetailComparePriority;

  /// No description provided for @ticketDetailCompareShared.
  ///
  /// In vi, this message translates to:
  /// **'Thông thường'**
  String get ticketDetailCompareShared;

  /// No description provided for @ticketDetailCompareBadge.
  ///
  /// In vi, this message translates to:
  /// **'Badge'**
  String get ticketDetailCompareBadge;

  /// No description provided for @ticketDetailCompareCustom.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh'**
  String get ticketDetailCompareCustom;

  /// No description provided for @ticketDetailCompareNormal.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu chuẩn'**
  String get ticketDetailCompareNormal;

  /// No description provided for @ticketDetailCompareGifts.
  ///
  /// In vi, this message translates to:
  /// **'Quà tặng thêm'**
  String get ticketDetailCompareGifts;

  /// No description provided for @landingExperienceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trải Nghiệm Hoàn Hảo'**
  String get landingExperienceTitle;

  /// No description provided for @landingExperienceBody.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý hành trình của bạn tại sự kiện một cách dễ dàng.'**
  String get landingExperienceBody;

  /// No description provided for @rulesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nội quy sự kiện'**
  String get rulesTitle;

  /// No description provided for @rulesIntro.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đọc kỹ các quy định dưới đây để đảm bảo một kỳ triển lãm an toàn, chuyên nghiệp và đáng nhớ cho tất cả mọi người.'**
  String get rulesIntro;

  /// No description provided for @rulesAttendanceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nội quy tham dự'**
  String get rulesAttendanceTitle;

  /// No description provided for @rulesAttendance1.
  ///
  /// In vi, this message translates to:
  /// **'Xuất trình vé hợp lệ tại cổng.'**
  String get rulesAttendance1;

  /// No description provided for @rulesAttendance2.
  ///
  /// In vi, this message translates to:
  /// **'Không mang vũ khí, chất cháy nổ.'**
  String get rulesAttendance2;

  /// No description provided for @rulesAttendance3.
  ///
  /// In vi, this message translates to:
  /// **'Tôn trọng không gian chung.'**
  String get rulesAttendance3;

  /// No description provided for @rulesCosplayTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quy định cosplay'**
  String get rulesCosplayTitle;

  /// No description provided for @rulesCosplay1.
  ///
  /// In vi, this message translates to:
  /// **'Trang phục phù hợp thuần phong mỹ tục.'**
  String get rulesCosplay1;

  /// No description provided for @rulesCosplay2.
  ///
  /// In vi, this message translates to:
  /// **'Đạo cụ không sắc nhọn, nguy hiểm.'**
  String get rulesCosplay2;

  /// No description provided for @rulesCosplay3.
  ///
  /// In vi, this message translates to:
  /// **'Sử dụng khu vực thay đồ đúng quy định.'**
  String get rulesCosplay3;

  /// No description provided for @rulesBoothTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quy định gian hàng'**
  String get rulesBoothTitle;

  /// No description provided for @rulesBooth1.
  ///
  /// In vi, this message translates to:
  /// **'Kinh doanh đúng danh mục đăng ký.'**
  String get rulesBooth1;

  /// No description provided for @rulesBooth2.
  ///
  /// In vi, this message translates to:
  /// **'Không lấn chiếm lối đi chung.'**
  String get rulesBooth2;

  /// No description provided for @rulesBooth3.
  ///
  /// In vi, this message translates to:
  /// **'Đảm bảo vệ sinh khu vực.'**
  String get rulesBooth3;

  /// No description provided for @rulesConductTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quy định hành vi'**
  String get rulesConductTitle;

  /// No description provided for @rulesConduct1.
  ///
  /// In vi, this message translates to:
  /// **'Nghiêm cấm quấy rối dưới mọi hình thức.'**
  String get rulesConduct1;

  /// No description provided for @rulesConduct2.
  ///
  /// In vi, this message translates to:
  /// **'Không xả rác bừa bãi.'**
  String get rulesConduct2;

  /// No description provided for @rulesConduct3.
  ///
  /// In vi, this message translates to:
  /// **'Tuân thủ hướng dẫn của BTC.'**
  String get rulesConduct3;

  /// No description provided for @rulesAgreeCheckbox.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đã đọc, hiểu và đồng ý với các nội quy trên.'**
  String get rulesAgreeCheckbox;

  /// No description provided for @rulesConfirmButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận đồng ý'**
  String get rulesConfirmButton;

  /// No description provided for @faqPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi thường gặp'**
  String get faqPageTitle;

  /// No description provided for @faqPageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm câu trả lời nhanh chóng cho các thắc mắc của bạn.'**
  String get faqPageSubtitle;

  /// No description provided for @faqSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần tìm gì?'**
  String get faqSearchHint;

  /// No description provided for @faqNoResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy kết quả phù hợp.'**
  String get faqNoResults;

  /// No description provided for @faqNeedHelp.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần hỗ trợ thêm? '**
  String get faqNeedHelp;

  /// No description provided for @faqContactUs.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ chúng tôi →'**
  String get faqContactUs;

  /// No description provided for @faqCatTickets.
  ///
  /// In vi, this message translates to:
  /// **'Vé'**
  String get faqCatTickets;

  /// No description provided for @faqTicketsQ1.
  ///
  /// In vi, this message translates to:
  /// **'Mua vé ở đâu?'**
  String get faqTicketsQ1;

  /// No description provided for @faqTicketsA1.
  ///
  /// In vi, this message translates to:
  /// **'Vào mục Vé trên app FUVEKON, chọn hạng vé phù hợp và hoàn tất thanh toán theo hướng dẫn. Mỗi tài khoản chỉ được sở hữu một vé active tại một thời điểm.'**
  String get faqTicketsA1;

  /// No description provided for @faqTicketsQ2.
  ///
  /// In vi, this message translates to:
  /// **'Có những hạng vé nào?'**
  String get faqTicketsQ2;

  /// No description provided for @faqTicketsA2.
  ///
  /// In vi, this message translates to:
  /// **'BTC công bố các hạng vé (Standard, VIP, v.v.) kèm quyền lợi tương ứng trên app. Giá và số lượng có thể thay đổi theo từng đợt mở bán.'**
  String get faqTicketsA2;

  /// No description provided for @faqTicketsQ3.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán vé bằng cách nào?'**
  String get faqTicketsQ3;

  /// No description provided for @faqTicketsA3.
  ///
  /// In vi, this message translates to:
  /// **'Sau khi đặt vé, bạn chuyển khoản qua mã QR ngân hàng hoặc PayPal như hướng dẫn, rồi bấm \"Tôi đã thanh toán\". BTC sẽ xác minh và duyệt vé trong thời gian sớm nhất.'**
  String get faqTicketsA3;

  /// No description provided for @faqTicketsQ4.
  ///
  /// In vi, this message translates to:
  /// **'Vé điện tử có hợp lệ không?'**
  String get faqTicketsQ4;

  /// No description provided for @faqTicketsA4.
  ///
  /// In vi, this message translates to:
  /// **'Có. Sau khi vé được duyệt, mã QR check-in và badge điện tử sẽ được gửi qua email và hiển thị trong app. Xuất trình QR tại cổng soát vé.'**
  String get faqTicketsA4;

  /// No description provided for @faqTicketsQ5.
  ///
  /// In vi, this message translates to:
  /// **'Tôi có thể nâng cấp vé không?'**
  String get faqTicketsQ5;

  /// No description provided for @faqTicketsA5.
  ///
  /// In vi, this message translates to:
  /// **'Có. Chủ vé đã được duyệt có thể nâng cấp lên hạng cao hơn bằng cách trả phần chênh lệch. Vé nâng cấp cũng cần được BTC xác minh thanh toán trước khi có hiệu lực.'**
  String get faqTicketsA5;

  /// No description provided for @faqTicketsQ6.
  ///
  /// In vi, this message translates to:
  /// **'Tôi có thể hoàn vé không?'**
  String get faqTicketsQ6;

  /// No description provided for @faqTicketsA6.
  ///
  /// In vi, this message translates to:
  /// **'Vé đã mua không được hoàn tiền, trừ khi BTC có thông báo chính thức (ví dụ: sự kiện hủy hoặc thay đổi lớn).'**
  String get faqTicketsA6;

  /// No description provided for @faqCatRegister.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get faqCatRegister;

  /// No description provided for @faqRegisterQ1.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để tạo tài khoản?'**
  String get faqRegisterQ1;

  /// No description provided for @faqRegisterA1.
  ///
  /// In vi, this message translates to:
  /// **'Chọn Đăng ký trên màn hình đăng nhập, điền email và mật khẩu, sau đó xác minh OTP gửi về email để kích hoạt tài khoản.'**
  String get faqRegisterA1;

  /// No description provided for @faqRegisterQ2.
  ///
  /// In vi, this message translates to:
  /// **'Có thể đăng nhập bằng Google không?'**
  String get faqRegisterQ2;

  /// No description provided for @faqRegisterA2.
  ///
  /// In vi, this message translates to:
  /// **'Có. FUVEKON hỗ trợ đăng nhập nhanh qua tài khoản Google. Lần đầu đăng nhập có thể cần bổ sung thông tin hồ sơ.'**
  String get faqRegisterA2;

  /// No description provided for @faqRegisterQ3.
  ///
  /// In vi, this message translates to:
  /// **'Tại sao cần xác minh email?'**
  String get faqRegisterQ3;

  /// No description provided for @faqRegisterA3.
  ///
  /// In vi, this message translates to:
  /// **'Xác minh email giúp bảo vệ tài khoản và cho phép bạn chỉnh sửa hồ sơ, mua vé, đăng ký panel/talent/dealer sau khi verify.'**
  String get faqRegisterA3;

  /// No description provided for @faqRegisterQ4.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu thì làm sao?'**
  String get faqRegisterQ4;

  /// No description provided for @faqRegisterA4.
  ///
  /// In vi, this message translates to:
  /// **'Chọn Quên mật khẩu trên màn đăng nhập, nhập email đã đăng ký và làm theo link/OTP để đặt lại mật khẩu mới.'**
  String get faqRegisterA4;

  /// No description provided for @faqRegisterQ5.
  ///
  /// In vi, this message translates to:
  /// **'Không nhận được mã OTP?'**
  String get faqRegisterQ5;

  /// No description provided for @faqRegisterA5.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra hộp thư spam. Nếu vẫn không thấy, dùng nút Gửi lại OTP trên app hoặc liên hệ contact@fuvekon.vn.'**
  String get faqRegisterA5;

  /// No description provided for @faqCatDealer.
  ///
  /// In vi, this message translates to:
  /// **'Dealer'**
  String get faqCatDealer;

  /// No description provided for @faqDealerQ1.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao đăng ký gian hàng?'**
  String get faqDealerQ1;

  /// No description provided for @faqDealerA1.
  ///
  /// In vi, this message translates to:
  /// **'Vào mục Dealer trên app, đọc quy định gian hàng, điền form đăng ký và tải lên tối đa 5 bảng giá. Hồ sơ sẽ được BTC xem xét.'**
  String get faqDealerA1;

  /// No description provided for @faqDealerQ2.
  ///
  /// In vi, this message translates to:
  /// **'Điều kiện để trở thành Dealer?'**
  String get faqDealerQ2;

  /// No description provided for @faqDealerA2.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần tài khoản đã xác minh email và tuân thủ quy định sản phẩm, bản quyền của BTC. Chi tiết xem tại mục Dealer trên app.'**
  String get faqDealerA2;

  /// No description provided for @faqDealerQ3.
  ///
  /// In vi, this message translates to:
  /// **'Phí gian hàng bao nhiêu?'**
  String get faqDealerQ3;

  /// No description provided for @faqDealerA3.
  ///
  /// In vi, this message translates to:
  /// **'Phí phụ thuộc loại gian hàng, diện tích và vị trí. BTC sẽ gửi thông tin chi phí sau khi duyệt hồ sơ đăng ký.'**
  String get faqDealerA3;

  /// No description provided for @faqDealerQ4.
  ///
  /// In vi, this message translates to:
  /// **'Thêm nhân viên gian hàng thế nào?'**
  String get faqDealerQ4;

  /// No description provided for @faqDealerA4.
  ///
  /// In vi, this message translates to:
  /// **'Chủ gian hàng tạo mã mời (booth code) trong app. Nhân viên nhập mã này tại mục Tham gia gian hàng để được thêm vào booth.'**
  String get faqDealerA4;

  /// No description provided for @faqDealerQ5.
  ///
  /// In vi, this message translates to:
  /// **'Bao lâu thì biết kết quả duyệt?'**
  String get faqDealerQ5;

  /// No description provided for @faqDealerA5.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian duyệt thường từ 3–7 ngày làm việc. Bạn sẽ nhận thông báo qua email và trong app khi hồ sơ được duyệt hoặc từ chối.'**
  String get faqDealerA5;

  /// No description provided for @faqCatTalent.
  ///
  /// In vi, this message translates to:
  /// **'Talent Show'**
  String get faqCatTalent;

  /// No description provided for @faqTalentQ1.
  ///
  /// In vi, this message translates to:
  /// **'Ai có thể đăng ký biểu diễn?'**
  String get faqTalentQ1;

  /// No description provided for @faqTalentA1.
  ///
  /// In vi, this message translates to:
  /// **'Nghệ sĩ, cosplayer, ca sĩ, vũ công và creator có thể nộp hồ sơ qua mục Talent trên app.'**
  String get faqTalentA1;

  /// No description provided for @faqTalentQ2.
  ///
  /// In vi, this message translates to:
  /// **'Có cần vé sự kiện không?'**
  String get faqTalentQ2;

  /// No description provided for @faqTalentA2.
  ///
  /// In vi, this message translates to:
  /// **'Có. Bạn cần sở hữu vé đã được duyệt và tài khoản đã xác minh email trước khi gửi đơn đăng ký talent.'**
  String get faqTalentA2;

  /// No description provided for @faqTalentQ3.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ talent cần gì?'**
  String get faqTalentQ3;

  /// No description provided for @faqTalentA3.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu bản thân, mô tả tiết mục dự kiến, hình ảnh/video tham khảo và thông tin liên hệ. Form chi tiết có trên app.'**
  String get faqTalentA3;

  /// No description provided for @faqTalentQ4.
  ///
  /// In vi, this message translates to:
  /// **'Thời hạn đăng ký?'**
  String get faqTalentQ4;

  /// No description provided for @faqTalentA4.
  ///
  /// In vi, this message translates to:
  /// **'Thời hạn đóng đơn được công bố trên app, website và fanpage chính thức FUVEKON. Nộp sớm để BTC sắp xếp lịch biểu diễn.'**
  String get faqTalentA4;

  /// No description provided for @faqCatPanel.
  ///
  /// In vi, this message translates to:
  /// **'Panel'**
  String get faqCatPanel;

  /// No description provided for @faqPanelQ1.
  ///
  /// In vi, this message translates to:
  /// **'Panel là gì?'**
  String get faqPanelQ1;

  /// No description provided for @faqPanelA1.
  ///
  /// In vi, this message translates to:
  /// **'Panel là buổi giao lưu, thảo luận chuyên đề với khách mời, diễn giả và người hâm mộ trong không gian sự kiện.'**
  String get faqPanelA1;

  /// No description provided for @faqPanelQ2.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký panel như thế nào?'**
  String get faqPanelQ2;

  /// No description provided for @faqPanelA2.
  ///
  /// In vi, this message translates to:
  /// **'Vào mục Panel, điền đề xuất chủ đề, thông tin diễn giả và nội dung dự kiến. BTC sẽ duyệt và xếp lịch nếu phù hợp.'**
  String get faqPanelA2;

  /// No description provided for @faqPanelQ3.
  ///
  /// In vi, this message translates to:
  /// **'Có cần vé để đăng ký panel không?'**
  String get faqPanelQ3;

  /// No description provided for @faqPanelA3.
  ///
  /// In vi, this message translates to:
  /// **'Có. Người đăng ký cần vé active đã duyệt và tài khoản email đã xác minh, tương tự đăng ký talent.'**
  String get faqPanelA3;

  /// No description provided for @faqPanelQ4.
  ///
  /// In vi, this message translates to:
  /// **'Lịch panel công bố khi nào?'**
  String get faqPanelQ4;

  /// No description provided for @faqPanelA4.
  ///
  /// In vi, this message translates to:
  /// **'Lịch panel chính thức được đăng tại mục Lịch trình sau khi BTC duyệt xong các đơn. Bạn có thể bookmark để nhận nhắc nhở.'**
  String get faqPanelA4;

  /// No description provided for @faqCatSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch trình'**
  String get faqCatSchedule;

  /// No description provided for @faqScheduleQ1.
  ///
  /// In vi, this message translates to:
  /// **'Xem lịch trình ở đâu?'**
  String get faqScheduleQ1;

  /// No description provided for @faqScheduleA1.
  ///
  /// In vi, this message translates to:
  /// **'Mục Lịch trình trên app hiển thị toàn bộ hoạt động theo ngày, khung giờ và sân khấu/khu vực.'**
  String get faqScheduleA1;

  /// No description provided for @faqScheduleQ2.
  ///
  /// In vi, this message translates to:
  /// **'Lịch có thay đổi không?'**
  String get faqScheduleQ2;

  /// No description provided for @faqScheduleA2.
  ///
  /// In vi, this message translates to:
  /// **'BTC có thể điều chỉnh lịch vì lý do vận hành. Thay đổi sẽ được cập nhật trên app và gửi thông báo nếu bạn đã bookmark mục đó.'**
  String get faqScheduleA2;

  /// No description provided for @faqScheduleQ3.
  ///
  /// In vi, this message translates to:
  /// **'Lịch cá nhân (My Schedule) là gì?'**
  String get faqScheduleQ3;

  /// No description provided for @faqScheduleA3.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể bookmark panel, talent show hoặc workshop yêu thích để xem trên timeline cá nhân và nhận nhắc trước 10–15 phút.'**
  String get faqScheduleA3;

  /// No description provided for @faqScheduleQ4.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện diễn ra mấy ngày?'**
  String get faqScheduleQ4;

  /// No description provided for @faqScheduleA4.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian và địa điểm chính thức được công bố trên trang sự kiện và mục Giới thiệu trên app.'**
  String get faqScheduleA4;

  /// No description provided for @faqCatLostFound.
  ///
  /// In vi, this message translates to:
  /// **'Lost & Found'**
  String get faqCatLostFound;

  /// No description provided for @faqLostFoundQ1.
  ///
  /// In vi, this message translates to:
  /// **'Tôi bị mất đồ tại sự kiện?'**
  String get faqLostFoundQ1;

  /// No description provided for @faqLostFoundA1.
  ///
  /// In vi, this message translates to:
  /// **'Đến quầy Lost & Found tại venue hoặc gửi báo mất trên app (mô tả, hình ảnh, thời gian và vị trí ước tính).'**
  String get faqLostFoundA1;

  /// No description provided for @faqLostFoundQ2.
  ///
  /// In vi, this message translates to:
  /// **'Xem danh sách đồ tìm thấy ở đâu?'**
  String get faqLostFoundQ2;

  /// No description provided for @faqLostFoundA2.
  ///
  /// In vi, this message translates to:
  /// **'Bảng tin Lost & Found công khai trên app liệt kê đồ được ghi nhận (ẩn thông tin nhận dạng nhạy cảm để tránh gian lận).'**
  String get faqLostFoundA2;

  /// No description provided for @faqLostFoundQ3.
  ///
  /// In vi, this message translates to:
  /// **'Nhận lại đồ bị mất thế nào?'**
  String get faqLostFoundQ3;

  /// No description provided for @faqLostFoundA3.
  ///
  /// In vi, this message translates to:
  /// **'Mang giấy tờ tùy thân đến quầy hỗ trợ, mô tả vật dụng và thời gian mất. Staff sẽ đối chiếu và bàn giao nếu khớp.'**
  String get faqLostFoundA3;

  /// No description provided for @faqLostFoundQ4.
  ///
  /// In vi, this message translates to:
  /// **'Đồ mất bao lâu thì được xử lý?'**
  String get faqLostFoundQ4;

  /// No description provided for @faqLostFoundA4.
  ///
  /// In vi, this message translates to:
  /// **'Staff cập nhật trạng thái (Lost / Found / Claimed) trên hệ thống. Bạn theo dõi tiến trình trong app hoặc liên hệ quầy.'**
  String get faqLostFoundA4;

  /// No description provided for @artbookTitle.
  ///
  /// In vi, this message translates to:
  /// **'Conbook FUVEKON'**
  String get artbookTitle;

  /// No description provided for @artbookSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hành trình Nghệ thuật - 2024'**
  String get artbookSubtitle;

  /// No description provided for @artbookDescription.
  ///
  /// In vi, this message translates to:
  /// **'Cuốn sách tổng hợp hơn 50 tác phẩm nghệ thuật từ cộng đồng sáng tạo FUVEKON, được in trên giấy mỹ thuật cao cấp.'**
  String get artbookDescription;

  /// No description provided for @artbookPageCount.
  ///
  /// In vi, this message translates to:
  /// **'120 Trang'**
  String get artbookPageCount;

  /// No description provided for @artbookPaperType.
  ///
  /// In vi, this message translates to:
  /// **'Giấy Couche 150gsm'**
  String get artbookPaperType;

  /// No description provided for @artbookSubmitCta.
  ///
  /// In vi, this message translates to:
  /// **'Gửi tác phẩm cho Conbook'**
  String get artbookSubmitCta;

  /// No description provided for @artbookSubmitBack.
  ///
  /// In vi, this message translates to:
  /// **'QUAY LẠI'**
  String get artbookSubmitBack;

  /// No description provided for @artbookSubmitTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gửi Conbook'**
  String get artbookSubmitTitle;

  /// No description provided for @artbookSubmitIntro.
  ///
  /// In vi, this message translates to:
  /// **'Nơi tôn vinh những tác phẩm xuất sắc. Hãy gửi kiệt tác của bạn để được BTC xem xét đưa vào cuốn Conbook FUVEKON.'**
  String get artbookSubmitIntro;

  /// No description provided for @artbookFormSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin tác phẩm'**
  String get artbookFormSectionTitle;

  /// No description provided for @artbookFieldTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tên tác phẩm'**
  String get artbookFieldTitle;

  /// No description provided for @artbookFieldTitleHint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Giấc mơ chiều thu'**
  String get artbookFieldTitleHint;

  /// No description provided for @artbookFieldAuthor.
  ///
  /// In vi, this message translates to:
  /// **'Tác giả / Bút danh'**
  String get artbookFieldAuthor;

  /// No description provided for @artbookFieldAuthorHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập bút danh của bạn'**
  String get artbookFieldAuthorHint;

  /// No description provided for @artbookFieldGenre.
  ///
  /// In vi, this message translates to:
  /// **'Thể loại'**
  String get artbookFieldGenre;

  /// No description provided for @artbookFieldGenreHint.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thể loại'**
  String get artbookFieldGenreHint;

  /// No description provided for @artbookFieldDescription.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả ý tưởng (Không bắt buộc)'**
  String get artbookFieldDescription;

  /// No description provided for @artbookFieldDescriptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ câu chuyện đằng sau tác phẩm của bạn...'**
  String get artbookFieldDescriptionHint;

  /// No description provided for @artbookFieldPortfolio.
  ///
  /// In vi, this message translates to:
  /// **'Link Portfolio'**
  String get artbookFieldPortfolio;

  /// No description provided for @artbookFieldPortfolioHint.
  ///
  /// In vi, this message translates to:
  /// **'https://'**
  String get artbookFieldPortfolioHint;

  /// No description provided for @artbookFieldPreview.
  ///
  /// In vi, this message translates to:
  /// **'Preview Tác phẩm'**
  String get artbookFieldPreview;

  /// No description provided for @artbookFieldRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng điền thông tin này'**
  String get artbookFieldRequired;

  /// No description provided for @artbookUploadLabel.
  ///
  /// In vi, this message translates to:
  /// **'Kéo thả file hoặc Click để tải lên'**
  String get artbookUploadLabel;

  /// No description provided for @artbookUploadHint.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ JPG, PNG, PDF. Tối đa 20MB.'**
  String get artbookUploadHint;

  /// No description provided for @artbookPreviewRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng tải lên preview tác phẩm'**
  String get artbookPreviewRequired;

  /// No description provided for @artbookSubmitButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi tác phẩm cho Conbook'**
  String get artbookSubmitButton;

  /// No description provided for @artbookRulesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quy định nộp bài'**
  String get artbookRulesTitle;

  /// No description provided for @artbookRuleSizeTitle.
  ///
  /// In vi, this message translates to:
  /// **'KÍCH THƯỚC'**
  String get artbookRuleSizeTitle;

  /// No description provided for @artbookRuleSizeBody.
  ///
  /// In vi, this message translates to:
  /// **'A4 (210 x 297mm), lề an toàn 5mm.'**
  String get artbookRuleSizeBody;

  /// No description provided for @artbookRuleFormatTitle.
  ///
  /// In vi, this message translates to:
  /// **'ĐỊNH DẠNG'**
  String get artbookRuleFormatTitle;

  /// No description provided for @artbookRuleFormatBody.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ màu CMYK, tối thiểu 300dpi.'**
  String get artbookRuleFormatBody;

  /// No description provided for @artbookRuleCopyrightTitle.
  ///
  /// In vi, this message translates to:
  /// **'BẢN QUYỀN'**
  String get artbookRuleCopyrightTitle;

  /// No description provided for @artbookRuleCopyrightBody.
  ///
  /// In vi, this message translates to:
  /// **'Tác phẩm phải là nguyên bản, chưa từng xuất bản thương mại.'**
  String get artbookRuleCopyrightBody;

  /// No description provided for @artbookDeadline.
  ///
  /// In vi, this message translates to:
  /// **'Hạn chót nộp tác phẩm: 20 Tháng 11, 2023'**
  String get artbookDeadline;

  /// No description provided for @artbookLoginRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đăng nhập để gửi tác phẩm Conbook'**
  String get artbookLoginRequired;

  /// No description provided for @artbookSubmitSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi tác phẩm thành công!'**
  String get artbookSubmitSuccess;

  /// No description provided for @artbookSubmitFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi tác phẩm. Vui lòng thử lại.'**
  String get artbookSubmitFailed;

  /// No description provided for @artbookGenreIllustration.
  ///
  /// In vi, this message translates to:
  /// **'Minh họa'**
  String get artbookGenreIllustration;

  /// No description provided for @artbookGenreComic.
  ///
  /// In vi, this message translates to:
  /// **'Truyện tranh'**
  String get artbookGenreComic;

  /// No description provided for @artbookGenrePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Nhiếp ảnh'**
  String get artbookGenrePhoto;

  /// No description provided for @artbookGenreDigital.
  ///
  /// In vi, this message translates to:
  /// **'Digital Art'**
  String get artbookGenreDigital;

  /// No description provided for @artbookGenreOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
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
